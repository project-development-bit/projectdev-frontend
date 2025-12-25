import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/features/faucet/presentation/provider/faucet_notifier_provider.dart';
import 'package:gigafaucet/features/localization/data/helpers/localization_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActualFaucetTitle extends ConsumerWidget {
  const ActualFaucetTitle({
    super.key,
    required this.isColumn,
  });
  final bool isColumn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(getFaucetNotifierProvider).status;
    return Flex(
      direction: isColumn ? Axis.vertical : Axis.horizontal,
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonText.titleMedium(context.translate('event_actual_faucet'),
            fontWeight: FontWeight.w700),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
              color: Color(0xff100E1C),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Color(0xff333333))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonText.titleMedium(
                "${status?.rewardPerClaim ?? 0}",
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
              ),
              SizedBox(width: 4),
              Image.asset(
                AppLocalImages.coin,
                width: 24,
                height: 24,
              ),
            ],
          ),
        ),
        CommonText.titleMedium(
          context.translate("event_every_hours",
              args: ["${status?.intervalHours ?? 0}"]),
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }
}
