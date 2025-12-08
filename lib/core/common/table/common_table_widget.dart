import 'package:cointiply_app/core/common/table/table_footer.dart';
import 'package:cointiply_app/core/common/table/table_header_widget.dart';
import 'package:cointiply_app/core/common/table/table_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:cointiply_app/core/core.dart';

class CommonTableWidget extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> values;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final Function(int) changePage;
  final Function(int) changeLimit;
  final Widget? filterBar;
  const CommonTableWidget({
    super.key,
    required this.headers,
    required this.values,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.changePage,
    required this.changeLimit,
    this.filterBar,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        if (filterBar != null) filterBar!,
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
                    width: values.length * 150.0,
                    child: Column(
                      children: [
                        TableHeaderWidget(headers: headers),
                        Divider(
                            color: const Color(
                                0xFF333333), // TODO: to use from scheme
                            height: 1),
                        ...values.map((e) => TableRowWidget(values: e)),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    TableHeaderWidget(headers: headers),
                    Divider(color: const Color(0xFF333333), height: 1),
                    ...values.map((e) => TableRowWidget(values: e)),
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
