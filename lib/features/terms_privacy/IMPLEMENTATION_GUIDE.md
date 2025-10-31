# Terms & Privacy Navigation - Clean Platform-Aware Implementation

## Overview
The Terms & Privacy feature has been restructured to provide a clean, platform-aware navigation experience:

- **Web**: Opens URLs in new browser tabs (better UX)
- **Mobile**: Shows WebView screens within the app

## Architecture

### 1. Navigation Service
**File**: `lib/features/terms_privacy/presentation/services/terms_privacy_navigation_service.dart`

This service automatically handles platform differences and provides a simple API:

```dart
// Extension methods (recommended)
context.showTerms(ref);
context.showPrivacy(ref);

// Direct service calls
TermsPrivacyNavigationService.showTerms(context, ref);
TermsPrivacyNavigationService.showPrivacy(context, ref);
```

### 2. Platform Detection
Uses conditional imports to handle web-specific functionality:

```dart
import 'web_url_launcher_stub.dart'
    if (dart.library.html) 'web_url_launcher_web.dart';
```

- **web_url_launcher_web.dart**: Web implementation using `dart:html`
- **web_url_launcher_stub.dart**: Stub for non-web platforms

### 3. Data Flow
1. **Fetch URLs**: Service calls the existing Riverpod provider to get Terms & Privacy URLs from API
2. **Platform Check**: Uses `kIsWeb` to determine platform
3. **Navigation**: 
   - Web: Opens URL in new tab using `window.open()`
   - Mobile: Navigates to WebView screen

## Implementation Example

### Updated Login Page
The login page now uses the clean navigation service:

```dart
// Before (routing-based)
onPressed: () => GoRouter.of(context).push(AppRoutes.termsOfService),

// After (platform-aware service)
onPressed: () => context.showTerms(ref),
```

### Usage in Any Widget
```dart
import '../services/terms_privacy_navigation_service.dart';

// In your widget's onPressed handler
ElevatedButton(
  onPressed: () => context.showTerms(ref),
  child: Text('Terms of Service'),
);

ElevatedButton(
  onPressed: () => context.showPrivacy(ref),
  child: Text('Privacy Policy'),
);
```

## File Structure

```
lib/features/terms_privacy/
├── data/
│   ├── models/terms_privacy_model.dart (existing)
│   ├── datasources/terms_privacy_remote.dart (existing)
│   └── repositories/terms_privacy_repository_impl.dart (existing)
├── domain/
│   ├── entities/terms_privacy_entity.dart (existing)
│   └── repositories/terms_privacy_repository.dart (existing)
└── presentation/
    ├── providers/terms_privacy_provider.dart (existing)
    ├── screens/
    │   ├── terms_screen.dart (existing - used for mobile)
    │   └── privacy_screen.dart (existing - used for mobile)
    ├── widgets/
    │   └── webview_wrapper.dart (existing)
    ├── services/
    │   ├── terms_privacy_navigation_service.dart (NEW)
    │   ├── web_url_launcher_web.dart (NEW)
    │   └── web_url_launcher_stub.dart (NEW)
    └── examples/
        └── navigation_example.dart (NEW)
```

## Router Cleanup

The app router has been cleaned up by removing the static routes:
- Removed: `/legal/terms-of-service` route
- Removed: `/legal/privacy-policy` route
- Kept: `/legal/contact-us` route (still uses traditional routing)

This reduces routing complexity while providing better UX.

## Benefits

1. **Platform Optimized**: 
   - Web users get new tabs (standard web behavior)
   - Mobile users get in-app WebViews (standard mobile behavior)

2. **Clean API**: Simple, intuitive methods
3. **Maintainable**: Single service handles all platform logic
4. **Future Proof**: Easy to extend or modify behavior
5. **Consistent**: Uses existing data layer and providers

## Migration Guide

### For Existing Code
Replace any existing terms/privacy navigation:

```dart
// Old routing approach
GoRouter.of(context).push(AppRoutes.termsOfService);
GoRouter.of(context).push(AppRoutes.privacyPolicy);

// New service approach
context.showTerms(ref);
context.showPrivacy(ref);
```

### Import Required
```dart
import '../services/terms_privacy_navigation_service.dart';
```

The service will automatically handle platform detection and URL fetching.