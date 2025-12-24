import 'package:gigafaucet/core/enum/user_role.dart';
import 'package:gigafaucet/core/error/error_model.dart';
import 'package:gigafaucet/core/services/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/features/auth/data/models/request/facebook_login_request.dart';
import 'package:gigafaucet/features/auth/data/models/request/google_login_request.dart';
import 'package:gigafaucet/features/auth/data/models/request/google_register_request.dart';
import 'package:gigafaucet/features/auth/domain/usecases/facebook_login_usecase.dart';
import 'package:gigafaucet/features/auth/domain/usecases/facebook_register_usecase.dart';
import 'package:gigafaucet/features/auth/domain/usecases/google_siginup_usecase.dart';
import 'package:gigafaucet/features/auth/domain/usecases/google_signin_usecase.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/providers/turnstile_provider.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/login_response.dart';
import '../../data/models/login_request.dart';
import 'auth_providers.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

// =============================================================================
// LOGIN STATE CLASSES
// =============================================================================

/// Login state for the application
@immutable
sealed class LoginState {
  const LoginState();
}

/// Initial login state
class LoginInitial extends LoginState {
  const LoginInitial();
}

/// Login operation in progress
class LoginLoading extends LoginState {
  const LoginLoading();
}

/// Login successful
class LoginSuccess extends LoginState {
  const LoginSuccess({this.user, required this.loginResponse});

  final User? user;
  final LoginResponse loginResponse;
}

/// Login error occurred
class LoginError extends LoginState {
  const LoginError(
      {required this.message,
      required this.email,
      this.isNetworkError = false,
      this.errorModel});
  final String email;
  final String message;
  final bool isNetworkError;
  final ErrorModel? errorModel;
}

// =============================================================================
// LOGIN STATE NOTIFIER
// =============================================================================

/// StateNotifier for managing login operations
class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(this._ref, this._deviceInfo) : super(const LoginInitial());

  final Ref _ref;
  final DeviceInfo _deviceInfo;

  Future<void> _refreshTurnstileForRetry() async {
    try {
      final notifier = _ref
          .read(turnstileNotifierProvider(TurnstileActionEnum.login).notifier);

      if (!notifier.isControllerReady) {
        await notifier.initializeController();
      }

      await notifier.refreshToken();
    } catch (e) {
      debugPrint('⚠️ Failed to refresh Turnstile token: $e');
    }
  }

  /// Login with email and password
  Future<void> login({
    required String email,
    required String password,
    required String countryCode,
    VoidCallback? onSuccess,
    Function(String)? onError,
  }) async {
    debugPrint('🔄 Starting login process for: $email');
    debugPrint('🔄 Current state before login: ${state.runtimeType}');

    // Ensure we start with loading state and clear any previous state
    state = const LoginLoading();
    debugPrint('🔄 State set to LoginLoading');

    try {
      // Get Turnstile token (replaces reCAPTCHA)
      String? turnstileToken;

      debugPrint('🔐 Checking Turnstile verification...');
      final turnstileState =
          _ref.read(turnstileNotifierProvider(TurnstileActionEnum.login));

      if (turnstileState is TurnstileSuccess) {
        turnstileToken = turnstileState.token;
        debugPrint('✅ Turnstile token obtained successfully');
      } else {
        debugPrint('❌ Turnstile verification incomplete');
        state = LoginError(
          email: email,
          message:
              'Security verification required. Please complete the verification and try again.',
        );
        return;
      }

      final loginRequest = LoginRequest(
        email: email,
        password: password,
        countryCode: countryCode,
        recaptchaToken: turnstileToken,
        deviceFingerprint: await _deviceInfo.getUniqueIdentifier() ?? '',
        userAgent: await _deviceInfo.getUserAgent(),
      );

      debugPrint('📤 Sending login request with Turnstile token');

      final loginUseCase = _ref.read(loginUseCaseProvider);

      // Add timeout to prevent infinite loading
      final result = await loginUseCase(loginRequest).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception(
              'Login timeout: Please check your internet connection and try again');
        },
      );

      result.fold(
        (failure) {
          debugPrint('❌ Login failed: ${failure.message}');
          state = LoginError(
            email: email,
            message: failure.message ?? 'Login failed',
            isNetworkError: failure.toString().contains('network') ||
                failure.toString().contains('connection'),
            errorModel: failure.errorModel,
          );

          // On any login error (wrong password, server error, etc.), refresh
          // Turnstile so the next attempt has a fresh token.
          _refreshTurnstileForRetry();

          onError?.call(failure.message ?? 'Login failed');
          debugPrint('🔄 State set to LoginError');
        },
        (loginResponse) async {
          debugPrint('✅ Login successful for: $email');

          // Check if this is a 2FA required response (user and tokens are null)
          if (loginResponse.user == null || loginResponse.tokens == null) {
            debugPrint('🔐 2FA required - userId: ${loginResponse.userId}');
            // Set state to LoginSuccess with the response containing userId
            state = LoginSuccess(
              user: null,
              loginResponse: loginResponse,
            );
            debugPrint('🔄 State set to LoginSuccess (2FA required)');
            onSuccess?.call();
            return;
          }

          debugPrint(
              '✅ Access token length: ${loginResponse.tokens!.accessToken.length}');
          debugPrint(
              '✅ Refresh token length: ${loginResponse.tokens!.refreshToken.length}');

          // Store user data in local database
          try {
            await DatabaseService.saveUser(loginResponse.user!);
            debugPrint('✅ User data saved to database');
          } catch (dbError) {
            debugPrint('⚠️ Failed to save user to database: $dbError');
            // Don't fail the login process if database save fails
          }

          // Ensure state is set after all async operations
          await Future.delayed(const Duration(milliseconds: 50));

          state = LoginSuccess(
            user: loginResponse.user,
            loginResponse: loginResponse,
          );
          debugPrint('🔄 State set to LoginSuccess');

          // Verify tokens were stored properly
          try {
            final secureStorage = _ref.read(secureStorageServiceProvider);
            final storedToken = await secureStorage.getAuthToken();
            debugPrint(
                '✅ Token verification - stored token length: ${storedToken?.length ?? 0}');
          } catch (e) {
            debugPrint('⚠️ Token verification failed: $e');
          }
          onSuccess?.call();
        },
      );
    } catch (e) {
      debugPrint('❌ Unexpected login error: $e');
      state = LoginError(
        email: email,
        message: e.toString().contains('timeout')
            ? 'Login timeout: Please check your connection and try again'
            : 'An unexpected error occurred during login. Please try again.',
      );

      // If the request threw, refresh Turnstile for a clean retry.
      _refreshTurnstileForRetry();

      debugPrint('🔄 State set to LoginError (catch block)');
    }

    debugPrint('🔄 Login process completed. Final state: ${state.runtimeType}');
  }

  Future<void> googleSignIn({
    required String countryCode,
    String? idToken,
    VoidCallback? onSuccess,
    Function(String)? onError,
  }) async {
    debugPrint('🔄 Starting login process for: google Login');
    debugPrint('🔄 Current state before login: ${state.runtimeType}');

    // Ensure we start with loading state and clear any previous state
    state = const LoginLoading();
    debugPrint('🔄 State set to LoginLoading');

    try {
      // Get Turnstile token (replaces reCAPTCHA)
      String? turnstileToken;

      debugPrint('🔐 Checking Turnstile verification...');
      final turnstileState =
          _ref.read(turnstileNotifierProvider(TurnstileActionEnum.login));

      if (turnstileState is TurnstileSuccess) {
        turnstileToken = turnstileState.token;
        debugPrint('✅ Turnstile token obtained successfully');
      } else {
        debugPrint('❌ Turnstile verification incomplete');
        state = LoginError(
          email: '',
          message:
              'Security verification required. Please complete the verification and try again.',
        );
        return;
      }

      final loginRequest = GoogleLoginRequest(
        idToken: idToken,
        countryCode: countryCode,
        recaptchaToken: turnstileToken,
        deviceFingerprint: await _deviceInfo.getUniqueIdentifier() ?? '',
        userAgent: await _deviceInfo.getUserAgent(),
      );

      debugPrint('📤 Sending login request with Turnstile token');

      final loginUseCase = _ref.read(googleSignInUseCaseProvider);

      // Add timeout to prevent infinite loading
      final result = await loginUseCase(loginRequest);

      result.fold(
        (failure) {
          debugPrint('❌ Login failed: ${failure.message}');
          state = LoginError(
            email: '',
            message: failure.message ?? 'Login failed',
            isNetworkError: failure.toString().contains('network') ||
                failure.toString().contains('connection'),
            errorModel: failure.errorModel,
          );
          onError?.call(failure.message ?? 'Login failed');
          debugPrint('🔄 State set to LoginError');
        },
        (loginResponse) async {
          debugPrint('✅ Login successful for: google Login');

          // Check if this is a 2FA required response (user and tokens are null)
          if (loginResponse.user == null || loginResponse.tokens == null) {
            debugPrint('🔐 2FA required - userId: ${loginResponse.userId}');
            // Set state to LoginSuccess with the response containing userId
            state = LoginSuccess(
              user: null,
              loginResponse: loginResponse,
            );
            debugPrint('🔄 State set to LoginSuccess (2FA required)');
            onSuccess?.call();
            return;
          }

          debugPrint(
              '✅ Access token length: ${loginResponse.tokens!.accessToken.length}');
          debugPrint(
              '✅ Refresh token length: ${loginResponse.tokens!.refreshToken.length}');

          // Store user data in local database
          try {
            await DatabaseService.saveUser(loginResponse.user!);
            debugPrint('✅ User data saved to database');
          } catch (dbError) {
            debugPrint('⚠️ Failed to save user to database: $dbError');
            // Don't fail the login process if database save fails
          }

          // Ensure state is set after all async operations
          await Future.delayed(const Duration(milliseconds: 50));

          state = LoginSuccess(
            user: loginResponse.user,
            loginResponse: loginResponse,
          );
          debugPrint('🔄 State set to LoginSuccess');

          // Verify tokens were stored properly
          try {
            final secureStorage = _ref.read(secureStorageServiceProvider);
            final storedToken = await secureStorage.getAuthToken();
            debugPrint(
                '✅ Token verification - stored token length: ${storedToken?.length ?? 0}');
          } catch (e) {
            debugPrint('⚠️ Token verification failed: $e');
          }
          onSuccess?.call();
        },
      );
    } catch (e) {
      debugPrint('❌ Unexpected login error: $e');
      state = LoginError(
        email: '',
        message: e.toString().contains('timeout')
            ? 'Google Login timeout: Please check your connection and try again'
            : 'An unexpected error occurred during Google login. Please try again.',
      );
      debugPrint('🔄 State set to Google LoginError (catch block)');
    }

    debugPrint('🔄 Login process completed. Final state: ${state.runtimeType}');
  }

  Future<void> googleSignUp({
    required String countryCode,
    String? idToken,
    UserRole role = UserRole.normalUser,
    String? referralCode,
    VoidCallback? onSuccess,
    Function(String)? onError,
  }) async {
    debugPrint('🔄 Starting google sign-up process');
    debugPrint('🔄 Current state before Google sign-up: ${state.runtimeType}');

    // Ensure we start with loading state and clear any previous state
    state = const LoginLoading();
    debugPrint('🔄 State set to GoogleSignUpLoading');

    try {
      // Get Turnstile token (replaces reCAPTCHA)
      String? turnstileToken;

      debugPrint('🔐 Checking Turnstile verification...');
      final turnstileState =
          _ref.read(turnstileNotifierProvider(TurnstileActionEnum.register));

      if (turnstileState is TurnstileSuccess) {
        turnstileToken = turnstileState.token;
        debugPrint('✅ Turnstile token obtained successfully');
      } else {
        debugPrint('❌ Turnstile verification incomplete');
        state = LoginError(
          email: '',
          message:
              'Security verification required. Please complete the verification and try again.',
        );
        return;
      }

      final loginRequest = GoogleRegisterRequest(
        idToken: idToken,
        role: role,
        referralCode: referralCode,
        countryCode: countryCode,
        recaptchaToken: turnstileToken,
        deviceFingerprint: await _deviceInfo.getUniqueIdentifier() ?? '',
        userAgent: await _deviceInfo.getUserAgent(),
      );

      debugPrint('📤 Sending login request with Turnstile token');

      final loginUseCase = _ref.read(googleSignUpUseCaseProvider);

      // Add timeout to prevent infinite loading
      final result = await loginUseCase(loginRequest);

      result.fold(
        (failure) {
          debugPrint('❌ Google sign-up failed: ${failure.message}');
          GoogleSignInPlatform.instance.signOut();
          state = LoginError(
            email: '',
            message: failure.message ?? 'Google sign-up failed',
            isNetworkError: failure.toString().contains('network') ||
                failure.toString().contains('connection'),
            errorModel: failure.errorModel,
          );
          onError?.call(failure.message ?? 'Google sign-up failed');
          debugPrint('🔄 State set to GoogleSignUpError');
        },
        (loginResponse) async {
          debugPrint('✅ Google sign-up successful');
          // Check if this is a 2FA required response (user and tokens are null)
          if (loginResponse.user == null || loginResponse.tokens == null) {
            debugPrint('🔐 2FA required - userId: ${loginResponse.userId}');
            // Set state to LoginSuccess with the response containing userId
            state = LoginSuccess(
              user: null,
              loginResponse: loginResponse,
            );
            debugPrint('🔄 State set to LoginSuccess (2FA required)');
            onSuccess?.call();
            return;
          }

          debugPrint(
              '✅ Access token length: ${loginResponse.tokens!.accessToken.length}');
          debugPrint(
              '✅ Refresh token length: ${loginResponse.tokens!.refreshToken.length}');

          // Store user data in local database
          try {
            await DatabaseService.saveUser(loginResponse.user!);
            debugPrint('✅ User data saved to database');
          } catch (dbError) {
            debugPrint('⚠️ Failed to save user to database: $dbError');
            // Don't fail the login process if database save fails
          }

          // Ensure state is set after all async operations
          await Future.delayed(const Duration(milliseconds: 50));

          state = LoginSuccess(
            user: loginResponse.user,
            loginResponse: loginResponse,
          );
          debugPrint('🔄 State set to LoginSuccess');

          // Verify tokens were stored properly
          try {
            final secureStorage = _ref.read(secureStorageServiceProvider);
            final storedToken = await secureStorage.getAuthToken();
            debugPrint(
                '✅ Token verification - stored token length: ${storedToken?.length ?? 0}');
          } catch (e) {
            debugPrint('⚠️ Token verification failed: $e');
          }
          onSuccess?.call();
        },
      );
    } catch (e) {
      debugPrint('❌ Unexpected login error: $e');
      state = LoginError(
        email: '',
        message: e.toString().contains('timeout')
            ? 'Google sign-up timeout: Please check your connection and try again'
            : 'An unexpected error occurred during Google sign-up. Please try again.',
      );
      debugPrint('🔄 State set to GoogleSignUpError (catch block)');
    }

    debugPrint(
        '🔄 Google sign-up process completed. Final state: ${state.runtimeType}');
  }

  Future<void> facebookSignIn({
    required String countryCode,
    String? accessToken,
    VoidCallback? onSuccess,
    Function(String)? onError,
  }) async {
    debugPrint('🔄 Starting login process for: Facebook Login');
    debugPrint('🔄 Current state before Facebook login: ${state.runtimeType}');

    // Ensure we start with loading state and clear any previous state
    state = const LoginLoading();
    debugPrint('🔄 State set to Facebook LoginLoading');

    try {
      // Get Turnstile token (replaces reCAPTCHA)
      String? turnstileToken;

      debugPrint('🔐 Checking Turnstile verification...');
      final turnstileState =
          _ref.read(turnstileNotifierProvider(TurnstileActionEnum.login));

      if (turnstileState is TurnstileSuccess) {
        turnstileToken = turnstileState.token;
        debugPrint('✅ Turnstile token obtained successfully');
      } else {
        debugPrint('❌ Turnstile verification incomplete');
        state = LoginError(
          email: '',
          message:
              'Security verification required. Please complete the verification and try again.',
        );
        return;
      }

      final loginRequest = FacebookLoginRequest(
        accessToken: accessToken,
        countryCode: countryCode,
        recaptchaToken: turnstileToken,
        deviceFingerprint: await _deviceInfo.getUniqueIdentifier() ?? '',
        userAgent: await _deviceInfo.getUserAgent(),
      );

      debugPrint('📤 Sending login request with Turnstile token');

      final loginUseCase = _ref.read(facebookLoginUseCaseProvider);
      // Add timeout to prevent infinite loading
      final result = await loginUseCase(loginRequest);

      result.fold(
        (failure) {
          debugPrint('❌  Facebook Login failed: ${failure.message}');
          state = LoginError(
            email: '',
            message: failure.message ?? 'Login failed',
            isNetworkError: failure.toString().contains('network') ||
                failure.toString().contains('connection'),
            errorModel: failure.errorModel,
          );
          onError?.call(failure.message ?? 'Login failed');
          debugPrint('🔄 State set to LoginError');
        },
        (loginResponse) async {
          debugPrint('✅ Login successful for: facebook Login');

          // Check if this is a 2FA required response (user and tokens are null)
          if (loginResponse.user == null || loginResponse.tokens == null) {
            debugPrint('🔐 2FA required - userId: ${loginResponse.userId}');
            // Set state to LoginSuccess with the response containing userId
            state = LoginSuccess(
              user: null,
              loginResponse: loginResponse,
            );
            debugPrint('🔄 State set to LoginSuccess (2FA required)');
            onSuccess?.call();
            return;
          }

          debugPrint(
              '✅ Access token length: ${loginResponse.tokens!.accessToken.length}');
          debugPrint(
              '✅ Refresh token length: ${loginResponse.tokens!.refreshToken.length}');

          // Store user data in local database
          try {
            await DatabaseService.saveUser(loginResponse.user!);
            debugPrint('✅ User data saved to database');
          } catch (dbError) {
            debugPrint('⚠️ Failed to save user to database: $dbError');
            // Don't fail the login process if database save fails
          }

          // Ensure state is set after all async operations
          await Future.delayed(const Duration(milliseconds: 50));

          state = LoginSuccess(
            user: loginResponse.user,
            loginResponse: loginResponse,
          );
          debugPrint('🔄 State set to LoginSuccess');

          // Verify tokens were stored properly
          try {
            final secureStorage = _ref.read(secureStorageServiceProvider);
            final storedToken = await secureStorage.getAuthToken();
            debugPrint(
                '✅ Token verification - stored token length: ${storedToken?.length ?? 0}');
          } catch (e) {
            debugPrint('⚠️ Token verification failed: $e');
          }
          onSuccess?.call();
        },
      );
    } catch (e) {
      debugPrint('❌ Unexpected login error: $e');
      state = LoginError(
        email: '',
        message: e.toString().contains('timeout')
            ? 'Google Login timeout: Please check your connection and try again'
            : 'An unexpected error occurred during Google login. Please try again.',
      );
      debugPrint('🔄 State set to Google LoginError (catch block)');
    }

    debugPrint('🔄 Login process completed. Final state: ${state.runtimeType}');
  }

  Future<void> facebookSignUp({
    required String countryCode,
    required String idToken,
    UserRole role = UserRole.normalUser,
    String? referralCode,
    VoidCallback? onSuccess,
    Function(String)? onError,
  }) async {
    debugPrint('🔄 Starting Facebook sign-up process');
    debugPrint(
        '🔄 Current state before Facebook sign-up: ${state.runtimeType}');

    // Ensure we start with loading state and clear any previous state
    state = const LoginLoading();
    debugPrint('🔄 State set to GoogleSignUpLoading');

    try {
      // Get Turnstile token (replaces reCAPTCHA)
      String? turnstileToken;

      debugPrint('🔐 Checking Turnstile verification...');
      final turnstileState =
          _ref.read(turnstileNotifierProvider(TurnstileActionEnum.register));

      if (turnstileState is TurnstileSuccess) {
        turnstileToken = turnstileState.token;
        debugPrint('✅ Turnstile token obtained successfully');
      } else {
        debugPrint('❌ Turnstile verification incomplete');
        state = LoginError(
          email: '',
          message:
              'Security verification required. Please complete the verification and try again.',
        );
        return;
      }

      final loginRequest = FacebookRegisterRequest(
        accessToken: idToken,
        role: role,
        referralCode: referralCode,
        countryCode: countryCode,
        recaptchaToken: turnstileToken,
        deviceFingerprint: await _deviceInfo.getUniqueIdentifier() ?? '',
        userAgent: await _deviceInfo.getUserAgent(),
      );

      debugPrint('📤 Sending login request with Turnstile token');

      final loginUseCase = _ref.read(facebookRegisterUseCaseProvider);

      // Add timeout to prevent infinite loading
      final result = await loginUseCase(loginRequest);

      result.fold(
        (failure) {
          debugPrint('❌ Facebook sign-up failed: ${failure.message}');
          GoogleSignInPlatform.instance.signOut();
          state = LoginError(
            email: '',
            message: failure.message ?? 'Facebook sign-up failed',
            isNetworkError: failure.toString().contains('network') ||
                failure.toString().contains('connection'),
            errorModel: failure.errorModel,
          );
          onError?.call(failure.message ?? 'Facebook sign-up failed');
          debugPrint('🔄 State set to FacebookSignUpError');
        },
        (loginResponse) async {
          debugPrint('✅ Facebook sign-up successful');
          // Check if this is a 2FA required response (user and tokens are null)
          if (loginResponse.user == null || loginResponse.tokens == null) {
            debugPrint('🔐 2FA required - userId: ${loginResponse.userId}');
            // Set state to LoginSuccess with the response containing userId
            state = LoginSuccess(
              user: null,
              loginResponse: loginResponse,
            );
            debugPrint('🔄 State set to LoginSuccess (2FA required)');
            onSuccess?.call();
            return;
          }

          debugPrint(
              '✅ Access token length: ${loginResponse.tokens!.accessToken.length}');
          debugPrint(
              '✅ Refresh token length: ${loginResponse.tokens!.refreshToken.length}');

          // Store user data in local database
          try {
            await DatabaseService.saveUser(loginResponse.user!);
            debugPrint('✅ User data saved to database');
          } catch (dbError) {
            debugPrint('⚠️ Failed to save user to database: $dbError');
            // Don't fail the login process if database save fails
          }

          // Ensure state is set after all async operations
          await Future.delayed(const Duration(milliseconds: 50));

          state = LoginSuccess(
            user: loginResponse.user,
            loginResponse: loginResponse,
          );
          debugPrint('🔄 State set to LoginSuccess');

          // Verify tokens were stored properly
          try {
            final secureStorage = _ref.read(secureStorageServiceProvider);
            final storedToken = await secureStorage.getAuthToken();
            debugPrint(
                '✅ Token verification - stored token length: ${storedToken?.length ?? 0}');
          } catch (e) {
            debugPrint('⚠️ Token verification failed: $e');
          }
          onSuccess?.call();
        },
      );
    } catch (e) {
      debugPrint('❌ Unexpected login error: $e');
      state = LoginError(
        email: '',
        message: e.toString().contains('timeout')
            ? 'Google sign-up timeout: Please check your connection and try again'
            : 'An unexpected error occurred during Google sign-up. Please try again.',
      );
      debugPrint('🔄 State set to GoogleSignUpError (catch block)');
    }

    debugPrint(
        '🔄 Google sign-up process completed. Final state: ${state.runtimeType}');
  }

  /// Clear error state
  void clearError() {
    if (state is LoginError) {
      state = const LoginInitial();
    }
  }

  /// Reset to initial state
  void reset() {
    state = const LoginInitial();
  }

  /// Reset to initial state (alias for reset)
  void resetToInitial() {
    reset();
  }

  /// Get current state type for debugging
  String get currentStateType => state.runtimeType.toString();

  /// Check if login is in progress
  bool get isLoading => state is LoginLoading;

  /// Get current error message (null if no error)
  String? get errorMessage {
    final currentState = state;
    if (currentState is LoginError) {
      return currentState.message;
    }
    return null;
  }

  /// Get current user (null if not logged in successfully)
  User? get currentUser {
    final currentState = state;
    if (currentState is LoginSuccess) {
      return currentState.user;
    }
    return null;
  }

  /// Get current login response (null if not logged in successfully)
  LoginResponse? get currentLoginResponse {
    final currentState = state;
    if (currentState is LoginSuccess) {
      return currentState.loginResponse;
    }
    return null;
  }
}

// =============================================================================
// LOGIN PROVIDERS
// =============================================================================

/// Provider for login state management
final loginNotifierProvider =
    StateNotifierProvider.autoDispose<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref, ref.read(deviceInfoProvider));
});

/// Provider for checking if login is in progress
final isLoginLoadingProvider = Provider<bool>((ref) {
  final loginState = ref.watch(loginNotifierProvider);
  return loginState is LoginLoading;
});

/// Provider for getting login error message
final loginErrorProvider = Provider<String?>((ref) {
  final loginState = ref.watch(loginNotifierProvider);
  if (loginState is LoginError) {
    return loginState.message;
  }
  return null;
});

/// Provider for getting current logged in user
final loggedInUserProvider = Provider<User?>((ref) {
  final loginState = ref.watch(loginNotifierProvider);
  if (loginState is LoginSuccess) {
    return loginState.user;
  }
  return null;
});

/// Provider for getting current login response
final loginResponseProvider = Provider<LoginResponse?>((ref) {
  final loginState = ref.watch(loginNotifierProvider);
  if (loginState is LoginSuccess) {
    return loginState.loginResponse;
  }
  return null;
});
