import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../extensions/context_extensions.dart';
import 'common_textfield.dart';

/// A responsive wrapper around CommonTextField that adapts to different screen sizes
class ResponsiveTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final String? helperText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;

  const ResponsiveTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.errorText,
    this.helperText,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.onEditingComplete,
    this.validator,
    this.inputFormatters,
    this.focusNode,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: context.isMobile
            ? double.infinity
            : context.isTablet
                ? 500
                : 400,
      ),
      child: CommonTextField(
        hintText: hintText,
        labelText: labelText,
        errorText: errorText,
        helperText: helperText,
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        enabled: enabled,
        readOnly: readOnly,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        prefixText: prefixText,
        suffixText: suffixText,
        onChanged: onChanged,
        onTap: onTap,
        onSubmitted: onSubmitted,
        onEditingComplete: onEditingComplete,
        validator: validator,
        inputFormatters: inputFormatters,
        focusNode: focusNode,
        autofocus: autofocus,
        textCapitalization: textCapitalization,
        textAlign: textAlign,
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.isMobile ? 16 : 20,
          vertical: context.isMobile ? 16 : 18,
        ),
        borderRadius: context.isMobile ? 8.0 : 12.0,
      ),
    );
  }
}
