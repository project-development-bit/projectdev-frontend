import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/flavor_manager.dart';
import '../config/app_flavor.dart';
import '../extensions/context_extensions.dart';

/// A banner widget that displays the current flavor information
/// Only visible in non-production builds
class FlavorBanner extends ConsumerWidget {
  final Widget child;
  
  const FlavorBanner({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flavor = ref.watch(flavorProvider);
    
    // Don't show banner in production
    if (FlavorManager.isProd) {
      return child;
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Banner(
        message: flavor.displayName.toUpperCase(),
        location: BannerLocation.topEnd,
        color: _getBannerColor(flavor),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
        child: child,
      ),
    );
  }

  Color _getBannerColor(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.dev:
        return Colors.green;
      case AppFlavor.staging:
        return Colors.orange;
      case AppFlavor.prod:
        return Colors.red;
    }
  }
}

/// A debug info widget that shows environment details
/// Only visible when debug features are enabled
class FlavorDebugInfo extends ConsumerWidget {
  const FlavorDebugInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flavor = ref.watch(flavorProvider);
    final config = ref.watch(configProvider);
    
    // Don't show in production or when debug features are disabled
    if (!FlavorManager.areDebugFeaturesEnabled) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🚀 Environment Info',
            style: context.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.primary,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Flavor', flavor.displayName),
          _buildInfoRow('App Name', config.appName),
          _buildInfoRow('API URL', config.apiBaseUrl),
          _buildInfoRow('Logging', config.enableLogging ? 'Enabled' : 'Disabled'),
          _buildInfoRow('Debug Features', config.enableDebugFeatures ? 'Enabled' : 'Disabled'),
          _buildInfoRow('Analytics', config.enableAnalytics ? 'Enabled' : 'Disabled'),
          _buildInfoRow('Crash Reporting', config.enableCrashReporting ? 'Enabled' : 'Disabled'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

/// A floating action button that shows/hides debug info
class FlavorDebugFAB extends StatefulWidget {
  const FlavorDebugFAB({super.key});

  @override
  State<FlavorDebugFAB> createState() => _FlavorDebugFABState();
}

class _FlavorDebugFABState extends State<FlavorDebugFAB> {
  bool _showDebugInfo = false;

  @override
  Widget build(BuildContext context) {
    // Don't show in production or when debug features are disabled
    if (!FlavorManager.areDebugFeaturesEnabled) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        if (_showDebugInfo)
          Positioned(
            bottom: 80,
            right: 16,
            child: const FlavorDebugInfo(),
          ),
        FloatingActionButton.small(
          onPressed: () {
            setState(() {
              _showDebugInfo = !_showDebugInfo;
            });
          },
          backgroundColor: context.primary,
          child: Icon(
            _showDebugInfo ? Icons.close : Icons.info_outline,
            color: context.onPrimary,
          ),
        ),
      ],
    );
  }
}