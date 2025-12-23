import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:google_sign_in_web/web_only.dart' as gsi_web;

class WebGoogleSignInButton extends StatefulWidget {
  const WebGoogleSignInButton({
    super.key,
    required this.onIdToken,
    this.onError,
    this.isLoading = false,
  });

  final FutureOr<void> Function(String idToken) onIdToken;
  final void Function(String message)? onError;
  final bool isLoading;

  @override
  State<WebGoogleSignInButton> createState() => _WebGoogleSignInButtonState();
}

class _WebGoogleSignInButtonState extends State<WebGoogleSignInButton> {
  late final Future<void> _initFuture;
  StreamSubscription<GoogleSignInUserData?>? _sub;
  bool _handling = false;

  @override
  void initState() {
    super.initState();

    _initFuture = GoogleSignInPlatform.instance.init();

    _sub = GoogleSignInPlatform.instance.userDataEvents?.listen(
      (user) {
        if (_handling) return;
        if (user == null) return;

        _handling = true;
        Future<void>(() async {
          try {
            final tokenData = await GoogleSignInPlatform.instance.getTokens(
              email: user.email,
              shouldRecoverAuth: true,
            );
            final idToken = tokenData.idToken;
            if (idToken == null || idToken.isEmpty) {
              GoogleSignInPlatform.instance.signOut();
              widget.onError?.call(
                'Google sign-in did not return an ID token in the browser.',
              );
              return;
            }
            await widget.onIdToken(idToken);
          } catch (e) {
            GoogleSignInPlatform.instance.signOut();
            widget.onError?.call(
              'Google sign-in failed in the browser. Please try again.',
            );
          } finally {
            _handling = false;
          }
        });
      },
      onError: (Object e) {
        widget.onError?.call(
          'Google sign-in failed in the browser. Please try again.',
        );
      },
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }

        // This renders the official Google Identity Services button.
        return gsi_web.renderButton(
            configuration: gsi_web.GSIButtonConfiguration(
          type: gsi_web.GSIButtonType.standard,
          theme: gsi_web.GSIButtonTheme.filledBlack, // Customize theme
          logoAlignment: gsi_web.GSIButtonLogoAlignment.left,
          size: gsi_web.GSIButtonSize.large,

          locale: "en-US",
        ));
      },
    );
  }
}
