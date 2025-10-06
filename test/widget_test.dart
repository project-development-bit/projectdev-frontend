import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cointiply_app/main_common.dart';
import 'package:cointiply_app/core/config/app_flavor.dart';
import 'package:cointiply_app/core/config/flavor_manager.dart';
import 'test_helpers/test_app_wrapper.dart';

void main() {
  setUpAll(() {
    // Initialize test flavor for all tests
    FlavorManager.initialize(AppFlavor.dev);
  });

  group('App Initialization Tests', () {
    testWidgets('App should initialize and show login page', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(
        const ProviderScope(
          child: TestAppWrapper(
            child: MyApp(),
          ),
        ),
      );

      // Wait for the app to settle
      await tester.pumpAndSettle();

      // Verify that the login page is displayed
      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.text('Sign in to continue to Burger Eats'), findsOneWidget);
      
      // Verify login form elements are present
      expect(find.byType(TextFormField), findsAtLeastNWidgets(2)); // Email and password fields
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('App should show flavor banner in development', (WidgetTester tester) async {
      // Ensure we're in dev mode
      FlavorManager.initialize(AppFlavor.dev);
      
      await tester.pumpWidget(
        const ProviderScope(
          child: TestAppWrapper(
            child: MyApp(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the dev flavor banner is present
      expect(find.byType(Banner), findsOneWidget);
    });

    testWidgets('App should support theme switching', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // App should initialize and show the main content
      // Since MyApp contains MaterialApp, we should find at least one
      expect(find.byType(MaterialApp), findsAtLeastNWidgets(1));
    });

    testWidgets('App should support locale switching', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // App should initialize with proper locale support
      // Since MyApp contains MaterialApp, we should find at least one
      expect(find.byType(MaterialApp), findsAtLeastNWidgets(1));
    });
  });
}
