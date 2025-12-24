<<<<<<< HEAD
import 'package:gigafaucet/core/core.dart';
import 'package:gigafaucet/routing/routing.dart';
=======
import 'dart:math' as math;

import 'package:gigafaucet/core/core.dart';
import 'package:gigafaucet/routing/routing.dart';
>>>>>>> main
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
    final webviewChild = LayoutBuilder(
      builder: (context, constraints) {
        final mediaSize = MediaQuery.of(context).size;

        final double width = constraints.hasBoundedWidth
            ? math.min(constraints.maxWidth, mediaSize.width)
            : mediaSize.width;
        final double height = constraints.hasBoundedHeight
            ? math.min(constraints.maxHeight, mediaSize.height)
            : mediaSize.height;

        return SizedBox(
          width: width,
          height: height,
          child: Webview(url: url),
        );
      },
    );
    final webview = ResponsiveSection(
      maxWidth: isMobile ? null : MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.zero,
      fullWidthOnMobile: true,
      child: webviewChild,
    );

    if (!useScaffold) {
      return webview;
    }

    return Scaffold(
      backgroundColor: AppColors.transparent,
      appBar: title != null
          ? AppBar(
              toolbarHeight: 46,
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
                    context.pop();
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
