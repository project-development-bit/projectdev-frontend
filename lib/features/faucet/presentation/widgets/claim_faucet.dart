import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:gigafaucet/core/providers/auth_provider.dart';
import 'package:gigafaucet/features/auth/presentation/widgets/dialog/login_required_dialog.dart';
import 'package:gigafaucet/features/faucet/presentation/provider/faucet_countdown_provider.dart';
import 'package:gigafaucet/features/faucet/presentation/provider/faucet_notifier_provider.dart';
import 'package:gigafaucet/features/faucet/presentation/widgets/dialog/claim_your_faucet_dialog.dart';
import 'package:gigafaucet/features/faucet/presentation/widgets/dialog/your_faucet_dialog.dart';
import 'package:gigafaucet/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClaimFaucet extends ConsumerWidget {
  const ClaimFaucet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faucetState = ref.watch(getFaucetNotifierProvider);
    final status = faucetState.status;

    // if (status == null) {
    //   print('ClaimFaucet: Faucet status is null');
    //   return const SizedBox.shrink();
    // }

    final countdown = ref.watch(
      faucetCountdownProvider(status),
    );

    final timeText = status?.canClaim ?? false
        ? context.translate('ready')
        : '${countdown.hours.toString().padLeft(2, '0')}:'
            '${countdown.minutes.toString().padLeft(2, '0')}:'
            '${countdown.seconds.toString().padLeft(2, '0')}';
    final isAuthenticated = ref.watch(isAuthenticatedObservableProvider);

    return GestureDetector(
      onTap: () {
        if (isAuthenticated) {
          showYourFaucetDialog(context, () {
            showClaimYourFaucetDialog(context);
          });
        } else {
          showYourFaucetDialog(context, () {
            showLoginRequiredDialog(context, onGoToLogin: () {
              context.go('/auth/login');
            });
          });
        }
      },
      child: SizedBox(
        width: 190,
        child: Column(
          children: [
            SizedBox(
              width: 190,
              height: 190,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      AppLocalImages.features1,
                      width: 190,
                      height: 190,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(150),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: CommonText.titleMedium(
                        !isAuthenticated
                            ? "Up to [\$4,000]"
                            : '${context.translate("event_next_faucet")}\n[$timeText]',
                        color: Colors.white,
                        maxLines: 2,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.center,
                        highlightFontSize: 24,
                        highlightColor: context.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CommonText.labelMedium(
              context.translate('claim_faucet'),
              fontWeight: FontWeight.w700,
              fontSize: 16,
              textAlign: TextAlign.center,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}
