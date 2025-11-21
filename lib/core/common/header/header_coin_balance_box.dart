import 'package:cointiply_app/core/common/common_text.dart';
import 'package:flutter/material.dart';

class HeaderCoinBalanceBox extends StatelessWidget {
  const HeaderCoinBalanceBox({super.key, required this.coinBalance});
  final String coinBalance;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      alignment: Alignment.center,
      height: 41,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.5,
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
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 5),
          CommonText.titleMedium(
            coinBalance,
            fontWeight: FontWeight.w700,
            color: colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }
}
