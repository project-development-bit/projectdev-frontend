import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/config/app_local_images.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/routing/app_router.dart';
import 'package:flutter/material.dart';

showOutofSpinDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => OutOfSpinDialogWidget(),
  );
}

class OutOfSpinDialogWidget extends StatelessWidget {
  const OutOfSpinDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      child: Container(
        width: isMobile
            ? MediaQuery.of(context).size.width * 0.9
            : isTablet
                ? MediaQuery.of(context).size.width * 0.7
                : 630,
        height: isMobile
            ? MediaQuery.of(context).size.height * 0.9
            : isTablet
                ? MediaQuery.of(context).size.height * 0.8
                : 696,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(isMobile
                ? AppLocalImages.spinNotRemainBgMobile
                : isTablet
                    ? AppLocalImages.spinNotRemainBgMobile
                    : AppLocalImages.spinNotRemainBg),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: isMobile
                    ? 20
                    : isTablet
                        ? 30
                        : 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppLocalImages.outOfSpins,
                  width: isMobile
                      ? 260
                      : isTablet
                          ? 360
                          : 400,
                  height: isMobile
                      ? 120
                      : isTablet
                          ? 180
                          : 200,
                ),
                Image.asset(
                  AppLocalImages.spinWheelIcon,
                  width: isMobile
                      ? 120
                      : isTablet
                          ? 180
                          : 200,
                  height: isMobile
                      ? 120
                      : isTablet
                          ? 180
                          : 200,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: isMobile
                          ? 20
                          : isTablet
                              ? 30
                              : 40),
                  child: CommonText.bodyMedium(
                    context.translate('come_back_later_for_more'),
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: isMobile
                        ? 16
                        : isTablet
                            ? 20
                            : 24,
                  ),
                ),
                CustomUnderLineButtonWidget(
                    width: isMobile ? 150 : 350,
                    title: context.translate("okay"),
                    fontSize: 14,
                    onTap: () {
                      context.pop();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
