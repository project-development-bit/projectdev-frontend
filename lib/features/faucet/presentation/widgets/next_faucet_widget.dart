import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/config/app_local_images.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/faucet/presentation/provider/faucet_countdown_provider.dart';
import 'package:cointiply_app/features/faucet/presentation/provider/faucet_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NextFaucetWidget extends ConsumerWidget {
  const NextFaucetWidget({
    super.key,
    required this.onClaimTap,
  });
  final Function onClaimTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(getFaucetNotifierProvider).status;
    if (status == null) {
      return const SizedBox.shrink();
    }

    final countdown = ref.watch(
      faucetCountdownProvider(status),
    );
    return Container(
      width: 365,
      height: 127,
      decoration: BoxDecoration(
        color: const Color(0xff1A1A1A),
        border: Border.all(color: const Color(0xff262626)),
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage(
            AppLocalImages.nextFaucetBg,
          ),
          fit: BoxFit.fill,
          alignment: Alignment.center,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!status.canClaim) ...[
            CommonText.titleMedium(
              context.translate('event_next_faucet'),
              fontWeight: FontWeight.w600,
              color: Color(0xFFFFD561),
            ),
            const SizedBox(height: 16),
            Row(
              spacing: 16,
              mainAxisSize: MainAxisSize.min,
              children: [
                _eventTime(
                  context,
                  time: countdown.hours.toString().padLeft(2, '0'),
                  unit: context.translate("event_hours"),
                ),
                _eventTime(
                  context,
                  time: countdown.minutes.toString().padLeft(2, '0'),
                  unit: context.translate("event_minutes"),
                ),
                _eventTime(
                  context,
                  time: countdown.seconds.toString().padLeft(2, '0'),
                  unit: context.translate("event_seconds"),
                ),
              ],
            ),
          ] else ...[
            CommonText.titleMedium(
              context.translate("your_faucet_ready"),
              fontWeight: FontWeight.w600,
              color: Color(0xFFFFD561),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CustomUnderLineButtonWidget(
              isDark: true,
              onTap: () {
                onClaimTap();
              },
              fontSize: 14,
              fontWeight: FontWeight.w700,
              title: context.translate("claim_your_faucet"),
            )
          ]
        ],
      ),
    );
  }

  Column _eventTime(BuildContext context,
      {required String time, required String unit}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonText.titleLarge(
          time,
          fontSize: 20,
          color: context.primary,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 4),
        CommonText.titleSmall(
          unit,
          color: Colors.white,
        ),
      ],
    );
  }
}
