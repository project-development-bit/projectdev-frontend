import 'dart:async';

import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

/// A generic, reusable searchable dropdown field for any data type (T).
class SearchableDropdown<T> extends StatelessWidget {
  const SearchableDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    required this.displayStringForItem,
    this.selectedItem,
    this.validator,
    this.labelText,
    this.hintText,
  });

  /// Function to provide the list of items based on filter (required by DropdownSearch)
  final FutureOr<List<T>> Function(String, LoadProps?)? items;

  /// Currently selected item
  final T? selectedItem;

  /// Callback when selection changes
  final ValueChanged<T?>? onChanged;

  /// Validator function for form validation
  final FormFieldValidator<T?>? validator;

  /// Function to get the string representation of an item for display and search.
  final String Function(T) displayStringForItem;

  /// Label text for the field (above the input)
  final String? labelText;

  /// Hint text for the field (inside the input when nothing is selected)
  final String? hintText;

  // --- Implementation Details ---

  // Builder for the selected item in the closed state (just the string)
  Widget _dropdownBuilder(BuildContext context, T? item) {
    if (item == null) {
      return CommonText.bodyMedium(
        hintText ?? (labelText ?? 'Select Item'),
        color: Theme.of(context).hintColor,
      );
    }
    return CommonText.bodyMedium(
      displayStringForItem(item),
      fontWeight: FontWeight.w500,
      color: context.onSurface,
    );
  }

  // Builder for the items inside the popup/dialog (just the string)
  Widget _itemBuilder(
      BuildContext context, T item, bool isDisabled, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: CommonText.bodyMedium(
        displayStringForItem(item),
        color: context.onSurface,
      ),
    );
  }

  // Custom filter logic
  bool _filterFn(T item, String filter) {
    return displayStringForItem(item)
        .toLowerCase()
        .contains(filter.toLowerCase());
  }

  // Comparison logic (must compare items based on their unique string representation)
  bool _compareFn(T item1, T item2) {
    return displayStringForItem(item1) == displayStringForItem(item2);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      // 1. Data Source and Callbacks
      items: items,
      selectedItem: selectedItem,
      onChanged: onChanged,

      // 2. Custom Builders and Logic
      dropdownBuilder: _dropdownBuilder,
      itemAsString:
          displayStringForItem, // Used internally for selected item and search
      compareFn: _compareFn,
      filterFn: _filterFn,

      // 3. Styling
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: labelText,
          hintText: hintText,
          filled: true,
          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),

      // 4. Search Popup
      popupProps: PopupProps.dialog(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: "Search...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        itemBuilder: _itemBuilder,
      ),

      // 5. Validation
      validator: validator,
    );
  }
}
