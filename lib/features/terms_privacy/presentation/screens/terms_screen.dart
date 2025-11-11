import 'package:cointiply_app/core/localization/app_localizations.dart';
import 'package:cointiply_app/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/common_text.dart';
import '../providers/terms_privacy_provider.dart';
import '../../../../core/common/webview_wrapper.dart';

class TermsScreen extends ConsumerStatefulWidget {
  const TermsScreen({super.key});

  @override
  ConsumerState<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends ConsumerState<TermsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(termsPrivacyNotifierProvider.notifier).fetchTermsAndPrivacy();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(termsPrivacyNotifierProvider);

    return Scaffold(
      body: _buildBody(state),
    );
  }

  Widget _buildBody(TermsPrivacyState state) {
    return switch (state) {
      TermsPrivacyInitial() => _buildInitialView(),
      TermsPrivacyLoading() => _buildLoadingView(),
      TermsPrivacySuccess(data: final data) => _buildWebView(data.termsUrl),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            CommonText(
              AppLocalizations.of(context)!
                  .translate("loading_terms_of_service"),
              fontSize: 16,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebView(String url) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: true,
              child: WebViewWrapper(
                useScaffold: false,
                url: url,
                onClose: () => context.pop(),
              ),
            ),
          ],
        );
      },
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
              color: colorScheme.error.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            CommonText(
              AppLocalizations.of(context)!.translate("failed_to_load_terms"),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            CommonText(
              message,
              fontSize: 14,
              color: colorScheme.tertiaryFixed.withValues(alpha: 0.7),
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
                color: colorScheme.onError,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.pop(),
              child: CommonText.titleSmall(
                  AppLocalizations.of(context)!.translate("close")),
            ),
          ],
        ),
      ),
    );
  }
}
