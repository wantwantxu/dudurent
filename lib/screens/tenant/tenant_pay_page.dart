import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class TenantPayPage extends StatelessWidget {
  const TenantPayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.watch<AppState>().tenantHome;
    final total = home.rent + 138;

    return Scaffold(
      appBar: AppBar(
        title: const Text('在线缴房租'),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [DopamineColors.pink, DopamineColors.orange],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('本期应缴合计', style: TextStyle(color: Colors.white70, fontSize: 11)),
                Text(
                  yen(total),
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
                ),
                Text(home.name, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          GlassCard(
            child: Column(
              children: [
                _row('房屋月租', yen(home.rent)),
                const Divider(height: 20),
                _row('水电气费', '¥138'),
                const Divider(height: 20),
                _row('合计', yen(total), emphasize: true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: '确认支付本月账单',
            colors: const [DopamineColors.yellow, DopamineColors.orange],
            foreground: const Color(0xFF0F172A),
            onPressed: () async {
              await context.read<AppState>().recordRentPayment(
                    propertyId: home.id,
                    propertyName: home.name,
                    amount: total,
                  );
              if (!context.mounted) return;
              showAppToast(context, '支付成功！账单已同步房东端');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool emphasize = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: emphasize ? FontWeight.w900 : FontWeight.w600,
              fontSize: emphasize ? 14 : 12,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: emphasize ? DopamineColors.pink : const Color(0xFF0F172A),
            fontWeight: FontWeight.w900,
            fontSize: emphasize ? 16 : 13,
          ),
        ),
      ],
    );
  }
}
