import 'package:gigafaucet/core/common/close_square_button.dart';
import 'package:gigafaucet/core/common/common_loading_widget.dart';
import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DialogBgWidget extends StatelessWidget {
  final Widget body;
  final String title;
  final Function()? onClose;

  /// this will be used to set fixed height for dialog loading state
  final double? dialogHeight;
  final double? dialogWidth;

  final Color? dividerColor;
  final EdgeInsetsGeometry? padding;
  final Function()? onRouteBack;
  final bool isOverlayLoading;
  final bool isInitLoading;
  final bool isShowingCloseButton;
  final double? titleFontSize;

  const DialogBgWidget(
      {super.key,
      required this.body,
      required this.title,
      this.onClose,
      this.dialogHeight,
      this.dividerColor,
      this.onRouteBack,
      this.dialogWidth,
      this.isOverlayLoading = false,
      this.isInitLoading = false,
      this.padding,
      this.titleFontSize,
      this.isShowingCloseButton = true});

  double _getDialogWidth(BuildContext context) {
    if (context.isMobile) {
      return MediaQuery.of(context).size.width; // Mobile → full width
    }
    if (context.isTablet) {
      return MediaQuery.of(context).size.width * 0.8; // Tablet → 80%
    }
    return dialogWidth ?? 650; //Fixed width for desktop
  }

  @override
  Widget build(BuildContext context) {
    final width = dialogWidth ?? _getDialogWidth(context);
    // final height = _getDialogHeight(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      height: isInitLoading || isOverlayLoading ? dialogHeight : null,
      constraints: BoxConstraints(
        maxHeight: context.isMobile
            ? context.screenHeight * 0.8
            : context.screenHeight * 0.9,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/dialog_background.png',
              fit: BoxFit.cover,
              // repeat: ImageRepeat.repeatX,
              alignment: Alignment.topCenter,
              gaplessPlayback: true,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: (context.isMobile || context.isTablet
                    ? const EdgeInsets.symmetric(horizontal: 17, vertical: 22)
                    : const EdgeInsets.symmetric(horizontal: 31, vertical: 22)),
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
                              fontSize: titleFontSize,
                              textAlign: isShowingCloseButton
                                  ? TextAlign.left
                                  : TextAlign.center,
                            ),
                    ),
                    if (isShowingCloseButton)
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
              isInitLoading
                  ? Expanded(
                      child: Center(child: CommonLoadingWidget.medium()),
                    )
                  : Flexible(child: body)
            ],
          ),
          Visibility(
            visible: isOverlayLoading,
            child: Container(
                height: dialogHeight,
                color: Colors.black.withValues(alpha: 150),
                child: Center(child: CommonLoadingWidget.medium())),
          )
        ],
      ),
    );
  }
}
