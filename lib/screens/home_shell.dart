import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'landlord/landlord_tabs.dart';
import 'shared/settings_tab.dart';
import 'tenant/tenant_tabs.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isLandlord = state.role == UserRole.landlord;

    Widget body;
    switch (state.tab) {
      case AppTab.properties:
        body = isLandlord ? const LandlordPropertiesTab() : const TenantHomeTab();
      case AppTab.finance:
        body = isLandlord ? const LandlordFinanceTab() : const TenantFinanceTab();
      case AppTab.settings:
        body = SettingsTab(isLandlord: isLandlord);
    }

    return Scaffold(
      backgroundColor: DopamineColors.scaffold,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        colors: [
                          DopamineColors.pink,
                          DopamineColors.purple,
                          DopamineColors.cyan,
                        ],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text('🐤', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '嘟嘟租房',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                            ),
                            SizedBox(width: 6),
                            _BrandPill(),
                          ],
                        ),
                        Text(
                          '退租结算 · 自定义抄表 · 房东租客多巴胺App',
                          style: TextStyle(fontSize: 10, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                  if (state.showRoleSwitch)
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          _RoleChip(
                            label: '房东端 🏠',
                            selected: isLandlord,
                            selectedColors: const [DopamineColors.purple, DopamineColors.deepPurple],
                            onTap: () {
                              state.setRole(UserRole.landlord);
                              showAppToast(context, '已切换至【房东端】');
                            },
                          ),
                          _RoleChip(
                            label: '租户端 🛋️',
                            selected: !isLandlord,
                            selectedColors: const [DopamineColors.pink, Color(0xFFE11D48)],
                            onTap: () {
                              state.setRole(UserRole.tenant);
                              showAppToast(context, '已切换至【租户端】');
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (state.showBanner)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [DopamineColors.yellow, DopamineColors.orange],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '✓ 已支持【办理退租清单结算】与【自定义抄表项目】',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ),
                    InkWell(
                      onTap: state.dismissBanner,
                      child: const Icon(Icons.close, size: 16),
                    ),
                  ],
                ),
              ),
            Expanded(child: body),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: state.tab.index,
        onDestinationSelected: (i) => state.setTab(AppTab.values[i]),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home, color: DopamineColors.purple),
            label: isLandlord ? '房源/首页' : '我的小窝',
          ),
          const NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long, color: DopamineColors.purple),
            label: '账单财务',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: DopamineColors.purple),
            label: '系统设置',
          ),
        ],
      ),
    );
  }
}

class _BrandPill extends StatelessWidget {
  const _BrandPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: DopamineColors.purple.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: DopamineColors.purple.withValues(alpha: 0.25)),
      ),
      child: const Text(
        'DuduRent',
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: DopamineColors.purple),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({
    required this.label,
    required this.selected,
    required this.selectedColors,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final List<Color> selectedColors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            gradient: selected ? LinearGradient(colors: selectedColors) : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }
}
