import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/common/common_textfield.dart';
import 'package:gigafaucet/core/common/custom_buttom_widget.dart';
import 'package:gigafaucet/core/common/dialog_bg_widget.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:gigafaucet/features/user_profile/presentation/providers/change_password_notifier.dart';
import 'package:gigafaucet/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

showChangePasswordDialog(BuildContext context) {
  context.showManagePopup(
    // height: context.isMobile ? 550 : 450,
    child: const ChangePasswordDialog(),
    barrierDismissible: false,
    //
  );
}

class ChangePasswordDialog extends ConsumerStatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  ConsumerState<ChangePasswordDialog> createState() =>
      _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends ConsumerState<ChangePasswordDialog> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _repeatNewPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isRepeatPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    ref.listenManual(changePasswordNotifierProvider, (previous, next) async {
      if (next.isChanging) return;
      if (next.status == ChangePasswordStatus.success) {
        if (mounted && context.mounted) {
          context.showSuccessSnackBar(
              message: context.translate('password_changed_successfully'));

          if (mounted) {
            context.pop(); // close dialog
          }
        }
      } else if (next.status == ChangePasswordStatus.failure) {
        // Show error message
        if (mounted && context.mounted) {
          context.showSnackBar(
            message: next.errorMessage ??
                context.translate('failed_to_change_password'),
            backgroundColor: context.error,
            textColor: Colors.white,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _repeatNewPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    // Validate form
    if (_formKey.currentState?.validate() ?? false) {
      final currentPassword = _currentPasswordController.text.trim();
      final newPassword = _newPasswordController.text.trim();
      final repeatNewPassword = _repeatNewPasswordController.text.trim();

      // Call change password API
      ref.read(changePasswordNotifierProvider.notifier).changePassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
            repeatNewPassword: repeatNewPassword,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(changePasswordNotifierProvider).isChanging;
    double dialogHeight = context.isDesktop
        ? 450
        : context.isTablet
            ? 450
            : 500;
    return DialogBgWidget(
        dialogHeight: dialogHeight,
        isOverlayLoading: isLoading,
        title: context.translate("change_your_password"),
        body: _dialogBgWidget(isLoading: isLoading));
  }

  Widget _dialogBgWidget({required bool isLoading}) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: context.isDesktop
              ? const EdgeInsets.symmetric(horizontal: 31, vertical: 16)
              : const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonText.bodyMedium(
                context.translate("change_password_description"),
              ),
              context.isDesktop
                  ? const SizedBox(height: 24)
                  : const SizedBox(height: 32),
              if (context.isMobile || context.isTablet) ...[
                // Current Password
                CommonText.bodyMedium(
                  context.translate("current_password"),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                CommonTextField(
                  controller: _currentPasswordController,
                  hintText: context.translate("enter_current_password"),
                  obscureText: !_isCurrentPasswordVisible,
                  enabled: !isLoading,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isCurrentPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.translate('current_password_required');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // New Password
                CommonText.bodyMedium(
                  context.translate("new_password"),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                CommonTextField(
                  controller: _newPasswordController,
                  hintText: context.translate("enter_new_password"),
                  obscureText: !_isNewPasswordVisible,
                  enabled: !isLoading,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isNewPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.translate('new_password_required');
                    }
                    if (value.trim().length < 8) {
                      return context.translate('password_too_short');
                    }
                    return null;
                  },
                ),
                context.isDesktop
                    ? const SizedBox(height: 24)
                    : const SizedBox(height: 32),

                // Repeat New Password
                CommonText.bodyMedium(
                  context.translate("repeat_new_password"),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                CommonTextField(
                  controller: _repeatNewPasswordController,
                  hintText: context.translate("enter_repeat_new_password"),
                  obscureText: !_isRepeatPasswordVisible,
                  enabled: !isLoading,
                  onSubmitted: (_) => _handleSubmit(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isRepeatPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isRepeatPasswordVisible = !_isRepeatPasswordVisible;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.translate('repeat_password_required');
                    }
                    if (value != _newPasswordController.text) {
                      return context.translate('passwords_do_not_match');
                    }
                    return null;
                  },
                ),
              ] else ...[
                // Desktop layout - Current Password
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 180,
                      child: CommonText.bodyLarge(
                        context.translate("current_password"),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommonTextField(
                        controller: _currentPasswordController,
                        hintText: context.translate("enter_current_password"),
                        obscureText: !_isCurrentPasswordVisible,
                        enabled: !isLoading,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isCurrentPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isCurrentPasswordVisible =
                                  !_isCurrentPasswordVisible;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context
                                .translate('current_password_required');
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                context.isDesktop
                    ? const SizedBox(height: 24)
                    : const SizedBox(height: 32),

                // Desktop layout - New Password
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 180,
                      child: CommonText.bodyLarge(
                        context.translate("new_password"),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommonTextField(
                        controller: _newPasswordController,
                        hintText: context.translate("enter_new_password"),
                        obscureText: !_isNewPasswordVisible,
                        enabled: !isLoading,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isNewPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isNewPasswordVisible = !_isNewPasswordVisible;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context.translate('new_password_required');
                          }
                          if (value.trim().length < 8) {
                            return context.translate('password_too_short');
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                context.isDesktop
                    ? const SizedBox(height: 24)
                    : const SizedBox(height: 32),

                // Desktop layout - Repeat New Password
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 180,
                      child: CommonText.bodyLarge(
                        context.translate("repeat_new_password"),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommonTextField(
                        controller: _repeatNewPasswordController,
                        hintText:
                            context.translate("enter_repeat_new_password"),
                        obscureText: !_isRepeatPasswordVisible,
                        enabled: !isLoading,
                        onSubmitted: (_) => _handleSubmit(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isRepeatPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isRepeatPasswordVisible =
                                  !_isRepeatPasswordVisible;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context
                                .translate('repeat_password_required');
                          }
                          if (value != _newPasswordController.text) {
                            return context.translate('passwords_do_not_match');
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              Center(
                  child: CustomUnderLineButtonWidget(
                title: context.translate('change_password_btn_text'),
                fontSize: 14,
                isDark: true,
                width: context.isDesktop ? 250 : double.infinity,
                fontWeight: FontWeight.w700,
                onTap: isLoading ? null : _handleSubmit,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
