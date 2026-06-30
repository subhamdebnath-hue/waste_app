import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:waste_app/l10n/locale_controller.dart';
import 'package:waste_app/main.dart';

void main() {
  testWidgets('BinGo shows splash screen first', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final localeController = await LocaleController.create();

    await tester.pumpWidget(WasteWiseApp(localeController: localeController));

    expect(find.text('BinGo'), findsOneWidget);
    expect(find.text('Smart Waste Segregation'), findsOneWidget);
  });
}
