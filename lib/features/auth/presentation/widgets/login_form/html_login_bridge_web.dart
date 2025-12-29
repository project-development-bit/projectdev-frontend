// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui;
import 'dart:convert';

import 'package:flutter/cupertino.dart';

late html.IFrameElement _iframe;

class HtmlLoginRegistry {
  static bool _initialized = false;

  static String email = '';
  static String password = '';
  static String? _emailError;
  static String? _passwordError;

  static void init({
    required void Function(String email, String password) onLogin,
  }) {
    debugPrint('Testing HtmlLoginRegistry : Initializing for web.');
    if (_initialized) {
      debugPrint('Testing HtmlLoginRegistry :  already initialized.');
      return;
    }
    _initialized = true;

    ui.platformViewRegistry.registerViewFactory('html-login', (int viewId) {
      _iframe = html.IFrameElement()
        ..src = 'login.html'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%';

      return _iframe;
    });

    html.window.onMessage.listen((event) {
      if (event.data is! String) return;

      final data = jsonDecode(event.data);

      switch (data['type']) {
        case 'LOGIN_DATA':
          email = data['email'] ?? '';
          password = data['password'] ?? '';
          onLogin(email, password);
          break;

        case 'CACHE_VALUES':
          email = data['email'] ?? '';
          password = data['password'] ?? '';
          break;

        case 'HTML_READY':
          restore();
          break;
      }
    });
  }

  static void requestLogin() {
    _iframe.contentWindow?.postMessage(
      jsonEncode({'type': 'REQUEST_LOGIN_DATA'}),
      '*',
    );
  }

  static void restore() {
    restoreErrors();
    _iframe.contentWindow?.postMessage(
      jsonEncode({
        'type': 'RESTORE_VALUES',
        'email': email,
        'password': password,
      }),
      '*',
    );
  }

  static void showErrors({String? emailError, String? passwordError}) {
    _emailError = emailError;
    _passwordError = passwordError;

    _iframe.contentWindow?.postMessage(
      jsonEncode({
        'type': 'SHOW_ERRORS',
        'emailError': emailError,
        'passwordError': passwordError,
      }),
      '*',
    );
  }

  static void restoreErrors() {
    if (_emailError == null && _passwordError == null) return;

    _iframe.contentWindow?.postMessage(
      jsonEncode({
        'type': 'SHOW_ERRORS',
        'emailError': _emailError,
        'passwordError': _passwordError,
      }),
      '*',
    );
  }

  static void clearErrors() {
    _emailError = null;
    _passwordError = null;

    _iframe.contentWindow?.postMessage(
      jsonEncode({'type': 'CLEAR_ERRORS'}),
      '*',
    );
  }

  static void dispose() {
    debugPrint("Testing HtmlLoginRegistry : Disposing HtmlLoginRegistry.");
    _initialized = false;
  }
}
