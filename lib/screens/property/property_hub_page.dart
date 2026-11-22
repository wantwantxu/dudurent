import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import 'add_custom_meter_page.dart';
import 'appliance_gallery_page.dart';
import 'lease_termination_page.dart';
import 'meter_entry_page.dart';
import 'submit_repair_page.dart';

class PropertyHubPage extends StatelessWidget {
  const PropertyHubPage({super.key, required this.propertyIndex});

  final int propertyIndex;

  Future<void> _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone.replaceAll('-', ''));
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    if (propertyIndex < 0 || propertyIndex >= state.properties.length) {
      return const Scaffold(body: Center(child: Text('房源不存在')));
    }
    final prop = state.properties[propertyIndex];

    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE11D48),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LeaseTerminationPage(propertyIndex: propertyIndex),
              ),
            ),
            icon: const Icon(Icons.receipt_long),
            label: const Text('办理退租结算', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(prop.name, overflow: TextOverflow.ellipsis),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: StatusChip(
                label: prop.status,
                color: statusBadgeColor(prop.badgeColor),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4C1D95), Color(0xFF1E1B4B)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('签约租客', style: TextStyle(color: Color(0xFFC4B5FD), fontSize: 10, fontWeight: FontWeight.w700)),
                          Text(
                            '${prop.tenant} (${prop.tenantPhone})',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                          ),
                          Text(
                            '租期：${prop.leaseStart} 至 ${prop.leaseEnd}',
                            style: const TextStyle(color: Color(0xFFDDD6FE), fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('月租金', style: TextStyle(color: Color(0xFFF9A8D4), fontSize: 10, fontWeight: FontWeight.w700)),
                        Text(
                          yen(prop.rent),
                          style: const TextStyle(color: DopamineColors.pink, fontWeight: FontWeight.w900, fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _miniStat('在租时长', '${prop.daysRented} 天')),
                    const SizedBox(width: 8),
                    Expanded(child: _miniStat('累计收到收益', yen(prop.totalYield), valueColor: const Color(0xFF6EE7B7))),
                    const SizedBox(width: 8),
                    Expanded(child: _miniStat('押金监管', yen(prop.deposit), valueColor: const Color(0xFFFDE047))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GlassCard(
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '⚡ 水电气与自定义抄表项',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final ok = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddCustomMeterPage(propertyIndex: propertyIndex),
                          ),
                        );
                        if (ok == true && context.mounted) {
                          showAppToast(context, '已成功为房源添加抄表项！');
                        }
                      },
                      child: const Text('+ 自定义项', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                    FilledButton(
                      onPressed: () async {
                        final ok = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MeterEntryPage(propertyIndex: propertyIndex),
                          ),
                        );
                        if (ok == true && context.mounted) {
                          showAppToast(context, '抄表止数更新成功！');
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: DopamineColors.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                      ),
                      child: const Text('更新抄表', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: prop.meters.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2.2,
                  ),
                  itemBuilder: (_, i) {
                    final m = prop.meters[i];
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: meterBg(m.color),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(m.name, style: const TextStyle(fontSize: 9, color: Colors.blueGrey, fontWeight: FontWeight.w700)),
                          Text('${m.val} ${m.unit}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '🔧 房屋故障报修与维修日志',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                      ),
                    ),
                    FilledButton(
                      onPressed: () async {
                        final ok = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SubmitRepairPage(propertyIndex: propertyIndex),
                          ),
                        );
                        if (ok == true && context.mounted) {
                          showAppToast(context, '故障报修单已提交并同步管家！');
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: DopamineColors.pink,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                      ),
                      child: const Text('+ 新增报修', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (prop.repairs.isEmpty)
                  const Text('暂无故障报修记录', style: TextStyle(fontSize: 10, color: Colors.blueGrey, fontStyle: FontStyle.italic))
                else
                  ...prop.repairs.map(
                    (r) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(r.item, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEF3C7),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        r.status,
                                        style: const TextStyle(color: Color(0xFF92400E), fontSize: 8, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(r.desc, style: const TextStyle(fontSize: 10, color: Colors.blueGrey)),
                              ],
                            ),
                          ),
                          Text(r.cost, style: const TextStyle(color: Color(0xFFF43F5E), fontWeight: FontWeight.w700, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text('📞 房东、租户与中介管家三方通讯', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
          const SizedBox(height: 8),
          _contactCard(
            title: '租户：${prop.tenant}',
            badge: '签约租客',
            phone: '电话：${prop.tenantPhone}',
            colors: const [Color(0xFFFFF1F2), Color(0xFFFFE4E6)],
            border: const Color(0xFFFCE7F3),
            primaryLabel: '拨打电话',
            primaryColor: DopamineColors.pink,
            onPrimary: () {
              showAppToast(context, '正在拨打租户电话');
              _call(prop.tenantPhone);
            },
            secondaryLabel: '复制微信',
            onSecondary: () async {
              await Clipboard.setData(const ClipboardData(text: 'zhangqiang_rent'));
              if (context.mounted) showAppToast(context, '已复制微信');
            },
          ),
          const SizedBox(height: 8),
          _contactCard(
            title: '中介管家：小陈 (链家租务)',
            badge: '房屋管家',
            phone: '电话：186-6666-9999',
            colors: const [Color(0xFFFFFBEB), Color(0xFFFFF7ED)],
            border: const Color(0xFFFED7AA),
            primaryLabel: '呼叫管家',
            primaryColor: DopamineColors.orange,
            onPrimary: () {
              showAppToast(context, '正在呼叫链家管家');
              _call('186-6666-9999');
            },
            secondaryLabel: '在线留言',
            onSecondary: () => showAppToast(context, '已向管家发送服务留言'),
          ),
          const SizedBox(height: 14),
          GlassCard(
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text('🛋️ 家具家电拍照交接档案', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ApplianceGalleryPage(propertyIndex: propertyIndex),
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: DopamineColors.pink,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                      ),
                      child: const Text('全量照片', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...prop.appliances.map(
                  (a) => GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AppliancePreviewPage(item: a)),
                    ),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                          Text(
                            a.panorama ? '360全景 · 点击预览' : '点击预览 · ✓ ${a.status}',
                            style: const TextStyle(color: Color(0xFF059669), fontSize: 9, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value, {Color valueColor = Colors.white}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Color(0xFFDDD6FE), fontSize: 9)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.w900, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _contactCard({
    required String title,
    required String badge,
    required String phone,
    required List<Color> colors,
    required Color border,
    required String primaryLabel,
    required Color primaryColor,
    required VoidCallback onPrimary,
    required String secondaryLabel,
    required VoidCallback onSecondary,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: border,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(badge, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(phone, style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: onPrimary,
                  style: FilledButton.styleFrom(backgroundColor: primaryColor),
                  child: Text(primaryLabel, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: onSecondary,
                  child: Text(secondaryLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: primaryColor)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
