import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/settings/profile_security_settings.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/settings/profile_setting_details.dart';
import 'package:flutter/material.dart';

class ProfileSettingsSection extends StatelessWidget {
  const ProfileSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSection(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          ProfileSettingDetails(),
          SizedBox(height: context.isMobile ? 16 : 24),
          ProfileSecuritySettings(),
        ],
      ),
    );
  }
}
