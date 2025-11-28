import 'package:cointiply_app/core/common/common_button.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/common_textfield.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/change_name_notifier.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/get_profile_notifier.dart';
import 'package:cointiply_app/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

showChangeNameDialog(BuildContext context) {
  context.showManagePopup(
    height: context.isMobile ? 320 : 280,
    barrierDismissible: false,
    child: ChangeNameDialog(),
    title: context.translate("change_your_name"),
  );
}

class ChangeNameDialog extends ConsumerStatefulWidget {
  const ChangeNameDialog({super.key});

  @override
  ConsumerState<ChangeNameDialog> createState() => _ChangeNameDialogState();
}

class _ChangeNameDialogState extends ConsumerState<ChangeNameDialog> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userName = ref.read(currentUserProvider).user?.name ?? '';
      _nameController.text = userName;
    });

    ref.listenManual(changeNameNotifierProvider, (previous, next) {
      if (next.isChanging) return;
      if (next.status == ChangeNameStatus.success) {
        if (mounted && context.mounted) {
          context.showSnackBar(
            message: context.translate('name_changed_successfully'),
            textColor: Colors.white,
          );
          context.pop(); // close dialog
          ref
              .read(getProfileNotifierProvider.notifier)
              .fetchProfile(isLoading: false); // refresh profile
          ref
              .read(currentUserProvider.notifier)
              .getCurrentUser(); // refresh current user
        }
      } else if (next.status == ChangeNameStatus.failure) {
        // Show error message
        if (mounted && context.mounted) {
          context.showSnackBar(
            message:
                next.errorMessage ?? context.translate('failed_to_change_name'),
            backgroundColor: context.error,
            textColor: Colors.white,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    // Validate form
    if (_formKey.currentState?.validate() ?? false) {
      final newName = _nameController.text.trim();
      final currentName = ref.read(currentUserProvider).user?.name ?? '';

      // Check if name has changed
      if (newName == currentName) {
        context.showSnackBar(
          message: context.translate('name_unchanged'),
          backgroundColor: context.error,
          textColor: Colors.white,
        );
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.translate('name_unchanged')),
            backgroundColor: context.error,
          ),
        );
        return;
      }

      // Get user ID
      final userId = ref.read(currentUserProvider).user?.id.toString() ?? '';
      if (userId.isEmpty) {
        context.showSnackBar(
          message: context.translate('user_not_found'),
          backgroundColor: context.error,
          textColor: Colors.white,
        );
        return;
      }

      // Call change name API
      ref.read(changeNameNotifierProvider.notifier).changeName(
            userId,
            newName,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(changeNameNotifierProvider).isChanging;
    return _dialogBgWidget(isLoading: isLoading);
  }

  Widget _dialogBgWidget({required bool isLoading}) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (context.isMobile) ...[
                CommonText.bodyMedium(context.translate("new_name")),
                const SizedBox(height: 8),
                CommonTextField(
                  controller: _nameController,
                  hintText: context.translate("enter_your_name"),
                  enabled: !isLoading,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.translate('name_required');
                    }
                    if (value.trim().length < 5) {
                      return context.translate('name_too_short');
                    }
                    if (value.trim().length > 50) {
                      return context.translate('name_too_long');
                    }
                    return null;
                  },
                ),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      child:
                          CommonText.bodyMedium(context.translate("new_name")),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommonTextField(
                        controller: _nameController,
                        hintText: context.translate("enter_your_name"),
                        enabled: !isLoading,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context.translate('name_required');
                          }
                          if (value.trim().length < 5) {
                            return context.translate('name_too_short');
                          }
                          if (value.trim().length > 50) {
                            return context.translate('name_too_long');
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              Center(
                child: CommonButton(
                  backgroundColor: Color(0xff333333),
                  text: context.translate('change_name_btn_text'),
                  onPressed: isLoading ? null : _handleSubmit,
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
