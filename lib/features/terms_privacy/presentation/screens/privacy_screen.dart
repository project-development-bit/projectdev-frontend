import 'package:gigafaucet/core/common/common_loading_widget.dart';
import 'package:gigafaucet/core/core.dart';
import 'package:gigafaucet/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/terms_privacy_provider.dart';
import '../../../../core/common/webview_wrapper.dart';

class PrivacyScreen extends ConsumerStatefulWidget {
  const PrivacyScreen({super.key});

  @override
  ConsumerState<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends ConsumerState<PrivacyScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch terms and privacy data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(termsPrivacyNotifierProvider.notifier).fetchTermsAndPrivacy();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(termsPrivacyNotifierProvider);

    return SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: _buildBody(state));
  }

  Widget _buildBody(TermsPrivacyState state) {
    return switch (state) {
      TermsPrivacyInitial() => _buildInitialView(),
      TermsPrivacyLoading() => _buildLoadingView(),
      TermsPrivacySuccess(data: final data) => _buildWebView(data.privacyUrl),
      TermsPrivacyError(message: final message) =>
        _buildErrorView(message, Theme.of(context).colorScheme),
    };
  }

  Widget _buildInitialView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildLoadingView() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: CommonLoadingWidget.large(),
      ),
    );
  }

  Widget _buildWebView(String url) {
    return WebViewWrapper(
      useScaffold: false,
      url: url,
      onClose: () => context.pop(),
    );
  }

  Widget _buildErrorView(String message, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: colorScheme.error.withValues(alpha: 700),
            ),
            const SizedBox(height: 16),
            CommonText(
              AppLocalizations.of(context)!
                  .translate("failed_to_load_privacy_policy"),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            CommonText(
              message,
              fontSize: 14,
              color: AppColors.lightTextSecondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref
                    .read(termsPrivacyNotifierProvider.notifier)
                    .fetchTermsAndPrivacy();
              },
              icon: const Icon(Icons.refresh),
              label: CommonText.titleSmall(
                AppLocalizations.of(context)!.translate("retry"),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.pop(),
              child: CommonText.titleSmall(
                AppLocalizations.of(context)!.translate("close"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
