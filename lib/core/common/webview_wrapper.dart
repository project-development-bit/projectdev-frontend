import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:webview_all/webview_all.dart';

class WebViewWrapper extends StatelessWidget {
  final String url;
  final String? title;
  final VoidCallback? onClose;
  final bool useScaffold;

  const WebViewWrapper({
    super.key,
    required this.url,
    this.title,
    this.onClose,
    this.useScaffold = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.isMobile;
    final webview = ResponsiveSection(
      maxWidth: isMobile ? null : MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.zero,
      fullWidthOnMobile: true,
      child: Webview(url: url),
    );

    if (!useScaffold) {
      return webview;
    }

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
      body: webview,
    );
  }
}
