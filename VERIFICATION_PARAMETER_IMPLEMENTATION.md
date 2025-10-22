# Verification Page Parameter Implementation

## Overview
This document describes the implementation of the `VerificationPageParameter` class for handling navigation to the verification page with structured parameters instead of query parameters.

## Files Created/Modified

### 1. New Files Created

#### `lib/routing/verification_page_parameter.dart`
A parameter class that encapsulates all the data needed for the VerificationPage:

```dart
class VerificationPageParameter {
  final String email;
  final bool isSendCode;
  final bool isFromForgotPassword;
  
  const VerificationPageParameter({
    required this.email,
    this.isSendCode = false,
    this.isFromForgotPassword = false,
  });
}
```

#### `lib/routing/routing.dart`
A barrel file that exports routing utilities for easier imports.

### 2. Modified Files

#### `lib/routing/app_router.dart`
- **Updated verification route**: Now accepts `VerificationPageParameter` as `extra` object
- **Added helper extensions**: `goToVerification()` and `pushToVerification()` methods for easy navigation
- **Fallback support**: Still supports query parameters for backward compatibility

```dart
// Before
context.go('/auth/verification?email=${Uri.encodeComponent(email)}');

// After - using helper method
context.goToVerification(
  email: email,
  isSendCode: true,
  isFromForgotPassword: false,
);

// After - using extra object directly
context.go('/auth/verification', extra: VerificationPageParameter(...));
```

#### `lib/features/auth/presentation/pages/signup_page.dart`
- **Updated navigation**: Uses `goToVerification()` helper method
- **Parameters**: Sets `isSendCode: true, isFromForgotPassword: false`

#### `lib/features/auth/presentation/pages/forgot_password_page.dart`
- **Updated navigation**: Uses `goToVerification()` helper method  
- **Parameters**: Sets `isSendCode: true, isFromForgotPassword: true`

#### `lib/features/auth/presentation/pages/login_page.dart`
- **Updated navigation**: Uses `pushToVerification()` helper method
- **Note**: Email is currently empty (marked with TODO) as the current implementation doesn't pass the email from the login form

## Usage Examples

### For Registration Success (SignUp)
```dart
context.goToVerification(
  email: registeredEmail,
  isSendCode: true,
  isFromForgotPassword: false,
);
```

### For Forgot Password Flow
```dart
context.goToVerification(
  email: userEmail,
  isSendCode: true,
  isFromForgotPassword: true,
);
```

### For Manual Verification (Login Dialog)
```dart
context.pushToVerification(
  email: userEmail,
  isSendCode: true,
  isFromForgotPassword: false,
);
```

## Benefits

1. **Type Safety**: Parameters are strongly typed instead of string-based query parameters
2. **Cleaner URLs**: No query parameters cluttering the URL
3. **Better Parameter Handling**: Single object contains all related parameters
4. **Easy to Extend**: New parameters can be added without changing method signatures
5. **Helper Methods**: Convenient navigation methods reduce boilerplate code
6. **Backward Compatibility**: Still supports query parameter fallback

## Router Configuration

The verification route now handles both approaches:

```dart
GoRoute(
  path: 'verification',
  name: 'verification',
  pageBuilder: (context, state) {
    final parameter = state.extra as VerificationPageParameter?;
    final email = parameter?.email ?? 
        state.uri.queryParameters['email'] ?? '';
    return NoTransitionPage(
      child: VerificationPage(
        email: email,
        isSendCode: parameter?.isSendCode ?? false,
        isFromForgotPassword: parameter?.isFromForgotPassword ?? false,
      ),
    );
  },
),
```

## Parameter Flow

```
SignUpPage → VerificationPage (isSendCode: true, isFromForgotPassword: false)
ForgotPasswordPage → VerificationPage (isSendCode: true, isFromForgotPassword: true)  
LoginPage → VerificationPage (isSendCode: true, isFromForgotPassword: false)
```

## Migration Guide

### Before
```dart
// Old way with query parameters
context.go('/auth/verification?email=${Uri.encodeComponent(email)}');
context.push('/auth/verification', extra: true); // isSendCode only
```

### After
```dart
// New way with parameter object
context.goToVerification(
  email: email,
  isSendCode: true,
  isFromForgotPassword: false,
);

// Or using extra object directly
context.go('/auth/verification', 
  extra: VerificationPageParameter(
    email: email,
    isSendCode: true,
    isFromForgotPassword: false,
  )
);
```

## TODO Items

1. **Login Page Email**: The login page dialog currently passes an empty email. This should be updated to pass the actual email from the login form.

2. **Error Handling**: Consider adding validation to the `VerificationPageParameter` constructor to ensure required fields are not empty.

3. **Documentation**: Add dartdoc comments to the parameter class and helper methods.

4. **Testing**: Add unit tests for the parameter class and integration tests for the navigation flows.