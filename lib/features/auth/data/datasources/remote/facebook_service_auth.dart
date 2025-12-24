import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

final facebookAuthServiceProvider = Provider((ref) => FacebookAuthService());

class FacebookAuthService {
  /// Handles the Facebook Sign-In flow and retrieves the authentication tokens.
  Future<String?> getFacebookAccessToken() async {
    try {
      final result = await _getFacebookAuthDetails();
      if (result == null) {
        return null;
      }

      debugPrint('Facebook Access Token: ${result.accessToken}');
      debugPrint('Facebook message: ${result.message}');
      debugPrint('Facebook Login Status: ${result.status.name}');
      debugPrint('Facebook Sign-In successful.');

      return result.accessToken?.tokenString;
    } catch (error) {
      debugPrint(
          "An error occurred during the Facebook sign-in process: $error");
      return null;
    }
  }

  /// Handles the Facebook Sign-In process.
  Future<LoginResult?> _getFacebookAuthDetails() async {
    final result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      debugPrint("Successfully signed in with Facebook.");
      return result;
    } else if (result.status == LoginStatus.cancelled) {
      debugPrint("Facebook login was cancelled by the user.");
      return null;
    } else if (result.status == LoginStatus.failed) {
      debugPrint("Facebook login failed: ${result.message}");
      return null;
    }

    return null;
  }

  /// Signs out of Facebook.
  Future<void> signOut() async {
    try {
      await FacebookAuth.instance.logOut();
      debugPrint("Successfully signed out from Facebook.");
    } catch (error) {
      debugPrint(
          "An error occurred during the Facebook sign-out process: $error");
    }
  }
}
