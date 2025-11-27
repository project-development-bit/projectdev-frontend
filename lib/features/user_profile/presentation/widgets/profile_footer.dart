import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/terms_privacy/presentation/services/terms_privacy_navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileFooter extends ConsumerWidget {
  const ProfileFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);
    final isMobile = context.isMobile;

    return ResponsiveSection(
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 16,
        ),
        child: isMobile
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonText.labelSmall(
                    "RID: 1k0k4k7vkyhwsgowwgs8c804k0o448000",
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 8),
                  CommonText.labelSmall(
                    "2025© Cointiply",
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 4,
                    children: [
                      _FooterLink(
                          onPressed: () {},
                          title: localizations?.translate("footer_support") ??
                              "Support"),
                      _FooterLink(
                          onPressed: () => context.showTerms(),
                          title: localizations?.translate("terms_of_service") ??
                              "Terms of Service"),
                      _FooterLink(
                          onPressed: () => context.showPrivacy(),
                          title: localizations?.translate("privacy_policy") ??
                              "Privacy Policy"),
                    ],
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText.labelSmall(
                    "RID: 1k0k4k7vkyhwsgowwgs8c804k0o448000",
                    color: colorScheme.onSurfaceVariant,
                  ),
                  CommonText.labelSmall(
                    "2025© Cointiply",
                    color: colorScheme.onSurfaceVariant,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _FooterLink(
                          onPressed: () {},
                          title: localizations?.translate("footer_support") ??
                              "Support"),
                      const SizedBox(width: 16),
                      _FooterLink(
                          onPressed: () => context.showTerms(),
                          title: localizations?.translate("terms_of_service") ??
                              "Terms of Service"),
                      const SizedBox(width: 16),
                      _FooterLink(
                          onPressed: () => context.showPrivacy(),
                          title: localizations?.translate("privacy_policy") ??
                              "Privacy Policy"),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String title;
  final Function() onPressed;

  const _FooterLink({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
      child: CommonText.labelSmall(
        title,
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
