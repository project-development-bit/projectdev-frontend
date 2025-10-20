# Gigafaucet - Flavor System Documentation

## Overview

The Gigafaucet app uses a comprehensive flavor system that allows for different configurations across development, staging, and production environments. This enables environment-specific API endpoints, feature flags, and debugging options.

## Available Flavors

### 🟢 Development (`dev`)
- **Purpose**: Local development and testing
- **API URL**: `https://api-dev.burgereats.com/api/v1`
- **Features**: 
  - Full logging enabled
  - Debug features enabled
  - Flavor banner visible
  - Debug FAB available
  - Detailed error reporting

### 🟠 Staging (`staging`)
- **Purpose**: Testing before production release
- **API URL**: `https://api-staging.burgereats.com/api/v1`
- **Features**:
  - Limited logging
  - Some debug features enabled
  - Flavor banner visible
  - Production-like environment
  - Analytics enabled

### 🔴 Production (`prod`)
- **Purpose**: Live production environment
- **API URL**: `https://api.burgereats.com/api/v1`
- **Features**:
  - No debug banners
  - No debug features
  - Optimized performance
  - Full analytics and crash reporting
  - Error logging only

## File Structure

```
lib/
├── main.dart                    # Default entry point (uses dev flavor)
├── main_dev.dart               # Development flavor entry point
├── main_staging.dart           # Staging flavor entry point
├── main_prod.dart              # Production flavor entry point
├── main_common.dart            # Shared app initialization logic
└── core/
    ├── config/
    │   ├── app_flavor.dart     # Flavor enumeration and extensions
    │   ├── app_config.dart     # Environment-specific configurations
    │   └── flavor_manager.dart # Flavor management and providers
    ├── network/
    │   └── dio_provider.dart   # HTTP client with flavor-aware configuration
    └── widgets/
        └── flavor_banner.dart  # Debug UI components
```

## Running Different Flavors

### Using Flutter Command Line

```bash
# Development
flutter run -t lib/main_dev.dart

# Staging
flutter run -t lib/main_staging.dart

# Production
flutter run -t lib/main_prod.dart
```

### Using the Flavor Runner Script

```bash
# Make script executable (first time only)
chmod +x run_flavor.sh

# Run development flavor
./run_flavor.sh dev

# Run staging flavor on iOS
./run_flavor.sh staging ios

# Run production flavor
./run_flavor.sh prod android
```

## Configuration Details

### API Endpoints
- **Dev**: `api-dev.burgereats.com` - Development server with latest features
- **Staging**: `api-staging.burgereats.com` - Pre-production testing
- **Prod**: `api.burgereats.com` - Production server

### Timeout Settings
- **Connect Timeout**: 30 seconds (all flavors)
- **Receive Timeout**: 30 seconds (all flavors)
- **Send Timeout**: 30 seconds (all flavors)

### Debug Features

#### Development
- Pretty HTTP request/response logging
- Detailed console output
- Flavor banner in top-right corner
- Debug info FAB
- Network interceptors with full logging

#### Staging
- Basic HTTP logging
- Flavor banner visible
- Limited debug output
- Error tracking enabled

#### Production
- No debug UI elements
- Error logging only
- Performance optimized
- Full analytics tracking

## Build Configuration

### Android
To properly support flavors in Android builds, you'll need to configure:

1. **android/app/build.gradle**:
```gradle
android {
    flavorDimensions "default"
    productFlavors {
        dev {
            dimension "default"
            applicationIdSuffix ".dev"
            versionNameSuffix "-dev"
            resValue "string", "app_name", "Gigafaucet Dev"
        }
        staging {
            dimension "default"
            applicationIdSuffix ".staging"
            versionNameSuffix "-staging"
            resValue "string", "app_name", "Gigafaucet Staging"
        }
        prod {
            dimension "default"
            resValue "string", "app_name", "Gigafaucet"
        }
    }
}
```

### iOS
For iOS, configure schemes in Xcode for each flavor with different bundle identifiers and app names.

## Usage in Code

### Accessing Current Flavor
```dart
// Using FlavorManager (static access)
if (FlavorManager.isDev) {
  print('Running in development mode');
}

String apiUrl = FlavorManager.fullApiUrl;
bool debugEnabled = FlavorManager.areDebugFeaturesEnabled;

// Using Riverpod providers
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flavor = ref.watch(flavorProvider);
    final config = ref.watch(configProvider);
    final isDebug = ref.watch(debugFeaturesEnabledProvider);
    
    return Text('Current flavor: ${flavor.displayName}');
  }
}
```

### Feature Flags
```dart
// Check if a feature is enabled
if (FlavorManager.isFeatureEnabled('newUserInterface')) {
  // Show new UI
} else {
  // Show old UI
}

// Access custom configuration
String customValue = FlavorManager.getConfigValue<String>('customKey') ?? 'default';
```

### Network Configuration
The `DioProvider` automatically configures HTTP timeouts, base URLs, and logging based on the current flavor:

```dart
// Automatically configured based on flavor
final dio = ref.watch(dioProvider);
```

## Visual Indicators

### Flavor Banner
- **Green banner**: Development environment
- **Orange banner**: Staging environment
- **No banner**: Production environment

### Debug FAB
- Available in dev and staging
- Shows environment info when tapped
- Hidden in production

## Best Practices

1. **Always use FlavorManager** for environment-specific logic
2. **Test all flavors** before releasing
3. **Keep sensitive data** out of configuration files
4. **Use feature flags** for experimental features
5. **Validate configuration** during app startup

## Security Considerations

- API keys and secrets should be injected at build time
- Production builds should have all debug features disabled
- Logging should be minimal in production
- Consider using different Firebase projects per flavor

## Troubleshooting

### Common Issues

1. **Flavor not switching**: Ensure you're using the correct entry point file
2. **API errors**: Verify the correct API URL for your flavor
3. **Missing debug features**: Check if debug features are enabled for your flavor
4. **Build errors**: Ensure all flavor-specific configurations are properly set

### Debug Commands

```bash
# Check current flavor configuration
flutter run -t lib/main_dev.dart --verbose

# View detailed build information
flutter build apk --flavor dev --verbose
```

## Migration Guide

When adding new flavors or modifying existing ones:

1. Update `AppFlavor` enum in `app_flavor.dart`
2. Add configuration in `AppConfig` class
3. Create new entry point file (`main_newFlavor.dart`)
4. Update build configurations (Android/iOS)
5. Test all existing functionality

## Future Enhancements

- [ ] Remote configuration support
- [ ] Dynamic feature toggles
- [ ] A/B testing framework
- [ ] Automated flavor deployment
- [ ] Environment-specific app icons