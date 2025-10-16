import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/extensions/context_extensions.dart';

/// A widget for entering a 4-digit verification code
class VerificationCodeInput extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final void Function(int index, String value) onChanged;
  final bool enabled;

  const VerificationCodeInput({
    super.key,
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
    this.enabled = true,
  }) : assert(controllers.length == 4, 'Must have exactly 4 controllers'),
       assert(focusNodes.length == 4, 'Must have exactly 4 focus nodes');

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return _CodeInputField(
          controller: controllers[index],
          focusNode: focusNodes[index],
          onChanged: (value) => onChanged(index, value),
          enabled: enabled,
        );
      }),
    );
  }
}

/// Individual code input field
class _CodeInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String) onChanged;
  final bool enabled;

  const _CodeInputField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: focusNode.hasFocus 
              ? context.primary 
              : context.outline.withAlpha(77), // 0.3 * 255 = 77
          width: focusNode.hasFocus ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: enabled 
            ? context.surface 
            : context.surface.withAlpha(128), // 0.5 * 255 = 128
      ),
      child: Center(
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          textAlign: TextAlign.center,
          style: context.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: enabled 
                ? context.onSurface 
                : context.onSurface.withAlpha(128), // 0.5 * 255 = 128
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
          ),
          onChanged: (value) {
            onChanged(value);
          },
          onTap: () {
            // Select all text when tapped
            controller.selection = TextSelection(
              baseOffset: 0,
              extentOffset: controller.text.length,
            );
          },
        ),
      ),
    );
  }
}