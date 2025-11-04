import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:webview_all/webview_all.dart';

class WebViewWrapper extends StatelessWidget {
  final String url;
  final String? title;
  final VoidCallback? onClose;
  // final

  const WebViewWrapper({
    super.key,
    required this.url,
    this.title,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.isMobile;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: title != null
          ? AppBar(
              title: CommonText.titleMedium(
                title ?? '',
                color: context.onSurface,
                fontWeight: FontWeight.w600,
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.close,
                  color: context.onSurface,
                ),
                onPressed: () {
                  if (onClose != null) {
                    onClose!();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
              elevation: 1,
            )
          : null,
      body: ResponsiveSection(
        // 90 % of screen width
        maxWidth: isMobile ? null : MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.zero,
        fullWidthOnMobile: true,
        child: Webview(url: url),
      ),
    );
  }
}
