import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:cointiply_app/core/localization/app_localizations.dart';
import 'package:cointiply_app/features/common/widgets/build_app_bar_title.dart';
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
      TermsPrivacyError(message: final message) => _buildErrorView(message),
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
            SliverAppBar(
              expandedHeight: 80.0,
              floating: true,
              pinned: true,
              snap: false,
              backgroundColor: context.surface.withAlpha(242),
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 1,
              automaticallyImplyLeading:
                  MediaQuery.of(context).size.width < 768,
              title: const CommonAppBar(),
              titleSpacing: 16,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        context.surface.withAlpha(250),
                        context.surface.withAlpha(235),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: true,
              child: WebViewWrapper(
                useScaffold: false,
                url: url,
                onClose: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorView(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
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
              color: Colors.grey[600],
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
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: CommonText.titleSmall(
                  AppLocalizations.of(context)!.translate("close")),
            ),
          ],
        ),
      ),
    );
  }
}
