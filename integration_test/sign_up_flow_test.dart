import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cointiply_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Sign Up Flow Test', () {
    testWidgets('Complete sign up flow with valid data',
        (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Sign Up screen from the app
      // First, try to find and tap a sign up button or link
      final signUpFinder = find.text('Sign Up');
      if (signUpFinder.evaluate().isNotEmpty) {
        await tester.tap(signUpFinder.first);
        await tester.pumpAndSettle();
      } else {
        // If no direct sign up button, navigate through authentication flow
        // This might be through a login page link
        final loginFinder = find.text('Sign In');
        if (loginFinder.evaluate().isNotEmpty) {
          await tester.tap(loginFinder.first);
          await tester.pumpAndSettle();

          // Look for "Sign Up" link on login page
          final signUpLinkFinder = find.text('Sign Up');
          if (signUpLinkFinder.evaluate().isNotEmpty) {
            await tester.tap(signUpLinkFinder.first);
            await tester.pumpAndSettle();
          }
        }
      }

      // Verify we're on the Sign Up screen
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Fill in your details to get started'), findsOneWidget);

      // Fill out the form with valid data
      // Full Name field
      final nameField = find.byType(TextFormField).at(0);
      await tester.enterText(nameField, 'Integration Test User');
      await tester.pumpAndSettle();

      // Email field
      final emailField = find.byType(TextFormField).at(1);
      await tester.enterText(emailField, 'integration.test@example.com');
      await tester.pumpAndSettle();

      // Password field
      final passwordField = find.byType(TextFormField).at(2);
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();

      // Confirm Password field
      final confirmPasswordField = find.byType(TextFormField).at(3);
      await tester.enterText(confirmPasswordField, 'password123');
      await tester.pumpAndSettle();

      // Select role from dropdown
      final roleDropdown = find.byType(DropdownButtonFormField<dynamic>);
      await tester.tap(roleDropdown);
      await tester.pumpAndSettle();

      // Select "Developer" role
      final developerOption = find.text('Developer').last;
      await tester.tap(developerOption);
      await tester.pumpAndSettle();

      // Submit the form
      final signUpButton = find.widgetWithText(ElevatedButton, 'Sign Up');
      expect(signUpButton, findsOneWidget);

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      // Wait for potential network request to complete
      // Give it some time for the API call
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Check if we successfully navigated to Sign In screen
      // We expect either to be on sign in page or see a success message

      // Check for success scenarios:
      // 1. We're redirected to login page
      final loginPageIndicators = [
        find.text('Welcome Back!'),
        find.text('Sign In'),
        find.text('Enter your email'),
        find.text('Enter your password')
      ];

      bool foundLoginIndicator = false;
      for (final indicator in loginPageIndicators) {
        if (indicator.evaluate().isNotEmpty) {
          foundLoginIndicator = true;
          break;
        }
      }

      // 2. Or we see a success message
      final successMessage = find.text('Account created successfully!');
      bool foundSuccessMessage = successMessage.evaluate().isNotEmpty;

      // Assert that either we're on login page or saw success message
      expect(foundLoginIndicator || foundSuccessMessage, isTrue,
          reason:
              'Should either navigate to login page or show success message');

      // If we found login indicators, verify we're actually on the sign in screen
      if (foundLoginIndicator) {
        // Verify key elements of the sign in screen are present
        expect(find.byType(TextFormField),
            findsAtLeastNWidgets(2)); // Email and password fields

        // Look for sign in button
        final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');
        expect(signInButton, findsOneWidget);
      }
    });

    testWidgets('Sign up with invalid data shows validation errors',
        (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Sign Up screen (similar logic as above)
      final signUpFinder = find.text('Sign Up');
      if (signUpFinder.evaluate().isNotEmpty) {
        await tester.tap(signUpFinder.first);
        await tester.pumpAndSettle();
      }

      // Verify we're on the Sign Up screen
      expect(find.text('Create Account'), findsOneWidget);

      // Try to submit empty form
      final signUpButton = find.widgetWithText(ElevatedButton, 'Sign Up');
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Full name is required'), findsOneWidget);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('Sign up with mismatched passwords shows error',
        (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Sign Up screen
      final signUpFinder = find.text('Sign Up');
      if (signUpFinder.evaluate().isNotEmpty) {
        await tester.tap(signUpFinder.first);
        await tester.pumpAndSettle();
      }

      // Fill form with mismatched passwords
      final nameField = find.byType(TextFormField).at(0);
      await tester.enterText(nameField, 'Test User');

      final emailField = find.byType(TextFormField).at(1);
      await tester.enterText(emailField, 'test@example.com');

      final passwordField = find.byType(TextFormField).at(2);
      await tester.enterText(passwordField, 'password123');

      final confirmPasswordField = find.byType(TextFormField).at(3);
      await tester.enterText(confirmPasswordField, 'differentpassword');

      await tester.pumpAndSettle();

      // Submit form
      final signUpButton = find.widgetWithText(ElevatedButton, 'Sign Up');
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      // Should show password mismatch error
      expect(find.text('Passwords do not match'), findsOneWidget);
    });
  });
}
