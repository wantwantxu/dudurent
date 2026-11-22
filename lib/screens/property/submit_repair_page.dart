import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../widgets/common_widgets.dart';

class SubmitRepairPage extends StatefulWidget {
  const SubmitRepairPage({super.key, required this.propertyIndex});

  final int propertyIndex;

  @override
  State<SubmitRepairPage> createState() => _SubmitRepairPageState();
}

class _SubmitRepairPageState extends State<SubmitRepairPage> {
  final _title = TextEditingController();
  final _desc = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('提交故障报修')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GlassCard(
            child: Column(
              children: [
                TextField(
                  controller: _title,
                  decoration: const InputDecoration(
                    labelText: '故障标题',
                    hintText: '例：主卧空调不制冷',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _desc,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: '故障描述',
                    hintText: '请描述现象、位置与紧急程度',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: '提交报修并通知管家',
            onPressed: () async {
              await context.read<AppState>().addRepair(
                    widget.propertyIndex,
                    item: _title.text.trim(),
                    desc: _desc.text.trim(),
                  );
              if (context.mounted) Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );
  }
}
