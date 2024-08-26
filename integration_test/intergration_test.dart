import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:orange/components/custom/custom_button.dart';
import 'package:orange/main.dart' as app;
import 'package:orange/components/custom/custom_icon.dart';
import 'package:orange/theme/stylesheet.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Tap on the custom button with text "Send" and then tap the back button or exit button', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final Finder sendButtonFinder = find.byWidgetPredicate(
      (Widget widget) =>
          widget is CustomButton && widget.text == 'Send',
    );
    expect(sendButtonFinder, findsOneWidget);
    await tester.tap(sendButtonFinder);
    await tester.pumpAndSettle();

    // Attempt to find and tap the back button
    final Finder backButtonFinder = find.byWidgetPredicate(
      (Widget widget) =>
          widget is CustomIcon && widget.icon == ThemeIcon.left,
    );
    if (backButtonFinder.evaluate().isNotEmpty) {
      expect(backButtonFinder, findsOneWidget);
      await tester.tap(backButtonFinder);
      await tester.pumpAndSettle();
      return; // Exit the test after successfully finding and tapping the back button
    }

    // If back button was not found, attempt to find and tap the exit button
    final Finder exitButtonFinder = find.byWidgetPredicate(
      (Widget widget) =>
          widget is CustomIcon && widget.icon == ThemeIcon.close,
    );
    if (exitButtonFinder.evaluate().isNotEmpty) {
      expect(exitButtonFinder, findsOneWidget);
      await tester.tap(exitButtonFinder);
      await tester.pumpAndSettle();
    } else {
      fail('Neither back button nor exit button was found.');
    }
  });
}
