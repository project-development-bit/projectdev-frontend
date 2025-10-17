// Debug API endpoints for testing different backend configurations
// This file contains alternative endpoints to test against the actual backend

// Current endpoints (from api_endpoints.dart)
const String currentVerifyEndpoint = 'users/verify'; // POST with /{email}/{code}
const String currentResendEndpoint = 'users/resend-code'; // POST with request body

// Alternative endpoint formats to test:

// Option 1: Verify with request body instead of path params
const String verifyWithBodyEndpoint = 'users/verify'; // POST with email/code in body

// Option 2: Different endpoint names
const String verifyAltEndpoint = 'auth/verify-email';
const String resendAltEndpoint = 'auth/resend-verification';

// Option 3: RESTful style
const String verifyRestEndpoint = 'users/verification'; // POST with body
const String resendRestEndpoint = 'users/verification/resend'; // POST with body

// Option 4: Common API patterns
const String verifyCommonEndpoint = 'verify-email';
const String resendCommonEndpoint = 'resend-verification-code';

// Debug function to test endpoint
Future<void> testEndpoint(String endpoint, Map<String, dynamic> data) async {
  print('Testing endpoint: $endpoint');
  print('With data: $data');
}

// Alternative verify code implementation for testing
class AlternativeVerifyCodeRequest {
  final String email;
  final String code;

  const AlternativeVerifyCodeRequest({
    required this.email,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'code': code,
    };
  }
}