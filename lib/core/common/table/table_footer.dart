import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TableFooter extends ConsumerWidget {
  const TableFooter({
    super.key,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.changePage,
    required this.changeLimit,
  });

  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final Function(int) changePage;
  final Function(int) changeLimit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final state = ref.watch(paymentHistoryNotifierProvider);
    // final notifier = ref.read(paymentHistoryNotifierProvider.notifier);

    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = context.isMobile;

    // final total = state.pagination?.total ?? 0;
    // final page = state.pagination?.currentPage ?? 1;
    // final limit = state.pagination?.limit ?? 10;
    // final totalPages = (total / limit).ceil() == 0 ? 1 : (total / limit).ceil();

    final start = ((page - 1) * limit) + 1;
    final end = (start + total - 1).clamp(0, total);

    // Pagination buttons
    final paginationWidget = Row(
      children: [
        IconButton(
          icon: Icon(Icons.chevron_left, color: const Color(0xFF98989A)),
          onPressed: page > 1 ? () => changePage(page - 1) : null,
        ),
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: CommonText.bodyMedium(
            "$page",
            color: colorScheme.surface,
          ),
        ),
        IconButton(
          icon: Icon(Icons.chevron_right, color: const Color(0xFF98989A)),
          onPressed: page < totalPages ? () => changePage(page + 1) : null,
        ),
      ],
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // LIMIT DROPDOWN + SHOWING TEXT
            Row(
              children: [
                DropdownButton<int>(
                  value: limit,
                  underline: SizedBox(),
                  dropdownColor: const Color(0xFF00131E),
                  items: [10, 20, 50, 100].map((v) {
                    return DropdownMenuItem(
                      value: v,
                      child: CommonText.bodyMedium(
                        "$v",
                        color: const Color(0xFF98989A),
                      ),
                    );
                  }).toList(),
                  onChanged: (v) => changeLimit(v!),
                ),
                SizedBox(width: 8),
                CommonText.bodyMedium(
                  "Showing $start to $end of $total records",
                  color: const Color(0xFF98989A),
                ),
              ],
            ),

            if (!isMobile) paginationWidget,
          ],
        ),
        if (isMobile)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: paginationWidget,
          ),
      ],
    );
  }
}
