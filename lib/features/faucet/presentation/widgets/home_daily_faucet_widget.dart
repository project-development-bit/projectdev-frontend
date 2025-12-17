import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/core/providers/auth_provider.dart';
import 'package:cointiply_app/features/auth/presentation/widgets/dialog/login_required_dialog.dart';
import 'package:cointiply_app/features/faucet/presentation/widgets/actual_faucet_title.dart';
import 'package:cointiply_app/features/faucet/presentation/widgets/dialog/claim_your_faucet_dialog.dart';
import 'package:cointiply_app/features/faucet/presentation/widgets/event_daily_streak_resets.dart';
import 'package:cointiply_app/features/faucet/presentation/widgets/faucet_status_day_list_widget.dart';
import 'package:cointiply_app/features/faucet/presentation/widgets/faucet_status_progress_bar.dart';
import 'package:cointiply_app/features/faucet/presentation/widgets/next_faucet_widget.dart';
import 'package:cointiply_app/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeDailyFaucetWidget extends ConsumerWidget {
  const HomeDailyFaucetWidget({super.key, required this.isColumn});
  final bool isColumn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xff00131E).withAlpha(127),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xff333333)),
      ),
      padding: const EdgeInsets.all(10.5),
      child: Column(children: [
        ActualFaucetTitle(
          isColumn: isColumn,
        ),
        SizedBox(height: 17),
        NextFaucetWidget(
          onClaimTap: () {
            final isAuthenticated = ref.read(isAuthenticatedObservableProvider);

            if (isAuthenticated) {
              showClaimYourFaucetDialog(context);
            } else {
              showLoginRequiredDialog(context, onGoToLogin: () {
                context.go('/auth/login');
              });
            }
          },
        ),
        SizedBox(height: 17),
        CommonText.titleLarge(
          context.translate("event_daily_streak_faucet"),
          fontSize: 20.0,
        ),
        CommonText.bodyLarge(
          context.translate("event_earn_coins_continue_streak"),
          color: Color(0xFF98989A),
        ),
        SizedBox(height: 24),
        FaucetStatusProgressBar(),
        SizedBox(height: 24),
        FaucetStatusDayListWidget(),
        SizedBox(height: 16),
        EventDailyStreakResets(),
      ]),
    );
  }
}
