import 'package:cointiply_app/core/common/table/table_footer.dart';
import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/earnings/presentation/provider/earnings_history_state.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/cards/coins_earned_history_card.dart';
import 'package:flutter/material.dart';

class CoinsHistorySection extends StatelessWidget {
  const CoinsHistorySection(
      {super.key,
      required this.state,
      required this.loadMore,
      required this.onPageChange,
      required this.onLimitChange});
  final EarningsHistoryState state;
  final Function loadMore;
  final Function(int) onPageChange;
  final Function(int) onLimitChange;
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
    final days = state.days;

    return Column(
      children: [
        Center(
          child: CommonText.bodyLarge(
            (localizations?.translate('coins_history_title') ??
                    "Last Coins Earned (Past 7 Days)")
                .replaceAll("{days}", days.toString()),
            fontWeight: FontWeight.w500,
            color: Color(0xFF98989A),

            /// TODO: Use from scheme
          ),
        ),
        const SizedBox(height: 20),
        // Empty state
        if (items.isEmpty)
          Container(
            height: 200,
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: CommonText.bodyMedium(
              localizations?.translate('no_coin_earn_history') ??
                  "No coin earning activity yet.",
              color: Color(0xFF98989A),
            ),
          )
        else
          for (final item in items)
            CoinsEarnedHistoryCard(
              title: item.title,
              subtitle: item.category,
              amount: item.amount,
              timeAgo: item.timeAgo,
            ),
        if (items.isNotEmpty)
          TableFooter(
            total: state.data?.data?.pagination.total ?? 0,
            page: state.page,
            limit: state.limit,
            totalPages: (state.data?.data?.pagination.total != null &&
                    state.data!.data!.pagination.limit > 0)
                ? (state.data!.data!.pagination.total /
                        state.data!.data!.pagination.limit)
                    .ceil()
                : 1,
            changePage: (newPage) {
              onPageChange(newPage);
            },
            changeLimit: (newLimit) {
              onLimitChange(newLimit);
            },
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
