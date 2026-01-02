import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:intl/intl.dart';

import '../providers/referred_users_provider.dart';
import 'affiliate_date_picket_button_widget.dart';

class AffiliateFilterBarWidget extends ConsumerWidget {
  const AffiliateFilterBarWidget({super.key});

  String _formatDateRange(String? dateFrom, String? dateTo) {
    if (dateFrom == null || dateTo == null) {
      return "Select Date Range";
    }
    try {
      final from = DateTime.parse(dateFrom);
      final to = DateTime.parse(dateTo);
      final formatter = DateFormat('dd/MM/yyyy');
      return '${formatter.format(from)} - ${formatter.format(to)}';
    } catch (e) {
      return "Select Date Range";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRequest = ref.watch(referredUsersProvider).currentRequest;
    final dateRangeText = _formatDateRange(
      currentRequest?.dateFrom,
      currentRequest?.dateTo,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AffiliateDatePickerButton(
          title: dateRangeText,
          onTap: () async {
            final DateTimeRange? pickedRange = await showDateRangePicker(
              context: context,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              initialDateRange: currentRequest?.dateFrom != null &&
                      currentRequest?.dateTo != null
                  ? DateTimeRange(
                      start: DateTime.parse(currentRequest!.dateFrom!),
                      end: DateTime.parse(currentRequest.dateTo!),
                    )
                  : null,
              cancelText: "Close",
              builder: (context, child) {
                double getDialogWidth(BuildContext context) {
                  if (context.isMobile) {
                    return MediaQuery.of(context)
                        .size
                        .width; // Mobile → full width
                  }
                  if (context.isTablet) {
                    return MediaQuery.of(context).size.width *
                        0.8; // Tablet → 80%
                  }
                  return 650; //Fixed width for desktop
                }

                double getDialogHeight(BuildContext context) {
                  if (context.isMobile) {
                    return MediaQuery.of(context).size.height *
                        0.9; // Mobile → 90% height
                  }
                  if (context.isTablet) {
                    return MediaQuery.of(context).size.height *
                        0.8; // Tablet → 80% height
                  }
                  return 580; // Fixed height for desktop
                }

                return Theme(
                  data: Theme.of(context).copyWith(
                    dialogTheme: const DialogThemeData(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: Theme.of(context).colorScheme.primary,
                      brightness: Theme.of(context).brightness,
                    ),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: getDialogWidth(context),
                        maxHeight: getDialogHeight(context),
                      ),
                      child: child!,
                    ),
                  ),
                );
              },
            );

            if (pickedRange != null) {
              ref
                  .read(referredUsersProvider.notifier)
                  .changeDateRange(pickedRange.start, pickedRange.end);
            }
          },
        ),
      ],
    );
  }
}
