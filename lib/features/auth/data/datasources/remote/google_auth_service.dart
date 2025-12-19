import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleAuthServiceProvider = Provider((ref) => GoogleAuthService());

class GoogleAuthService {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
      final googleAuth = await _getGoogleAuthDetails();
      if (googleAuth == null) {
        return null;
      }

      debugPrint('Google ID Token: ${googleAuth.idToken}');
      debugPrint('Google Access Token: ${googleAuth.accessToken}');
      debugPrint('Google Sign-In serverAuthCode: ${googleAuth.serverAuthCode}');
      debugPrint('Google Sign-In successful.');

      // final firebaseUser = await _signInToFirebaseWithGoogle(googleAuth);

      // debugPrint('Firebase User UID: ${firebaseUser?.uid}');
      // debugPrint('Firebase User Email: ${firebaseUser?.email}');
      // debugPrint('Firebase User Display Name: ${firebaseUser?.displayName}');
      // debugPrint('Firebase User Photo URL: ${firebaseUser?.photoURL}');

      // Step 3: If successful, update and return the request object.
      debugPrint('Successfully signed in with Google and Firebase.');
      return GoolgeSignInResult(
        idToken: googleAuth.idToken,
        // user: firebaseUser,
      );
    } catch (error) {
      debugPrint("An error occurred during the Google sign-in process: $error");
      return null;
    }
  }

  /// Handles the Google Sign-In flow and retrieves the authentication tokens.
  /// Includes the necessary workaround for Flutter Web.
  Future<GoogleSignInAuthentication?> _getGoogleAuthDetails() async {
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
    // await _firebaseAuth.signOut();
  }
}

class GoolgeSignInResult {
  final String? idToken;
  // final User? user;

  GoolgeSignInResult({
    this.idToken,
    // this.user
  });
}
