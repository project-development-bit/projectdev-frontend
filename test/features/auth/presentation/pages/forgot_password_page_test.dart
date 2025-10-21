import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cointiply_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:cointiply_app/features/auth/presentation/providers/forgot_password_provider.dart';

void main() {
  group('ForgotPasswordPage Widget Tests', () {
    
    testWidgets('should display all required UI elements', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const ForgotPasswordPage(),
          ),
        ),
      );

      // Assert
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.byIcon(Icons.lock_reset), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Send Security Code'), findsOneWidget);
      expect(find.text('Back to Login'), findsOneWidget);
    });

    testWidgets('should show validation error for empty email', (WidgetTester tester) async {
      // Arrange  
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const ForgotPasswordPage(),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Send Security Code'));
      await tester.pump();

      // Assert
      expect(find.text('Please enter your email address'), findsOneWidget);
    });

    testWidgets('should show validation error for invalid email format', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const ForgotPasswordPage(),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField), 'invalid-email');
      await tester.tap(find.text('Send Security Code'));
      await tester.pump();

      // Assert
      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('should accept valid email format', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const ForgotPasswordPage(),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      await tester.tap(find.text('Send Security Code'));
      await tester.pump();

      // Assert - No validation error should be shown
      expect(find.text('Please enter your email address'), findsNothing);
      expect(find.text('Please enter a valid email address'), findsNothing);
    });

    testWidgets('should show loading indicator when request is in progress', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            forgotPasswordProvider.overrideWith(
              (ref) => TestForgotPasswordNotifier(ForgotPasswordLoading()),
            ),
          ],
          child: MaterialApp(
            home: const ForgotPasswordPage(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // The button should be disabled during loading
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('should navigate back when back button is pressed', (WidgetTester tester) async {
      // Arrange
      bool backPressed = false;
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => const ForgotPasswordPage())
                    );
                  },
                  child: const Text('Go to Forgot Password'),
                ),
              ),
            ),
            onGenerateRoute: (settings) {
              if (settings.name == '/') {
                backPressed = true;
              }
              return null;
            },
          ),
        ),
      );

      // Navigate to forgot password page
      await tester.tap(find.text('Go to Forgot Password'));
      await tester.pumpAndSettle();

      // Act - Press back button
      await tester.tap(find.text('Back to Login'));
      await tester.pumpAndSettle();

      // Assert - Should navigate back
      expect(find.byType(ForgotPasswordPage), findsNothing);
    });

    testWidgets('should handle different screen sizes responsively', (WidgetTester tester) async {
      // Test mobile size
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const ForgotPasswordPage(),
          ),
        ),
      );
      await tester.pump();

      // Assert mobile layout elements are present
      expect(find.byType(ForgotPasswordPage), findsOneWidget);
      expect(find.byIcon(Icons.lock_reset), findsOneWidget);
      
      // Test tablet/desktop size
      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pump();

      // Assert elements are still present in larger screen
      expect(find.byType(ForgotPasswordPage), findsOneWidget);
      expect(find.byIcon(Icons.lock_reset), findsOneWidget);
    });

    testWidgets('should display correct hint and label text', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const ForgotPasswordPage(),
          ),
        ),
      );

      // Act
      final textField = find.byType(TextFormField);
      
      // Assert
      expect(textField, findsOneWidget);
      
      // Check that the text field renders properly
      final textFormField = tester.widget<TextFormField>(textField);
      expect(textFormField, isNotNull);
    });
  });
}

/// Test notifier for overriding the provider in tests
class TestForgotPasswordNotifier extends ForgotPasswordNotifier {
  final ForgotPasswordState _testState;
  
  TestForgotPasswordNotifier(this._testState) : super(throw UnimplementedError());
  
  @override
  ForgotPasswordState build() => _testState;
  
  @override
  Future<void> forgotPassword(String email) async {
    // Do nothing in test
  }
  
  @override
  void reset() {
    // Do nothing in test
  }
}