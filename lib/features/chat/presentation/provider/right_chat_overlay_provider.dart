import 'package:flutter_riverpod/flutter_riverpod.dart';

/// --- PROVIDER SECTION ---
///
/// Riverpod provider to control chat overlay visibility

final rightChatOverlayProvider =
    StateNotifierProvider<RightChatOverlayNotifier, bool>((ref) {
  return RightChatOverlayNotifier();
});

/// State Notifier to manage chat overlay visibility
class RightChatOverlayNotifier extends StateNotifier<bool> {
  RightChatOverlayNotifier() : super(false);

  void open() => state = true;
  void close() => state = false;
  void toggle() {
    state = !state;
  }

  bool get isOpen => state;
}

/// --- CONFIG SECTION ---

class RightChatOverlayConfig {
  /// URL for your Tawk.to or any chat widget
  static const String chatUrl =
      "https://tawk.to/chat/68e4bddd7651d7194ef40daa/1j6uobasr";

  /// Default width of the right chat panel
  static const double panelWidth = 400;

  /// Set to false to disable chat overlay entirely
  static const bool isEnabled = true;
}
