// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_task_app/features/splash/presentation/views/splash_view.dart';

void main() {
  testWidgets('SplashView displays correct text and structure', (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (context, child) => const MaterialApp(
          home: SplashView(),
        ),
      ),
    );

    expect(find.byType(SplashView), findsOneWidget);
    expect(find.text('WEATHER'), findsOneWidget);
  });
}
