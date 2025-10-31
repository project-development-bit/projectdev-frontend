import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../auth/domain/entities/user.dart';
import '../providers/current_user_provider.dart';

/// Widget to display current user information in profile context
/// Integrated with the user_profile feature for displaying whoami API data
class CurrentUserInfoWidget extends ConsumerStatefulWidget {
  /// Whether to auto-refresh user data when widget is initialized
  final bool autoRefresh;
  
  /// Whether to show loading indicators
  final bool showLoading;
  
  /// Custom styling for the container
  final BoxDecoration? decoration;
  
  /// Padding for the content
  final EdgeInsets? padding;

  /// Whether to show compact view (for use in headers)
  final bool isCompact;

  const CurrentUserInfoWidget({
    super.key,
    this.autoRefresh = true,
    this.showLoading = true,
    this.decoration,
    this.padding,
    this.isCompact = false,
  });

  @override
  ConsumerState<CurrentUserInfoWidget> createState() => _CurrentUserInfoWidgetState();
}

class _CurrentUserInfoWidgetState extends ConsumerState<CurrentUserInfoWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.autoRefresh) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Only initialize user if authenticated
        final isAuthenticated = ref.read(isAuthenticatedObservableProvider);
        if (isAuthenticated) {
          ref.read(currentUserProvider.notifier).initializeUser();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(currentUserProvider);
    final localizations = AppLocalizations.of(context);

    return Container(
      decoration: widget.decoration ??
          BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.outline.withOpacity(0.3)),
          ),
      padding: widget.padding ?? const EdgeInsets.all(16),
      child: _buildContent(context, userState, localizations),
    );
  }

  Widget _buildContent(BuildContext context, CurrentUserState userState, AppLocalizations? localizations) {
    if (userState.isLoading && widget.showLoading) {
      return _buildLoadingState(context, localizations);
    }

    if (userState.error != null) {
      return _buildErrorState(context, userState.error!, localizations);
    }

    if (userState.user != null) {
      return _buildUserInfo(context, userState.user!, localizations);
    }

    return _buildEmptyState(context, localizations);
  }

  Widget _buildLoadingState(BuildContext context, AppLocalizations? localizations) {
    if (widget.isCompact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          CommonText.bodySmall(
            localizations?.translate('loading_user_info') ?? 'Loading...',
            color: context.onSurface.withOpacity(0.7),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 12),
        CommonText.bodyMedium(
          localizations?.translate('loading_user_info') ?? 'Loading user information...',
          textAlign: TextAlign.center,
          color: context.onSurface.withOpacity(0.7),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String error, AppLocalizations? localizations) {
    if (widget.isCompact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: context.error,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CommonText.bodySmall(
              'Error loading user',
              color: context.error,
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline,
          color: context.error,
          size: 48,
        ),
        const SizedBox(height: 12),
        CommonText.bodyMedium(
          error,
          textAlign: TextAlign.center,
          color: context.error,
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => ref.read(currentUserProvider.notifier).getCurrentUser(),
          child: Text(localizations?.translate('retry') ?? 'Retry'),
        ),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context, User user, AppLocalizations? localizations) {
    if (widget.isCompact) {
      return _buildCompactUserInfo(context, user, localizations);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildUserHeader(context, user, localizations),
        const SizedBox(height: 16),
        _buildUserDetails(context, user, localizations),
      ],
    );
  }

  Widget _buildCompactUserInfo(BuildContext context, User user, AppLocalizations? localizations) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: context.primary,
          child: CommonText.bodySmall(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
            color: context.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonText.bodyMedium(
                user.name.isEmpty ? localizations?.translate('unnamed_user') ?? 'User' : user.name,
                fontWeight: FontWeight.w600,
                color: context.onSurface,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              CommonText.bodySmall(
                user.email,
                color: context.onSurface.withOpacity(0.7),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        _buildVerificationBadge(context, user, localizations, compact: true),
      ],
    );
  }

  Widget _buildUserHeader(BuildContext context, User user, AppLocalizations? localizations) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: context.primary,
          child: CommonText.titleLarge(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
            color: context.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText.titleMedium(
                user.name.isEmpty ? localizations?.translate('unnamed_user') ?? 'Unnamed User' : user.name,
                fontWeight: FontWeight.w600,
                color: context.onSurface,
              ),
              const SizedBox(height: 2),
              CommonText.bodySmall(
                user.email,
                color: context.onSurface.withOpacity(0.7),
              ),
            ],
          ),
        ),
        _buildVerificationBadge(context, user, localizations),
      ],
    );
  }

  Widget _buildVerificationBadge(BuildContext context, User user, AppLocalizations? localizations, {bool compact = false}) {
    final isVerified = user.isUserVerified;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 8, vertical: compact ? 2 : 4),
      decoration: BoxDecoration(
        color: isVerified ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(compact ? 8 : 12),
        border: Border.all(
          color: isVerified ? Colors.green : Colors.orange,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVerified ? Icons.verified : Icons.warning,
            size: compact ? 12 : 14,
            color: isVerified ? Colors.green : Colors.orange,
          ),
          SizedBox(width: compact ? 2 : 4),
          CommonText.bodySmall(
            isVerified 
                ? localizations?.translate('verified') ?? 'Verified'
                : localizations?.translate('unverified') ?? 'Unverified',
            color: isVerified ? Colors.green : Colors.orange,
            fontWeight: FontWeight.w500,
            fontSize: compact ? 10 : null,
          ),
        ],
      ),
    );
  }

  Widget _buildUserDetails(BuildContext context, User user, AppLocalizations? localizations) {
    return Column(
      children: [
        _buildDetailRow(
          context,
          Icons.badge,
          localizations?.translate('user_role') ?? 'Role',
          user.role.name.toUpperCase(),
        ),
        if (user.country?.isNotEmpty == true) ...[
          const SizedBox(height: 8),
          _buildDetailRow(
            context,
            Icons.public,
            localizations?.translate('country') ?? 'Country',
            user.country!,
          ),
        ],
        if (user.language?.isNotEmpty == true) ...[
          const SizedBox(height: 8),
          _buildDetailRow(
            context,
            Icons.language,
            localizations?.translate('language') ?? 'Language',
            user.language!.toUpperCase(),
          ),
        ],
        if (user.referralCode?.isNotEmpty == true) ...[
          const SizedBox(height: 8),
          _buildDetailRow(
            context,
            Icons.share,
            localizations?.translate('referral_code') ?? 'Referral Code',
            user.referralCode!,
          ),
        ],
        const SizedBox(height: 8),
        _buildDetailRow(
          context,
          Icons.access_time,
          localizations?.translate('member_since') ?? 'Member Since',
          _formatDate(user.createdAt),
        ),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: context.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 8),
        CommonText.bodySmall(
          '$label:',
          color: context.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CommonText.bodySmall(
            value,
            color: context.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations? localizations) {
    if (widget.isCompact) {
      return Row(
        children: [
          Icon(
            Icons.person_outline,
            size: 16,
            color: context.onSurface.withOpacity(0.5),
          ),
          const SizedBox(width: 8),
          CommonText.bodySmall(
            localizations?.translate('no_user_data') ?? 'No user data',
            color: context.onSurface.withOpacity(0.5),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.person_outline,
          size: 48,
          color: context.onSurface.withOpacity(0.5),
        ),
        const SizedBox(height: 12),
        CommonText.bodyMedium(
          localizations?.translate('no_user_data') ?? 'No user data available',
          textAlign: TextAlign.center,
          color: context.onSurface.withOpacity(0.5),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => ref.read(currentUserProvider.notifier).getCurrentUser(),
          child: Text(localizations?.translate('load_user_info') ?? 'Load User Info'),
        ),
      ],
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime).inDays;

    if (difference < 30) {
      return '$difference days ago';
    } else if (difference < 365) {
      final months = (difference / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }
}