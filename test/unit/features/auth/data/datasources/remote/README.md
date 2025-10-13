# Auth Remote Data Source Tests

## Overview
This file contains comprehensive unit tests for the `AuthRemoteDataSourceImpl` class, which handles remote authentication operations.

## Test Coverage

### ✅ **Success Scenarios**
- **HTTP 200 Response**: Verifies successful registration with 200 status code
- **HTTP 201 Response**: Verifies successful registration with 201 status code
- **Different User Roles**: Tests registration with various user roles (admin, dev, superUser, normalUser)

### ❌ **Error Scenarios**
- **400 Bad Request**: Shows server message (e.g., "Invalid email format")
- **409 Conflict**: Shows server message (e.g., "Duplicate entry 'user10@gmail.com' for key 'users.email'")
- **422 Unprocessable Entity**: Shows server message (e.g., "Password too short")
- **500+ Server Errors**: Shows server message or falls back to generic error
- **Network Errors**: Connection timeouts and network unreachable
- **Non-DioException Errors**: Unexpected errors during registration

### 🛠️ **Data Validation**
- **Correct API Endpoint**: Verifies calls are made to the correct endpoint (`users`)
- **Request Data Format**: Ensures proper JSON structure is sent
- **Role Serialization**: Confirms role enum values are correctly serialized
- **Error Message Handling**: Tests both scenarios with and without error messages in response data

### 🔧 **Provider Testing**
- **Provider Type Verification**: Ensures the Riverpod provider has the correct type

## Server Error Response Format

The server returns errors in the following JSON format:
```json
{
  "type": "error",
  "status": 409,
  "message": "Duplicate entry 'user10@gmail.com' for key 'users.email'"
}
```

The implementation extracts the `message` field and passes it directly to the client, providing clear server-generated error messages.

## Implementation Highlights

### 🧹 **Clean Architecture**
- **Separated Concerns**: Helper methods for message extraction and fallback handling
- **Reduced Redundancy**: Eliminated repeated error handling code
- **Improved Readability**: Clear method names and documentation
- **Type Safety**: Proper const constructor and immutable design

## Key Features Tested

### 1. **API Integration**
```dart
// Tests that the correct endpoint is called with proper data
await authRemoteDataSource.register(registerRequest);
verify(() => mockDioClient.post(registerEndpoints, data: expectedData));
```

### 2. **Error Handling**
```dart
// Tests specific HTTP error codes with server messages
throwsA(isA<DioException>().having(
  (e) => e.message,
  'message',
  equals('Invalid email format'), // Direct server message
))
```

### 3. **Role Support**
```dart
// Tests all user role types
role: UserRole.admin // 'Dev', 'Admin', 'SuperUser', 'NormalUser'
```

## Dependencies
- **mocktail**: For mocking the DioClient
- **flutter_test**: Core testing framework
- **dio**: HTTP client library

## Running Tests
```bash
flutter test test/unit/features/auth/data/datasources/remote/auth_remote_test.dart
```

## Test Structure
- **Group**: `AuthRemoteDataSourceImpl`
  - **Subgroup**: `register`
    - Individual test cases for each scenario
  - **Group**: `AuthRemoteDataSource Provider`
    - Provider validation tests