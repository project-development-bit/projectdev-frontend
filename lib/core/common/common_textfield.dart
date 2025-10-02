import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../localization/app_localizations.dart';

class CommonTextField extends StatefulWidget {
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
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? disabledBorder;
  final Color? fillColor;
  final bool filled;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
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
  final FloatingLabelBehavior? floatingLabelBehavior;
  final double? borderRadius;
  final Color? borderColor;
  final double? borderWidth;

  const CommonTextField({
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
    this.contentPadding,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.disabledBorder,
    this.fillColor,
    this.filled = true,
    this.style,
    this.hintStyle,
    this.labelStyle,
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
    this.floatingLabelBehavior,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: _obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      onFieldSubmitted: widget.onSubmitted,
      onEditingComplete: widget.onEditingComplete,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      textCapitalization: widget.textCapitalization,
      textAlign: widget.textAlign,
      style: widget.style ?? theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        errorText: widget.errorText,
        helperText: widget.helperText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onPressed: _toggleObscureText,
              )
            : widget.suffixIcon,
        prefixText: widget.prefixText,
        suffixText: widget.suffixText,
        contentPadding: widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: widget.border ?? _defaultBorder(),
        enabledBorder: widget.enabledBorder ?? _defaultEnabledBorder(),
        focusedBorder: widget.focusedBorder ?? _defaultFocusedBorder(),
        errorBorder: widget.errorBorder ?? _defaultErrorBorder(),
        disabledBorder: widget.disabledBorder ?? _defaultDisabledBorder(),
        fillColor: widget.fillColor ?? theme.colorScheme.surfaceContainerHighest.withAlpha(25),
        filled: widget.filled,
        hintStyle: widget.hintStyle ??
            theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withAlpha(140),
            ),
        labelStyle: widget.labelStyle ??
            theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
        floatingLabelBehavior: widget.floatingLabelBehavior ?? FloatingLabelBehavior.auto,
      ),
    );
  }

  OutlineInputBorder _defaultBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0),
      borderSide: BorderSide(
        color: widget.borderColor ?? Theme.of(context).colorScheme.outline,
        width: widget.borderWidth ?? 1.0,
      ),
    );
  }

  OutlineInputBorder _defaultEnabledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0),
      borderSide: BorderSide(
        color: widget.borderColor ?? Theme.of(context).colorScheme.outline,
        width: widget.borderWidth ?? 1.0,
      ),
    );
  }

  OutlineInputBorder _defaultFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
        width: (widget.borderWidth ?? 1.0) + 1.0,
      ),
    );
  }

  OutlineInputBorder _defaultErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.error,
        width: (widget.borderWidth ?? 1.0) + 1.0,
      ),
    );
  }

  OutlineInputBorder _defaultDisabledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.outline.withAlpha(85),
        width: widget.borderWidth ?? 1.0,
      ),
    );
  }
}

// Common validation functions
class TextFieldValidators {
  static String? email(String? value, BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return localizations?.translate('email_required') ?? 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return localizations?.translate('email_invalid') ?? 'Please enter a valid email address';
    }
    return null;
  }

  static String? password(String? value, BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return localizations?.translate('password_required') ?? 'Password is required';
    }
    if (value.length < 8) {
      return localizations?.translate('password_min_length', args: ['8']) ?? 'Password must be at least 8 characters long';
    }
    return null;
  }

  static String? required(String? value, BuildContext context, {String? fieldName}) {
    final localizations = AppLocalizations.of(context);
    if (value == null || value.trim().isEmpty) {
      if (fieldName != null) {
        return localizations?.translate('field_required', args: [fieldName]) ?? '$fieldName is required';
      }
      return localizations?.translate('field_required', args: ['This field']) ?? 'This field is required';
    }
    return null;
  }

  static String? minLength(String? value, int minLength, BuildContext context, {String? fieldName}) {
    final localizations = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      if (fieldName != null) {
        return localizations?.translate('field_required', args: [fieldName]) ?? '$fieldName is required';
      }
      return localizations?.translate('field_required', args: ['This field']) ?? 'This field is required';
    }
    if (value.length < minLength) {
      if (fieldName != null) {
        return localizations?.translate('password_min_length', args: [minLength.toString()]) ?? '$fieldName must be at least $minLength characters long';
      }
      return localizations?.translate('password_min_length', args: [minLength.toString()]) ?? 'This field must be at least $minLength characters long';
    }
    return null;
  }

  static String? maxLength(String? value, int maxLength, BuildContext context, {String? fieldName}) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? 'This field'} must not exceed $maxLength characters';
    }
    return null;
  }

  static String? phoneNumber(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    if (!phoneRegex.hasMatch(value) || value.length < 10) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? numeric(String? value, BuildContext context, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    if (double.tryParse(value) == null) {
      return '${fieldName ?? 'This field'} must be a valid number';
    }
    return null;
  }
}

// Common input formatters
class TextFieldFormatters {
  static List<TextInputFormatter> phoneNumber() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(15),
    ];
  }

  static List<TextInputFormatter> alphaNumeric() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
    ];
  }

  static List<TextInputFormatter> lettersOnly() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
    ];
  }

  static List<TextInputFormatter> numbersOnly() {
    return [
      FilteringTextInputFormatter.digitsOnly,
    ];
  }

  static List<TextInputFormatter> decimal() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
    ];
  }

  static List<TextInputFormatter> maxLength(int length) {
    return [
      LengthLimitingTextInputFormatter(length),
    ];
  }
}
