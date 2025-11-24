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
  const DialogBgWidget(
      {super.key,
      required this.body,
      required this.title,
      this.onClose,
      this.dialogHeight});

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

    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            DialogGradientBackground(width: width, height: height),
            Container(
              width: width,
              height: height,
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                height: height,
                child: Column(
                  children: [
                    SizedBox(
                      height: 88,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 29),
                            child: CommonText.headlineSmall(
                              title,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          CloseSquareButton(onTap: () {
                            context.pop();
                            if (onClose != null) {
                              onClose!();
                            }
                          })
                        ],
                      ),
                    ),
                    Divider(),
                    Expanded(child: body)
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
