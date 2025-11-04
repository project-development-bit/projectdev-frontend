import 'package:cointiply_app/features/chat/presentation/pages/right_chat_overlay.dart';
import 'package:cointiply_app/features/chat/presentation/provider/right_chat_overlay_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// --- EXAMPLE PAGE ---

class RightChatOverlayExample extends ConsumerWidget {
  const RightChatOverlayExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatNotifier = ref.read(rightChatOverlayProvider.notifier);

    return RightChatOverlay(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("Right Chat Overlay Example"),
          actions: [
            IconButton(
              icon: const Icon(Icons.chat),
              onPressed: chatNotifier.toggle,
            ),
          ],
        ),
        body: const Center(
          child: Text(
            "Main App Content",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
