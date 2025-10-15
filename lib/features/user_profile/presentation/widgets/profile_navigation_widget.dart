import 'package:flutter/material.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/extensions/context_extensions.dart';

/// Navigation tabs widget for profile sections
class ProfileNavigationWidget extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int)? onTabSelected;

  const ProfileNavigationWidget({
    super.key,
    required this.tabs,
    this.selectedIndex = 0,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: context.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final title = entry.value;
            final isSelected = index == selectedIndex;
            
            return _buildNavTab(context, title, isSelected, () {
              onTabSelected?.call(index);
            });
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNavTab(
    BuildContext context, 
    String title, 
    bool isSelected, 
    VoidCallback? onTap
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? context.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: CommonText.bodyMedium(
          title,
          color: isSelected ? context.primary : context.onSurface.withOpacity(0.7),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}