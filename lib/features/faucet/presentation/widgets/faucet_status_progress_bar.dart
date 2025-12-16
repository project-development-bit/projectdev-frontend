import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/config/app_local_images.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/faucet/presentation/provider/faucet_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FaucetStatusProgressBar extends ConsumerWidget {
  const FaucetStatusProgressBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(getFaucetNotifierProvider).status;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.isMobile ? 11 : 53.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Column(
              spacing: 10.0,
              children: [
                CommonText.titleMedium(
                  "[${status?.streak.progressPercent ?? 0}]%",
                  highlightColor: context.primary,
                  fontWeight: FontWeight.w700,
                ),
                LinearProgressIndicator(
                  value: 0.5,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(20),
                  backgroundColor: Colors.white.withAlpha(50),
                  valueColor: AlwaysStoppedAnimation<Color>(context.primary),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonText.titleMedium(
                      "[${status?.streak.remaining ?? 0}] ",
                      highlightColor: context.primary,
                      fontWeight: FontWeight.w700,
                    ),
                    Image.asset(
                      AppLocalImages.coin,
                      width: 24,
                      height: 24,
                    ),
                    CommonText.titleMedium(
                      " ${context.translate("remaining")}",
                      highlightColor: context.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 14),
          SizedBox(
            height: context.isMobile ? 80 : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonText.titleMedium(
                  "${status?.streak.dailyTarget ?? 0} ",
                ),
                Image.asset(
                  AppLocalImages.coin,
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
