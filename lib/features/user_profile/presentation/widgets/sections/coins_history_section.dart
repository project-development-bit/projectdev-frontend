import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/earnings/presentation/provider/earnings_history_state.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/cards/coins_earned_history_card.dart';
import 'package:flutter/material.dart';

class CoinsHistorySection extends StatelessWidget {
  const CoinsHistorySection(
      {super.key, required this.state, required this.loadMore});
  final EarningsHistoryState state;
  final Function loadMore;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

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
      children: [
        Center(
          child: CommonText.bodyLarge(
            localizations?.translate('coins_history_title') ??
                "Last Coins Earned (Past 7 Days)",
            fontWeight: FontWeight.w500,
            color: Color(0xFF98989A),

            /// TODO: Use from scheme
          ),
        ),
        const SizedBox(height: 20),
        for (final item in items)
          CoinsEarnedHistoryCard(
            title: item.title,
            subtitle: item.category,
            amount: item.amount,
            timeAgo: item.timeAgo,
          ),
        const SizedBox(height: 20),
        if (state.isLoadingMore)
          const Center(child: CircularProgressIndicator()),
        if (state.canLoadMore && !state.isLoadingMore)
          CustomButtonWidget(
            title: localizations?.translate("load_more") ?? "Load More",
            onTap: () => loadMore(),
            fontWeight: FontWeight.w700,
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
