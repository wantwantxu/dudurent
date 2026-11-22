import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../widgets/common_widgets.dart';

class AddCustomMeterPage extends StatefulWidget {
  const AddCustomMeterPage({super.key, required this.propertyIndex});

  final int propertyIndex;

  @override
  State<AddCustomMeterPage> createState() => _AddCustomMeterPageState();
}

class _AddCustomMeterPageState extends State<AddCustomMeterPage> {
  final _name = TextEditingController();
  final _unit = TextEditingController();
  final _val = TextEditingController(text: '0');

  @override
  void dispose() {
    _name.dispose();
    _unit.dispose();
    _val.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('添加自定义抄表项目')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GlassCard(
            child: Column(
              children: [
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: '抄表项目名称',
                    hintText: '例：地暖费 / 公摊电费 / 网络费',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _unit,
                        decoration: const InputDecoration(
                          labelText: '计量单位',
                          hintText: '例：吉焦 / 度',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _val,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: '当前止数',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: '确认添加抄表项',
            onPressed: () async {
              await context.read<AppState>().addCustomMeter(
                    widget.propertyIndex,
                    MeterItem(
                      name: _name.text.trim().isEmpty ? '新增自定义项' : _name.text.trim(),
                      unit: _unit.text.trim().isEmpty ? '次' : _unit.text.trim(),
                      val: num.tryParse(_val.text.trim()) ?? 0,
                      color: 'pink',
                    ),
                  );
              if (context.mounted) Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );
  }
}
