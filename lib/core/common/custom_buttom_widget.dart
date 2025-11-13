import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  final bool isActive;
  const CustomButtonWidget({
    super.key,
    required this.title,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 305, // Figma width
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 17,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              if (isActive) Color(0xFFFFCC02) else Color(0xFF333333),
              if (isActive) Color(0xFFFFCC02) else Color(0xFF333333),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border(
            bottom: BorderSide(
              color: isActive ? Color(0xFFB28F0C) : Color(0xFF262626),
              width: 5,
            ),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              // color: Color(0xFF2A2A2A),
              color: isActive ? Color(0xFF2A2A2A) : Color(0xFF98989A),
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
