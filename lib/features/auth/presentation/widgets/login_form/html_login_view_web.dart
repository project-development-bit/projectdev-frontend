// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui;
import 'dart:convert';

import 'package:flutter/widgets.dart';

late html.IFrameElement _iframe;

Widget getHtmlEmailPasswordView({
  required void Function(String email, String password) onLogin,
}) {
  ui.platformViewRegistry.registerViewFactory('html-login', (int viewId) {
    _iframe = html.IFrameElement()
      ..src = 'login.html'
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%';

    return _iframe;
  });

  html.window.onMessage.listen((event) {
    if (event.data is String) {
      final decoded = jsonDecode(event.data);

      if (decoded['type'] == 'LOGIN_DATA') {
        onLogin(decoded['email'] ?? '', decoded['password'] ?? '');
      }
    }
  });

  return const HtmlElementView(viewType: 'html-login');
}

void requestEmailPasswordDataFromHtmlImpl() {
  _iframe.contentWindow?.postMessage({'type': 'REQUEST_LOGIN_DATA'}, '*');
}

void sendErrorsToHtmlImpl({String? emailError, String? passwordError}) {
  _iframe.contentWindow?.postMessage({
    'type': 'SHOW_ERRORS',
    'emailError': emailError,
    'passwordError': passwordError,
  }, '*');
}

void clearErrorsInHtmlImpl() {
  _iframe.contentWindow?.postMessage({
    'type': 'SHOW_ERRORS',
    'emailError': null,
    'passwordError': null,
  }, '*');
}
