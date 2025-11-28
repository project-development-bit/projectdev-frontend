import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/earnings/data/model/request/earnings_history_request.dart';
import 'package:cointiply_app/features/earnings/presentation/provider/earnings_history_state.dart';
import 'package:cointiply_app/features/earnings/presentation/provider/get_earnings_history_notifier.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/cards/coins_earned_history_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoinsHistorySection extends ConsumerWidget {
  const CoinsHistorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(earningsHistoryNotifierProvider);
    final notifier = ref.read(earningsHistoryNotifierProvider.notifier);
    final localizations = AppLocalizations.of(context);

    // Auto-fetch on enter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.status == EarningsHistoryStatus.initial) {
        notifier.fetchEarningsHistory(
          const EarningsHistoryRequestModel(page: 1, limit: 20, days: 7),
        );
      }
    });

    if (state.status == EarningsHistoryStatus.loading && state.data == null) {
      return const _HistoryLoading();
    }

    if (state.status == EarningsHistoryStatus.error) {
      return Center(
        child: CommonText.bodyMedium(
          state.error ?? "Something went wrong",
          color: Theme.of(context).colorScheme.error,
        ),
      );
    }

    final items = state.data?.data?.earnings ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CommonText.bodyLarge(
            localizations?.translate('coins_history_title') ??
                "Last Coins Earned (Past 7 Days)",
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onPrimary,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
        const SizedBox(height: 20),

        // Earned items
        for (final item in items)
          CoinsEarnedHistoryCard(
            title: item.title,
            subtitle: item.category,
            amount: item.amount,
            timeAgo: item.timeAgo,
          ),

        const SizedBox(height: 20),

        // Pagination
        if (state.isLoadingMore)
          const Center(child: CircularProgressIndicator()),

        if (state.canLoadMore && !state.isLoadingMore)
          Center(
            child: CustomButtonWidget(
              title: localizations?.translate("load_more") ?? "Load More",
              onTap: () {
                notifier.loadMore();
              },
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}

class _HistoryLoading extends StatelessWidget {
  const _HistoryLoading();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
