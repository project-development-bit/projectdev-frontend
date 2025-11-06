import 'package:cointiply_app/core/common/webview_wrapper.dart';
import 'package:cointiply_app/core/localization/app_localizations.dart';
import 'package:cointiply_app/features/chat/presentation/provider/right_chat_overlay_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// --- UI WRAPPER SECTION ---
///
/// Wrap your entire page with this widget (like InternalVerificationOverlay)

class RightChatOverlay extends ConsumerWidget {
  final Widget child;

  const RightChatOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isChatOpen = ref.watch(rightChatOverlayProvider);

    if (!RightChatOverlayConfig.isEnabled) {
      return child;
    }

    return Stack(
      children: [
        // Base app content
        InkWell(
            onTap: () {
              ref.read(rightChatOverlayProvider.notifier).close();
            },
            child: child),

        // Right-side chat overlay
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          top: 0,
          bottom: 0,
          right: isChatOpen ? 0 : -RightChatOverlayConfig.panelWidth,
          width: RightChatOverlayConfig.panelWidth,
          child: _ChatPanel(),
        ),
      ],
    );
  }
}

/// --- INTERNAL CHAT PANEL ---

class _ChatPanel extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(rightChatOverlayProvider.notifier);

    return Material(
      color: Colors.black87,
      elevation: 8,
      child: Stack(
        children: [
          // Embedded chat WebView
          const WebViewWrapper(
            url: RightChatOverlayConfig.chatUrl,
          ),

          // Close button
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: notifier.close,
              tooltip: AppLocalizations.of(context)!.translate('close_chat'),
            ),
          ),
        ],
      ),
    );
  }
}
