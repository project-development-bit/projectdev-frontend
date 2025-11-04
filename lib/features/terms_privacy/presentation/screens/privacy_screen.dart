import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/common_text.dart';
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

    return Scaffold(
      body: _buildBody(state),
    );
  }

  Widget _buildBody(TermsPrivacyState state) {
    return switch (state) {
      TermsPrivacyInitial() => _buildInitialView(),
      TermsPrivacyLoading() => _buildLoadingView(),
      TermsPrivacySuccess(data: final data) => _buildWebView(data.privacyUrl),
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
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            CommonText(
              'Loading Privacy Policy...',
              fontSize: 16,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebView(String url) {
    return WebViewWrapper(
      url: url,
      title: 'Privacy Policy',
      onClose: () => Navigator.of(context).pop(),
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
            const CommonText(
              'Failed to Load Privacy Policy',
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
              label: const Text('Retry'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
