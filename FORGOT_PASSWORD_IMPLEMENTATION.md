# Forgot Password API Implementation

This document describes the complete implementation of the forgot password functionality following clean architecture principles and using Riverpod for state management.

## Overview

The forgot password feature allows users to request a password reset by providing their email address. The system sends a security code to the user's email that can be used to reset their password.

## API Endpoint

```bash
curl --location '/users/forgot_password' \
--header 'Content-Type: application/json' \
--data-raw '{
    "email": "laminowner369@gmail.com"
}'
```

### Expected Response Format

```json
{
    "success": true,
    "message": "Reset password is completed!",
    "data": {
        "email": "saizayarhtet7@gmail.com",
        "securityCode": 2912
    }
}
```

## Architecture Overview

The implementation follows Clean Architecture principles with the following layers:

```
Presentation Layer (UI & State Management)
    ↓
Data Layer (Models, Repositories, Remote Data Sources)
```

## Implementation Details

### 1. Data Models

#### ForgotPasswordRequest
**Location:** `lib/features/auth/data/models/forgot_password_request.dart`

```dart
class ForgotPasswordRequest {
  const ForgotPasswordRequest({
    required this.email,
  });

  final String email;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
```

**Features:**
- Immutable request model
- JSON serialization support
- Equality and hashCode implementation
- Input validation ready

#### ForgotPasswordResponse
**Location:** `lib/features/auth/data/models/forgot_password_response.dart`

```dart
class ForgotPasswordResponse {
  const ForgotPasswordResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final ForgotPasswordData data;

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json);
}

class ForgotPasswordData {
  const ForgotPasswordData({
    required this.email,
    required this.securityCode,
  });

  final String email;
  final int securityCode;
}
```

**Features:**
- Nested data structure matching API response
- JSON deserialization support
- Type-safe access to security code and email
- Comprehensive equality implementation

### 2. API Configuration

**Location:** `lib/core/config/api_endpoints.dart`

```dart
const String forgotPasswordEndpoints = 'users/forgot_password';
```

### 3. Remote Data Source

#### Interface
**Location:** `lib/features/auth/data/datasources/remote/auth_remote.dart`

```dart
abstract class AuthRemoteDataSource {
  Future<ForgotPasswordResponse> forgotPassword(ForgotPasswordRequest request);
}
```

#### Implementation

```dart
@override
Future<ForgotPasswordResponse> forgotPassword(ForgotPasswordRequest request) async {
  try {
    debugPrint('📤 Sending forgot password request to: ${request.email}');
    debugPrint('📤 Request URL: $forgotPasswordEndpoints');
    
    final response = await dioClient.post(
      forgotPasswordEndpoints,
      data: request.toJson(),
    );

    debugPrint('📥 Forgot password response: ${response.data}');
    
    return ForgotPasswordResponse.fromJson(response.data as Map<String, dynamic>);
    
  } on DioException catch (e) {
    // Comprehensive error handling with logging
    throw DioException(
      requestOptions: e.requestOptions,
      response: e.response,
      message: serverMessage ?? _getFallbackMessage(e),
    );
  }
}
```

**Features:**
- Comprehensive error handling
- Debug logging for development
- Server error message extraction
- Proper exception propagation

### 4. Repository Implementation

**Location:** `lib/features/auth/data/repositories/auth_repo_impl.dart`

```dart
@override
Future<Either<Failure, ForgotPasswordResponse>> forgotPassword(ForgotPasswordRequest request) async {
  try {
    final response = await remoteDataSource.forgotPassword(request);
    return Right(response);
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
  } catch (e) {
    return Left(ServerFailure(message: e.toString()));
  }
}
```

**Features:**
- Functional programming with Either types
- Comprehensive error handling
- Server error model integration
- Clean separation of concerns

### 5. State Management with Riverpod

#### Provider Definition
**Location:** `lib/features/auth/presentation/providers/forgot_password_provider.dart`

```dart
final forgotPasswordProvider = StateNotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>(
  (ref) => ForgotPasswordNotifier(ref.watch(authRepositoryProvider)),
);
```

#### State Classes

```dart
sealed class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}
class ForgotPasswordLoading extends ForgotPasswordState {}
class ForgotPasswordSuccess extends ForgotPasswordState {
  final ForgotPasswordResponse response;
  ForgotPasswordSuccess(this.response);
}
class ForgotPasswordError extends ForgotPasswordState {
  final String message;
  final int? statusCode;
  ForgotPasswordError(this.message, {this.statusCode});
}
```

#### Notifier Implementation

```dart
class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  final AuthRepository _authRepository;
  
  ForgotPasswordNotifier(this._authRepository) : super(ForgotPasswordInitial());
  
  Future<void> forgotPassword(String email) async {
    // Email validation
    if (!_isValidEmail(email)) {
      state = ForgotPasswordError('Please enter a valid email address');
      return;
    }
    
    state = ForgotPasswordLoading();
    
    final request = ForgotPasswordRequest(email: email);
    final result = await _authRepository.forgotPassword(request);
    
    result.fold(
      (failure) => state = ForgotPasswordError(_getFailureMessage(failure)),
      (response) => state = ForgotPasswordSuccess(response),
    );
  }
}
```

**Features:**
- Client-side email validation
- Loading state management
- Error handling with user-friendly messages
- Success state with response data

### 6. UI Implementation

#### Forgot Password Page
**Location:** `lib/features/auth/presentation/pages/forgot_password_page.dart`

**Key Features:**
- Responsive design with `ResponsiveContainer`
- Form validation
- State-reactive UI updates
- Loading indicators
- Success/error dialogs
- Accessibility support

#### Usage Example

```dart
class ForgotPasswordPage extends ConsumerStatefulWidget {
  @override
  Widget build(BuildContext context) {
    final forgotPasswordState = ref.watch(forgotPasswordProvider);
    
    // Listen to state changes
    ref.listen<ForgotPasswordState>(forgotPasswordProvider, (previous, next) {
      if (next is ForgotPasswordSuccess) {
        _showSuccessDialog(context, next.response);
      } else if (next is ForgotPasswordError) {
        _showErrorSnackBar(context, next.message);
      }
    });
    
    return Scaffold(/* UI implementation */);
  }
}
```

### 7. Testing Implementation

#### Unit Tests

**Data Models Tests:**
- `test/features/auth/data/models/forgot_password_request_test.dart`
- `test/features/auth/data/models/forgot_password_response_test.dart`

**Provider Tests:**
- `test/features/auth/presentation/providers/forgot_password_provider_test.dart`

**Widget Tests:**
- `test/features/auth/presentation/pages/forgot_password_page_test.dart`

#### Test Coverage

```dart
group('ForgotPasswordRequest', () {
  test('should create instance with required email', () {/* */});
  test('should convert to JSON correctly', () {/* */});
  test('should implement equality correctly', () {/* */});
});

group('ForgotPasswordProvider', () {
  test('initial state should be ForgotPasswordInitial', () {/* */});
  test('should validate email format correctly', () {/* */});
  test('reset should return to initial state', () {/* */});
});

group('ForgotPasswordPage Widget Tests', () {
  testWidgets('should display all required UI elements', (tester) {/* */});
  testWidgets('should show validation error for empty email', (tester) {/* */});
  testWidgets('should show loading indicator when request is in progress', (tester) {/* */});
});
```

## Usage Guide

### Basic Implementation

```dart
// 1. Trigger forgot password request
ref.read(forgotPasswordProvider.notifier).forgotPassword('user@example.com');

// 2. Listen to state changes
ref.listen<ForgotPasswordState>(forgotPasswordProvider, (previous, next) {
  switch (next) {
    case ForgotPasswordLoading():
      showLoadingIndicator();
    case ForgotPasswordSuccess(response: final response):
      showSuccessMessage('Security code: ${response.data.securityCode}');
    case ForgotPasswordError(message: final message):
      showErrorMessage(message);
    default:
      hideAllIndicators();
  }
});
```

### Navigation Integration

```dart
// Navigate to forgot password page
context.push('/forgot-password');

// Or using named routes
Navigator.pushNamed(context, '/forgot-password');
```

## Error Handling

### Client-Side Validation

```dart
bool _isValidEmail(String email) {
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegex.hasMatch(email);
}
```

### Server Error Handling

- **400 Bad Request:** Invalid email format
- **404 Not Found:** User not found
- **429 Too Many Requests:** Rate limiting
- **500 Internal Server Error:** Server error

### Error Messages

```dart
String _getFailureMessage(Failure failure) {
  if (failure is ServerFailure) {
    return failure.message ?? 'Server error occurred';
  }
  return 'An unexpected error occurred';
}
```

## Security Considerations

1. **Email Validation:** Client-side and server-side validation
2. **Rate Limiting:** Prevent abuse of the forgot password endpoint
3. **Security Code:** Temporary codes with expiration
4. **No Data Leakage:** Don't reveal if email exists in system
5. **HTTPS Only:** All requests over secure connections

## Performance Considerations

1. **Debounced Input:** Prevent excessive validation calls
2. **Caching:** Cache validation results temporarily
3. **Loading States:** Provide immediate feedback
4. **Error Recovery:** Allow retry mechanisms

## Internationalization

```dart
Text(localizations?.translate('forgot_password') ?? 'Forgot Password?')
Text(localizations?.translate('security_code_sent') ?? 'Security code sent')
```

## Future Enhancements

1. **Biometric Verification:** Add biometric confirmation
2. **Multi-Factor Authentication:** SMS/TOTP integration
3. **Progressive Web App:** PWA support for web platform
4. **Analytics:** Track forgot password usage patterns
5. **A/B Testing:** Test different UI variations

## Troubleshooting

### Common Issues

1. **Email Not Received:** Check spam folder, verify email address
2. **Network Errors:** Check internet connection, server status
3. **Validation Errors:** Ensure email format is correct
4. **Rate Limiting:** Wait before making another request

### Debug Commands

```bash
# Check API endpoint
curl -X POST /users/forgot_password -H "Content-Type: application/json" -d '{"email":"test@example.com"}'

# Enable debug logging
flutter run --debug

# Run tests
flutter test test/features/auth/
```

## Dependencies

- **flutter_riverpod:** State management
- **dartz:** Functional programming (Either types)
- **dio:** HTTP client
- **flutter_test:** Testing framework
- **equatable:** Value equality (optional)

## Changelog

- **v1.0.0:** Initial implementation with clean architecture
- **v1.1.0:** Added comprehensive testing
- **v1.2.0:** Enhanced error handling and validation
- **v1.3.0:** Responsive UI improvements