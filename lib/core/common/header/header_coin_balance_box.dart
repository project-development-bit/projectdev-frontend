import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

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
          Image(
            image: const AssetImage("assets/images/rewards/coin.png"),
            width: context.isMobile ? 16 : 24,
            height: context.isMobile ? 16 : 24,
          ),
          const SizedBox(width: 5),
          CommonText.titleMedium(
            coinBalance,
            fontWeight: FontWeight.w700,
            fontSize: context.isMobile ? 14 : 16,
            color: colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }
}
