import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

// 1. Define the Provider
final googleWebAuthServiceProvider = Provider<GoogleWebAuthService>((ref) {
  return GoogleWebAuthService();
});

// 2. Define the Service Class
class GoogleWebAuthService {
  final String _clientId =
      '645002434672-nji58g0s1sdqfpu679h3h7cc3v9diaue.apps.googleusercontent.com';

  // Ensure this matches your setup (http vs https)
  final String _redirectUri = 'http://localhost:8000/auth.html';
  final callbackUrlScheme =
      'com.googleusercontent.apps.645002434672-nji58g0s1sdqfpu679h3h7cc3v9diaue';

  Future<String?> getGoogleIdToken() async {
    final String nonce = _generateNonce();

    try {
      final url = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
        'response_type': 'id_token',
        'client_id': _clientId,
        'redirect_uri': _redirectUri,
        'scope': 'openid profile email',
        'nonce': nonce,
      });

      // Open the web URL for authentication
      final result = await FlutterWebAuth2.authenticate(
        url: url.toString(),
        // IMPORTANT: Scheme must match your redirectUri (http or https)
        callbackUrlScheme: callbackUrlScheme,
        options: FlutterWebAuth2Options(),
      );

      debugPrint('FlutterWebAuth2 Result: $result');

      // Robust Parsing: Handle the fragment securely
      final Uri resultUri = Uri.parse(result);
      final Map<String, String> fragmentParams =
          Uri.splitQueryString(resultUri.fragment);

      final String? idToken = fragmentParams['id_token'];

      if (idToken != null) {
        debugPrint("Google Sign-In Success: ID Token found");
        return idToken;
      } else {
        debugPrint("Error: No id_token found in response.");
        return null;
      }
    } catch (e) {
      debugPrint('Error during Google sign-in: $e');
      return null;
    }
  }

  String _generateNonce([int length = 32]) {
    final Random random = Random();
    final List<int> values =
        List<int>.generate(length, (i) => random.nextInt(256));
    return Uri.encodeComponent(String.fromCharCodes(values));
  }
}
