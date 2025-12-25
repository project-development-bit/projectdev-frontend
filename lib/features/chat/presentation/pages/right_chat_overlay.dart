import 'package:gigafaucet/core/common/webview_wrapper.dart';
import 'package:gigafaucet/features/localization/data/helpers/app_localizations.dart';
import 'package:gigafaucet/features/chat/presentation/provider/right_chat_overlay_provider.dart';
import 'package:gigafaucet/core/common/widgets/custom_pointer_interceptor.dart';
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

    return CustomPointerInterceptor(
      child: Stack(
        children: [
          // Base app content (interactable when chat closed)
          AbsorbPointer(
            absorbing: isChatOpen, // disable base taps only when chat is open
            child: child,
          ),

          // Optional dim background (click to close)
          if (isChatOpen)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  ref.read(rightChatOverlayProvider.notifier).close();
                },
                child: Container(
                  color: Colors.black.withAlpha(100),
                ),
              ),
            ),

          // Chat panel (interactive and always above dim layer)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: 0,
            bottom: 0,
            right: isChatOpen ? 0 : -RightChatOverlayConfig.panelWidth,
            width: RightChatOverlayConfig.panelWidth,
            child: _ChatPanel(),
          ),
        ],
      ),
    );
  }
}

/// --- INTERNAL CHAT PANEL ---
class _ChatPanel extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(rightChatOverlayProvider.notifier);
    // final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          alignment: Alignment.centerRight,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(-2, 0),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.black87),
            onPressed: () {
              notifier.close();
            },
            tooltip: AppLocalizations.of(context)!.translate('close_chat'),
          ),
        ),
        Expanded(
          child: Material(
            color: Colors.black87,
            elevation: 8,
            child: WebViewWrapper(
              url: RightChatOverlayConfig.chatUrl,
            ),
          ),
        ),
      ],
    );
  }
}
