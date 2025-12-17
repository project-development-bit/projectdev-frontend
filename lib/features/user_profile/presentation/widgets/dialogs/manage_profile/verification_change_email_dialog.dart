import 'package:gigafaucet/core/common/dialog_bg_widget.dart';
import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:gigafaucet/features/auth/presentation/providers/verification_provider.dart';
import 'package:gigafaucet/features/auth/presentation/widgets/verification_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

showVerificationChangeEmailDialog(BuildContext context, String email) {
  context.showManagePopup(
    // height: context.isDesktop ? 600 : context.mediaQuery.size.height * 0.9,
    child: VerificationChangeEmailDialog(email: email),
    // title: context.translate("verify_new_email")
  );
}

class VerificationChangeEmailDialog extends ConsumerWidget {
  final String email;
  const VerificationChangeEmailDialog({super.key, required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading =
        ref.watch(verificationNotifierProvider) is VerificationLoading;
    return DialogBgWidget(
      isOverlayLoading: isLoading,
      dialogHeight:
          context.isDesktop ? 600 : context.mediaQuery.size.height * 0.9,
      title: context.translate("verify_new_email"),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: _bodyWidget()),
      ),
    );
  }

  Widget _bodyWidget() {
    return VerificationFormWidget(email: email, isFromEmailChanged: true);
  }
}
