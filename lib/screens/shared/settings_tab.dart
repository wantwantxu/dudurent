import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import 'backup_tab.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key, required this.isLandlord});

  final bool isLandlord;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final mode = state.showRoleSwitch
        ? '所有（房东 + 租户）'
        : state.enableLandlord
            ? '仅房东'
            : '仅租户';

    return BackupTab(
      title: '系统设置',
      exportLabel: isLandlord ? '导出 JSON 格式备份文件' : '导出我的租房合同与留存数据',
      showImport: isLandlord,
      showReset: isLandlord,
      description: isLandlord ? null : '支持将当前房屋租约凭证、家具家电交接留存数据导出备份。',
      header: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('使用身份', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
            const SizedBox(height: 4),
            Text('默认开启全部。关闭后首页不再显示对应端。当前：$mode', style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('我是房东', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
              subtitle: const Text('房源台账、抄表、退租结算', style: TextStyle(fontSize: 11)),
              value: state.enableLandlord,
              activeThumbColor: DopamineColors.purple,
              onChanged: (v) => _toggle(context, landlord: v, tenant: state.enableTenant),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('我是租户', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
              subtitle: const Text('我的小窝、缴租、报修', style: TextStyle(fontSize: 11)),
              value: state.enableTenant,
              activeThumbColor: DopamineColors.pink,
              onChanged: (v) => _toggle(context, landlord: state.enableLandlord, tenant: v),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggle(BuildContext context, {required bool landlord, required bool tenant}) async {
    if (!landlord && !tenant) {
      showAppToast(context, '至少保留一种身份');
      return;
    }
    await context.read<AppState>().setIdentity(landlord: landlord, tenant: tenant);
    if (!context.mounted) return;
    showAppToast(context, landlord && tenant ? '已显示全部身份' : landlord ? '已关闭租户端' : '已关闭房东端');
  }
}
