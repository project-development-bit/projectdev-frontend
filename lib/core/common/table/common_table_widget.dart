import 'package:cointiply_app/core/common/table/models/table_column.dart';
import 'package:cointiply_app/core/common/table/table_footer.dart';
import 'package:cointiply_app/core/common/table/table_header_widget.dart';
import 'package:cointiply_app/core/common/table/table_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:cointiply_app/core/core.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CommonTableWidget extends StatelessWidget {
  final List<TableColumn> columns;
  final List<List<String>> values;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final Function(int) changePage;
  final Function(int) changeLimit;
  final Widget? filterBar;
  final bool isLoading;
  final String noDataText;
  const CommonTableWidget({
    super.key,
    required this.columns,
    required this.values,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.changePage,
    required this.changeLimit,
    this.filterBar,
    this.isLoading = false,
    this.noDataText = "no_data_available",
  });

  double get totalWidth =>
      columns.fold(0, (sum, col) => sum + col.width); // sum of all widths
  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        if (filterBar != null) filterBar!,
        SizedBox(height: filterBar != null ? 8 : 0),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF00131E), // TODO: to use from scheme
            borderRadius: BorderRadius.circular(10),
          ),
          child: isMobile || isTablet
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: totalWidth,
                    child: Column(
                      children: [
                        TableHeaderWidget(
                            headers: columns.map((col) => col.header).toList()),
                        Divider(color: const Color(0xFF333333), height: 1),
                        Skeletonizer(
                          enabled: isLoading,
                          child: values.isEmpty && !isLoading
                              ? _buildNoData(context, noDataText: noDataText)
                              : Column(
                                  children: [
                                    ...values
                                        .map((e) => TableRowWidget(values: e)),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    TableHeaderWidget(
                        headers: columns.map((col) => col.header).toList()),
                    Divider(color: const Color(0xFF333333), height: 1),
                    Skeletonizer(
                      enabled: isLoading,
                      child: values.isEmpty && !isLoading
                          ? _buildNoData(context, noDataText: noDataText)
                          : Column(
                              children: [
                                ...values.map((e) => TableRowWidget(values: e)),
                              ],
                            ),
                    )
                  ],
                ),
        ),
        const SizedBox(height: 12),
        TableFooter(
          total: total,
          page: page,
          limit: limit,
          totalPages: totalPages,
          changePage: changePage,
          changeLimit: changeLimit,
        ),
      ],
    );
  }
}

Widget _buildNoData(BuildContext context,
    {String noDataText = "no_data_available"}) {
  final localizations = AppLocalizations.of(context);

  return Container(
    height: 80,
    alignment: Alignment.center,
    child: CommonText.bodyMedium(
      localizations?.translate(noDataText) ?? "No data available",
      color: const Color(0xFF98989A), // TODO: use from scheme
      fontWeight: FontWeight.w600,
    ),
  );
}
