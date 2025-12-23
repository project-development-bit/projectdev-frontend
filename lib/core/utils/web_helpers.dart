import 'dart:js_interop';

@JS('window.removeSplashFromWeb')
external void _jsRemoveSplashFromWeb();

void removeSplashFromWeb() {
  try {
    _jsRemoveSplashFromWeb();
  } catch (e) {
    // Ignore errors if function doesn't exist
  }
}
