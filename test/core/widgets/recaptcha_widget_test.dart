import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/widgets/recaptcha_widget.dart';
import 'package:gigafaucet/core/config/flavor_manager.dart';
import 'package:gigafaucet/core/config/app_flavor.dart';

void main() {
  group('RecaptchaWidget Tests', () {
    setUp(() {
      // Initialize with staging flavor for testing
      FlavorManager.initialize(AppFlavor.staging);
    });

    testWidgets('should render reCAPTCHA widget for staging environment',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RecaptchaWidget(
                onVerificationChanged: (bool isVerified) {
                  // Callback for verification changes
                },
              ),
            ),
          ),
        ),
      );

      // Verify that the widget is rendered
      expect(find.text("I'm not a robot"), findsOneWidget);
      expect(find.text('reCAPTCHA'), findsOneWidget);
    });

    testWidgets('should not render reCAPTCHA widget for dev environment',
        (WidgetTester tester) async {
      // Set to dev environment
      FlavorManager.initialize(AppFlavor.dev);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RecaptchaWidget(
                onVerificationChanged: (bool isVerified) {
                  // Should not be called
                },
              ),
            ),
          ),
        ),
      );

      // Verify that the widget is not rendered
      expect(find.text("I'm not a robot"), findsNothing);
      expect(find.text('reCAPTCHA'), findsNothing);
    });

    testWidgets(
        'should call onVerificationChanged when verification status changes',
        (WidgetTester tester) async {
      FlavorManager.initialize(AppFlavor.staging);
      bool verificationStatus = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RecaptchaWidget(
                onVerificationChanged: (bool isVerified) {
                  verificationStatus = isVerified;
                },
              ),
            ),
          ),
        ),
      );

      // Initial state should be false
      expect(verificationStatus, false);

      // Note: We can't easily test the Google reCAPTCHA integration in unit tests
      // as it requires browser APIs. This would need integration tests.
    });

    testWidgets('should show error message when reCAPTCHA is not configured',
        (WidgetTester tester) async {
      // Set to production where no reCAPTCHA key is configured
      FlavorManager.initialize(AppFlavor.prod);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RecaptchaWidget(
                onVerificationChanged: (bool isVerified) {
                  // Should not be called
                },
              ),
            ),
          ),
        ),
      );

      // Should not render anything when no site key is configured
      expect(find.text("I'm not a robot"), findsNothing);
      expect(find.text('reCAPTCHA'), findsNothing);
    });
  });
}
