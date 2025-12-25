import 'package:gigafaucet/core/common/common_text.dart';
import 'package:flutter/material.dart';

class RememberMeWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  const RememberMeWidget({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: (checked) => onChanged(checked ?? false),
            activeColor: colorScheme.primary,
            side: BorderSide(color: colorScheme.onSurfaceVariant),
          ),
          CommonText.bodyMedium(
            label,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.ellipsis,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
