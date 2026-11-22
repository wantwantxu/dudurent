import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class ApplianceGalleryPage extends StatelessWidget {
  const ApplianceGalleryPage({super.key, required this.propertyIndex});

  final int propertyIndex;

  Future<void> _add(BuildContext context, {required bool panorama, required ImageSource source}) async {
    final picker = ImagePicker();
    final shot = await picker.pickImage(source: source, imageQuality: panorama ? 95 : 85, maxWidth: panorama ? 4096 : 2048);
    if (shot == null || !context.mounted) return;

    final nameCtrl = TextEditingController(text: panorama ? '360全景' : '新家具家电');
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(panorama ? '保存360全景' : '保存照片'),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: '名称', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          FilledButton(onPressed: () => Navigator.pop(ctx, nameCtrl.text.trim()), child: const Text('保存')),
        ],
      ),
    );
    nameCtrl.dispose();
    if (name == null || !context.mounted) return;

    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/appliances');
    await folder.create(recursive: true);
    final id = DateTime.now().millisecondsSinceEpoch;
    final dest = File('${folder.path}/$id.jpg');
    await File(shot.path).copy(dest.path);
    if (!context.mounted) return;

    await context.read<AppState>().addAppliance(
          propertyIndex,
          ApplianceItem(
            id: id,
            name: name.isEmpty ? (panorama ? '360全景' : '交接照片') : name,
            status: '完好',
            photo: dest.path,
            panorama: panorama,
          ),
        );
    if (context.mounted) showAppToast(context, panorama ? '360全景已保存' : '照片已保存');
  }

  void _openAddSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera, color: DopamineColors.pink),
              title: const Text('拍照上传'),
              onTap: () {
                Navigator.pop(ctx);
                _add(context, panorama: false, source: ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: DopamineColors.purple),
              title: const Text('从相册上传'),
              onTap: () {
                Navigator.pop(ctx);
                _add(context, panorama: false, source: ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.threesixty, color: DopamineColors.orange),
              title: const Text('360全景拍照'),
              subtitle: const Text('拍下或选取全景图后可拖动环视'),
              onTap: () {
                Navigator.pop(ctx);
                _add(context, panorama: true, source: ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.panorama, color: DopamineColors.cyan),
              title: const Text('上传360全景图'),
              onTap: () {
                Navigator.pop(ctx);
                _add(context, panorama: true, source: ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context, ApplianceItem item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除这张档案？'),
        content: Text(item.name),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('删除')),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    await context.read<AppState>().removeAppliance(propertyIndex, item.id);
    final file = File(item.photo);
    if (item.hasFile && file.existsSync()) {
      await file.delete();
    }
    if (context.mounted) showAppToast(context, '已删除');
  }

  @override
  Widget build(BuildContext context) {
    final appliances = context.watch<AppState>().properties[propertyIndex].appliances;

    return Scaffold(
      appBar: AppBar(title: const Text('家具家电交接照片')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddSheet(context),
        icon: const Icon(Icons.add_a_photo),
        label: const Text('新增'),
      ),
      body: appliances.isEmpty
          ? const Center(child: Text('还没有照片，点右下角新增或上传360全景'))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
              itemCount: appliances.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final a = appliances[i];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      _Thumb(item: a),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (a.panorama)
                              const Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Text('360全景', style: TextStyle(color: DopamineColors.orange, fontSize: 10, fontWeight: FontWeight.w800)),
                              ),
                            Text(a.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                            Text('✓ ${a.status}', style: const TextStyle(color: Color(0xFF047857), fontSize: 10, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: '预览',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AppliancePreviewPage(item: a)),
                        ),
                        icon: const Icon(Icons.visibility_outlined),
                      ),
                      IconButton(
                        tooltip: '删除',
                        onPressed: () => _delete(context, a),
                        icon: const Icon(Icons.delete_outline, color: Color(0xFFE11D48)),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.item});
  final ApplianceItem item;

  @override
  Widget build(BuildContext context) {
    final file = File(item.photo);
    final image = item.hasFile && file.existsSync();
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 72,
        height: 72,
        child: image
            ? Image.file(file, fit: BoxFit.cover)
            : const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [DopamineColors.pink, DopamineColors.purple]),
                ),
                child: Icon(Icons.photo_camera_back, color: Colors.white),
              ),
      ),
    );
  }
}

class AppliancePreviewPage extends StatefulWidget {
  const AppliancePreviewPage({super.key, required this.item});

  final ApplianceItem item;

  @override
  State<AppliancePreviewPage> createState() => _AppliancePreviewPageState();
}

class _AppliancePreviewPageState extends State<AppliancePreviewPage> {
  double _yaw = 0;
  double _pitch = 0;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final file = File(item.photo);
    final ready = item.hasFile && file.existsSync();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(item.panorama ? '${item.name} · 360' : item.name),
      ),
      body: !ready
          ? const Center(child: Text('这是演示档案，还没有上传原图', style: TextStyle(color: Colors.white70)))
          : item.panorama
              ? GestureDetector(
                  onPanUpdate: (d) => setState(() {
                    _yaw = (_yaw - d.delta.dx / 180).clamp(-1.0, 1.0);
                    _pitch = (_pitch - d.delta.dy / 180).clamp(-0.8, 0.8);
                  }),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('拖动画面环视 360 全景', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ),
                      Expanded(
                        child: ClipRect(
                          child: OverflowBox(
                            maxWidth: double.infinity,
                            maxHeight: double.infinity,
                            child: Transform.translate(
                              offset: Offset(-_yaw * 280, -_pitch * 160),
                              child: Image.file(file, fit: BoxFit.cover, width: 1400, height: 780),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : InteractiveViewer(
                  child: Center(child: Image.file(file)),
                ),
    );
  }
}
