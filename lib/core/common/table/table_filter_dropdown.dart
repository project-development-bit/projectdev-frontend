import 'package:cointiply_app/core/common/common_text.dart';
import 'package:flutter/material.dart';

class TableFilterDropdown extends StatefulWidget {
  final Widget child;
  final List<String> options;
  final String selected;
  final Function(String) onSelect;
  final double width;

  const TableFilterDropdown({
    super.key,
    required this.child,
    required this.options,
    required this.selected,
    required this.onSelect,
    this.width = 220,
  });

  @override
  State<TableFilterDropdown> createState() => _TableFilterDropdownState();
}

class _TableFilterDropdownState extends State<TableFilterDropdown> {
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
    final colorScheme = Theme.of(context).colorScheme;

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
                            ? colorScheme.primary
                            : const Color(0xFF98989A),
                      ),
                      const SizedBox(width: 8),
                      CommonText.bodyMedium(
                        option.toUpperCase(),
                        color:
                            isSelected ? Colors.white : const Color(0xFF98989A),
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
