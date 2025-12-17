import 'dart:async';

import 'package:cointiply_app/core/common/common_image_widget.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';

/// A searchable dropdown field specialized for items needing a flag/icon,
/// name, and code display in both the list and the selected field.
class SearchableDropdownWithIcon<T> extends StatelessWidget {
  const SearchableDropdownWithIcon({
    super.key,
    required this.items,
    required this.onChanged,
    required this.getItemCode,
    required this.getItemName,
    required this.getItemIconUrl,
    this.selectedItem,
    this.validator,
    // this.labelText,
    this.hintText,
    this.floatingLabelBehavior,
    this.placeholder,
  });

  /// Function to provide the list of items based on filter (for search/remote loading)
  final FutureOr<List<T>> Function(String, LoadProps?)? items;

  /// Currently selected item
  final T? selectedItem;

  /// Callback when selection changes
  final ValueChanged<T?>? onChanged;

  /// Validator function for form validation
  final FormFieldValidator<T?>? validator;

  /// Function to get code from item
  final String Function(T) getItemCode;

  /// Function to get name from item
  final String Function(T) getItemName;

  /// Function to get the URL for the icon/flag from item
  final String Function(T) getItemIconUrl;

  /// Label text for the field
  // final String? labelText;

  /// Hint text for the search field inside the popup
  final String? hintText;

  final FloatingLabelBehavior? floatingLabelBehavior;

  final Widget? placeholder;

  // Builder for the selected item in the closed state (Flag | Name/Code)
  Widget _dropdownBuilder(BuildContext context, T? item) {
    if (item == null) {
      return CommonText.bodyMedium(
        hintText ?? 'Select Item',
        color: Theme.of(context).hintColor,
      );
    }
    return Row(
      children: [
        SizedBox(
          width: 32,
          height: 21,
          child: CommonImage(imageUrl: getItemIconUrl(item)), // Flag
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonText.bodyMedium(
                getItemName(item),
                fontWeight: FontWeight.w500,
                color: context.onSurface,
              ),
              // CommonText.bodySmall(
              //   getItemCode(item),
              //   color: context.onSurface.withValues(alpha: 0.6),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  // Builder for the items inside the popup/dialog (Flag | Name/Code)
  Widget _itemBuilder(
      BuildContext context, T item, bool isDisabled, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            height: 21,
            child: CommonImage(
              imageUrl: getItemIconUrl(item),
              placeholder: placeholder,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonText.bodyMedium(
                  getItemName(item),
                  fontWeight: FontWeight.w500,
                  color: context.onSurface,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Custom filter logic
  bool _filterFn(T item, String filter) {
    return getItemName(item).toLowerCase().contains(filter.toLowerCase()) ||
        getItemCode(item).toLowerCase().contains(filter.toLowerCase());
  }

  // Comparison logic for selected item (must use a unique key like code)
  bool _compareFn(T item1, T item2) {
    return getItemCode(item1) == getItemCode(item2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownSearch<T>(
      suffixProps: const DropdownSuffixProps(
        dropdownButtonProps: DropdownButtonProps(
            iconOpened: Icon(
              Icons.keyboard_arrow_up_rounded,
              color: Color(0xFF98989A),
              size: 24,
            ),
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            disabledColor: Colors.transparent,
            iconClosed: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF98989A),
              size: 24,
            )),
      ),
      items: items,
      selectedItem: selectedItem,
      onChanged: onChanged,
      dropdownBuilder: _dropdownBuilder,
      compareFn: _compareFn,
      filterFn: _filterFn,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          floatingLabelBehavior:
              floatingLabelBehavior ?? FloatingLabelBehavior.never,
          // labelText: labelText ?? 'Select Item *',
          filled: true,
          fillColor: (Theme.of(context).brightness == Brightness.dark
              ? AppColors.websiteCard
              : theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.1)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        ),
      ),

      // 4. Search Popup
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.onSurface.withValues(alpha: 0.6),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.onSurface.withValues(alpha: 0.6),
              ),
            ),
            hintText: "Search...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        itemBuilder: _itemBuilder,
      ),
      // 5. Validation
      validator: validator,
    );
  }
}
