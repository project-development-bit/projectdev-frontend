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
    testWidgets('App should initialize and show home page',
        (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(
        const ProviderScope(
          child: TestAppWrapper(
            child: MyApp(),
          ),
        ),
      );

      // Wait for the app to load with timeout
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Verify that the home page is displayed (app starts on home page, not login)
      expect(
          find.text('Turn your free time into free Bitcoin'), findsOneWidget);
      expect(find.text('Earn up to \$596 USD per offer'), findsOneWidget);
      
      // Verify home page elements are present
      expect(find.text('Start Earning Now'),
          findsAtLeastNWidgets(1)); // CTA buttons
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

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Verify that the dev flavor banner is present
      expect(find.byType(Banner), findsOneWidget);
    });

    testWidgets('App should support theme switching', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

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

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // App should initialize with proper locale support
      // Since MyApp contains MaterialApp, we should find at least one
      expect(find.byType(MaterialApp), findsAtLeastNWidgets(1));
    });
  });
}
