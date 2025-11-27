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
  final Color? dividerColor;
  const DialogBgWidget(
      {super.key,
      required this.body,
      required this.title,
      this.onClose,
      this.dialogHeight,
      this.dividerColor});

  double _getDialogWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (context.isMobile) return width; // Mobile → full width
    if (context.isTablet) return width * 0.8; // Tablet → 80%
    return 650; //Fixed width for desktop
  }

  double _getDialogHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (context.isTablet) return height * 0.9;
    return dialogHeight ?? 470;
  }

  @override
  Widget build(BuildContext context) {
    final width = _getDialogWidth(context);
    final height = _getDialogHeight(context);

    return ScaffoldMessenger(
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(20),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  DialogGradientBackground(width: width, height: height),
                  SizedBox(
                    width: width,
                    height: height,
                    child: SizedBox(
                      height: height,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 22),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CommonText.headlineSmall(
                                    title,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
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
                            color: dividerColor ??
                                Color(0xFF003248), // TODO use from theme,
                            thickness: 1,
                          ),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: body,
                          ))
                        ],
                      ),
                    ),
                  )
                ],
              )),
        );
      }),
    );
  }
}
