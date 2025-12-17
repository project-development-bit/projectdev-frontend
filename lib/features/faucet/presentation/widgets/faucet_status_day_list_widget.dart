import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:gigafaucet/features/faucet/presentation/provider/faucet_notifier_provider.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FaucetStatusDayListWidget extends ConsumerWidget {
  const FaucetStatusDayListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ScrollController();
    final status = ref.watch(getFaucetNotifierProvider).status;

    final currentDay = status?.streak.currentDay ?? 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.isMobile ? 0 : 30.5),
      child: Scrollbar(
        controller: scrollController,
        thickness: 2,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(bottom: 10, left: 5, top: 5),
          child: Row(
            spacing: 12,
            children: (status?.streak.days ?? []).map((day) {
              final isActive = day.day == currentDay;
              return _eventDayItemWidget(
                context,
                day: LocalizationExtension(context)
                    .translate("event_day", args: [day.day.toString()]),
                coins: day.reward.toString(),
                isActive: isActive,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _eventDayItemWidget(
    BuildContext context, {
    required String day,
    required String coins,
    bool isActive = false,
  }) {
    return Container(
      decoration: isActive
          ? DottedDecoration(
              color: context.primary,
              borderRadius: BorderRadius.circular(12),
              strokeWidth: 2,
              shape: Shape.box,
            )
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22.5, vertical: 19.5),
        decoration: BoxDecoration(
          color: Color(0xff00131E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            CommonText.titleMedium(
              context
                  .translate("event_day", args: [day.replaceAll("Day ", "")]),
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonText.titleMedium(
                  coins,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
                SizedBox(width: 6),
                Image.asset(
                  AppLocalImages.coin,
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
