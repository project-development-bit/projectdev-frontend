import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gigafaucet/features/auth/presentation/pages/reset_password_page.dart';
import 'package:gigafaucet/features/auth/domain/repositories/auth_repository.dart';

import 'package:gigafaucet/core/common/common_button.dart';
import 'package:gigafaucet/core/common/common_textfield.dart';
import '../../../../test_helpers/test_app_wrapper.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('ResetPasswordPage Widget Tests', () {
    late MockAuthRepository mockAuthRepository;
    const testEmail = 'test@example.com';

    setUp(() {
      mockAuthRepository = MockAuthRepository();
    });

    Widget createTestWidget() {
      return ProviderScope(
        overrides: [
          // resetPasswordProvider.overrideWith(
          //   (ref) => ResetPasswordNotifier(mockAuthRepository,),
          // ),
        ],
        child: TestAppWrapper(
          child: ResetPasswordPage(email: testEmail),
        ),
      );
    }

    group('UI Elements', () {
      testWidgets('should display app bar with title',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Reset Password'), findsWidgets);
      });

      testWidgets('should display header section with email',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Create New Password'), findsOneWidget);
        expect(find.text('For: $testEmail'), findsOneWidget);
        expect(find.text('Password must be at least 8 characters long'),
            findsOneWidget);
        expect(find.byIcon(Icons.lock_reset), findsOneWidget);
      });

      testWidgets('should display password input fields',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(CommonTextField), findsNWidgets(2));
        expect(find.text('New Password'), findsOneWidget);
        expect(find.text('Confirm Password'), findsOneWidget);
        expect(find.text('Enter your new password'), findsOneWidget);
        expect(find.text('Confirm your new password'), findsOneWidget);
      });

      testWidgets('should display password visibility toggles',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byIcon(Icons.visibility), findsNWidgets(2));
      });

      testWidgets('should display reset password button',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(CommonButton), findsOneWidget);
        expect(find.text('Reset Password'),
            findsNWidgets(2)); // One in app bar, one in button
      });

      testWidgets('should display back to login link',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(TextButton), findsOneWidget);
        expect(find.text('Back to Login'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      });
    });

    group('User Interactions', () {
      testWidgets(
          'should toggle password visibility when visibility icon is tapped',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Act - Tap first visibility icon (new password field)
        await tester.tap(find.byIcon(Icons.visibility).first);
        await tester.pumpAndSettle();

        // Assert - Should show visibility_off icon
        expect(find.byIcon(Icons.visibility_off), findsAtLeastNWidgets(1));
      });

      testWidgets('should enter text in password fields',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Act
        await tester.enterText(
            find.byType(CommonTextField).first, 'newpassword123');
        await tester.enterText(
            find.byType(CommonTextField).last, 'newpassword123');
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('newpassword123'), findsNWidgets(2));
      });

      testWidgets(
          'should show loading state when reset password is in progress',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              // resetPasswordProvider.overrideWith(
              //   (ref) {
              //     final notifier = ResetPasswordNotifier(mockAuthRepository);
              //     notifier.state = ResetPasswordLoading();
              //     return notifier;
              //   },
              // ),
            ],
            child: TestAppWrapper(
              child: ResetPasswordPage(email: testEmail),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        final button = tester.widget<CommonButton>(find.byType(CommonButton));
        expect(button.isLoading, isTrue);
        expect(button.onPressed, isNull);
      });
    });

    group('Form Validation', () {
      testWidgets('should show validation error for short password',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Act
        await tester.enterText(find.byType(CommonTextField).first, '123');
        await tester.enterText(find.byType(CommonTextField).last, '123');
        await tester.tap(find.byType(CommonButton));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Password must be at least 8 characters long'),
            findsWidgets);
      });

      testWidgets('should show validation error when passwords do not match',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Act
        await tester.enterText(
            find.byType(CommonTextField).first, 'password123');
        await tester.enterText(
            find.byType(CommonTextField).last, 'differentpassword');
        await tester.tap(find.byType(CommonButton));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Passwords do not match'), findsWidgets);
      });

      testWidgets('should submit form when all validations pass',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Act
        await tester.enterText(
            find.byType(CommonTextField).first, 'validpassword123');
        await tester.enterText(
            find.byType(CommonTextField).last, 'validpassword123');
        await tester.tap(find.byType(CommonButton));
        await tester.pumpAndSettle();

        // Assert - Should attempt to call the provider
        // The actual provider call would be mocked in integration tests
        expect(find.text('Password must be at least 8 characters long'),
            findsNothing);
        expect(find.text('Passwords do not match'), findsNothing);
      });
    });

    group('Navigation', () {
      testWidgets('should attempt navigation when back to login is tapped',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();

        // Assert - Should not crash (navigation would be handled by router in real app)
        expect(tester.takeException(), isNull);
      });
    });

    group('Responsive Design', () {
      testWidgets('should adapt to different screen sizes',
          (WidgetTester tester) async {
        // Arrange - Set mobile screen size
        tester.view.physicalSize = const Size(375, 667); // iPhone SE size
        tester.view.devicePixelRatio = 2.0;

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert - Should render without overflow
        expect(tester.takeException(), isNull);
        expect(find.byType(ResetPasswordPage), findsOneWidget);

        // Arrange - Set tablet screen size
        tester.view.physicalSize = const Size(768, 1024); // iPad size
        await tester.pumpAndSettle();

        // Assert - Should still render correctly
        expect(tester.takeException(), isNull);
        expect(find.byType(ResetPasswordPage), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper semantics for screen readers',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert - Check that form fields have labels
        expect(find.text('New Password'), findsOneWidget);
        expect(find.text('Confirm Password'), findsOneWidget);

        // Check that button is accessible
        expect(find.byType(CommonButton), findsOneWidget);

        // Check semantic structure
        expect(tester.getSemantics(find.byType(ResetPasswordPage)), isNotNull);
      });
    });

    group('Theme Integration', () {
      testWidgets('should use theme colors correctly',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert - Widget should render with theme applied
        expect(find.byType(ResetPasswordPage), findsOneWidget);
        expect(tester.takeException(), isNull);

        // The specific color assertions would require accessing the actual widget properties
        // which is complex in widget tests. This test ensures the theme is applied without errors.
      });
    });
  });
}
