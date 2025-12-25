import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/features/faucet/presentation/provider/faucet_notifier_provider.dart';
import 'package:gigafaucet/features/localization/data/helpers/localization_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventDailyStreakResets extends ConsumerWidget {
  const EventDailyStreakResets({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(getFaucetNotifierProvider).status;

    return Column(
      children: [
        if ((status?.streak.currentDay ?? 0) ==
            (status?.streak.maxDays ?? 30)) ...[
          CommonText.bodyMedium(
            context.translate(
              "you_have_reached_max_faucet_reward",
            ),
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 24),
        ],
        CommonText.bodyLarge(
          context.translate("event_daily_streak_resets",
              args: ["${status?.dailyReset.timeUntilReset.hours ?? 0}"]),
          color: Color(0xFF98989A),
          fontWeight: FontWeight.w700,
        )
      ],
    );
  }
}
