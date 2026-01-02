import 'package:cloudflare_turnstile/cloudflare_turnstile.dart'
    hide TurnstileError;
import 'package:gigafaucet/core/theme/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/turnstile_provider.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/extensions/context_extensions.dart';

class CloudflareTurnstileWidget extends ConsumerStatefulWidget {
  final String? siteKey;
  final TurnstileSize size;
  final TurnstileTheme? theme;
  final String? language;
  final bool retryAutomatically;
  final TurnstileRefreshExpired refreshExpired;
  final TurnstileActionEnum action;
  final bool debugMode;

  const CloudflareTurnstileWidget({
    super.key,
    this.siteKey,
    this.size = TurnstileSize.normal,
    this.theme,
    this.language,
    this.retryAutomatically = false,
    this.action = TurnstileActionEnum.login,
    this.refreshExpired = TurnstileRefreshExpired.manual,
    this.debugMode = kDebugMode,
  });

  @override
  ConsumerState<CloudflareTurnstileWidget> createState() =>
      _CloudflareTurnstileWidgetState();
}

class _CloudflareTurnstileWidgetState
    extends ConsumerState<CloudflareTurnstileWidget> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize with delay to ensure Turnstile API is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeController();
    });
  }

  Future<void> _initializeController() async {
    try {
      if (kDebugMode) {
        print('🔧 Initializing Turnstile widget...');
        print('🔑 Site Key: $_getLiveSiteKey');
        print('🌐 Environment: ${kDebugMode ? 'Debug' : 'Production'}');
      }

      await _turnstilleNotifier.initializeController();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        if (kDebugMode) {
          print('✅ Turnstile widget initialized successfully');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to initialize Turnstile controller: $e');
      }
      // Set error state
      if (mounted) {
        _turnstilleNotifier.onTurnstileError(
            'Failed to load security verification. Please check your internet connection and refresh the page.');
      }
    }
  }

  TurnstileNotifier get _turnstilleNotifier =>
      ref.read(turnstileNotifierProvider(widget.action).notifier);

  /// Get the correct site key based on environment
  String get _getLiveSiteKey {
    // IMPORTANT: Cloudflare Turnstile site key configuration
    //
    // This error occurs when:
    // 1. Wrong site key is used
    // 2. Site key doesn't match the domain
    // 3. Site key is not properly configured in Cloudflare
    //
    // To fix this:
    // 1. Go to Cloudflare dashboard: https://dash.cloudflare.com/
    // 2. Select your domain
    // 3. Go to Security → Turnstile
    // 4. Create a new site with your exact domain
    // 5. Copy the "Site Key" (public key) - NOT the secret key
    // 6. Replace the production key below

    if (widget.siteKey != null) {
      return widget.siteKey!;
    }

    // TEMPORARY: Using test key for ALL environments until you get your real key
    // This test key always passes verification
    // Once you have your real site key from Cloudflare, update the production key below
    const String testKey = '0x4AAAAAAB-h_zqcfZnriGXu';
    const String productionSiteKey =
        '0x4AAAAAAB-h_zqcfZnriGXu'; // REPLACE THIS WITH YOUR REAL KEY

    // For now, use test key in both debug and production
    // This helps verify the integration works before adding real key
    if (kDebugMode) {
      debugPrint('🔑 Using Turnstile TEST key (always passes)');
      return testKey;
    } else {
      // IMPORTANT: Change this to 'productionSiteKey' after getting your real key from Cloudflare
      debugPrint(
          '⚠️ WARNING: Using TEST key in production. Please update with real site key!');
      return productionSiteKey; // Change to: productionSiteKey

      // After getting your realxsite key:
      // 1. Replace '0x4AAAAAAABvMxgQiLjU_ErY' above with your real key
      // 2. Change 'return testKey;' to 'return productionSiteKey;'
    }
  }

  /// Get theme based on current context
  TurnstileTheme get _getTheme {
    if (widget.theme != null) return widget.theme!;

    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? TurnstileTheme.dark
        : TurnstileTheme.light;
  }

  /// Get language code
  String get _getLanguage {
    if (widget.language != null) return widget.language!;

    final locale = Localizations.localeOf(context);
    return locale.languageCode;
  }

  /// Handle refresh token
  void _handleRefreshToken() async {
    await _turnstilleNotifier.refreshToken();
  }

  /// Handle validate token
  void _handleValidateToken() async {
    final controller = _turnstilleNotifier.controller;
    if (controller != null) {
      final isExpired = await controller.isExpired();

      if (mounted) {
        context.showSuccessSnackBar(
          message: isExpired ? 'Token is Expired' : 'Token is Valid',
        );
      }
    }
  }

  /// Validate configuration and log helpful information
  void _validateConfiguration() {
    final siteKey = _getLiveSiteKey;

    if (kDebugMode) {
      print('🔧 Turnstile Configuration Validation:');
      print('🔑 Site Key: $siteKey');
      print('🌐 Environment: ${kDebugMode ? "Debug" : "Production"}');
      print('🔧 Domain: ${Uri.base.host}');
      print('🔒 HTTPS: ${Uri.base.scheme == "https"}');
      print('🎨 Theme: $_getTheme');
      print('🗣️ Language: $_getLanguage');

      // Validate common issues
      if (siteKey == '0x4AAAAAAABvMxgQiLjU_ErY' && !kDebugMode) {
        print('⚠️  WARNING: You are using the example site key in production!');
        print('   Please replace with your actual Cloudflare site key.');
      }

      if (siteKey.startsWith('0x') && kDebugMode) {
        print('💡 INFO: Using live site key in debug mode.');
        print(
            '   Consider using test key "1x00000000000000000000AA" for development.');
      }

      if (Uri.base.scheme != "https" && !kDebugMode) {
        print('⚠️  WARNING: Production requires HTTPS for Turnstile to work.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final turnstileState = ref.watch(turnstileNotifierProvider(widget.action));

    final controller = _turnstilleNotifier.controller;

    // Validate configuration on build
    _validateConfiguration();

    // Turnstile options
    final options = TurnstileOptions(
      size: widget.size,
      theme: _getTheme,
      refreshExpired: widget.refreshExpired,
      language: _getLanguage,
      retryInterval: Duration(milliseconds: 300),
      retryAutomatically: widget.retryAutomatically,
    );
    // final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      // padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Turnstile Widget
          _isInitialized && controller != null
              ? Center(
                  child: CloudflareTurnstile(
                    siteKey: _getLiveSiteKey,
                    options: options,
                    controller: controller,
                    action: widget.action.name,
                    baseUrl: kDebugMode
                        ? "http://localhost"
                        : "https://staging.gigafaucet.com",
                    onTokenReceived: (token) {
                      if (kDebugMode) {
                        print('✅ Turnstile: Token received successfully');
                        print('🔑 Site Key: $_getLiveSiteKey');
                        print(
                            '🌐 Environment: ${kDebugMode ? "Debug" : "Production"}');
                      }
                      _turnstilleNotifier.onTokenReceived(token);
                    },
                    onTokenExpired: () {
                      if (kDebugMode) {
                        print('⏰ Turnstile: Token expired');
                      }
                      _turnstilleNotifier.onTokenExpired();
                    },
                    onError: (error) {
                      if (kDebugMode) {
                        print('❌ Turnstile Error: ${error.message}');
                        print('🔑 Site Key Used: $_getLiveSiteKey');
                        print(
                            '🌐 Environment: ${kDebugMode ? "Debug" : "Production"}');
                        print('🔧 Domain: ${Uri.base.host}');
                        print('🔒 HTTPS: ${Uri.base.scheme == "https"}');
                      }
                      _turnstilleNotifier.onTurnstileError(error.message);
                    },
                  ),
                )
              : const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Loading security verification...'),
                    ],
                  ),
                ),

          const SizedBox(height: 8),

          // Status and Controls
          _buildStatusSection(turnstileState, context),
        ],
      ),
    );
  }

  Widget _buildStatusSection(TurnstileState state, BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status indicator
        _buildStatusIndicator(state, context),

        // Token display (only in debug mode)
        if (widget.debugMode && state is TurnstileSuccess) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.darkTextTertiary
                  : AppColors.lightTextTertiary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText.bodySmall(
                  'Debug - Token (first 50 chars):',
                  color: isDarkMode
                      ? AppColors.darkTextTertiary.withValues(alpha: 0.8)
                      : AppColors.lightTextTertiary.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 4),
                CommonText.bodySmall(
                  state.token.length > 50
                      ? '${state.token.substring(0, 50)}...'
                      : state.token,
                  color: isDarkMode
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
              ],
            ),
          ),
        ],

        // Action buttons (only show in debug mode or when there's an error)
        if ((widget.debugMode ||
                state is TurnstileError ||
                state is TurnstileExpired) &&
            _turnstilleNotifier.controller != null) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state is TurnstileError || state is TurnstileExpired)
                TextButton.icon(
                  onPressed: _handleRefreshToken,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Retry'),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                  ),
                ),
              if (kDebugMode) ...[
                if (state is TurnstileError || state is TurnstileExpired)
                  const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: _handleValidateToken,
                  icon: const Icon(Icons.check_circle, size: 16),
                  label: const Text('Validate'),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildStatusIndicator(TurnstileState state, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (state) {
      case TurnstileLoading():
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 6),
            CommonText.bodyMedium(
              'Verifying security challenge...',
              color: context.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ],
        );

      case TurnstileSuccess():
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 22, color: AppColors.success),
            const SizedBox(width: 6),
            CommonText.bodyMedium(
              'Security verification successful',
              color: AppColors.success,
              fontWeight: FontWeight.w500,
            ),
          ],
        );

      case TurnstileError(message: final message):
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 22, color: colorScheme.error),
            const SizedBox(width: 6),
            Expanded(
              child: CommonText.bodyMedium(
                'Verification failed: $message',
                color: colorScheme.error,
              ),
            ),
          ],
        );

      case TurnstileExpired():
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.access_time, size: 16, color: colorScheme.primary),
            const SizedBox(width: 8),
            CommonText.bodySmall(
              'Security verification expired',
              color: colorScheme.onPrimary,
            ),
          ],
        );

      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security, size: 16, color: AppColors.info),
            const SizedBox(width: 8),
            CommonText.bodySmall(
              'Security verification required',
              color: context.onSurfaceVariant,
            ),
          ],
        );
    }
  }
}
