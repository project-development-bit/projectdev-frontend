import 'package:gigafaucet/core/common/webview_wrapper.dart';
import 'package:gigafaucet/core/core.dart';
import 'package:gigafaucet/features/chat/presentation/provider/right_chat_overlay_provider.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WebViewWrapper(
      title: !context.isMobile
          ? null
          : AppLocalizations.of(context)?.translate('chat') ?? 'Chat',
      url: RightChatOverlayConfig.chatUrl,
    );
  }
}
