import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final isMobile = context.isMobile;

    return Scaffold(
      appBar: title != null
          ? AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: isMobile
                  ? Colors.transparent
                  : Theme.of(context).appBarTheme.backgroundColor,
              toolbarOpacity: 1.0,
              title: CommonText(
                title!,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
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
