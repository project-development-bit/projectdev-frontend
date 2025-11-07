import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/referrals/domain/entity/referred_user_entity.dart';
import 'package:flutter/material.dart';

class ReferredUsersTable extends StatelessWidget {
  final List<ReferredUserEntity> users;
  final bool isMobile;
  final AppLocalizations? localizations;

  const ReferredUsersTable({
    super.key,
    required this.users,
    required this.isMobile,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Table Header ───────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: colorScheme.outlineVariant),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: CommonText.labelSmall(
                  localizations?.translate('referrals_table_username') ??
                      'Username',
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Expanded(
                flex: 2,
                child: CommonText.labelSmall(
                  localizations?.translate('referrals_table_date') ?? 'Date',
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (!isMobile)
                Expanded(
                  flex: 3,
                  child: CommonText.labelSmall(
                    localizations?.translate('referrals_table_full_date') ??
                        'Full Date',
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),

        // ─── Table Rows ─────────────────────────────
        if (users.isNotEmpty)
          ...users
              .map((user) => _ReferredUserRow(user: user, isMobile: isMobile))
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Center(
              child: CommonText.bodySmall(
                localizations?.translate('referrals_table_no_records') ??
                    'No referred users yet.',
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

        // ─── Footer Row ─────────────────────────────
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      CommonText.bodySmall(
                        '20',
                        color: colorScheme.onSurface,
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 16),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                CommonText.bodySmall(
                  'Showing 1 to ${users.length} of ${users.length} records',
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: CommonText.labelSmall(
                '1',
                color: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReferredUserRow extends StatelessWidget {
  final ReferredUserEntity user;
  final bool isMobile;

  const _ReferredUserRow({
    required this.user,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: CommonText.bodySmall(
              user.username,
              color: colorScheme.onSurface,
            ),
          ),
          Expanded(
            flex: 2,
            child: CommonText.bodySmall(
              user.date,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (!isMobile)
            Expanded(
              flex: 3,
              child: CommonText.bodySmall(
                user.fullDate,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}
