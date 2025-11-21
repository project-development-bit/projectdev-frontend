import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/extensions/context_extensions.dart';

class VerificationCodeInput extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;

  const VerificationCodeInput({
    super.key,
    required this.controller,
    this.enabled = true,
    this.onCompleted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: context.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: enabled ? context.onSurface : context.onSurface.withAlpha(128),
      ),
      decoration: BoxDecoration(
        color: enabled ? context.surface : context.surface.withAlpha(128),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.outline.withAlpha(77),
          width: 1,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: context.primary,
        width: 2,
      ),
    );

    final disabledPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: context.outline.withAlpha(77),
        width: 1,
      ),
      color: context.outline.withAlpha(128),
    );

    return Pinput(
      length: 4,
      controller: controller,
      enabled: enabled,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      disabledPinTheme: disabledPinTheme,
      onCompleted: onCompleted,
      onChanged: onChanged,
      keyboardType: TextInputType.number,
      inputFormatters: const [],
    );
  }
}
