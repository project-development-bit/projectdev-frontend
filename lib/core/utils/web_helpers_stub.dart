// IO implementation for non-web platforms (Android, iOS, etc.)
// Keeps API surface identical to the web helper, but removes the native splash.
import 'package:flutter/services.dart';

const MethodChannel _splashChannel = MethodChannel('app.splash');

void removeSplashFromWeb() {
  try {
    _splashChannel.invokeMethod<void>('hide');
  } catch (_) {
    // Ignore: channel may not be registered in some builds.
  }
}
