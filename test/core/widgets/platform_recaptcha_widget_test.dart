import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cointiply_app/core/widgets/recaptcha_widget.dart';
import 'package:cointiply_app/core/providers/recaptcha_provider.dart';
import 'package:cointiply_app/core/services/platform_recaptcha_service.dart';
import 'package:cointiply_app/core/config/flavor_manager.dart';
import 'package:cointiply_app/core/config/app_flavor.dart';

void main() {
  group('Platform-Aware reCAPTCHA Tests', () {
    setUp(() {
      // Initialize with staging flavor for testing
      FlavorManager.initialize(AppFlavor.staging);
    });

    group('PlatformRecaptchaService', () {
      test('should detect platform correctly', () {
        expect(PlatformRecaptchaService.isSupported, isTrue);
        expect(PlatformRecaptchaService.platformName, isNotEmpty);
      });

      test('should initialize successfully', () async {
        final success = await PlatformRecaptchaService.initialize('test_site_key');
        expect(success, isTrue);
      });

      test('should execute verification', () async {
        await PlatformRecaptchaService.initialize('test_site_key');
        final token = await PlatformRecaptchaService.execute('test_action');
        expect(token, isNotNull);
        expect(token, isNotEmpty);
      });
    });

    group('RecaptchaWidget', () {
      testWidgets('should render for staging environment', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: RecaptchaWidgetFactory.forLogin(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should show the reCAPTCHA container
        expect(find.byType(RecaptchaWidget), findsOneWidget);
        expect(find.text("I'm not a robot"), findsOneWidget);
      });

      testWidgets('should show platform indicator in debug mode', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: RecaptchaWidgetFactory.forLogin(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should show platform information in debug mode
        expect(find.textContaining('Platform:'), findsOneWidget);
        expect(find.textContaining('Action: login'), findsOneWidget);
      });

      testWidgets('should handle verification tap', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: RecaptchaWidgetFactory.forLogin(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Wait for initialization
        await tester.pump(const Duration(seconds: 2));

        // Find and tap the verification area
        final recaptchaFinder = find.text("I'm not a robot");
        expect(recaptchaFinder, findsOneWidget);
        
        await tester.tap(recaptchaFinder);
        await tester.pump();

        // Should show loading indicator
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should use different actions for different factory methods', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    RecaptchaWidgetFactory.forLogin(),
                    RecaptchaWidgetFactory.forSignup(),
                    RecaptchaWidgetFactory.forPasswordReset(),
                    RecaptchaWidgetFactory.forForgotPassword(),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should render multiple reCAPTCHA widgets
        expect(find.byType(RecaptchaWidget), findsNWidgets(4));
        
        // Should show different actions in debug mode
        expect(find.textContaining('Action: login'), findsOneWidget);
        expect(find.textContaining('Action: signup'), findsOneWidget);
        expect(find.textContaining('Action: password_reset'), findsOneWidget);
        expect(find.textContaining('Action: forgot_password'), findsOneWidget);
      });

      testWidgets('should show enhanced UI with platform icons', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: RecaptchaWidgetFactory.forLogin(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should show reCAPTCHA branding
        expect(find.text('reCAPTCHA'), findsOneWidget);
        expect(find.text('Privacy'), findsOneWidget);
        expect(find.text('Terms'), findsOneWidget);
        
        // Should show platform-specific icon
        expect(find.byIcon(Icons.language), findsOneWidget); // Web platform icon
      });

      testWidgets('should work with custom actions', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: RecaptchaWidget(action: 'custom_action'),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should show the custom action in debug mode
        expect(find.textContaining('Action: custom_action'), findsOneWidget);
      });
    });

    group('RecaptchaProvider Integration', () {
      testWidgets('should integrate with RecaptchaProvider state', (WidgetTester tester) async {
        late WidgetRef ref;
        
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: Consumer(
                  builder: (context, widgetRef, child) {
                    ref = widgetRef;
                    return RecaptchaWidgetFactory.forLogin();
                  },
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Check initial provider state
        final isRequired = ref.read(isRecaptchaRequiredProvider);
        final isLoading = ref.read(isRecaptchaLoadingProvider);
        
        expect(isRequired, isTrue);
        expect(isLoading, isFalse); // Should be ready after initialization
      });

      test('should provide correct state through providers', () async {
        final container = ProviderContainer();
        
        // Wait for initialization
        await Future.delayed(const Duration(milliseconds: 100));
        
        final isRequired = container.read(isRecaptchaRequiredProvider);
        final isAvailable = container.read(isRecaptchaAvailableProvider);
        
        expect(isRequired, isTrue);
        expect(isAvailable, isTrue);
        
        container.dispose();
      });
    });

    group('Error Handling', () {
      testWidgets('should display error messages properly', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              // Override provider to simulate error state
              recaptchaNotifierProvider.overrideWith(
                (ref) => TestRecaptchaNotifier()..simulateError(),
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: RecaptchaWidgetFactory.forLogin(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should show error message
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.textContaining('failed'), findsOneWidget);
      });
    });
  });
}

/// Test implementation of RecaptchaNotifier for testing error states
class TestRecaptchaNotifier extends RecaptchaNotifier {
  void simulateError() {
    state = const RecaptchaError(message: 'Test error message');
  }
}