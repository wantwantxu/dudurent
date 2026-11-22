import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../finance/income_detail_page.dart';
import '../property/add_property_page.dart';
import '../property/property_hub_page.dart';

class LandlordPropertiesTab extends StatelessWidget {
  const LandlordPropertiesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        GradientHeader(
          colors: const [
            Color(0xFF0F172A),
            Color(0xFF1E1B4B),
            Color(0xFF3B0764),
          ],
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [DopamineColors.pink, DopamineColors.orange],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text('房', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '下午好，林大房东 ✨',
                          style: TextStyle(color: Color(0xFFE9D5FF), fontSize: 11),
                        ),
                        Text(
                          '名下资产及租赁台账',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () async {
                      final ok = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(builder: (_) => const AddPropertyPage()),
                      );
                      if (ok == true && context.mounted) {
                        showAppToast(context, '成功添加新房产记录！');
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: DopamineColors.pink,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.add, size: 14),
                    label: const Text('新增房源', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      label: '累计收益',
                      value: yen(state.totalYield),
                      hint: '实时已到账',
                      onTap: () => state.setTab(AppTab.finance),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricTile(
                      label: '押金监管池',
                      value: yen(state.totalDeposit),
                      hint: '全额托管',
                      onTap: () => state.setTab(AppTab.finance),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricTile(
                      label: '累计出租时长',
                      value: '${state.totalRentDays} 天',
                      hint: '满租无空置',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 14,
                decoration: BoxDecoration(
                  color: DopamineColors.pink,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  '名下多套房产 (点击进入详情页办理抄表/报修/退租)',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                ),
              ),
              Text(
                '${state.properties.length} 套在租',
                style: const TextStyle(fontSize: 10, color: Colors.blueGrey, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        ...List.generate(state.properties.length, (index) {
          final prop = state.properties[index];
          final accent = index.isEven ? DopamineColors.pink : DopamineColors.purple;
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: GlassCard(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PropertyHubPage(propertyIndex: index),
                ),
              ),
              onLongPress: () => _confirmDeleteProperty(context, prop.id, prop.name),
              borderColor: accent,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [DopamineColors.pink, DopamineColors.purple],
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text('🏢', style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              prop.name,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                            ),
                            Text.rich(
                              TextSpan(
                                style: const TextStyle(fontSize: 10, color: Colors.blueGrey),
                                children: [
                                  const TextSpan(text: '租客：'),
                                  TextSpan(
                                    text: prop.tenant,
                                    style: const TextStyle(
                                      color: DopamineColors.purple,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const TextSpan(text: ' | 月租：'),
                                  TextSpan(
                                    text: yen(prop.rent),
                                    style: const TextStyle(
                                      color: DopamineColors.pink,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      StatusChip(
                        label: prop.status,
                        color: statusBadgeColor(prop.badgeColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '⏱ 已租 ${prop.daysRented} 天 | 抄表项 ${prop.meters.length} 个',
                            style: const TextStyle(fontSize: 10, color: Colors.blueGrey),
                          ),
                        ),
                        const Text(
                          '进入查看与退租结算 ›',
                          style: TextStyle(
                            fontSize: 10,
                            color: DopamineColors.purple,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 24),
      ],
    );
  }
}

Future<void> _confirmDeleteProperty(BuildContext context, int id, String name) async {
  final ok = await showModalBottomSheet<bool>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE11D48)),
              onPressed: () => Navigator.pop(ctx, true),
              icon: const Icon(Icons.delete_outline),
              label: const Text('删除房源'),
            ),
          ],
        ),
      ),
    ),
  );
  if (ok != true || !context.mounted) return;
  final state = context.read<AppState>();
  final index = state.properties.indexWhere((p) => p.id == id);
  if (index < 0) return;
  await state.deleteProperty(index);
  if (context.mounted) showAppToast(context, '已删除房源');
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.hint,
    this.onTap,
  });

  final String label;
  final String value;
  final String hint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Color(0xFFFBCFE8), fontSize: 9, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
              Text(hint, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 8)),
            ],
          ),
        ),
      ),
    );
  }
}

class LandlordFinanceTab extends StatelessWidget {
  const LandlordFinanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Row(
          children: [
            Icon(Icons.receipt_long, color: DopamineColors.pink, size: 18),
            SizedBox(width: 6),
            Text(
              '财务收支与押金监管台账',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const IncomeDetailPage(title: '全部收益详情')),
            ),
            child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4C1D95), Color(0xFF1E1B4B)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('年度累计收租收益', style: TextStyle(color: Color(0xFFDDD6FE), fontSize: 10)),
                        Text(
                          yen(state.totalYield),
                          style: const TextStyle(
                            color: DopamineColors.pink,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                    ),
                    child: const Text(
                      '合规存管',
                      style: TextStyle(color: Color(0xFF6EE7B7), fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white24, height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('冻结押金余额', style: TextStyle(color: Colors.white70, fontSize: 10)),
                        Text(yen(state.totalDeposit), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('本月待收租金', style: TextStyle(color: Colors.white70, fontSize: 10)),
                        Text(yen(state.monthlyPending), style: const TextStyle(color: DopamineColors.yellow, fontWeight: FontWeight.w900, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
            ),
          ),
        const SizedBox(height: 8),
        const Text('点击卡片查看按日 / 按月 / 按年收益', style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
        const SizedBox(height: 8),
        ...state.properties.map(
          (prop) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(12),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => IncomeDetailPage(propertyId: prop.id, title: prop.name),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(prop.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                        Text(
                          '已到账收益: ${yen(prop.totalYield)}',
                          style: const TextStyle(fontSize: 10, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '+${yen(prop.rent)}/月',
                    style: const TextStyle(color: DopamineColors.pink, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
