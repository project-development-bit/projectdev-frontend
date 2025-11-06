import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/terms_screen.dart';
import '../screens/privacy_screen.dart';

/// Service for handling Terms & Privacy navigation across platforms
class TermsPrivacyNavigationService {
  /// Navigate to Terms of Service
  /// On web: Opens URL in new tab
  /// On mobile: Shows WebView screen
  static Future<void> showTerms(BuildContext context, WidgetRef ref) async {
    // if (kIsWeb) {
    //   await _openTermsInNewTab(ref);
    // } else {
    _showTermsScreen(context);
    // }
  }

  /// Navigate to Privacy Policy
  /// On web: Opens URL in new tab
  /// On mobile: Shows WebView screen
  static Future<void> showPrivacy(BuildContext context, WidgetRef ref) async {
    // if (kIsWeb) {
    //   await _openPrivacyInNewTab(ref);
    // } else {
    _showPrivacyScreen(context);
    // }
  }

  // Private methods for web platform
  // static Future<void> _openTermsInNewTab(WidgetRef ref) async {
  //   try {
  //     // First fetch the data to get the URL
  //     await ref
  //         .read(termsPrivacyNotifierProvider.notifier)
  //         .fetchTermsAndPrivacy();

  //     final state = ref.read(termsPrivacyNotifierProvider);
  //     if (state is TermsPrivacySuccess) {
  //       final url = state.data.termsUrl;
  //       if (url.isNotEmpty) {
  //         await _launchUrlInNewTab(url);
  //       } else {
  //         debugPrint('Terms URL is empty');
  //       }
  //     } else if (state is TermsPrivacyError) {
  //       debugPrint('Failed to fetch terms URL: ${state.message}');
  //     }
  //   } catch (e) {
  //     debugPrint('Error opening terms in new tab: $e');
  //   }
  // }

  // static Future<void> _openPrivacyInNewTab(WidgetRef ref) async {
  //   try {
  //     // First fetch the data to get the URL
  //     await ref
  //         .read(termsPrivacyNotifierProvider.notifier)
  //         .fetchTermsAndPrivacy();

  //     final state = ref.read(termsPrivacyNotifierProvider);
  //     if (state is TermsPrivacySuccess) {
  //       final url = state.data.privacyUrl;
  //       if (url.isNotEmpty) {
  //         await _launchUrlInNewTab(url);
  //       } else {
  //         debugPrint('Privacy URL is empty');
  //       }
  //     } else if (state is TermsPrivacyError) {
  //       debugPrint('Failed to fetch privacy URL: ${state.message}');
  //     }
  //   } catch (e) {
  //     debugPrint('Error opening privacy in new tab: $e');
  //   }
  // }

  // Private methods for mobile platform
  static void _showTermsScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TermsScreen(),
      ),
    );
  }

  static void _showPrivacyScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PrivacyScreen(),
      ),
    );
  }

  // Platform-agnostic URL launcher
  // static Future<void> _launchUrlInNewTab(String url) async {
  //   try {
  //     if (kIsWeb) {
  //       await openUrlInNewTab(url);
  //     }
  //   } catch (e) {
  //     debugPrint('Error launching URL: $e');
  //   }
  // }
}

/// Extension to simplify usage
extension TermsPrivacyNavigationExtension on BuildContext {
  /// Show Terms of Service (platform-aware)
  Future<void> showTerms(WidgetRef ref) async {
    await TermsPrivacyNavigationService.showTerms(this, ref);
  }

  /// Show Privacy Policy (platform-aware)
  Future<void> showPrivacy(WidgetRef ref) async {
    await TermsPrivacyNavigationService.showPrivacy(this, ref);
  }
}
