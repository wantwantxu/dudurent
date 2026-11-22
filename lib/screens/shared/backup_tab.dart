import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class BackupTab extends StatelessWidget {
  const BackupTab({
    super.key,
    required this.title,
    required this.exportLabel,
    this.description,
    this.showImport = true,
    this.showReset = true,
    this.header,
  });

  final String title;
  final String exportLabel;
  final String? description;
  final bool showImport;
  final bool showReset;
  final Widget? header;

  Future<void> _export(BuildContext context) async {
    final state = context.read<AppState>();
    final json = state.exportJson();
    final name = 'DuduRent_Backup_${DateTime.now().toIso8601String().substring(0, 10)}.json';

    try {
      if (kIsWeb) {
        await SharePlus.instance.share(ShareParams(text: json, subject: name));
      } else {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/$name');
        await file.writeAsString(json);
        await SharePlus.instance.share(
          ShareParams(files: [XFile(file.path)], text: '嘟嘟租房数据备份'),
        );
      }
      if (context.mounted) showAppToast(context, '备份文件已成功生成导出！');
    } catch (e) {
      if (context.mounted) showAppToast(context, '导出失败，请重试');
    }
  }

  Future<void> _import(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final state = context.read<AppState>();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    String? raw;
    if (file.bytes != null) {
      raw = utf8.decode(file.bytes!);
    } else if (file.path != null) {
      raw = await File(file.path!).readAsString();
    }
    if (raw == null) {
      if (context.mounted) {
        messenger.hideCurrentSnackBar();
        showAppToast(context, '无法读取备份文件');
      }
      return;
    }

    final ok = await state.importFromJson(raw);
    if (context.mounted) {
      showAppToast(
        context,
        ok ? '已成功解析并导入数据备份！' : '备份文件格式不兼容！',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (header != null) ...[
          header!,
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            const Icon(Icons.cloud_upload, color: DopamineColors.purple, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
            ),
            if (showImport)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'JSON 云端/本地',
                  style: TextStyle(color: Color(0xFF6B21A8), fontSize: 9, fontWeight: FontWeight.w700),
                ),
              ),
          ],
        ),
        if (description != null) ...[
          const SizedBox(height: 8),
          Text(description!, style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
        ],
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        colors: [DopamineColors.purple, DopamineColors.pink],
                      ),
                    ),
                    child: const Icon(Icons.file_download, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('一键导出完整数据备份', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                        Text(
                          '包含所有套房、抄表自定义项、维修与退租记录',
                          style: TextStyle(fontSize: 10, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              PrimaryButton(label: exportLabel, onPressed: () => _export(context)),
            ],
          ),
        ),
        if (showImport) ...[
          const SizedBox(height: 12),
          GlassCard(
            borderColor: DopamineColors.orange.withValues(alpha: 0.4),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [DopamineColors.orange, DopamineColors.yellow],
                        ),
                      ),
                      child: const Icon(Icons.file_upload, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('从备份文件导入恢复数据', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                          Text(
                            '选择本地 .json 备份文件并实时解析还原',
                            style: TextStyle(fontSize: 10, color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  label: '选择 JSON 备份文件恢复',
                  colors: const [DopamineColors.orange, DopamineColors.orange],
                  onPressed: () => _import(context),
                ),
              ],
            ),
          ),
        ],
        if (showReset) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('重置为初始演示示例数据', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                      Text(
                        '恢复系统默认预设的3套房产与测试台账',
                        style: TextStyle(fontSize: 10, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await context.read<AppState>().resetSampleData();
                    if (context.mounted) showAppToast(context, '已恢复为演示默认数据！');
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFE2E8F0),
                    foregroundColor: const Color(0xFF334155),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('重置', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
