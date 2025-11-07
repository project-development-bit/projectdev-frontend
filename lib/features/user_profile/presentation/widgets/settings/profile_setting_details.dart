import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';

class ProfileSettingDetails extends StatefulWidget {
  const ProfileSettingDetails({super.key});

  @override
  State<ProfileSettingDetails> createState() => _ProfileSettingDetailsState();
}

class _ProfileSettingDetailsState extends State<ProfileSettingDetails> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  final TextEditingController _usernameCtrl = TextEditingController();

  bool enableInterest = false;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _usernameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = context.isMobile;

    return ResponsiveSection(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withAlpha(100),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Title ─────────────────────────────
                  CommonText.titleLarge(
                    localizations?.translate("profile_settings_title") ??
                        "Profile Details",
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 24),
                  // ─── Avatar ─────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: CommonText.titleLarge(
                              "AU",
                              color: colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        CommonText.bodyMedium(
                          localizations?.translate("profile_avatar") ??
                              "Avatar",
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ─── Full Name ─────────────────────────────
                  CommonText.bodyMedium(
                    "${localizations?.translate("profile_full_name") ?? "Full Name"} *",
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 8),

                  if (isMobile)
                    Column(
                      children: [
                        CommonTextField(
                          controller: _firstNameCtrl,
                          hintText:
                              localizations?.translate("profile_first_name") ??
                                  "First name",
                          labelText:
                              localizations?.translate("profile_first_name") ??
                                  "First name",
                          textInputAction: TextInputAction.next,
                          validator: (value) => TextFieldValidators.required(
                              value, context,
                              fieldName: localizations
                                      ?.translate("profile_first_name") ??
                                  "First name"),
                        ),
                        const SizedBox(height: 12),
                        CommonTextField(
                          controller: _lastNameCtrl,
                          hintText:
                              localizations?.translate("profile_last_name") ??
                                  "Last name",
                          labelText:
                              localizations?.translate("profile_last_name") ??
                                  "Last name",
                          textInputAction: TextInputAction.next,
                          validator: (value) => TextFieldValidators.required(
                              value, context,
                              fieldName: localizations
                                      ?.translate("profile_last_name") ??
                                  "Last name"),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: CommonTextField(
                            controller: _firstNameCtrl,
                            hintText: localizations
                                    ?.translate("profile_first_name") ??
                                "First name",
                            labelText: localizations
                                    ?.translate("profile_first_name") ??
                                "First name",
                            textInputAction: TextInputAction.next,
                            validator: (value) => TextFieldValidators.required(
                                value, context,
                                fieldName: localizations
                                        ?.translate("profile_first_name") ??
                                    "First name"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CommonTextField(
                            controller: _lastNameCtrl,
                            hintText:
                                localizations?.translate("profile_last_name") ??
                                    "Last name",
                            labelText:
                                localizations?.translate("profile_last_name") ??
                                    "Last name",
                            textInputAction: TextInputAction.next,
                            validator: (value) => TextFieldValidators.required(
                                value, context,
                                fieldName: localizations
                                        ?.translate("profile_last_name") ??
                                    "Last name"),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 24),

                  // ─── Username ─────────────────────────────
                  CommonText.bodyMedium(
                    "${localizations?.translate("profile_username") ?? "Username"} *",
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 8),

                  CommonTextField(
                    controller: _usernameCtrl,
                    hintText: localizations?.translate("profile_username") ??
                        "Username",
                    labelText: localizations?.translate("profile_username") ??
                        "Username",
                    textInputAction: TextInputAction.done,
                    validator: (value) => TextFieldValidators.minLength(
                        value, 4, context,
                        fieldName:
                            localizations?.translate("profile_username") ??
                                "Username"),
                  ),

                  const SizedBox(height: 8),

                  CommonText.bodySmall(
                    localizations?.translate("profile_username_note") ??
                        "Your username can only be changed once every 30 days.",
                    color: colorScheme.onSurfaceVariant,
                  ),

                  const SizedBox(height: 24),

                  // ─── Enable 5% Interest ───────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CommonText.bodyMedium(
                          "${localizations?.translate("profile_interest_label") ?? "Enable 5% Interest"} *",
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Switch(
                        value: enableInterest,
                        onChanged: (value) =>
                            setState(() => enableInterest = value),
                        inactiveTrackColor: colorScheme.surfaceContainerHigh,
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  CommonText.bodySmall(
                    localizations?.translate("profile_interest_description") ??
                        "Your account will earn 5% interest when you have more than 35,000 Coins. Interest is paid weekly.",
                    color: colorScheme.onSurfaceVariant,
                  ),

                  const SizedBox(height: 32),

                  // ─── Buttons ─────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colorScheme.outline),
                          foregroundColor: colorScheme.onSurfaceVariant,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                        onPressed: () {
                          // TODO: discard
                        },
                        child: CommonText.bodyMedium(
                          localizations?.translate("btn_discard") ?? "Discard",
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // TODO: save profile
                          }
                        },
                        child: CommonText.bodyMedium(
                          localizations?.translate("btn_save_changes") ??
                              "Save Changes",
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
