import 'package:cointiply_app/core/common/common_image_widget.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/localization/app_localizations.dart';
import 'package:cointiply_app/core/theme/app_colors.dart';
import 'package:cointiply_app/features/auth/presentation/providers/ip_country_provider.dart';
import 'package:cointiply_app/features/auth/presentation/providers/ip_country_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Country {
  final String code;
  final String name;
  final String flagUrl;

  const Country({
    required this.code,
    required this.name,
    required this.flagUrl,
  });
}

// Static list from your JSON
const List<Country> kCountries = [
  Country(
    code: 'AU',
    name: 'Australia',
    flagUrl: 'https://flagsapi.com/AU/flat/64.png',
  ),
  Country(
    code: 'CN',
    name: 'China',
    flagUrl: 'https://flagsapi.com/CN/flat/64.png',
  ),
  Country(
    code: 'FR',
    name: 'France',
    flagUrl: 'https://flagsapi.com/FR/flat/64.png',
  ),
  Country(
    code: 'DE',
    name: 'Germany',
    flagUrl: 'https://flagsapi.com/DE/flat/64.png',
  ),
  Country(
    code: 'IN',
    name: 'India',
    flagUrl: 'https://flagsapi.com/IN/flat/64.png',
  ),
  Country(
    code: 'JP',
    name: 'Japan',
    flagUrl: 'https://flagsapi.com/JP/flat/64.png',
  ),
  Country(
    code: 'MM',
    name: 'Myanmar',
    flagUrl: 'https://flagsapi.com/MM/flat/64.png',
  ),
  Country(
    code: 'SG',
    name: 'Singapore',
    flagUrl: 'https://flagsapi.com/SG/flat/64.png',
  ),
  Country(
    code: 'TH',
    name: 'Thailand',
    flagUrl: 'https://flagsapi.com/TH/flat/64.png',
  ),
  Country(
    code: 'US',
    name: 'United States',
    flagUrl: 'https://flagsapi.com/US/flat/64.png',
  ),
];

final selectedCountryProvider = StateProvider<Country>((ref) {
  return kCountries.first;
});

class CountrySelectorField extends ConsumerWidget {
  final Country? initialCountry;
  final ValueChanged<Country>? onChanged;
  final String? labelKey;

  const CountrySelectorField({
    super.key,
    this.initialCountry,
    this.onChanged,
    this.labelKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);

    final selectedCountry = ref.watch(selectedCountryProvider);
    final ipState = ref.watch(getIpCountryNotifierProvider);

    if (ipState.status == GetIpCountryStatus.success &&
        ipState.country != null) {
      final detectedCode = ipState.country!.code?.toUpperCase();

      final detectedCountry = kCountries.firstWhere(
        (c) => c.code == detectedCode,
        orElse: () => selectedCountry,
      );

      if (detectedCountry.code != selectedCountry.code) {
        Future.microtask(() {
          ref.read(selectedCountryProvider.notifier).state = detectedCountry;
          onChanged?.call(detectedCountry);
        });
      }
    }

    final isMobile = mediaQuery.size.width < 600;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelKey != null && labelKey!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: CommonText.bodySmall(
              localizations?.translate(labelKey!) ?? '',
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        InkWell(
          onTap: () => _showCountryPicker(context, ref, selectedCountry),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            height: isMobile ? 48 : 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: (Theme.of(context).brightness == Brightness.dark
                  ? AppColors.websiteCard
                  : theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CommonImage(
                    imageUrl: selectedCountry.flagUrl,
                    width: 28,
                    height: 20,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CommonText.bodyMedium(
                    selectedCountry.name,
                    color: colorScheme.onSurface,
                    fontSize: 14,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showCountryPicker(
    BuildContext context,
    WidgetRef ref,
    Country selectedCountry,
  ) async {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    final mediaQuery = MediaQuery.of(context);
    final isMobile = mediaQuery.size.width < 600;
    final isTablet =
        mediaQuery.size.width >= 600 && mediaQuery.size.width < 1024;

    final dialogWidth = isMobile
        ? mediaQuery.size.width
        : isTablet
            ? mediaQuery.size.width * 0.8
            : mediaQuery.size.width * 0.6;

    final Country? result = await showDialog<Country>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: dialogWidth,
              constraints: const BoxConstraints(maxHeight: 520),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: CommonText.titleMedium(
                            localizations?.translate('select_country_title') ??
                                'Select your country',
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          splashRadius: 18,
                          icon: Icon(
                            Icons.close_rounded,
                            color: colorScheme.onSurface,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Country list
                  Expanded(
                    child: ListView.separated(
                      itemCount: kCountries.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: colorScheme.outlineVariant,
                      ),
                      itemBuilder: (context, index) {
                        final country = kCountries[index];
                        final isSelected = country.code == selectedCountry.code;

                        return InkWell(
                          onTap: () => Navigator.of(context).pop(country),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: CommonImage(
                                    imageUrl: country.flagUrl,
                                    width: 28,
                                    height: 20,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CommonText.bodyMedium(
                                    country.name,
                                    color: colorScheme.onSurface,
                                    fontSize: 14,
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_rounded,
                                    color: colorScheme.primary,
                                    size: 18,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );

    if (result != null) {
      ref.read(selectedCountryProvider.notifier).state = result;
      onChanged?.call(result);
    }
  }
}
