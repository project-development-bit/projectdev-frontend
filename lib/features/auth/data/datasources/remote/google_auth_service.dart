import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleAuthServiceProvider = Provider((ref) => GoogleAuthService());

class GoogleAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
// Source - https://stackoverflow.com/a
// Posted by Pratik Butani
// Retrieved 2025-12-18, License - CC BY-SA 4.0

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '645002434672-nji58g0s1sdqfpu679h3h7cc3v9diaue.apps.googleusercontent.com',
    scopes: [
      'openid',
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      "https://www.googleapis.com/auth/userinfo.profile"
    ],
  );

  Future<UserCredential> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in aborted');
      }

      final googleAuth = await googleUser.authentication;
      debugPrint("Testing 101 : idToken ${googleAuth.idToken}");
      debugPrint("Testing 101 : accessToken ${googleAuth.accessToken}");

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      debugPrint('Google sign-in successful: ${firebaseUser?.email}');
      debugPrint('Firebase User UID: ${firebaseUser?.uid}');
      debugPrint('Firebase User Display Name: ${firebaseUser?.displayName}');
      debugPrint('Firebase User Photo URL: ${firebaseUser?.photoURL}');
      debugPrint('User Credential: $userCredential');
      if (firebaseUser == null) {
        throw Exception("Failed to sign in with Google");
      }
      debugPrint("Testing 101 : ${userCredential.toString()}");
      return userCredential;
    } catch (e) {
      rethrow; // Let the caller handle it further if needed
    }
  }

  Future<String?> getGoogleIdToken() async {
    try {
      // 1. Try to sign in silently. This is the recommended way on web.
      GoogleSignInAccount? account = await _googleSignIn.signInSilently();

      // 2. If silent sign-in fails, try interactive sign-in as a fallback.
      account ??= await _googleSignIn.signIn();

      if (account == null) {
        print("Google Sign-In failed: The user cancelled the sign-in.");
        return null;
      }

      // 3. Get authentication details.
      GoogleSignInAuthentication auth = await account.authentication;
      String? idToken = auth.idToken;

      // This is a workaround for the known issue where idToken can be null
      // on the first interactive sign-in on the web.
      if (kIsWeb && idToken == null) {
        print("idToken was null, attempting to re-authenticate silently...");
        final silentAuthAccount =
            await _googleSignIn.signInSilently(reAuthenticate: true);
        if (silentAuthAccount != null) {
          auth = await silentAuthAccount.authentication;
          idToken = auth.idToken;
        }
      }

      if (idToken == null) {
        print("Error: idToken is still null after all attempts.");
      }

      return idToken;
    } catch (error) {
      print("An error occurred during Google Sign-In: $error");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
