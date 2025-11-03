import 'package:cloudflare_turnstile/cloudflare_turnstile.dart' hide TurnstileError;
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
  
  const CloudflareTurnstileWidget({
    super.key,
    this.siteKey,
    this.size = TurnstileSize.normal,
    this.theme,
    this.language,
    this.retryAutomatically = false,
    this.refreshExpired = TurnstileRefreshExpired.manual,
  });

  @override
  ConsumerState<CloudflareTurnstileWidget> createState() => _CloudflareTurnstileWidgetState();
}

class _CloudflareTurnstileWidgetState extends ConsumerState<CloudflareTurnstileWidget> {
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
      
      await ref.read(turnstileNotifierProvider.notifier).initializeController();
      
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
        ref.read(turnstileNotifierProvider.notifier).onTurnstileError(
          'Failed to load security verification. Please check your internet connection and refresh the page.'
        );
      }
    }
  }

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
    return brightness == Brightness.dark ? TurnstileTheme.dark : TurnstileTheme.light;
  }

  /// Get language code
  String get _getLanguage {
    if (widget.language != null) return widget.language!;
    
    final locale = Localizations.localeOf(context);
    return locale.languageCode;
  }

  /// Handle refresh token
  void _handleRefreshToken() async {
    await ref.read(turnstileNotifierProvider.notifier).refreshToken();
  }

  /// Handle validate token
  void _handleValidateToken() async {
    final controller = ref.read(turnstileNotifierProvider.notifier).controller;
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
        print('   Consider using test key "1x00000000000000000000AA" for development.');
      }
      
      if (Uri.base.scheme != "https" && !kDebugMode) {
        print('⚠️  WARNING: Production requires HTTPS for Turnstile to work.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final turnstileState = ref.watch(turnstileNotifierProvider);
    final turnstileNotifier = ref.watch(turnstileNotifierProvider.notifier);
    final controller = turnstileNotifier.controller;

    // Validate configuration on build
    _validateConfiguration();

    // Turnstile options
    final options = TurnstileOptions(
      size: widget.size,
      theme: _getTheme,
      refreshExpired: widget.refreshExpired,
      language: _getLanguage,
      retryAutomatically: widget.retryAutomatically,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Turnstile Widget
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              minHeight: 65,
              maxHeight: 100,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).cardColor,
            ),
            child: _isInitialized && controller != null
                ? Center(
                    child: CloudflareTurnstile(
                      siteKey: _getLiveSiteKey,
                      options: options,
                      controller: controller,
                      action: "login",
                      baseUrl:
                          kDebugMode
                          ? "http://localhost"
                          : "https://staging.gigafaucet.com",
                      onTokenReceived: (token) {
                        if (kDebugMode) {
                          print('✅ Turnstile: Token received successfully');
                          print('🔑 Site Key: $_getLiveSiteKey');
                          print('🌐 Environment: ${kDebugMode ? "Debug" : "Production"}');
                        }
                        turnstileNotifier.onTokenReceived(token);
                      },
                      onTokenExpired: () {
                        if (kDebugMode) {
                          print('⏰ Turnstile: Token expired');
                        }
                        turnstileNotifier.onTokenExpired();
                      },
                      onError: (error) {
                        if (kDebugMode) {
                          print('❌ Turnstile Error: ${error.message}');
                          print('🔑 Site Key Used: $_getLiveSiteKey');
                          print('🌐 Environment: ${kDebugMode ? "Debug" : "Production"}');
                          print('🔧 Domain: ${Uri.base.host}');
                          print('🔒 HTTPS: ${Uri.base.scheme == "https"}');
                        }
                        turnstileNotifier.onTurnstileError(error.message);
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
          ),

          const SizedBox(height: 8),

          // Status and Controls
          _buildStatusSection(turnstileState, context),
        ],
      ),
    );
  }

  Widget _buildStatusSection(TurnstileState state, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status indicator
        _buildStatusIndicator(state, context),
        
        // Token display (only in debug mode)
        if (kDebugMode && state is TurnstileSuccess) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText.bodySmall(
                  'Debug - Token (first 50 chars):',
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 4),
                CommonText.bodySmall(
                  state.token.length > 50 
                      ? '${state.token.substring(0, 50)}...'
                      : state.token,
                  color: Colors.grey.shade800,
                ),
              ],
            ),
          ),
        ],
        
        // Action buttons (only show in debug mode or when there's an error)
        if ((kDebugMode || state is TurnstileError || state is TurnstileExpired) && 
            ref.watch(turnstileNotifierProvider.notifier).controller != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              if (state is TurnstileError || state is TurnstileExpired)
                TextButton.icon(
                  onPressed: _handleRefreshToken,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Retry'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
    switch (state) {
      case TurnstileLoading():
        return Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 8),
            CommonText.bodySmall(
              'Verifying security challenge...',
              color: context.onSurfaceVariant,
            ),
          ],
        );

      case TurnstileSuccess():
        return Row(
          children: [
            const Icon(Icons.check_circle, size: 16, color: Colors.green),
            const SizedBox(width: 8),
            CommonText.bodySmall(
              'Security verification successful',
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ],
        );

      case TurnstileError(message: final message):
        return Row(
          children: [
            const Icon(Icons.error, size: 16, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: CommonText.bodySmall(
                'Verification failed: $message',
                color: Colors.red,
              ),
            ),
          ],
        );

      case TurnstileExpired():
        return Row(
          children: [
            const Icon(Icons.access_time, size: 16, color: Colors.orange),
            const SizedBox(width: 8),
            CommonText.bodySmall(
              'Security verification expired',
              color: Colors.orange,
            ),
          ],
        );

      default:
        return Row(
          children: [
            const Icon(Icons.security, size: 16, color: Colors.blue),
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
