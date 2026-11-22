import 'dart:convert';

class MeterItem {
  String name;
  num val;
  String unit;
  String color;

  MeterItem({
    required this.name,
    required this.val,
    required this.unit,
    this.color = 'purple',
  });

  factory MeterItem.fromJson(Map<String, dynamic> json) => MeterItem(
        name: json['name'] as String? ?? '',
        val: json['val'] as num? ?? 0,
        unit: json['unit'] as String? ?? '',
        color: json['color'] as String? ?? 'purple',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'val': val,
        'unit': unit,
        'color': color,
      };
}

class RepairItem {
  int id;
  String item;
  String desc;
  String status;
  String cost;

  RepairItem({
    required this.id,
    required this.item,
    required this.desc,
    required this.status,
    required this.cost,
  });

  factory RepairItem.fromJson(Map<String, dynamic> json) => RepairItem(
        id: json['id'] as int? ?? 0,
        item: json['item'] as String? ?? '',
        desc: json['desc'] as String? ?? '',
        status: json['status'] as String? ?? '',
        cost: json['cost'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'item': item,
        'desc': desc,
        'status': status,
        'cost': cost,
      };
}

class ApplianceItem {
  int id;
  String name;
  String status;
  String photo;
  bool panorama;

  ApplianceItem({
    this.id = 0,
    required this.name,
    required this.status,
    required this.photo,
    this.panorama = false,
  });

  bool get hasFile => photo.startsWith('/') || photo.contains(':\\') || photo.contains(':/');

  factory ApplianceItem.fromJson(Map<String, dynamic> json) => ApplianceItem(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        status: json['status'] as String? ?? '完好',
        photo: json['photo'] as String? ?? '',
        panorama: json['panorama'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
        'photo': photo,
        'panorama': panorama,
      };
}

class IncomeEntry {
  int id;
  int propertyId;
  String propertyName;
  String date;
  int amount;
  String title;

  IncomeEntry({
    required this.id,
    required this.propertyId,
    required this.propertyName,
    required this.date,
    required this.amount,
    required this.title,
  });

  DateTime get dateTime => DateTime.tryParse(date) ?? DateTime.now();

  factory IncomeEntry.fromJson(Map<String, dynamic> json) => IncomeEntry(
        id: json['id'] as int? ?? 0,
        propertyId: json['propertyId'] as int? ?? 0,
        propertyName: json['propertyName'] as String? ?? '',
        date: json['date'] as String? ?? '',
        amount: (json['amount'] as num?)?.toInt() ?? 0,
        title: json['title'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'propertyId': propertyId,
        'propertyName': propertyName,
        'date': date,
        'amount': amount,
        'title': title,
      };
}

class Property {
  int id;
  String name;
  String tenant;
  String tenantPhone;
  int rent;
  int daysRented;
  int totalYield;
  int deposit;
  String status;
  String badgeColor;
  List<MeterItem> meters;
  List<RepairItem> repairs;
  List<ApplianceItem> appliances;
  String leaseStart;
  String leaseEnd;

  Property({
    required this.id,
    required this.name,
    required this.tenant,
    required this.tenantPhone,
    required this.rent,
    required this.daysRented,
    required this.totalYield,
    required this.deposit,
    required this.status,
    required this.badgeColor,
    required this.meters,
    required this.repairs,
    required this.appliances,
    this.leaseStart = '2024-11-20',
    this.leaseEnd = '2026-11-20',
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        tenant: json['tenant'] as String? ?? '',
        tenantPhone: json['tenantPhone'] as String? ?? '',
        rent: (json['rent'] as num?)?.toInt() ?? 0,
        daysRented: (json['daysRented'] as num?)?.toInt() ?? 0,
        totalYield: (json['totalYield'] as num?)?.toInt() ?? 0,
        deposit: (json['deposit'] as num?)?.toInt() ?? 0,
        status: json['status'] as String? ?? '在租中',
        badgeColor: json['badgeColor'] as String? ?? 'emerald',
        meters: (json['meters'] as List<dynamic>? ?? [])
            .map((e) => MeterItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        repairs: (json['repairs'] as List<dynamic>? ?? [])
            .map((e) => RepairItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        appliances: (json['appliances'] as List<dynamic>? ?? [])
            .map((e) => ApplianceItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        leaseStart: json['leaseStart'] as String? ?? '2024-11-20',
        leaseEnd: json['leaseEnd'] as String? ?? '2026-11-20',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tenant': tenant,
        'tenantPhone': tenantPhone,
        'rent': rent,
        'daysRented': daysRented,
        'totalYield': totalYield,
        'deposit': deposit,
        'status': status,
        'badgeColor': badgeColor,
        'meters': meters.map((e) => e.toJson()).toList(),
        'repairs': repairs.map((e) => e.toJson()).toList(),
        'appliances': appliances.map((e) => e.toJson()).toList(),
        'leaseStart': leaseStart,
        'leaseEnd': leaseEnd,
      };
}

class AppData {
  List<Property> properties;
  List<IncomeEntry> incomes;
  bool enableLandlord;
  bool enableTenant;

  AppData({
    required this.properties,
    List<IncomeEntry>? incomes,
    this.enableLandlord = true,
    this.enableTenant = true,
  }) : incomes = incomes ?? [];

  factory AppData.fromJson(Map<String, dynamic> json) => AppData(
        properties: (json['properties'] as List<dynamic>? ?? [])
            .map((e) => Property.fromJson(e as Map<String, dynamic>))
            .toList(),
        incomes: (json['incomes'] as List<dynamic>? ?? [])
            .map((e) => IncomeEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
        enableLandlord: json['enableLandlord'] as bool? ?? true,
        enableTenant: json['enableTenant'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'properties': properties.map((e) => e.toJson()).toList(),
        'incomes': incomes.map((e) => e.toJson()).toList(),
        'enableLandlord': enableLandlord,
        'enableTenant': enableTenant,
      };

  String toJsonString() => const JsonEncoder.withIndent('  ').convert(toJson());

  factory AppData.fromJsonString(String source) =>
      AppData.fromJson(jsonDecode(source) as Map<String, dynamic>);
}

enum UserRole { landlord, tenant }

enum AppTab { properties, finance, settings }

enum IncomePeriod { day, month, year }
