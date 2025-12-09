import 'package:cointiply_app/core/common/close_square_button.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/dialog_gradient_backgroud.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DialogBgWidget extends StatelessWidget {
  final Widget body;
  final String title;
  final Function()? onClose;
  final double? dialogHeight;
  final double? dialogWidth;

  final Color? dividerColor;
  final EdgeInsetsGeometry? padding;
  final Function()? onRouteBack;
  const DialogBgWidget(
      {super.key,
      required this.body,
      required this.title,
      this.onClose,
      this.dialogHeight,
      this.dividerColor,
      this.onRouteBack,
      this.dialogWidth,
      this.padding});

  double _getDialogWidth(BuildContext context) {
    if (context.isMobile) {
      return MediaQuery.of(context).size.width; // Mobile → full width
    }
    if (context.isTablet) {
      return MediaQuery.of(context).size.width * 0.8; // Tablet → 80%
    }
    return dialogWidth ?? 650; //Fixed width for desktop
  }

  double _getDialogHeight(BuildContext context) {
    return dialogHeight ?? 470;
  }

  @override
  Widget build(BuildContext context) {
    final width = dialogWidth ?? _getDialogWidth(context);
    final height = _getDialogHeight(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        DialogGradientBackground(width: width, height: height),
        SizedBox(
          width: width,
          height: height,
          child: Column(
            children: [
              Container(
                padding: context.isMobile || context.isTablet
                    ? const EdgeInsets.symmetric(horizontal: 17, vertical: 22)
                    : const EdgeInsets.symmetric(horizontal: 31, vertical: 22),
                child: Row(
                  children: [
                    Expanded(
                      child: onRouteBack != null
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    onRouteBack!();
                                  },
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Color(0xFF98989A),
                                    weight: 16,
                                  ),
                                ),
                                SizedBox(width: 16),
                                CommonText.headlineSmall(
                                  title,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onPrimary,
                                  overflow: TextOverflow.clip,
                                )
                              ],
                            )
                          : CommonText.headlineSmall(
                              title,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onPrimary,
                              overflow: TextOverflow.clip,
                            ),
                    ),
                    CloseSquareButton(onTap: () {
                      context.pop();
                      if (onClose != null) {
                        onClose!();
                      }
                    })
                  ],
                ),
              ),
              Divider(
                color:
                    dividerColor ?? Color(0xFF003248), // TODO use from theme,
                thickness: 1,
              ),
              Expanded(child: body)
            ],
          ),
        )
      ],
    );
  }
}
