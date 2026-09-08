import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_management_system/app/app.dart';

void main() {
  testWidgets('Library Management System renders splash and app launch', (WidgetTester tester) async {
    await tester.pumpWidget(const LibraryManagementSystem());

    expect(find.text('Library Management System'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Advance time past the splash delay
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify transition to WelcomeScreen
    expect(find.text('Welcome to'), findsOneWidget);
    expect(find.text('Role'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
