// import 'package:cointiply_app/features/localization/presentation/providers/get_languages_state.dart';
// import 'package:cointiply_app/features/localization/presentation/providers/get_localization_notifier.dart';
// import 'package:cointiply_app/features/localization/presentation/providers/localization_notifier_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class LocaleSwitchWidget extends ConsumerWidget {
//   const LocaleSwitchWidget({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentLocale = ref.watch(localizationNotifierProvider).currentLocale;
//     final localeNotifier = ref.read(localizationNotifierProvider.notifier);
//     final theme = Theme.of(context);
//     final languageState = ref.watch(getLanguagesNotifierProvider);

//     return PopupMenuButton<Locale>(
//       onSelected: (Locale locale) async {
//         debugPrint(
//             'Locale selected: ${locale.languageCode}-${locale.countryCode}');
//         await localeNotifier.changeLocale(locale);
//         debugPrint(
//             'Current locale after change: ${ref.read(localizationNotifierProvider).currentLocale.languageCode}');
//       },
//       tooltip: 'Select Language',
//       icon: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: theme.colorScheme.outline.withAlpha(13),
//           ),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               localeNotifier.getFlag(currentLocale),
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(width: 8),
//             Text(
//               localeNotifier.getLocaleName(currentLocale),
//               style: theme.textTheme.bodyMedium?.copyWith(
//                 color: theme.colorScheme.onSurface,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(width: 4),
//             Icon(
//               Icons.keyboard_arrow_down,
//               size: 16,
//               color: theme.colorScheme.onSurfaceVariant,
//             ),
//           ],
//         ),
//       ),
//       itemBuilder: (BuildContext context) {
//         return languageState.localeList.map((Locale locale) {
//           final isSelected = locale.languageCode == currentLocale.languageCode;

//           return PopupMenuItem<Locale>(
//             value: locale,
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 4),
//               decoration: isSelected
//                   ? BoxDecoration(
//                       color: theme.colorScheme.primary.withAlpha(25),
//                       borderRadius: BorderRadius.circular(6),
//                     )
//                   : null,
//               child: Row(
//                 children: [
//                   Text(
//                     localeNotifier.getFlag(locale),
//                     style: const TextStyle(fontSize: 18),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       localeNotifier.getLocaleName(locale),
//                       style: theme.textTheme.bodyMedium?.copyWith(
//                         color: isSelected
//                             ? theme.colorScheme.primary
//                             : theme.colorScheme.onSurface,
//                         fontWeight:
//                             isSelected ? FontWeight.w600 : FontWeight.w400,
//                       ),
//                     ),
//                   ),
//                   if (isSelected)
//                     Icon(
//                       Icons.check,
//                       size: 18,
//                       color: theme.colorScheme.primary,
//                     ),
//                 ],
//               ),
//             ),
//           );
//         }).toList();
//       },
//     );
//   }
// }

// // Simplified locale toggle button (alternative design)
// class LocaleToggleButton extends ConsumerWidget {
//   const LocaleToggleButton({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentLocale = ref.watch(localizationNotifierProvider).currentLocale;
//     final localeNotifier = ref.read(localizationNotifierProvider.notifier);
//     final theme = Theme.of(context);

//     return IconButton(
//       onPressed: () => localeNotifier.toggleLocale(),
//       tooltip: 'Switch Language',
//       icon: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: theme.colorScheme.surfaceContainerHighest.withAlpha(13),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               localeNotifier.getFlag(currentLocale),
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(width: 4),
//             Text(
//               currentLocale.languageCode.toUpperCase(),
//               style: theme.textTheme.bodySmall?.copyWith(
//                 fontWeight: FontWeight.w600,
//                 color: theme.colorScheme.onSurfaceVariant,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Compact locale switcher for app bars
// class CompactLocaleSwitcher extends ConsumerWidget {
//   const CompactLocaleSwitcher({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentLocale = ref.watch(localizationNotifierProvider).currentLocale;
//     final localeNotifier = ref.read(localizationNotifierProvider.notifier);
//     final theme = Theme.of(context);

//     return GestureDetector(
//       onTap: () async {
//         debugPrint(
//             'CompactLocaleSwitcher tapped - current: ${currentLocale.languageCode}');
//         await localeNotifier.toggleLocale();
//         debugPrint(
//             'After toggle - new locale: ${ref.read(localizationNotifierProvider).currentLocale.languageCode}');
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         decoration: BoxDecoration(
//           color: theme.colorScheme.primary.withAlpha(25),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: theme.colorScheme.primary.withAlpha(75)),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               localeNotifier.getFlag(currentLocale),
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(width: 4),
//             Text(
//               currentLocale.languageCode.toUpperCase(),
//               style: theme.textTheme.bodySmall?.copyWith(
//                 fontWeight: FontWeight.w600,
//                 color: theme.colorScheme.primary,
//                 fontSize: 11,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
