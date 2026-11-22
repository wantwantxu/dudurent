import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../widgets/common_widgets.dart';

class MeterEntryPage extends StatefulWidget {
  const MeterEntryPage({super.key, required this.propertyIndex});

  final int propertyIndex;

  @override
  State<MeterEntryPage> createState() => _MeterEntryPageState();
}

class _MeterEntryPageState extends State<MeterEntryPage> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    final meters = context.read<AppState>().properties[widget.propertyIndex].meters;
    _controllers = meters.map((m) => TextEditingController(text: '${m.val}')).toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meters = context.watch<AppState>().properties[widget.propertyIndex].meters;

    return Scaffold(
      appBar: AppBar(title: const Text('更新抄表止数')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GlassCard(
            child: Column(
              children: List.generate(meters.length, (i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${meters[i].name} (${meters[i].unit})',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _controllers[i],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: '保存抄表数据',
            onPressed: () async {
              final values = _controllers.map((c) => num.tryParse(c.text.trim()) ?? 0).toList();
              await context.read<AppState>().updateMeters(widget.propertyIndex, values);
              if (context.mounted) Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );
  }
}
