import 'package:cointiply_app/features/wallet/data/models/response/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:cointiply_app/core/core.dart';

class TransactionsTable extends StatelessWidget {
  final List<TransactionModel> items;

  const TransactionsTable({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = context.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),

        // FILTER BAR
        TransactionFilterBar(),

        const SizedBox(height: 14),

        // TABLE CONTAINER
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colorScheme.outlineVariant, width: 1),
          ),
          child: isMobile
              ? Column(
                  children: items.map((e) {
                    return TransactionMobileRow(item: e);
                  }).toList(),
                )
              : Column(
                  children: [
                    TransactionDesktopHeader(),
                    Divider(color: colorScheme.outlineVariant, height: 1),
                    ...items.map((e) => TransactionDesktopRow(item: e))
                  ],
                ),
        ),

        const SizedBox(height: 14),

        // FOOTER (page size + showing)
        TransactionTableFooter(itemsCount: items.length),
      ],
    );
  }
}

class TransactionDesktopHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final headers = [
      localizations?.translate("tx_description") ?? "Description",
      localizations?.translate("tx_status") ?? "Status",
      localizations?.translate("tx_amount") ?? "Amount",
      localizations?.translate("tx_coins") ?? "Coins",
      localizations?.translate("tx_currency") ?? "Currency",
      localizations?.translate("tx_address") ?? "Address",
      localizations?.translate("tx_date") ?? "Date",
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: headers.map((e) {
          return Expanded(
            flex: 1,
            child: CommonText.bodyMedium(
              e,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TransactionDesktopRow extends StatelessWidget {
  final TransactionModel item;

  const TransactionDesktopRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final values = [
      item.description,
      item.status,
      item.amount,
      item.coins,
      item.currency,
      item.address,
      item.date
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: values.map((e) {
          return Expanded(
            child: CommonText.bodySmall(
              e,
              color: colorScheme.onSurfaceVariant,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TransactionMobileRow extends StatelessWidget {
  final TransactionModel item;

  const TransactionMobileRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText.bodyMedium(item.description,
              color: colorScheme.primary, fontWeight: FontWeight.w600),
          const SizedBox(height: 6),
          CommonText.bodySmall("${item.status} • ${item.amount}",
              color: colorScheme.onSurfaceVariant),
          CommonText.bodySmall("${item.coins} • ${item.currency}",
              color: colorScheme.onSurfaceVariant),
          CommonText.bodySmall(item.address,
              color: colorScheme.onSurfaceVariant),
          CommonText.bodySmall(item.date, color: colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}

class TransactionFilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        TransactionFilterButton(
          title: localizations?.translate("filter_currency") ??
              "Filter By Currency",
        ),
        const SizedBox(width: 10),
        TransactionFilterButton(
          title: localizations?.translate("filter_type") ?? "Filter By Type",
        ),
        const SizedBox(width: 8),
        CommonImage(
          imageUrl: "assets/icons/refresh.png",
          width: 22,
          height: 22,
        )
      ],
    );
  }
}

class TransactionFilterButton extends StatelessWidget {
  final String title;
  const TransactionFilterButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Row(
        children: [
          CommonText.bodyMedium(
            title,
            color: colorScheme.onSurface,
          ),
          const SizedBox(width: 6),
          Icon(Icons.keyboard_arrow_down_rounded,
              color: colorScheme.onSurfaceVariant, size: 18),
        ],
      ),
    );
  }
}

class TransactionTableFooter extends StatelessWidget {
  final int itemsCount;

  const TransactionTableFooter({super.key, required this.itemsCount});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // PAGE SIZE DROPDOWN
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              CommonText.bodyMedium("20", color: colorScheme.onSurface),
              const SizedBox(width: 6),
              Icon(Icons.keyboard_arrow_down_rounded,
                  color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),

        // SHOWING TEXT
        CommonText.bodySmall(
          "${localizations?.translate('showing') ?? 'Showing'} 1 to 0 of $itemsCount ${localizations?.translate('records') ?? 'records'}",
          color: colorScheme.onSurfaceVariant,
        ),

        // PAGINATION
        Row(
          children: [
            Icon(Icons.chevron_left, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 6),
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: CommonText.bodyMedium(
                "1",
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
          ],
        )
      ],
    );
  }
}
