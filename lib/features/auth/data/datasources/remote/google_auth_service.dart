import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

final googleAuthServiceProvider = Provider((ref) => GoogleAuthService());

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '645002434672-nji58g0s1sdqfpu679h3h7cc3v9diaue.apps.googleusercontent.com',
    scopes: [
      'email',
      'profile',
      'openid',
    ],
  );

  Future<String?> getGoogleIdToken() async {
    try {
      final googleAuth = await _getGoogleAuthDetails();
      if (googleAuth == null) {
        return null;
      }

      debugPrint('Google ID Token: $googleAuth');
      // debugPrint('Google Access Token: ${googleAuth.accessToken}');
      // debugPrint('Google Sign-In serverAuthCode: ${googleAuth.serverAuthCode}');
      debugPrint('Google Sign-In successful.');

      // Step 3: If successful, update and return the request object.
      debugPrint('Successfully signed in with Google and Firebase.');
      return googleAuth;
    } catch (error) {
      debugPrint("An error occurred during the Google sign-in process: $error");
      throw Exception("Google sign-in failed: $error");
    }
  }

  /// Handles the Google Sign-In flow and retrieves the authentication tokens.
  /// Includes the necessary workaround for Flutter Web.
  Future<String?> _getGoogleAuthDetails() async {
    if (kIsWeb) {
      try {
        debugPrint(
            "Testing Google Sign-In : Running on web platform, using web-specific token retrieval.");
        final tokenData = await GoogleSignInPlatform.instance.signIn();
        if (tokenData?.idToken?.isEmpty ?? true && tokenData?.email != null) {
          debugPrint(
              "Testing Google Sign-In : idToken is empty, attempting to get tokens via email. tokenData.email: ${tokenData!.email}");
          final idToken = (await GoogleSignInPlatform.instance
                  .getTokens(email: tokenData.email))
              .idToken;
          debugPrint(
              "Testing Google Sign-In : Retrieved idToken via email method. idToken is null: ${idToken == null}");
          if (idToken == null) {
            return await signInSilently();
          }

          return idToken;
        }
        if (tokenData != null) {
          return tokenData.idToken;
        }
        return await signInSilently();
      } catch (e) {
        debugPrint(
            "Testing Google Sign-In : Error during web Google Sign-In: $e");
        throw Exception("Web Google Sign-In failed: $e");
      }
    }
    GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account == null) {
      debugPrint("Google Sign-In aborted by user.");
      return null;
    }
    GoogleSignInAuthentication auth = await account.authentication;
    if (kIsWeb && auth.idToken == null) {
      debugPrint(
          "idToken was null on web, attempting to re-authenticate silently...");
      final silentAuthAccount =
          await _googleSignIn.signInSilently(reAuthenticate: true);
      if (silentAuthAccount != null) {
        auth = await silentAuthAccount.authentication;
      }
    }
    if (auth.idToken == null) {
      throw Exception(
          "Failed to retrieve idToken from Google after all attempts.");
    }

    debugPrint("Successfully retrieved Google auth details.");
    debugPrint("idToken is present: ${auth.idToken != null}");
    debugPrint("accessToken is present: ${auth.accessToken != null}");

    return auth.idToken;
  }

  Future<String> signInSilently() async {
    final GoogleSignInAccount? account = await _googleSignIn.signInSilently(
        reAuthenticate: true, suppressErrors: true);

    debugPrint(
        "Testing Google Sign-In : Silent sign-in attempt completed. Account is null: ${account == null}");
    if (account == null) {
      debugPrint(
          "Testing Google Sign-In : No Google account is currently signed in.");
      throw Exception("No Google account is currently signed in.");
    }
    final GoogleSignInAuthentication auth = await account.authentication;
    if (auth.idToken == null) {
      debugPrint(
          "Testing Google Sign-In : idToken is null after silent sign-in.");
      throw Exception(
          "Failed to retrieve idToken from silently signed-in user.");
    }
    debugPrint(
        "Testing Google Sign-In : Successfully retrieved idToken via silent sign-in.");
    return auth.idToken!;
  }

  /// Signs into Firebase using the provided Google authentication details.
  // Future<User?> _signInToFirebaseWithGoogle(
  //     GoogleSignInAuthentication googleAuth) async {
  //   // CRITICAL FIX: Provide both accessToken and idToken to the credential.
  //   // This is the most robust way to authenticate with Firebase.
  //   final AuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );

  //   final userCredential =
  //       await FirebaseAuth.instance.signInWithCredential(credential);
  //   final firebaseUser = userCredential.user;

  //   if (firebaseUser != null) {
  //     debugPrint(
  //         'Firebase Sign-In Successful. UID: ${firebaseUser.uid}, Email: ${firebaseUser.email}');
  //   }

  //   return firebaseUser;
  // }

  Future<void> signOut() async {
    if (_googleSignIn.currentUser == null) {
      return;
    }
    await _googleSignIn.signOut();
    // await _firebaseAuth.signOut();
  }
}
