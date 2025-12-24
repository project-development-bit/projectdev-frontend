import 'package:gigafaucet/core/common/close_square_button.dart';
import 'package:gigafaucet/core/common/common_image_widget.dart';
import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      child: SizedBox(
        width: isMobile
            ? MediaQuery.of(context).size.width * 0.9
            : isTablet
                ? MediaQuery.of(context).size.width * 0.7
                : 630,
        height: isMobile
            ? MediaQuery.of(context).size.height * 0.7
            : isTablet
                ? 650
                : 696,
        child: Stack(
          children: [
            Container(
              width: isMobile
                  ? MediaQuery.of(context).size.width * 0.9
                  : isTablet
                      ? MediaQuery.of(context).size.width * 0.7
                      : 630,
              height: isMobile
                  ? MediaQuery.of(context).size.height * 0.7
                  : isTablet
                      ? 650
                      : 696,
              padding: isMobile
                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                  : null,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage(isMobile
                      ? AppLocalImages.spinNotRemainBgMobile
                      : AppLocalImages.successSpingDialogBg),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              child: FittedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: isMobile ? 20 : 40),
                    CommonImage(
                      imageUrl: AppLocalImages.congratsLabel,
                      fit: BoxFit.contain,
                      width: isMobile
                          ? context.screenWidth * 0.6
                          : isTablet
                              ? 350
                              : 400,
                    ),
                    SizedBox(height: isMobile ? 20 : 40),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CommonText.bodyLarge(
                        rewardLabel,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        maxLines: 2,
                        fontSize: isMobile ? 24 : 24,
                      ),
                    ),
                    SizedBox(height: isMobile ? 20 : 40),
                    CommonImage(
                      imageUrl: AppLocalImages.fortuneWheelGirlCong,
                      fit: isMobile ? BoxFit.contain : BoxFit.cover,
                      alignment:
                          isMobile ? Alignment.center : Alignment.topCenter,
                      width: isMobile
                          ? context.screenWidth * 0.75
                          : isTablet
                              ? 250
                              : 270,
                      height: isMobile
                          ? context.screenHeight * 0.7
                          : isTablet
                              ? 300
                              : 370,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                right: isMobile ? 10 : 16,
                top: isMobile ? 10 : 16,
                child: CloseSquareButton(onTap: () {
                  context.pop();
                }))
          ],
        ),
      ),
    );
  }
}
