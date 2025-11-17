import 'package:flutter/material.dart';

class HomeBannerSection extends StatelessWidget {
  const HomeBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 350,
      child: Image.asset(
        'assets/images/bg/test_banner.png',
        width: double.infinity,
        height: 350,
        fit: BoxFit.cover,
      ),
    );
  }
}