import 'package:cointiply_app/features/wallet/domain/entity/withdrawal_option.dart';
import 'package:cointiply_app/features/wallet/presentation/providers/get_withdrawal_options_notifier_provider.dart';
import 'package:cointiply_app/features/wallet/presentation/providers/withdrawal_option_state.dart';
import 'package:cointiply_app/features/wallet/presentation/widgets/sub_widgets/interest_notification_widget.dart';
import 'package:cointiply_app/features/wallet/presentation/widgets/sub_widgets/withdrawal_earning_methods_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WithdrawlEarningSection extends ConsumerWidget {
  const WithdrawlEarningSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final withdrawalOptions =
        ref.watch(getWithdrawalNotifierProvider).withdrawalOptions;

    final isLoading = ref.watch(getWithdrawalNotifierProvider).status ==
        GetWithdrawalOptionStatus.loading;
    return Column(
      children: [
        WithdrawalEarningMethodsWidget(
          methods: withdrawalOptions,
          onSelect: (WithdrawalOption option) {},
          isLoading: isLoading,
        ),
        InterestNotificationWidget(),
      ],
    );
  }
}
