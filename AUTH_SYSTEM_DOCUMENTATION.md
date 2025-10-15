# Authentication System Documentation

## Overview

This document describes the comprehensive authentication system implemented for the Project Dev Flutter application. The system follows clean architecture principles with proper state management, error handling, navigation flow, and local data persistence.

## Architecture

### Clean Architecture Layers

```
presentation/
├── providers/
│   ├── auth_providers.dart          # Dependency injection providers
│   └── auth_state_notifier.dart     # State management with Riverpod
├── pages/
│   ├── login_page.dart              # Login UI with state integration
│   └── signup_page.dart             # Registration UI with state integration
└── widgets/
    └── ... (auth-related widgets)

domain/
├── entities/
│   ├── user.dart                    # User domain entity
│   ├── auth_tokens.dart             # JWT tokens entity
│   └── login_response.dart          # Login response entity
├── repositories/
│   └── auth_repository.dart         # Repository interface
└── usecases/
    └── login_usecase.dart           # Business logic use cases

data/
├── models/
│   ├── user_model.dart              # User data model with JSON serialization
│   ├── login_request.dart           # Login request model
│   ├── register_request.dart        # Registration request model
│   └── ... (other models)
├── datasources/
│   └── remote/
│       └── auth_remote.dart         # HTTP API data source
└── repositories/
    └── auth_repo_impl.dart          # Repository implementation
```

## State Management

### Authentication States

The system uses a sealed class hierarchy for type-safe state management:

```dart
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState        // Initial/Unknown state
class AuthUnauthenticated extends AuthState // User not logged in
class AuthLoading extends AuthState        // Operation in progress
class AuthAuthenticated extends AuthState  // User logged in with data
class AuthError extends AuthState          // Error occurred with message
class AuthRegisterSuccess extends AuthState // Registration successful
```

### State Providers

- **`authStateNotifierProvider`**: Main state notifier managing auth operations
- **`isAuthenticatedProvider`**: Boolean provider for authentication status
- **`currentUserProvider`**: Current user entity (null if not authenticated)
- **`currentLoginResponseProvider`**: Full login response with tokens

## User Flow

### Registration Flow

1. **User fills registration form** with name, email, password, confirm password
2. **Frontend validation** checks form completeness and password match
3. **API call** to `/auth/register` endpoint with RegisterRequest model
4. **Success**: Navigate to login page, show success message
5. **Error**: Show server error message or fallback message

```dart
// Example usage in UI
await authNotifier.register(
  name: 'John Doe',
  email: 'john@example.com',
  password: 'password123',
  confirmPassword: 'password123',
  role: UserRole.normalUser,
);
```

### Login Flow

1. **User fills login form** with email and password
2. **Frontend validation** checks form completeness
3. **API call** to `/auth/login` endpoint with LoginRequest model
4. **Success**: 
   - Store JWT tokens securely using flutter_secure_storage
   - Store user data in local SQLite database
   - Navigate to dashboard/home page
   - Show success message
5. **Error**: Show server error message or fallback message

```dart
// Example usage in UI
await authNotifier.login(
  email: 'john@example.com',
  password: 'password123',
);
```

### Logout Flow

1. **User initiates logout**
2. **Clear all auth data**:
   - Remove JWT tokens from secure storage
   - Clear any cached user data
3. **Navigate to login page**
4. **Update state** to unauthenticated

## Data Persistence

### JWT Token Storage

Uses `flutter_secure_storage` for secure token management:

```dart
// Stored keys
const String _accessTokenKey = 'access_token';
const String _refreshTokenKey = 'refresh_token';
const String _userIdKey = 'user_id';
```

### Local Database (SQLite)

User data is stored locally using SQLite for offline access and performance:

```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  role TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
```

### Database Service

The `DatabaseService` class provides methods for:
- `saveUser(User user)`: Store/update user data
- `getUserById(int id)`: Retrieve user by ID
- `getUserByEmail(String email)`: Retrieve user by email
- `getAllUsers()`: Get all stored users
- `deleteUser(int id)`: Remove user data
- `clearAllUsers()`: Clear all user data

## Error Handling

### Server Error Messages

The system extracts and displays actual server error messages instead of generic errors:

```dart
// Server response format
{
  "success": false,
  "message": "Invalid credentials", // Shown to user
  "errors": {
    "email": ["Email is required"]
  }
}
```

### Error Types

- **Network Errors**: Connection issues, timeouts
- **Server Errors**: 4xx/5xx HTTP responses with server messages
- **Validation Errors**: Client-side form validation
- **Database Errors**: Local storage failures (non-blocking)

### Error Display

Errors are shown via SnackBar with different colors:
- **Red**: Error messages
- **Green**: Success messages
- **Orange**: Warning messages

## Memory Management

### Resource Disposal

Controllers and focus nodes are properly disposed:

```dart
@override
void dispose() {
  _emailController.dispose();
  _passwordController.dispose();
  _emailFocusNode.dispose();
  _passwordFocusNode.dispose();
  super.dispose();
}
```

### Provider Lifecycle

- Providers use `autoDispose` where appropriate
- State is cleared on logout to prevent memory leaks
- Database connections are properly managed with singleton pattern

## Security Considerations

### Token Security

- JWT tokens stored in secure storage (Keychain on iOS, Keystore on Android)
- Tokens are cleared on logout
- Refresh token rotation supported

### Input Validation

- Email format validation
- Password strength requirements
- SQL injection prevention through parameterized queries
- XSS prevention through proper data encoding

### Error Message Safety

- Server errors are sanitized before display
- Sensitive information is not exposed in error messages
- Fallback messages for unknown errors

## Testing

### Unit Tests

Comprehensive test coverage includes:

- **State Management Tests**: All auth state transitions
- **Repository Tests**: Data layer operations with mocks
- **Use Case Tests**: Business logic validation
- **Provider Tests**: Dependency injection and lifecycle

### Test Features

- Mock data sources for isolated testing
- Test environment detection to skip database operations
- Proper cleanup and resource disposal in tests

### Running Tests

```bash
# Run all auth tests
flutter test test/unit/features/auth/

# Run specific test file
flutter test test/unit/features/auth/data/repositories/auth_repo_impl_test.dart

# Run with coverage
flutter test --coverage
```

## API Integration

### Authentication Endpoints

```bash
# Register new user
POST /auth/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "confirm_password": "password123",
  "role": "normal_user"
}

# Login user
POST /auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}
```

### Response Format

```json
{
  "success": true,
  "message": "Login successful.",
  "user": {
    "id": 11,
    "name": "John Doe",
    "email": "john@example.com",
    "role": "normal_user"
  },
  "tokens": {
    "access_token": "eyJhbGciOiJIUzI1NiIs...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
    "token_type": "Bearer",
    "access_token_expires_in": "15m",
    "refresh_token_expires_in": "7d"
  }
}
```

## Usage Examples

### Basic Integration

```dart
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateNotifierProvider);
    
    return MaterialApp(
      home: switch (authState) {
        AuthAuthenticated() => const DashboardPage(),
        AuthUnauthenticated() => const LoginPage(),
        AuthLoading() => const LoadingPage(),
        AuthError() => const ErrorPage(),
        _ => const SplashPage(),
      },
    );
  }
}
```

### Checking Authentication Status

```dart
class ProtectedWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuth = ref.watch(isAuthenticatedProvider);
    final currentUser = ref.watch(currentUserProvider);
    
    if (!isAuth) {
      return const LoginRequiredWidget();
    }
    
    return Column(
      children: [
        Text('Welcome ${currentUser?.name}!'),
        // Protected content here
      ],
    );
  }
}
```

### Navigation Guard

```dart
// In router configuration
redirect: (context, state) async {
  final container = ProviderScope.containerOf(context);
  final isAuth = container.read(isAuthenticatedProvider);
  
  if (!isAuth && !state.location.startsWith('/auth')) {
    return '/auth/login';
  }
  return null;
},
```

## Performance Optimizations

### Efficient State Updates

- State changes only when necessary
- Immutable state objects prevent unnecessary rebuilds
- Provider selectors for specific data access

### Database Optimization

- Connection pooling through singleton pattern
- Indexed columns for fast queries
- Batch operations for multiple updates

### Memory Usage

- Lazy loading of user data
- Proper disposal of resources
- Efficient JSON serialization/deserialization

## Future Enhancements

### Planned Features

- [ ] Biometric authentication (fingerprint/face ID)
- [ ] Social login (Google, Facebook, Apple)
- [ ] Multi-factor authentication (2FA)
- [ ] Password reset functionality
- [ ] Remember me functionality with secure token refresh
- [ ] Offline authentication support

### Scalability Considerations

- Token refresh automation
- Background sync for user data
- Push notification integration for auth events
- Advanced role-based access control (RBAC)

## Troubleshooting

### Common Issues

1. **Database initialization errors**: Ensure proper SQLite setup
2. **Token storage issues**: Check device secure storage availability
3. **Network timeouts**: Configure appropriate timeout values
4. **State synchronization**: Verify provider hierarchy and dependencies

### Debug Commands

```bash
# Check database content
flutter test test/unit/core/services/database_service_test.dart

# Verify auth flow
flutter test test/unit/features/auth/presentation/providers/auth_state_notifier_test.dart

# Test complete auth system
flutter test test/unit/features/auth/
```

## Conclusion

This authentication system provides a robust, secure, and user-friendly foundation for the Project Dev application. It follows Flutter best practices, implements clean architecture principles, and provides comprehensive error handling with proper memory management.

The system is thoroughly tested, well-documented, and ready for production use while being easily extensible for future enhancements.