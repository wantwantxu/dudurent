import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class IncomeDetailPage extends StatefulWidget {
  const IncomeDetailPage({super.key, this.propertyId, this.title = '收益详情'});

  final int? propertyId;
  final String title;

  @override
  State<IncomeDetailPage> createState() => _IncomeDetailPageState();
}

class _IncomeDetailPageState extends State<IncomeDetailPage> {
  IncomePeriod _period = IncomePeriod.month;
  String? _openKey;

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<AppState>().incomesFor(widget.propertyId);
    final groups = _group(entries, _period);
    final total = entries.fold<int>(0, (s, e) => s + e.amount);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title, overflow: TextOverflow.ellipsis)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF4C1D95), Color(0xFF1E1B4B)]),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('筛选范围内累计到账', style: TextStyle(color: Color(0xFFDDD6FE), fontSize: 11)),
                Text(yen(total), style: const TextStyle(color: DopamineColors.pink, fontSize: 28, fontWeight: FontWeight.w900)),
                Text('${entries.length} 笔', style: const TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SegmentedButton<IncomePeriod>(
            segments: const [
              ButtonSegment(value: IncomePeriod.day, label: Text('按日')),
              ButtonSegment(value: IncomePeriod.month, label: Text('按月')),
              ButtonSegment(value: IncomePeriod.year, label: Text('按年')),
            ],
            selected: {_period},
            onSelectionChanged: (v) => setState(() {
              _period = v.first;
              _openKey = null;
            }),
          ),
          const SizedBox(height: 12),
          if (groups.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('暂无收益记录', style: TextStyle(color: Colors.blueGrey))),
            ),
          ...groups.map((g) {
            final open = _openKey == g.key;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GlassCard(
                onTap: () => setState(() => _openKey = open ? null : g.key),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(g.label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                        ),
                        Text(yen(g.total), style: const TextStyle(color: DopamineColors.pink, fontWeight: FontWeight.w900)),
                        Icon(open ? Icons.expand_less : Icons.expand_more, size: 18, color: Colors.blueGrey),
                      ],
                    ),
                    if (open) ...[
                      const Divider(height: 16),
                      ...g.items.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(e.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                    Text(
                                      '${e.date} · ${e.propertyName}',
                                      style: const TextStyle(fontSize: 10, color: Colors.blueGrey),
                                    ),
                                  ],
                                ),
                              ),
                              Text('+${yen(e.amount)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _IncomeGroup {
  _IncomeGroup(this.key, this.label);
  final String key;
  final String label;
  int total = 0;
  final List<IncomeEntry> items = [];
}

List<_IncomeGroup> _group(List<IncomeEntry> entries, IncomePeriod period) {
  final map = <String, _IncomeGroup>{};
  for (final e in entries) {
    final d = e.dateTime;
    final String key;
    final String label;
    switch (period) {
      case IncomePeriod.day:
        key = e.date;
        label = e.date;
      case IncomePeriod.month:
        key = '${d.year}-${d.month.toString().padLeft(2, '0')}';
        label = '${d.year}年${d.month}月';
      case IncomePeriod.year:
        key = '${d.year}';
        label = '${d.year}年';
    }
    final group = map.putIfAbsent(key, () => _IncomeGroup(key, label));
    group.total += e.amount;
    group.items.add(e);
  }
  final groups = map.values.toList()..sort((a, b) => b.key.compareTo(a.key));
  return groups;
}
