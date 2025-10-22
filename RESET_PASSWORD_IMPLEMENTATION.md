# Reset Password Implementation Documentation

## Overview
This document describes the complete implementation of the reset password functionality following clean architecture principles, using Riverpod for state management, and responsive design with common widgets and theme integration.

## API Integration

### Endpoint
```bash
curl --location 'https://api.gigafaucet.com/api/v1/users/save_password' \
--header 'Content-Type: application/json' \
--data-raw '{
    "email": "saizayarhtet7@gmail.com",
    "password": "12345678",
    "confirm_password": "12345678"
}'
```

### Response Format
```json
{
    "success": true,
    "message": "Password was saved successfully!",
    "data": {
        "user": {
            "id": 23,
            "name": "sai",
            "email": "saizayarhtet7@gmail.com",
            "role": "NormalUser"
        },
        "tokens": {
            "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
            "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
            "tokenType": "Bearer",
            "accessTokenExpiresIn": "15m",
            "refreshTokenExpiresIn": "7d"
        }
    }
}
```

## Architecture Overview

The implementation follows Clean Architecture with these layers:

```
Presentation Layer (UI & State Management)
    ↓
Domain Layer (Entities & Repositories)
    ↓
Data Layer (Models, Remote Data Sources)
```

## Implementation Details

### 1. API Configuration

**File:** `lib/core/config/api_endpoints.dart`
```dart
const savePasswordEndpoints = 'users/save_password';
```

### 2. Data Models

#### ResetPasswordRequest
**File:** `lib/features/auth/data/models/reset_password_request.dart`

```dart
class ResetPasswordRequest {
  const ResetPasswordRequest({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  final String email;
  final String password;
  final String confirmPassword;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
    };
  }
}
```

**Features:**
- Immutable request model with validation helpers
- JSON serialization support
- Password match validation (`isPasswordMatched`)
- Password requirements validation (`isPasswordValid`)
- Completeness check (`isComplete`)
- Security-focused `toString()` that hides sensitive data

#### ResetPasswordResponse
**File:** `lib/features/auth/data/models/reset_password_response.dart`

```dart
typedef ResetPasswordResponse = LoginResponse;

extension ResetPasswordResponseExtension on LoginResponse {
  bool get isResetSuccessful => user.id > 0;
  String get resetMessage => 'Password was saved successfully!';
  String get userInfo => 'User: ${user.name} (${user.email})';
}
```

**Features:**
- Reuses existing `LoginResponse` entity
- Provides context-specific extension methods
- Type-safe response handling

### 3. Remote Data Source

**File:** `lib/features/auth/data/datasources/remote/auth_remote.dart`

```dart
@override
Future<LoginResponseModel> resetPassword(ResetPasswordRequest request) async {
  try {
    final response = await dioClient.post(
      savePasswordEndpoints,
      data: request.toJson(),
    );
    
    return LoginResponseModel.fromJson(response.data);
  } on DioException catch (e) {
    // Comprehensive error handling
    throw DioException(
      requestOptions: e.requestOptions,
      response: e.response,
      message: serverMessage ?? _getFallbackMessage(e),
    );
  }
}
```

**Features:**
- Comprehensive error handling with debug logging
- Server error message extraction
- Proper exception propagation

### 4. Repository Implementation

**File:** `lib/features/auth/data/repositories/auth_repo_impl.dart`

```dart
@override
Future<Either<Failure, LoginResponse>> resetPassword(
    ResetPasswordRequest request) async {
  try {
    final loginResponseModel = await remoteDataSource.resetPassword(request);
    return Right(loginResponseModel.toEntity());
  } on DioException catch (e) {
    ErrorModel? errorModel;
    if (e.response?.data != null) {
      errorModel = ErrorModel.fromJson(e.response!.data);
    }
    return Left(ServerFailure(
      message: e.message,
      statusCode: e.response?.statusCode,
      errorModel: errorModel,
    ));
  }
}
```

**Features:**
- Functional programming with Either types
- Error model integration
- Clean separation of concerns

### 5. State Management with Riverpod

**File:** `lib/features/auth/presentation/providers/reset_password_provider.dart`

#### State Classes
```dart
sealed class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}
class ResetPasswordLoading extends ResetPasswordState {}
class ResetPasswordSuccess extends ResetPasswordState {
  final ResetPasswordResponse response;
  ResetPasswordSuccess(this.response);
}
class ResetPasswordError extends ResetPasswordState {
  final String message;
  final int? statusCode;
  ResetPasswordError(this.message, {this.statusCode});
}
```

#### Notifier Implementation
```dart
class ResetPasswordNotifier extends StateNotifier<ResetPasswordState> {
  Future<void> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Comprehensive input validation
    final validationError = _validateInputs(email, password, confirmPassword);
    if (validationError != null) {
      state = ResetPasswordError(validationError);
      return;
    }
    
    state = ResetPasswordLoading();
    
    final request = ResetPasswordRequest(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
    
    final result = await _authRepository.resetPassword(request);
    
    result.fold(
      (failure) => state = ResetPasswordError(_getFailureMessage(failure)),
      (response) => state = ResetPasswordSuccess(response),
    );
  }
}
```

**Features:**
- Client-side validation with detailed error messages
- Loading state management
- Server error handling with user-friendly messages
- HTTP status code specific error handling
- Convenience providers for specific states

### 6. Responsive UI Implementation

**File:** `lib/features/auth/presentation/pages/reset_password_page.dart`

#### Key Features

**Responsive Design:**
```dart
ResponsiveContainer(
  maxWidth: context.isMobile ? null : 400,
  padding: EdgeInsets.all(context.isMobile ? 20 : 32),
  child: Form(/* ... */),
)
```

**Common Widgets Integration:**
- `CommonTextField` for password input fields
- `CommonButton` for reset password action
- `CommonText` for typography consistency
- Proper theming with `Theme.of(context).colorScheme`

**User Experience Features:**
- Password visibility toggles
- Real-time form validation
- Loading states with disabled button
- Success/error feedback via SnackBars
- Auto-navigation to login after success
- Keyboard navigation support

**Accessibility:**
- Proper focus management
- Screen reader support
- Semantic labels and hints

### 7. Routing Integration

**File:** `lib/routing/app_router.dart`

```dart
GoRoute(
  path: 'reset-password',
  name: 'reset-password',
  pageBuilder: (context, state) {
    final email = state.uri.queryParameters['email'] ?? '';
    return NoTransitionPage(
      child: ResetPasswordPage(email: email),
    );
  },
),
```

**Helper Extensions:**
```dart
extension GoRouterExtension on BuildContext {
  void goToResetPassword({required String email}) {
    go('${AppRoutes.resetPassword}?email=${Uri.encodeComponent(email)}');
  }
  
  void pushToResetPassword({required String email}) {
    push('${AppRoutes.resetPassword}?email=${Uri.encodeComponent(email)}');
  }
}
```

### 8. Navigation Flow Integration

**Updated Verification Page:**
```dart
if (next is VerificationSuccess) {
  if(widget.isFromForgotPassword){
    context.goToResetPassword(email: widget.email);
    return;
  }
  GoRouterExtension(context).go('/auth/login');
}
```

## Security Measures

1. **No Token Storage:** Tokens from reset password response are not stored, requiring user to login again
2. **Input Validation:** Client-side validation for email format and password requirements
3. **Secure Logging:** Sensitive data is hidden in debug logs
4. **Password Masking:** Passwords are obscured in forms with toggle visibility
5. **URL Encoding:** Email parameters are properly URL-encoded

## Validation Rules

1. **Email:** Valid email format required
2. **Password:** Minimum 8 characters
3. **Confirmation:** Must match the new password
4. **Completeness:** All fields must be filled

## Error Handling

### Client-side Validation
- Invalid email format
- Password too short (< 8 characters)
- Password mismatch
- Empty required fields

### Server-side Error Handling
- 400: Invalid request format
- 401: Unauthorized (email not verified)
- 404: Email not found
- 429: Too many requests
- 500: Server error

## Testing Implementation

### Unit Tests
- **Model Tests:** `test/features/auth/data/models/reset_password_request_test.dart`
- **Provider Tests:** `test/features/auth/presentation/providers/reset_password_provider_test.dart`

### Widget Tests
- **Page Tests:** `test/features/auth/presentation/pages/reset_password_page_test.dart`

**Test Coverage:**
- Data model serialization/deserialization
- Validation logic
- State management transitions
- UI component rendering
- User interactions
- Error scenarios
- Responsive design
- Accessibility

## Usage Examples

### Basic Navigation
```dart
context.goToResetPassword(email: 'user@example.com');
```

### Manual Provider Usage
```dart
// Trigger reset password
ref.read(resetPasswordProvider.notifier).resetPassword(
  email: 'user@example.com',
  password: 'newpassword123',
  confirmPassword: 'newpassword123',
);

// Listen to state changes
ref.listen<ResetPasswordState>(resetPasswordProvider, (previous, next) {
  switch (next) {
    case ResetPasswordLoading():
      showLoadingIndicator();
    case ResetPasswordSuccess():
      navigateToLogin();
    case ResetPasswordError(message: final message):
      showErrorMessage(message);
  }
});
```

### Using Convenience Providers
```dart
final isLoading = ref.watch(isResetPasswordLoadingProvider);
final errorMessage = ref.watch(resetPasswordErrorProvider);
final successResponse = ref.watch(resetPasswordSuccessProvider);
```

## Performance Considerations

1. **Lazy Loading:** Providers are created only when needed
2. **Efficient Rebuilds:** State changes trigger minimal UI rebuilds
3. **Input Debouncing:** Validation runs on form submission, not on every keystroke
4. **Memory Management:** Controllers and focus nodes are properly disposed

## Responsive Design

- **Mobile:** Full-width forms with appropriate padding
- **Tablet/Desktop:** Constrained width (400px max) with centered layout
- **Adaptive Sizing:** Icons, buttons, and spacing adapt to screen size
- **Touch Targets:** Minimum 44px touch targets for mobile devices

## Theme Integration

The reset password page fully integrates with the app's theme system:

- **Colors:** Uses `Theme.of(context).colorScheme` for consistent branding
- **Typography:** Leverages `CommonText` widgets for consistent text styling
- **Spacing:** Responsive spacing based on screen size
- **Interactive Elements:** Proper focus states and touch feedback

## Future Enhancements

1. **Biometric Verification:** Add biometric confirmation for password reset
2. **Progressive Web App:** PWA support for web platform
3. **Analytics:** Track password reset success/failure rates
4. **A/B Testing:** Test different UI variations
5. **Multi-factor Authentication:** SMS/TOTP integration for additional security

## Troubleshooting

### Common Issues

1. **Email Not Received:** Check forgot password flow first
2. **Network Errors:** Check internet connection and server status
3. **Validation Errors:** Ensure all requirements are met
4. **Navigation Issues:** Verify proper email parameter passing

### Debug Commands

```bash
# Analyze reset password implementation
flutter analyze lib/features/auth/presentation/providers/reset_password_provider.dart

# Run unit tests
flutter test test/features/auth/presentation/providers/reset_password_provider_test.dart

# Run widget tests
flutter test test/features/auth/presentation/pages/reset_password_page_test.dart

# Run all auth tests
flutter test test/features/auth/
```

## Dependencies

- **flutter_riverpod:** State management
- **dartz:** Functional programming (Either types)
- **dio:** HTTP client
- **go_router:** Navigation
- **flutter_test:** Testing framework
- **mocktail:** Mocking for tests

## Files Created/Modified

### New Files
- `lib/features/auth/data/models/reset_password_request.dart`
- `lib/features/auth/data/models/reset_password_response.dart`
- `lib/features/auth/presentation/providers/reset_password_provider.dart`
- `lib/features/auth/presentation/pages/reset_password_page.dart`
- `test/features/auth/data/models/reset_password_request_test.dart`
- `test/features/auth/presentation/providers/reset_password_provider_test.dart`
- `test/features/auth/presentation/pages/reset_password_page_test.dart`

### Modified Files
- `lib/core/config/api_endpoints.dart`
- `lib/features/auth/data/datasources/remote/auth_remote.dart`
- `lib/features/auth/domain/repositories/auth_repository.dart`
- `lib/features/auth/data/repositories/auth_repo_impl.dart`
- `lib/routing/app_router.dart`
- `lib/features/auth/presentation/pages/verification_page.dart`

## Changelog

- **v1.0.0:** Initial implementation with clean architecture
- **v1.1.0:** Added comprehensive testing
- **v1.2.0:** Enhanced responsive design and theme integration
- **v1.3.0:** Added navigation flow integration with verification page