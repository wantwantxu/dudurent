import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/sample_data.dart';
import '../models/models.dart';

class AppState extends ChangeNotifier {
  static const _storageKey = 'dudu_rent_app_data_v1';

  AppData _data = createSampleData();
  UserRole _role = UserRole.landlord;
  AppTab _tab = AppTab.properties;
  bool _showBanner = true;
  bool _ready = false;

  AppData get data => _data;
  List<Property> get properties => _data.properties;
  UserRole get role => _role;
  AppTab get tab => _tab;
  bool get showBanner => _showBanner;
  bool get ready => _ready;
  bool get enableLandlord => _data.enableLandlord;
  bool get enableTenant => _data.enableTenant;
  bool get showRoleSwitch => enableLandlord && enableTenant;
  List<IncomeEntry> get incomes => _data.incomes;

  int get totalYield =>
      properties.fold(0, (sum, p) => sum + p.totalYield);

  int get totalDeposit =>
      properties.fold(0, (sum, p) => sum + p.deposit);

  int get totalRentDays =>
      properties.fold(0, (sum, p) => sum + p.daysRented);

  int get monthlyPending =>
      properties.fold(0, (sum, p) => sum + p.rent);

  Property get tenantHome => properties.isNotEmpty
      ? properties.first
      : createSampleData().properties.first;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        _data = AppData.fromJsonString(raw);
      } catch (_) {
        _data = createSampleData();
      }
    }
    if (_data.incomes.isEmpty) {
      _data.incomes = seedIncomes(_data.properties);
      await _persist();
    }
    _syncRoleWithIdentity();
    _ready = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, _data.toJsonString());
  }

  void setRole(UserRole role) {
    _role = role;
    _tab = AppTab.properties;
    notifyListeners();
  }

  void setTab(AppTab tab) {
    _tab = tab;
    notifyListeners();
  }

  void dismissBanner() {
    _showBanner = false;
    notifyListeners();
  }

  void _syncRoleWithIdentity() {
    if (!_data.enableLandlord && _data.enableTenant) {
      _role = UserRole.tenant;
    } else if (_data.enableLandlord && !_data.enableTenant) {
      _role = UserRole.landlord;
    } else if (!_data.enableLandlord && !_data.enableTenant) {
      _data.enableLandlord = true;
      _data.enableTenant = true;
    }
  }

  Future<void> setIdentity({required bool landlord, required bool tenant}) async {
    if (!landlord && !tenant) return;
    _data.enableLandlord = landlord;
    _data.enableTenant = tenant;
    _syncRoleWithIdentity();
    _tab = AppTab.properties;
    await _persist();
    notifyListeners();
  }

  List<IncomeEntry> incomesFor(int? propertyId) {
    final list = propertyId == null
        ? List<IncomeEntry>.from(_data.incomes)
        : _data.incomes.where((e) => e.propertyId == propertyId).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  Future<void> addProperty({
    required String name,
    required String tenant,
    required int rent,
  }) async {
    final prop = Property(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name.isEmpty ? '新上架套房' : name,
      tenant: tenant.isEmpty ? '新租客' : tenant,
      tenantPhone: '138-0000-0000',
      rent: rent,
      daysRented: 30,
      totalYield: rent,
      deposit: rent * 2,
      status: '在租中',
      badgeColor: 'emerald',
      meters: [
        MeterItem(name: '电费止数', val: 100, unit: '度', color: 'amber'),
        MeterItem(name: '水费止数', val: 10, unit: '吨', color: 'cyan'),
      ],
      repairs: [],
      appliances: [
        ApplianceItem(
          name: '品牌空调/冰箱/洗衣机',
          status: '完好',
          photo: 'new',
        ),
      ],
    );
    _data.properties.add(prop);
    _data.incomes.add(
      IncomeEntry(
        id: DateTime.now().millisecondsSinceEpoch,
        propertyId: prop.id,
        propertyName: prop.name,
        date: _iso(DateTime.now()),
        amount: rent,
        title: '首月租金',
      ),
    );
    await _persist();
    notifyListeners();
  }

  Future<void> deleteProperty(int index) async {
    if (index < 0 || index >= _data.properties.length) return;
    final id = _data.properties[index].id;
    _data.properties.removeAt(index);
    _data.incomes.removeWhere((e) => e.propertyId == id);
    await _persist();
    notifyListeners();
  }

  Future<void> recordRentPayment({
    required int propertyId,
    required String propertyName,
    required int amount,
    String title = '在线缴租',
  }) async {
    _data.incomes.add(
      IncomeEntry(
        id: DateTime.now().millisecondsSinceEpoch,
        propertyId: propertyId,
        propertyName: propertyName,
        date: _iso(DateTime.now()),
        amount: amount,
        title: title,
      ),
    );
    await _persist();
    notifyListeners();
  }

  Future<void> addAppliance(int propertyIndex, ApplianceItem item) async {
    if (item.id == 0) item.id = DateTime.now().millisecondsSinceEpoch;
    _data.properties[propertyIndex].appliances.add(item);
    await _persist();
    notifyListeners();
  }

  Future<void> removeAppliance(int propertyIndex, int applianceId) async {
    _data.properties[propertyIndex].appliances.removeWhere((a) => a.id == applianceId);
    await _persist();
    notifyListeners();
  }

  Future<void> addCustomMeter(int propertyIndex, MeterItem meter) async {
    _data.properties[propertyIndex].meters.add(meter);
    await _persist();
    notifyListeners();
  }

  Future<void> updateMeters(int propertyIndex, List<num> values) async {
    final meters = _data.properties[propertyIndex].meters;
    for (var i = 0; i < meters.length && i < values.length; i++) {
      meters[i].val = values[i];
    }
    await _persist();
    notifyListeners();
  }

  Future<void> addRepair(
    int propertyIndex, {
    required String item,
    required String desc,
  }) async {
    final prop = _data.properties[propertyIndex];
    prop.repairs.add(
      RepairItem(
        id: DateTime.now().millisecondsSinceEpoch,
        item: item.isEmpty ? '通用设施报修' : item,
        desc: desc.isEmpty ? '问题跟进中' : desc,
        status: '已派单管家',
        cost: '待估算',
      ),
    );
    prop.status = '有报修';
    prop.badgeColor = 'amber';
    await _persist();
    notifyListeners();
  }

  Future<void> confirmTermination(int propertyIndex) async {
    final prop = _data.properties[propertyIndex];
    prop.status = '已退租出账';
    prop.badgeColor = 'slate';
    await _persist();
    notifyListeners();
  }

  Future<void> resetSampleData() async {
    final landlord = _data.enableLandlord;
    final tenant = _data.enableTenant;
    _data = createSampleData();
    _data.enableLandlord = landlord;
    _data.enableTenant = tenant;
    _data.incomes = seedIncomes(_data.properties);
    _syncRoleWithIdentity();
    await _persist();
    notifyListeners();
  }

  Future<bool> importFromJson(String raw) async {
    try {
      final imported = AppData.fromJsonString(raw);
      if (imported.properties.isEmpty) return false;
      _data = imported;
      await _persist();
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  String exportJson() => _data.toJsonString();
}

String _iso(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

List<IncomeEntry> seedIncomes(List<Property> properties) {
  final now = DateTime.now();
  final list = <IncomeEntry>[];
  var seq = 1;
  for (final prop in properties) {
    final months = (prop.daysRented / 30).ceil().clamp(1, 24);
    for (var i = 0; i < months; i++) {
      final month = DateTime(now.year, now.month - i, 1);
      final day = i == 0 ? now.day.clamp(1, 28) : (5 + (prop.id % 7)).clamp(1, 28);
      list.add(
        IncomeEntry(
          id: seq++,
          propertyId: prop.id,
          propertyName: prop.name,
          date: _iso(DateTime(month.year, month.month, day)),
          amount: prop.rent,
          title: '${month.month}月租金',
        ),
      );
    }
  }
  return list;
}
