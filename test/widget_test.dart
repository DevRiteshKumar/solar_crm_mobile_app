import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:crm_mobile_app/app/app.dart';

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(Get.reset);

  testWidgets('App launches login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SolarCrmApp());
    await tester.pumpAndSettle();
    expect(find.text('Sign In'), findsWidgets);
  });
}
