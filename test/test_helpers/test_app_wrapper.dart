import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cointiply_app/core/database/database_service.dart';
import 'package:cointiply_app/core/config/app_flavor.dart';
import 'package:cointiply_app/core/config/flavor_manager.dart';

/// Test wrapper widget that provides necessary dependencies for testing
class TestAppWrapper extends StatelessWidget {
  final Widget child;
  final List<Override>? overrides;

  const TestAppWrapper({
    super.key,
    required this.child,
    this.overrides,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides ?? [],
      child: MaterialApp(
        home: child,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

/// Initializes test environment with necessary dependencies
class TestInitializer {
  static bool _isInitialized = false;

  /// Initialize test environment (call once per test session)
  static Future<void> initialize() async {
    if (_isInitialized) return;

    TestWidgetsFlutterBinding.ensureInitialized();
    
    // Initialize test flavor
    FlavorManager.initialize(AppFlavor.dev);
    
    // Initialize Hive for testing (in-memory)
    await DatabaseService.init();
    
    _isInitialized = true;
  }

  /// Reset test environment (call before each test if needed)
  static void reset() {
    // Reset any global state if needed
    FlavorManager.initialize(AppFlavor.dev);
  }
}

/// Test utilities for common operations
class TestUtils {
  /// Pumps widget and waits for all animations to complete
  static Future<void> pumpAndSettle(WidgetTester tester, [Widget? widget]) async {
    if (widget != null) {
      await tester.pumpWidget(widget);
    }
    await tester.pumpAndSettle();
  }

  /// Creates a test-ready widget with all necessary providers
  static Widget createTestWidget(Widget child, {List<Override>? overrides}) {
    return ProviderScope(
      overrides: overrides ?? [],
      child: MaterialApp(
        home: child,
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  /// Taps a widget and waits for the tap to complete
  static Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Enters text into a field and waits for completion
  static Future<void> enterTextAndSettle(WidgetTester tester, Finder finder, String text) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }

  /// Verifies that a widget exists and is visible
  static void verifyWidgetExists(Finder finder, {int count = 1}) {
    if (count == 1) {
      expect(finder, findsOneWidget);
    } else {
      expect(finder, findsNWidgets(count));
    }
  }

  /// Verifies that a widget does not exist
  static void verifyWidgetNotExists(Finder finder) {
    expect(finder, findsNothing);
  }

  /// Verifies text exists on screen
  static void verifyTextExists(String text) {
    expect(find.text(text), findsOneWidget);
  }

  /// Verifies text does not exist on screen
  static void verifyTextNotExists(String text) {
    expect(find.text(text), findsNothing);
  }
}