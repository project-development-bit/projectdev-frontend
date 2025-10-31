import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/app_localizations.dart';
import '../providers/current_user_provider.dart';
import 'current_user_info_widget.dart';

/// Profile section widget for displaying current user information
/// Integrates with the existing profile system design
class CurrentUserSectionWidget extends ConsumerWidget {
  const CurrentUserSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, localizations),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: CurrentUserInfoWidget(
              autoRefresh: false,
              showLoading: true,
              decoration: null,
              padding: EdgeInsets.zero,
            ),
          ),
          _buildActions(context, ref, localizations),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations? localizations) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.account_circle,
              color: context.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText.titleMedium(
                localizations?.translate('account_information') ?? 'Account Information',
                fontWeight: FontWeight.w600,
                color: context.onSurface,
              ),
              const SizedBox(height: 2),
              CommonText.bodySmall(
                localizations?.translate('authenticated_user_details') ?? 'Your authenticated user details',
                color: context.onSurface.withOpacity(0.7),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref, AppLocalizations? localizations) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => ref.read(currentUserProvider.notifier).refreshUser(),
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(localizations?.translate('refresh') ?? 'Refresh'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showUserDetails(context, ref),
              icon: const Icon(Icons.info_outline, size: 18),
              label: Text(localizations?.translate('details') ?? 'Details'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUserDetails(BuildContext context, WidgetRef ref) {
    final user = ref.read(profileCurrentUserProvider);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user data available')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Text(
                        'User Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    child: CurrentUserInfoWidget(
                      autoRefresh: false,
                      showLoading: false,
                      decoration: BoxDecoration(
                        color: context.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: context.outline.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}