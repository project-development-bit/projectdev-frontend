import 'package:gigafaucet/core/common/common_image_widget.dart';
import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/common/custom_buttom_widget.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:gigafaucet/routing/app_router.dart';
import 'package:flutter/material.dart';

showSuccessSpinDialog(BuildContext context,
    {required String rewardImageUrl, required String rewardLabel}) {
  showDialog(
    context: context,
    builder: (context) => SuccessSpinDialogWidget(
      rewardImageUrl: rewardImageUrl,
      rewardLabel: rewardLabel,
    ),
  );
}

class SuccessSpinDialogWidget extends StatelessWidget {
  final String rewardImageUrl;
  final String rewardLabel;
  const SuccessSpinDialogWidget(
      {super.key, required this.rewardImageUrl, required this.rewardLabel});

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonText.titleLarge(context.translate("congratulations"),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: isMobile
                      ? 24
                      : isTablet
                          ? 30
                          : 36),
              SizedBox(
                  height: isMobile
                      ? 10
                      : isTablet
                          ? 15
                          : 20),
              CommonImage(
                imageUrl: rewardImageUrl,
                fit: BoxFit.contain,
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
              SizedBox(
                  height: isMobile
                      ? 10
                      : isTablet
                          ? 15
                          : 20),
              CommonText.bodyLarge(
                rewardLabel,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: isMobile ? 16 : 20,
              ),
              SizedBox(
                  height: isMobile
                      ? 10
                      : isTablet
                          ? 15
                          : 20),
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
    );
  }
}
