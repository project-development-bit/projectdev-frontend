import 'package:cointiply_app/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Service for handling Terms & Privacy navigation across platforms
class TermsPrivacyNavigationService {
  /// Navigate to Terms of Service
  /// On web: Opens URL in new tab
  /// On mobile: Shows WebView screen
  static Future<void> showTerms(
    BuildContext context,
  ) async {
    // if (kIsWeb) {
    //   await _openTermsInNewTab(ref);
    // } else {
    _showTermsScreen(context);
    // }
  }

  /// Navigate to Privacy Policy
  /// On web: Opens URL in new tab
  /// On mobile: Shows WebView screen
  static Future<void> showPrivacy(BuildContext context) async {
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
    context.goNamed(AppRoutes.terms);
  }

  static void _showPrivacyScreen(BuildContext context) {
    context.goNamed(AppRoutes.privacy);
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
  Future<void> showTerms() async {
    await TermsPrivacyNavigationService.showTerms(this);
  }

  /// Show Privacy Policy (platform-aware)
  Future<void> showPrivacy() async {
    await TermsPrivacyNavigationService.showPrivacy(this);
  }
}
