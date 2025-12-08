import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/wallet/presentation/providers/payment_history_notifier_provider.dart';
import 'package:cointiply_app/features/wallet/presentation/widgets/sub_widgets/transaction_filter_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class TransactionFilterBar extends ConsumerWidget {
  const TransactionFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(paymentHistoryNotifierProvider.notifier);
    final state = ref.watch(paymentHistoryNotifierProvider);

    final isMobile = context.isMobile;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TransactionFilterDropdown(
          selected: state.filterCurrency ?? "all",
          options: const ["all", "usdt", "coin", "btc"],
          onSelect: notifier.changeFilterCurrency,
          child: TransactionFilterButton(
            title: "Currency: ${(state.filterCurrency ?? "all").toUpperCase()}",
          ),
        ),
        SizedBox(width: isMobile ? 6 : 10),
        TransactionFilterDropdown(
          selected: state.filterStatus ?? "all",
          options: const ["all", "confirmed", "pending", "failed"],
          onSelect: notifier.changeStatus,
          child: TransactionFilterButton(
            title: "Type: ${(state.filterStatus ?? "all").toUpperCase()}",
          ),
        ),
        SizedBox(width: isMobile ? 6 : 10),
        GestureDetector(
          onTap: notifier.refresh,
          child: SvgPicture.asset(
            "assets/images/icons/Refresh ccw.svg",
            width: isMobile ? 16 : 24,
            height: isMobile ? 16 : 24,
          ),
        ),
      ],
    );
  }
}

class TransactionFilterDropdown extends StatefulWidget {
  final Widget child;
  final List<String> options;
  final String selected;
  final Function(String) onSelect;
  final double width;

  const TransactionFilterDropdown({
    super.key,
    required this.child,
    required this.options,
    required this.selected,
    required this.onSelect,
    this.width = 220,
  });

  @override
  State<TransactionFilterDropdown> createState() =>
      _TransactionFilterDropdownState();
}

class _TransactionFilterDropdownState extends State<TransactionFilterDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (_) => Positioned(
        width: widget.width,
        left: offset.dx,
        top: offset.dy + renderBox.size.height + 6,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFF00131E),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 6),
            shrinkWrap: true,
            children: widget.options.map((option) {
              final isSelected = option == widget.selected;

              return InkWell(
                onTap: () {
                  widget.onSelect(option);
                  _toggleDropdown();
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.circle_outlined,
                        size: 18,
                        color: isSelected
                            ? Colors.blueAccent
                            : const Color(0xFF98989A),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        option.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFFEEEEEE),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: widget.child,
      ),
    );
  }
}
