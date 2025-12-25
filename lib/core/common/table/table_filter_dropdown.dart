import 'package:gigafaucet/core/common/common_text.dart';
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
    this.width = 200,
  });

  @override
  State<TableFilterDropdown> createState() => _TableFilterDropdownState();
}

class _TableFilterDropdownState extends State<TableFilterDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  // Track hover index
  int _hoverIndex = -1;

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _closeOverlay();
    }
  }

  void _closeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _hoverIndex = -1;
  }

  @override
  void dispose() {
    _closeOverlay();
    super.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final colorScheme = Theme.of(context).colorScheme;

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          width: widget.width,
          left: offset.dx,
          top: offset.dy + renderBox.size.height + 6,
          child: Material(
            color: Colors.transparent,
            child: StatefulBuilder(
              builder: (context, setOverlayState) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0x22FFFFFF)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(widget.options.length, (index) {
                      final option = widget.options[index];
                      final isSelected = widget.selected == option;
                      final isHover = index == _hoverIndex;

                      return MouseRegion(
                        onEnter: (_) => setOverlayState(() {
                          _hoverIndex = index;
                        }),
                        onExit: (_) => setOverlayState(() {
                          _hoverIndex = -1;
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 140),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              widget.onSelect(option);
                              _toggleDropdown();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.5,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    child: isSelected
                                        ? Icon(Icons.check,
                                            size: 18,
                                            color: colorScheme.primary)
                                        : const SizedBox(),
                                  ),
                                  const SizedBox(width: 10),
                                  CommonText.bodyMedium(
                                    option.toUpperCase(),
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                    color: isSelected
                                        ? colorScheme.primary
                                        : isHover
                                            ? const Color(
                                                0xFFFFD530) // TODO: Use from color scheme
                                            : const Color(0xFFB5B5B5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(maxWidth: widget.width, minWidth: 100),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          onTap: _toggleDropdown,
          child: widget.child,
        ),
      ),
    );
  }
}
