import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/wallet/presentation/widgets/wallet_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletTabBarWidget extends ConsumerWidget {
  const WalletTabBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(walletTabBarIndexProvider);
    final isMobile = context.isMobile;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22.5),
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double spacing = 4;
          final double buttonWidth =
              (constraints.maxWidth - spacing) / (context.isDesktop ? 3.1 : 2);

          return Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.center,
            spacing: spacing,
            runSpacing: 12.0,
            children: [
              CustomButtonWidget(
                isOutlined: true,
                padding: const EdgeInsets.symmetric(vertical: 12),
                title: isMobile
                    ? context.translate("withdrawal")
                    : context.translate("withdrawal_earning"),
                // index: 0,
                isActive: selectedIndex == 0,
                width: buttonWidth,
                fontSize: 16,
                onTap: () =>
                    ref.read(walletTabBarIndexProvider.notifier).state = 0,
              ),
              CustomButtonWidget(
                isOutlined: true,
                padding: const EdgeInsets.symmetric(vertical: 12),
                title: context.translate("balances"),
                isActive: selectedIndex == 1,
                width: buttonWidth,
                fontSize: 16,
                onTap: () =>
                    ref.read(walletTabBarIndexProvider.notifier).state = 1,
              ),
              CustomButtonWidget(
                title: context.translate("payment_history"),
                padding: const EdgeInsets.symmetric(vertical: 12),
                isActive: selectedIndex == 2,
                width: isMobile ? buttonWidth + 30 : buttonWidth,
                fontSize: 16,
                isOutlined: true,
                onTap: () =>
                    ref.read(walletTabBarIndexProvider.notifier).state = 2,
              ),
            ],
          );
        },
      ),
    );
  }
}
