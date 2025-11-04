import 'package:flutter/material.dart';
import 'package:webview_all/webview_all.dart';
import 'common_text.dart';

class WebViewWrapper extends StatelessWidget {
  final String url;
  final String? title;
  final VoidCallback? onClose;

  const WebViewWrapper({
    super.key,
    required this.url,
    this.title,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
          ? AppBar(
              title: title != null
                  ? CommonText(
                      title ?? "",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    )
                  : SizedBox(),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose ?? () => Navigator.of(context).pop(),
              ),
            )
          : null,
      body: Webview(
        url: url,
      ),
    );
  }
}
