import 'package:cointiply_app/core/config/app_local_images.dart';
import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HeaderCoinBalanceBox extends StatelessWidget {
  const HeaderCoinBalanceBox({super.key, required this.coinBalance});
  final String coinBalance;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = context.screenWidth;

    return Container(
      alignment: Alignment.center,
      height: 41,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth < 320 ? 6 : 16.5,
      ),
      decoration: BoxDecoration(
        color: Color(0xff100E1C),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0x83333333), //TODO: Replace with theme color
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // CommonImage(
          //   imageUrl: AppLocalImages.coin,
          //   width: context.isMobile ? 16 : 24,
          //   height: context.isMobile ? 16 : 24,
          //   filterQuality: FilterQuality.high,
          // ),
          SvgPicture.asset(
            AppLocalImages.coinSvg,
            width: context.isMobile ? 16 : 24,
            height: context.isMobile ? 16 : 24,
          ),
          const SizedBox(width: 5),
          CommonText.titleMedium(
            coinBalance,
            fontWeight: FontWeight.w700,
            fontSize: context.isMobile ? 12 : 16,
            color: colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }
}
