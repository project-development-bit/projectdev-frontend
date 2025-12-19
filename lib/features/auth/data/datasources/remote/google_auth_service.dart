import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleAuthServiceProvider = Provider((ref) => GoogleAuthService());

class GoogleAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '645002434672-nji58g0s1sdqfpu679h3h7cc3v9diaue.apps.googleusercontent.com',
    scopes: [
      'email',
      'profile',
      'openid',
    ],
  );

  Future<GoolgeSignInResult?> getGoogleIdToken() async {
    try {
      // Step 1: Get Google authentication details (idToken and accessToken).
      final googleAuth = await _getGoogleAuthDetails();
      if (googleAuth == null) {
        // This means the sign-in was cancelled by the user.
        return null;
      }

      // Step 2: Use the Google credential to sign in to Firebase.
      final firebaseUser = await _signInToFirebaseWithGoogle(googleAuth);
      if (firebaseUser == null) {
        // This would be an unexpected error if Firebase sign-in fails.
        throw Exception(
            "Failed to sign in to Firebase after getting Google credential.");
      }

      // Step 3: If successful, update and return the request object.
      debugPrint('Successfully signed in with Google and Firebase.');
      return GoolgeSignInResult(
        idToken: googleAuth.idToken,
        user: firebaseUser,
      );
    } catch (error) {
      debugPrint("An error occurred during the Google sign-in process: $error");
      return null;
    }
  }

  /// Handles the Google Sign-In flow and retrieves the authentication tokens.
  /// Includes the necessary workaround for Flutter Web.
  Future<GoogleSignInAuthentication?> _getGoogleAuthDetails() async {
    // 1. Attempt to sign in silently. This is the recommended first step on web.
    GoogleSignInAccount? account = await _googleSignIn.signInSilently();

    // 2. If silent sign-in fails, fall back to the interactive sign-in.
    account ??= await _googleSignIn.signIn();

    // 3. If there's still no account, the user likely cancelled the sign-in flow.
    if (account == null) {
      debugPrint("Google Sign-In aborted by user.");
      return null;
    }

    // 4. Get the authentication object from the account.
    GoogleSignInAuthentication auth = await account.authentication;

    // 5. Web-specific workaround: If idToken is null, force a re-authentication.
    if (kIsWeb && auth.idToken == null) {
      debugPrint(
          "idToken was null on web, attempting to re-authenticate silently...");
      final silentAuthAccount =
          await _googleSignIn.signInSilently(reAuthenticate: true);
      if (silentAuthAccount != null) {
        auth = await silentAuthAccount.authentication;
      }
    }

    // 6. After all attempts, if idToken is still null, something is wrong.
    if (auth.idToken == null) {
      throw Exception(
          "Failed to retrieve idToken from Google after all attempts.");
    }

    debugPrint("Successfully retrieved Google auth details.");
    debugPrint("idToken is present: ${auth.idToken != null}");
    debugPrint("accessToken is present: ${auth.accessToken != null}");

    return auth;
  }

  /// Signs into Firebase using the provided Google authentication details.
  Future<User?> _signInToFirebaseWithGoogle(
      GoogleSignInAuthentication googleAuth) async {
    // CRITICAL FIX: Provide both accessToken and idToken to the credential.
    // This is the most robust way to authenticate with Firebase.
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      debugPrint(
          'Firebase Sign-In Successful. UID: ${firebaseUser.uid}, Email: ${firebaseUser.email}');
    }

    return firebaseUser;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}

class GoolgeSignInResult {
  final String? idToken;
  final User? user;

  GoolgeSignInResult({this.idToken, this.user});
}
