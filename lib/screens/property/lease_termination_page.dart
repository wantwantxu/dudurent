import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class LeaseTerminationPage extends StatefulWidget {
  const LeaseTerminationPage({super.key, required this.propertyIndex});

  final int propertyIndex;

  @override
  State<LeaseTerminationPage> createState() => _LeaseTerminationPageState();
}

class _LeaseTerminationPageState extends State<LeaseTerminationPage> {
  final _utilities = TextEditingController(text: '280');
  final _damage = TextEditingController(text: '150');
  final _clean = TextEditingController(text: '200');

  @override
  void dispose() {
    _utilities.dispose();
    _damage.dispose();
    _clean.dispose();
    super.dispose();
  }

  double get _finalRefund {
    final prop = context.read<AppState>().properties[widget.propertyIndex];
    final util = double.tryParse(_utilities.text) ?? 0;
    final damage = double.tryParse(_damage.text) ?? 0;
    final clean = double.tryParse(_clean.text) ?? 0;
    return prop.deposit - util - damage - clean;
  }

  @override
  Widget build(BuildContext context) {
    final prop = context.watch<AppState>().properties[widget.propertyIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('退租清算与押金退还'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: StatusChip(label: '退租办理', color: Color(0xFFF43F5E))),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE11D48), DopamineColors.pink],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('最终退租核算', style: TextStyle(color: Color(0xFFFCE7F3), fontSize: 10, fontWeight: FontWeight.w700)),
                Text(prop.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
                Text(
                  '押金基数：${yen(prop.deposit)}',
                  style: const TextStyle(color: Color(0xFFFCE7F3), fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('退租结算清单明细项', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                const Divider(height: 20),
                _line('1. 应退基础押金', '+${yen(prop.deposit)}', const Color(0xFF059669)),
                const SizedBox(height: 10),
                _deduct('2. 未结水电气/网络末期费扣除', _utilities),
                const SizedBox(height: 10),
                _deduct('3. 家具家电损坏/维修扣款', _damage),
                const SizedBox(height: 10),
                _deduct('4. 退租保洁与垃圾清运费', _clean),
                const Divider(height: 24),
                Row(
                  children: [
                    const Expanded(
                      child: Text('应退租客净额：', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                    ),
                    Text(
                      yen(_finalRefund),
                      style: const TextStyle(
                        color: DopamineColors.pink,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                PrimaryButton(
                  label: '确认办理退租并退款出账',
                  colors: const [Color(0xFFE11D48), Color(0xFFF43F5E)],
                  onPressed: () async {
                    await context.read<AppState>().confirmTermination(widget.propertyIndex);
                    if (!context.mounted) return;
                    showAppToast(context, '房源【${prop.name}】退租出账办理完成！');
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(String label, String value, Color color) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _deduct(String label, TextEditingController controller) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF475569)))),
        SizedBox(
          width: 96,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: Color(0xFFE11D48), fontWeight: FontWeight.w700, fontSize: 12),
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }
}
