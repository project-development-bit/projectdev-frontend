import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/referred_users_provider.dart';
import 'affiliate_date_picket_button_widget.dart';

class AffiliateFilterBarWidget extends ConsumerWidget {
  const AffiliateFilterBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate =
        ref.watch(referredUsersProvider).currentRequest?.dateFrom;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AffiliateDatePickerButton(
          title: selectedDate ?? "dd/mm/yyyy",
          onTap: () async {
            final dateTime = await showDatePicker(
                context: context,
                cancelText: "Close",
                initialDate: DateTime.parse(selectedDate ??
                    DateTime.now().toIso8601String()),
                firstDate: DateTime(1900),
                lastDate: DateTime.now());
            if (dateTime != null) {
              ref.read(referredUsersProvider.notifier).changeDate(dateTime);
            }
          },
        ),
      ],
    );
  }
}
