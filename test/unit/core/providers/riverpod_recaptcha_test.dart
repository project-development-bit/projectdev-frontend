import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cointiply_app/core/providers/recaptcha_provider.dart';
import 'package:cointiply_app/core/providers/consolidated_auth_provider.dart';

void main() {
  group('Riverpod reCAPTCHA State Management Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('RecaptchaNotifier Tests', () {
      test('should initialize with appropriate state based on environment', () {
        final state = container.read(recaptchaNotifierProvider);
        // In test environment, it should be RecaptchaNotAvailable because no site key is configured
        expect(state, anyOf([
          isA<RecaptchaInitial>(),
          isA<RecaptchaNotAvailable>(),
        ]));
      });

      test('should provide correct provider responses', () {
        container = ProviderContainer();
        
        // Test initial state
        final isVerified = container.read(isRecaptchaVerifiedProvider);
        expect(isVerified, false);
        
        final isLoading = container.read(isRecaptchaLoadingProvider);
        expect(isLoading, false);
        
        final token = container.read(recaptchaTokenProvider);
        expect(token, isNull);
        
        final error = container.read(recaptchaErrorProvider);
        expect(error, isNull);
      });

      test('should update state when manually set to verified', () {
        container = ProviderContainer();
        const testToken = 'test-verification-token';
        
        // Set to verified state manually for testing
        container.read(recaptchaNotifierProvider.notifier).state = 
            const RecaptchaVerified(token: testToken);
        
        final token = container.read(recaptchaTokenProvider);
        expect(token, equals(testToken));
        
        final isVerified = container.read(isRecaptchaVerifiedProvider);
        expect(isVerified, true);
      });

      test('should handle error states correctly', () {
        container = ProviderContainer();
        const errorMessage = 'Test reCAPTCHA error';
        
        // Set error state
        container.read(recaptchaNotifierProvider.notifier).state = 
            const RecaptchaError(message: errorMessage);
        
        final error = container.read(recaptchaErrorProvider);
        expect(error, equals(errorMessage));
        
        final isVerified = container.read(isRecaptchaVerifiedProvider);
        expect(isVerified, false);
      });

      test('should handle loading states correctly', () {
        container = ProviderContainer();
        
        // Set initializing state
        container.read(recaptchaNotifierProvider.notifier).state = 
            const RecaptchaInitializing();
        
        final isLoading = container.read(isRecaptchaLoadingProvider);
        expect(isLoading, true);
        
        // Set verifying state
        container.read(recaptchaNotifierProvider.notifier).state = 
            const RecaptchaVerifying();
        
        final isStillLoading = container.read(isRecaptchaLoadingProvider);
        expect(isStillLoading, true);
      });

      test('should reset to appropriate state when reset is called', () {
        container = ProviderContainer();
        final notifier = container.read(recaptchaNotifierProvider.notifier);
        
        // Simulate verified state
        notifier.state = const RecaptchaVerified(token: 'test-token');
        expect(container.read(recaptchaNotifierProvider), isA<RecaptchaVerified>());
        
        // Reset
        notifier.reset();
        
        final finalState = container.read(recaptchaNotifierProvider);
        // Should reset to ready or not available depending on configuration
        expect(finalState, anyOf([
          isA<RecaptchaReady>(),
          isA<RecaptchaNotAvailable>(),
        ]));
      });
    });

    group('Consolidated Auth Provider Tests', () {
      test('should create consolidated state with reCAPTCHA state', () {
        container = ProviderContainer();
        
        final consolidatedState = container.read(consolidatedAuthStateProvider);
        
        expect(consolidatedState.recaptchaState, anyOf([
          isA<RecaptchaInitial>(),
          isA<RecaptchaNotAvailable>(),
        ]));
        expect(consolidatedState.isRecaptchaVerified, false);
      });

      test('should calculate isLoading correctly from reCAPTCHA state', () {
        container = ProviderContainer();
        
        // Initially not loading
        final initialLoading = container.read(isAnyAuthLoadingProvider);
        expect(initialLoading, false);
        
        // Set reCAPTCHA to initializing
        container.read(recaptchaNotifierProvider.notifier).state = 
            const RecaptchaInitializing();
        
        final loadingState = container.read(isAnyAuthLoadingProvider);
        expect(loadingState, true);
      });

      test('should provide auth actions with correct functionality', () {
        container = ProviderContainer();
        
        final authActions = container.read(authActionsProvider);
        
        expect(authActions, isA<AuthActions>());
        expect(() => authActions.resetRecaptcha(), returnsNormally);
        expect(() => authActions.resetAllStates(), returnsNormally);
      });

      test('should get current error from reCAPTCHA when present', () {
        container = ProviderContainer();
        const errorMessage = 'Test reCAPTCHA error';
        
        // Set reCAPTCHA error state
        container.read(recaptchaNotifierProvider.notifier).state = 
            const RecaptchaError(message: errorMessage);
        
        final consolidatedError = container.read(currentAuthErrorProvider);
        expect(consolidatedError, equals(errorMessage));
      });
    });

    group('Provider Integration Tests', () {
      test('should maintain consistency between individual and consolidated providers', () {
        container = ProviderContainer();
        
        // Check individual providers match consolidated state
        final individualRecaptchaState = container.read(recaptchaNotifierProvider);
        final consolidatedState = container.read(consolidatedAuthStateProvider);
        
        expect(consolidatedState.recaptchaState, equals(individualRecaptchaState));
        
        final individualIsVerified = container.read(isRecaptchaVerifiedProvider);
        expect(consolidatedState.isRecaptchaVerified, equals(individualIsVerified));
      });

      test('should update consolidated state when reCAPTCHA state changes', () {
        container = ProviderContainer();
        
        // Check initial state
        final consolidatedState = container.read(consolidatedAuthStateProvider);
        expect(consolidatedState.isRecaptchaVerified, false);
        
        // Change reCAPTCHA state
        container.read(recaptchaNotifierProvider.notifier).state = 
            const RecaptchaVerified(token: 'test-token');
        
        // Check consolidated state updated
        final updatedConsolidatedState = container.read(consolidatedAuthStateProvider);
        expect(updatedConsolidatedState.isRecaptchaVerified, true);
        expect(updatedConsolidatedState.recaptchaState, isA<RecaptchaVerified>());
      });
    });

    group('State Transition Tests', () {
      test('should transition through states correctly during verification flow', () {
        container = ProviderContainer();
        final notifier = container.read(recaptchaNotifierProvider.notifier);
        
        // Start with initial state (may be not available in test environment)
        final initialState = container.read(recaptchaNotifierProvider);
        expect(initialState, anyOf([
          isA<RecaptchaInitial>(),
          isA<RecaptchaNotAvailable>(),
        ]));
        
        // Move to ready state
        notifier.state = const RecaptchaReady();
        expect(container.read(recaptchaNotifierProvider), isA<RecaptchaReady>());
        expect(container.read(canVerifyRecaptchaProvider), true);
        
        // Move to verifying state
        notifier.state = const RecaptchaVerifying();
        expect(container.read(recaptchaNotifierProvider), isA<RecaptchaVerifying>());
        expect(container.read(isRecaptchaLoadingProvider), true);
        
        // Move to verified state
        notifier.state = const RecaptchaVerified(token: 'success-token');
        expect(container.read(recaptchaNotifierProvider), isA<RecaptchaVerified>());
        expect(container.read(isRecaptchaVerifiedProvider), true);
        expect(container.read(recaptchaTokenProvider), equals('success-token'));
      });

      test('should handle error transitions correctly', () {
        container = ProviderContainer();
        final notifier = container.read(recaptchaNotifierProvider.notifier);
        
        // Start with ready state
        notifier.state = const RecaptchaReady();
        
        // Move to verifying
        notifier.state = const RecaptchaVerifying();
        expect(container.read(isRecaptchaLoadingProvider), true);
        
        // Move to error
        notifier.state = const RecaptchaError(message: 'Verification failed');
        expect(container.read(isRecaptchaLoadingProvider), false);
        expect(container.read(isRecaptchaVerifiedProvider), false);
        expect(container.read(recaptchaErrorProvider), equals('Verification failed'));
      });
    });
  });
}