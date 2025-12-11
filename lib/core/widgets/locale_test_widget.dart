import 'package:cointiply_app/features/localization/presentation/providers/localization_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/localization/presentation/providers/translation_provider.dart';

class LocaleTestWidget extends ConsumerWidget {
  const LocaleTestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localizationNotifierProvider).currentLocale;
    final localeNotifier = ref.read(localizationNotifierProvider.notifier);
    final translate = ref.watch(translationProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Locale Test Widget',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
                'Current Locale: ${currentLocale.languageCode}-${currentLocale.countryCode}'),
            Text(
                'Direct Translation "welcome_back": ${translate('welcome_back')}'),
            Text('Direct Translation "sign_in": ${translate('sign_in')}'),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    debugPrint('Button pressed: Switching to English');
                    await localeNotifier.changeLocale(const Locale('en', 'US'));
                    debugPrint('Button pressed: English switch completed');
                  },
                  child: const Text('English'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    debugPrint('Button pressed: Switching to Myanmar');
                    await localeNotifier.changeLocale(const Locale('my', 'MM'));
                    debugPrint('Button pressed: Myanmar switch completed');
                  },
                  child: const Text('Myanmar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
