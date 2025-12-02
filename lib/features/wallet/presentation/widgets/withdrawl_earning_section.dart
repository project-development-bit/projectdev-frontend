import 'package:cointiply_app/features/wallet/presentation/widgets/interest_notification_widget.dart';
import 'package:cointiply_app/features/wallet/presentation/widgets/withdrawal_earning_methods_widget.dart';
import 'package:flutter/material.dart';

class WithdrawlEarningSection extends StatelessWidget {
  const WithdrawlEarningSection({super.key});

  @override
  Widget build(BuildContext context) {
    final withdrawalMethods = [
      WithdrawalOption(
        key: "btc",
        title: "Bitcoin",
        icon: "assets/images/coins/btc@2x.png",
        minCoins: 50000,
      ),
      WithdrawalOption(
        key: "dash",
        title: "Dash",
        icon: "assets/images/coins/dash@2x.png",
        minCoins: 30000,
      ),
      WithdrawalOption(
        key: "doge",
        title: "Doge",
        icon: "assets/images/coins/doge@2x.png",
        minCoins: 30000,
      ),
      WithdrawalOption(
        key: "ltc",
        title: "Litecoin",
        icon: "assets/images/coins/litecoin@2x.png",
        minCoins: 30000,
      ),
    ];
    return Column(
      children: [
        WithdrawalEarningMethodsWidget(
          methods: withdrawalMethods,
          onSelect: (key) {},
        ),
        InterestNotificationWidget(),
      ],
    );
  }
}
