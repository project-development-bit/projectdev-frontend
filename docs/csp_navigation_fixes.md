# CSP and Navigation Fixes for Flutter Web

## Issues Fixed

### 1. Content Security Policy (CSP) Error - CanvasKit
**Problem**: 
```
Refused to load the script 'https://www.gstatic.com/flutter-canvaskit/...' because it violates the following Content Security Policy directive: "script-src 'self' 'unsafe-eval' 'unsafe-inline' https://unpkg.com"
```

**Root Cause**: 
Flutter web uses CanvasKit which loads from `https://www.gstatic.com/flutter-canvaskit/`, but the CSP only allowed scripts from `https://unpkg.com`.

**Solution**: 
Updated `web/index.html` to include `https://www.gstatic.com` in the `script-src` directive.

### 2. Content Security Policy (CSP) Error - API Connections
**Problem**: 
```
Refused to connect to 'http://13.250.102.238/api/v1/users/login' because it violates the following Content Security Policy directive: "connect-src 'self' https: wss: ws:"
```

**Root Cause**: 
The API server is using HTTP (`http://13.250.102.238/api/v1/`) but the CSP only allowed HTTPS connections in the `connect-src` directive.

**Solution**: 
Updated `web/index.html` to include `http:` in the `connect-src` directive to allow HTTP API connections.

### 3. Navigation Issue After Login
**Problem**: 
After successful login, the app was not properly navigating to the home page. The app was showing success message but staying on login page.

**Root Cause**: 
The login page was using `context.pushNamedHome()` which pushes the home route onto the navigation stack instead of replacing the current route. This causes navigation issues in web browsers.

**Solution**: 
Changed navigation from `context.pushNamedHome()` to `GoRouter.of(context).go(AppRoutes.home)` to replace the current route.

## Files Modified

### `/web/index.html`
- Added `https://www.gstatic.com` to `script-src` directive for CanvasKit support
- Added `http:` to `connect-src` directive for API connections

**Final CSP Configuration**:
```html
<meta http-equiv="Content-Security-Policy" content="
    default-src 'self';
    script-src 'self' 'unsafe-eval' 'unsafe-inline' https://unpkg.com https://www.gstatic.com;
    style-src 'self' 'unsafe-inline' https://fonts.googleapis.com;
    font-src 'self' https://fonts.gstatic.com;
    img-src 'self' data: https:;
    connect-src 'self' http: https: wss: ws:;
    object-src 'none';
    base-uri 'self';
">
```

### `/lib/features/auth/presentation/pages/login_page.dart`
- Added `go_router` import
- Added `app_router` import for `AppRoutes`
- Changed navigation method from `pushNamedHome()` to `GoRouter.of(context).go(AppRoutes.home)`

## Architecture Notes

The project has two API configuration systems:

1. **Flavor-based configuration** (recommended):
   - `lib/core/config/app_config.dart` - Lines 37-97
   - Uses HTTPS URLs like `https://api-dev.burgereats.com`
   - Environment-specific settings

2. **Hardcoded configuration** (currently used):
   - `lib/core/config/app_config.dart` - Line 162
   - Uses HTTP: `http://13.250.102.238/api/v1/`
   - Used by `lib/core/network/base_dio_client.dart`

## Testing

### CSP Fix Verification
1. Build the web app: `flutter build web`
2. The build should complete without CSP errors
3. CanvasKit should load successfully in the browser
4. API calls to HTTP endpoints should work

### Navigation Fix Verification
1. Run the web app: `flutter run -d web-server --web-port 8081`
2. Navigate to login page
3. Perform a successful login
4. Verify that the app navigates to home page (not staying on login)
5. Check browser navigation - back button should not return to login page

## Production Recommendations

### 1. Use HTTPS for API (Recommended)
Instead of allowing HTTP in CSP, configure your API server to use HTTPS:
- Update `AppConfig.appUrl` to use `https://13.250.102.238/api/v1/`
- Revert CSP to only allow HTTPS: `connect-src 'self' https: wss: ws:;`

### 2. Use Environment-based Configuration
Switch from hardcoded `appUrl` to flavor-based configuration:
```dart
// Instead of AppConfig.appUrl, use:
final config = FlavorManager.currentConfig;
final baseUrl = config.fullApiUrl;
```

### 3. Security Considerations
- HTTP connections are less secure than HTTPS
- Consider using SSL certificates for your API server
- Monitor CSP violations in production
- Consider more restrictive CSP for production builds

## Benefits

1. **CSP Compliance**: Web app now loads properly without Content Security Policy violations
2. **API Connectivity**: HTTP API connections work without CSP blocking
3. **Proper Navigation**: Login → Home navigation works correctly on web
4. **Better UX**: Users can't accidentally go back to login page after authentication
5. **Cross-platform**: Maintains compatibility with both mobile and web

## Future Considerations

- Migrate API server to HTTPS for enhanced security
- Implement environment-specific CSP configurations
- Consider using more restrictive CSP directives for production
- Consolidate API configuration to use flavor-based system exclusively