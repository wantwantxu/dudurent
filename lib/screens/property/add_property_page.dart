import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../widgets/common_widgets.dart';

class AddPropertyPage extends StatefulWidget {
  const AddPropertyPage({super.key});

  @override
  State<AddPropertyPage> createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  final _name = TextEditingController();
  final _tenant = TextEditingController();
  final _rent = TextEditingController(text: '6000');

  @override
  void dispose() {
    _name.dispose();
    _tenant.dispose();
    _rent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('新增房源')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GlassCard(
            child: Column(
              children: [
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: '房源名称',
                    hintText: '例：静安区花园洋房 501室',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _tenant,
                  decoration: const InputDecoration(
                    labelText: '租客姓名',
                    hintText: '例：张强',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _rent,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '月租金 (元)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: '确认添加房源',
            onPressed: () async {
              await context.read<AppState>().addProperty(
                    name: _name.text.trim(),
                    tenant: _tenant.text.trim(),
                    rent: int.tryParse(_rent.text.trim()) ?? 6000,
                  );
              if (context.mounted) Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );
  }
}
