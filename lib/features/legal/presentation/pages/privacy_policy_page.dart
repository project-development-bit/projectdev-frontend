import 'package:gigafaucet/core/common/common_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/common/common_container.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../providers/legal_provider.dart';

/// Privacy Policy page
class PrivacyPolicyPage extends ConsumerStatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  ConsumerState<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends ConsumerState<PrivacyPolicyPage> {
  @override
  void initState() {
    super.initState();
    // Load privacy policy when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(legalNotifierProvider.notifier).getPrivacyPolicy();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLegalLoadingProvider);
    final error = ref.watch(legalErrorProvider);
    final document = ref.watch(currentLegalDocumentProvider);

    return Scaffold(
      appBar: AppBar(
        title: CommonText.titleMedium(
          context.translate('privacy_policy'),
          color: context.onSurface,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: context.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: ResponsiveContainer(
        child: _buildBody(context, isLoading, error, document),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, bool isLoading, String? error, dynamic document) {
    if (isLoading) {
      return Center(
        child: CommonLoadingWidget.large(),
      );
    }

    if (error != null) {
      return Center(
        child: CommonContainer(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: context.error,
              ),
              const SizedBox(height: 16),
              CommonText.titleMedium(
                context.translate('error'),
                color: context.error,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 8),
              CommonText.bodyMedium(
                error,
                color: context.onSurfaceVariant,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () =>
                    ref.read(legalNotifierProvider.notifier).getPrivacyPolicy(),
                child: CommonText.bodyMedium(
                  context.translate('retry'),
                  color: context.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (document != null) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: CommonContainer(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              CommonText.headlineSmall(
                document.title,
                color: context.onSurface,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 8),

              // Last updated
              CommonText.bodySmall(
                '${context.translate('last_updated')}: ${_formatDate(document.lastUpdated)}',
                color: context.onSurfaceVariant,
              ),
              const SizedBox(height: 8),

              // Version
              CommonText.bodySmall(
                '${context.translate('version')}: ${document.version}',
                color: context.onSurfaceVariant,
              ),
              const SizedBox(height: 24),

              // Content
              CommonText.bodyMedium(
                document.content,
                color: context.onSurface,
              ),

              // Sections (if any)
              if (document.sections.isNotEmpty) ...[
                const SizedBox(height: 32),
                for (final section in document.sections) ...[
                  CommonText.titleMedium(
                    section.title,
                    color: context.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 12),
                  CommonText.bodyMedium(
                    section.content,
                    color: context.onSurface,
                  ),
                  const SizedBox(height: 24),
                ],
              ],
            ],
          ),
        ),
      );
    }

    return Center(
      child: CommonText.bodyMedium(
        context.translate('no_data_available'),
        color: context.onSurfaceVariant,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
