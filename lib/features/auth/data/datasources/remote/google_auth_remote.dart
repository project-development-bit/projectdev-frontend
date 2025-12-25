import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/features/auth/data/services/google_web_auth_service.dart'
    if (dart.library.io) 'package:gigafaucet/features/auth/data/services/google_mobile_auth_service.dart';

// Define the Provider
final googleAuthRemoteProvider = Provider<GoogleAuthRemote>((ref) {
  return GoogleAuthRemote();
});

// Service Class
class GoogleAuthRemote {
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  // Function to obtain the Google credentials (including ID token)
  Future<String?> getGoogleIdToken() async {
    return _googleAuthService.getGoogleIdToken();
  }

  Future<void> signOut() async {
    _googleAuthService.signOut();
  }
}
