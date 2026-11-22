import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dudu_rent/main.dart';
import 'package:dudu_rent/state/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('嘟嘟租房首页展示品牌与房东端', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState();
    await state.init();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: const DuduRentApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('嘟嘟租房'), findsWidgets);
    expect(find.textContaining('房东端'), findsOneWidget);
    expect(find.textContaining('名下资产及租赁台账'), findsOneWidget);
  });
}
