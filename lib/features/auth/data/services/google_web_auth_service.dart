import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:gigafaucet/core/config/flavor_manager.dart';
import 'package:googleapis_auth/auth_browser.dart';

// Service Class
class GoogleAuthService {
  final String _clientId = FlavorManager.currentConfig.googleClientId;

  final callbackUrlScheme =
      'com.googleusercontent.apps.645002434672-nji58g0s1sdqfpu679h3h7cc3v9diaue';
  final scopes = [
    "openid",
    "https://www.googleapis.com/auth/userinfo.profile",
    "https://www.googleapis.com/auth/userinfo.email"
  ];

  // Function to obtain credentials
  Future<AccessCredentials> obtainClient() async {
    if (!kIsWeb) {
      throw UnimplementedError(
          'obtainClient is not implemented for dart:io platform.');
    }

    try {
      final credentials = await requestAccessCredentials(
        clientId: _clientId,
        scopes: scopes,
      );

      debugPrint(
          'Testing Google Sign-In: Obtained Google OAuth2 credentials successfully.');
      debugPrint('Testing Google Sign-In: idToken: ${credentials.idToken}');
      return credentials;
    } catch (e) {
      debugPrint('Error obtaining credentials: $e');
      rethrow;
    }
  }

  // Function to obtain the Google credentials (including ID token)
  Future<String?> getGoogleIdToken() async {
    try {
      // Request access credentials for the OAuth 2.0 flow
      final credentials = await obtainClient();
      // Log credentials for debugging purposes (you can remove this in production)
      debugPrint('Testing Google Sign-In : ID Token: ${credentials.idToken}');
      debugPrint(
          'Testing Google Sign-In : Access Token: ${credentials.accessToken.data}');
      debugPrint(
          'Testing Google Sign-In : Refresh Token: ${credentials.refreshToken}');
      debugPrint('Testing Google Sign-In : Scopes : ${credentials.scopes}');
      // Check if the id_token is returned successfully
      if (credentials.idToken != null) {
        debugPrint(
            'Testing Google Sign-In : Google API Authenticated Client obtained successfully.');
        return credentials.idToken; // Return the id_token
      } else {
        debugPrint(
            'Testing Google Sign-In : idToken is null. Falling back to access token as idToken.');
        return credentials.accessToken.data;

        // final credential = GoogleAuthProvider.credential(
        //   accessToken: credentials.accessToken.data,
        //   idToken: credentials.idToken,
        // );
        // if (credential.idToken != null) {
        //   debugPrint(
        //       'Testing Google Sign-In : Fallback Google ID Token from Credential obtained successfully.');
        //   return credential.idToken;
        // }
        // UserCredential userCredential =
        //     await FirebaseAuth.instance.signInWithCredential(credential);
        // String? idToken = await userCredential.user?.getIdToken(true);
        // debugPrint(
        //     'Testing Google Sign-In : Retrieved idToken from Firebase User. idToken is null: ${idToken == null}');
        // debugPrint('Testing Google Sign-In :idToken: $idToken');
        // if (idToken == null) {
        //   debugPrint(
        //       'Testing Google Sign-In : Failed to retrieve idToken from Firebase User.');
        //   debugPrint(
        //       'Testing Google Sign-In : Falling back to access token as idToken.');
        //   return credentials.accessToken.data;
        // }
        // return idToken;
      }
    } catch (e) {
      debugPrint('Testing Google Sign-In : Error obtaining client: $e');
      return null;
    }
  }

  // Future<UserCredential> signInWithGoogle(String accessToken) async {
  //   final AuthCredential credential =
  //       GoogleAuthProvider.credential(accessToken: accessToken);
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  Future<void> signOut() async {
    // await FirebaseAuth.instance.signOut();
    // debugPrint('Testing Google Sign-In : User signed out from Firebase.');
  }
}
