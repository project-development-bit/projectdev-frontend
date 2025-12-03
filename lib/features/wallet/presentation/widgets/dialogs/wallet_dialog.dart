import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/core/common/dialog_bg_widget.dart';
import 'package:cointiply_app/features/wallet/presentation/providers/get_balance_notifier_provider.dart';
import 'package:cointiply_app/features/wallet/presentation/providers/get_withdrawal_options_notifier_provider.dart';
import 'package:cointiply_app/features/wallet/presentation/widgets/sections/balances_section.dart';
import 'package:cointiply_app/features/wallet/presentation/widgets/sections/payament_history_section.dart';
import 'package:cointiply_app/features/wallet/presentation/widgets/sub_widgets/wallet_tab_bar_widget.dart';
import 'package:cointiply_app/features/wallet/presentation/widgets/sections/withdrawl_earning_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final walletTabBarIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

class WalletDialog extends ConsumerStatefulWidget {
  const WalletDialog({super.key});

  @override
  ConsumerState<WalletDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends ConsumerState<WalletDialog> {
  int selectedTab = 0;

  double _getDialogHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (context.isTablet) return height * 0.9;
    return 680;
  }

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(getBalanceNotifierProvider.notifier).fetchUserBalance();
      ref.read(getWithdrawalNotifierProvider.notifier).fetchWithdrawalOptions();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = _getDialogHeight(context);
    // final isTablet = context.isTablet;
    // final isMobile = context.isMobile;

    return DialogBgWidget(
      dialogHeight: height,
      title: context.translate("wallet"),
      padding: EdgeInsets.zero,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 31),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              WalletTabBarWidget(),
              _manageProfileTabBody(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _manageProfileTabBody() {
    final selectedIndex = ref.watch(walletTabBarIndexProvider);
    if (selectedIndex == 0) {
      return const WithdrawlEarningSection();
    } else if (selectedIndex == 1) {
      return const BalancesSection();
    } else if (selectedIndex == 2) {
      return const PayamentHistorySection();
    }
    return const SizedBox();
  }
}
