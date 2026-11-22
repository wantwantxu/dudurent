import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../finance/income_detail_page.dart';
import '../property/property_hub_page.dart';
import 'tenant_pay_page.dart';

class TenantHomeTab extends StatelessWidget {
  const TenantHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    if (state.properties.isEmpty) {
      return const Center(child: Text('暂无在租房源'));
    }
    final home = state.tenantHome;
    final remaining = 730 - home.daysRented;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        GradientHeader(
          colors: const [
            DopamineColors.pink,
            Color(0xFFE11D48),
            DopamineColors.orange,
          ],
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text('租', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('嗨，张强 🌸', style: TextStyle(color: Color(0xFFFCE7F3), fontSize: 11)),
                        Text(
                          '我在租的温馨小窝',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white30),
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
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                  '履约中 🟢',
                                  style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                home.name,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('本期月租', style: TextStyle(color: Color(0xFFFCE7F3), fontSize: 10)),
                            Text.rich(
                              TextSpan(
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                                children: [
                                  TextSpan(text: yen(home.rent)),
                                  const TextSpan(text: '/月', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white24, height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('入住时间及剩余', style: TextStyle(color: Color(0xFFFCE7F3), fontSize: 10)),
                              Text(
                                '已住 ${home.daysRented} 天 (剩余 $remaining 天)',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const TenantPayPage()),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: DopamineColors.yellow,
                            foregroundColor: const Color(0xFF0F172A),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.credit_card, size: 14),
                          label: const Text('在线缴房租', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: GlassCard(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PropertyHubPage(propertyIndex: 0)),
            ),
            borderColor: DopamineColors.pink,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '🏠 点击查看当前住房完整详情 (抄表/报修/退租)',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                      ),
                    ),
                    Text(
                      '查看详情 ›',
                      style: TextStyle(color: DopamineColors.purple, fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  '实时查看水电气止数、提交房屋故障报修、联系房东中介与核算退租清单',
                  style: TextStyle(fontSize: 10, color: Colors.blueGrey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TenantFinanceTab extends StatelessWidget {
  const TenantFinanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    if (state.properties.isEmpty) {
      return const Center(child: Text('暂无账单'));
    }
    final home = state.tenantHome;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          '💳 租房租金与水电气账单',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
        const SizedBox(height: 12),
        GlassCard(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => IncomeDetailPage(propertyId: home.id, title: '我的账单明细'),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Expanded(
                    child: Text('10月份月租+水电账单', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  ),
                  Text('已缴清', style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '房屋租金：${yen(home.rent)} | 水电气费：¥138',
                style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
              ),
              const SizedBox(height: 4),
              const Text('点击查看按日 / 按月 / 按年明细 ›', style: TextStyle(fontSize: 10, color: DopamineColors.purple, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ],
    );
  }
}

