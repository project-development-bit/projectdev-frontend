import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

/// A common dropdown form field widget with consistent styling
///
/// Type parameter [T] allows this widget to work with any data type
class CommonDropdownField<T> extends StatelessWidget {
  const CommonDropdownField({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint,
    this.label,
    this.validator,
    this.enabled = true,
    this.borderRadius,
    this.itemBuilder,
    this.displayStringForItem,
    this.prefixIcon,
    this.isExpanded = true,
  });

  /// List of items to display in dropdown
  final List<T> items;

  /// Callback when selection changes
  final ValueChanged<T?>? onChanged;

  /// Currently selected value
  final T? value;

  /// Hint text when no value is selected
  final String? hint;

  /// Label text above the dropdown
  final String? label;

  /// Validator function for form validation
  final String? Function(T?)? validator;

  /// Whether the dropdown is enabled
  final bool enabled;

  /// Border radius for the dropdown
  final double? borderRadius;

  /// Custom builder for dropdown items
  final Widget Function(BuildContext, T)? itemBuilder;

  /// Function to get display string from item
  final String Function(T)? displayStringForItem;

  /// Icon to show at the start of the field
  final Widget? prefixIcon;

  /// Whether dropdown should expand to fill available width
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveBorderRadius = borderRadius ?? 12.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          CommonText.bodyMedium(
            label!,
            fontWeight: FontWeight.w600,
            color: context.onSurface,
          ),
          const SizedBox(height: 8),
        ],
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: itemBuilder != null
                  ? itemBuilder!(context, item)
                  : CommonText.bodyMedium(
                      displayStringForItem?.call(item) ?? item.toString(),
                      color: context.onSurface,
                    ),
            );
          }).toList(),
          onChanged: enabled ? onChanged : null,
          validator: validator,
          isExpanded: isExpanded,
          hint: hint != null
              ? CommonText.bodyMedium(
                  hint!,
                  color: context.onSurface.withValues(alpha: 0.6),
                )
              : null,
          icon: Icon(
            Icons.expand_more_sharp,
            color: enabled
                ? Color(0xff545454)
                : Color(0xff545454).withValues(alpha: 0.5),
          ),
          isDense: false,
          padding: EdgeInsets.zero,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            filled: true,
            fillColor: enabled
                ? Color(0xff1A1A1A)
                : Color(0xff1A1A1A).withValues(alpha: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
              borderSide: BorderSide(
                color: context.outline.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
              borderSide: BorderSide(
                color: context.outline.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
              borderSide: BorderSide(
                color: context.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
              borderSide: BorderSide(
                color: context.error,
                width: 2.0,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
              borderSide: BorderSide(
                color: context.outline.withValues(alpha: 0.2),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
          ),
          dropdownColor: Color(0xff1A1A1A),
          menuMaxHeight: 300,
        ),
      ],
    );
  }
}
