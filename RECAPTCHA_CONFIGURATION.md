# reCAPTCHA Configuration Guide

## Dynamic Site Key Loading

This project now supports dynamic reCAPTCHA site key loading based on the environment (localhost vs production).

### Setup Instructions

1. **Add your localhost site key** to the `index.html` file:
   - Open `/web/index.html`
   - Find the line: `localhost: 'YOUR_LOCALHOST_SITE_KEY_HERE'`
   - Replace `'YOUR_LOCALHOST_SITE_KEY_HERE'` with your actual localhost reCAPTCHA site key

2. **Add localhost key to Flutter configuration** (optional, for mobile testing):
   - Open `lib/core/config/app_config.dart`
   - Find the line: `'localhostRecaptchaSiteKey': 'YOUR_LOCALHOST_SITE_KEY_HERE'`
   - Replace the placeholder with your localhost site key

### How it works

#### Web Platform
- The `index.html` automatically detects if running on localhost
- Uses localhost key for local development
- Uses production/staging key for deployed environments
- Automatically loads the appropriate reCAPTCHA script on page load

#### Mobile Platform
- Uses the flavor-specific site keys from `AppConfig`
- Dev/Staging/Prod environments have separate keys
- Localhost detection not applicable for mobile

### Environment Detection

The system detects localhost using these hostname patterns:
- `localhost`
- `127.0.0.1`
- `0.0.0.0`
- `192.168.*` (local network)
- `*.local` (mDNS)

### Testing

1. **Localhost Testing:**
   - Run `flutter run -d chrome --web-port 3000`
   - The system will automatically use your localhost key
   - Check browser console for reCAPTCHA loading messages

2. **Production Testing:**
   - Deploy to staging/production environment
   - The system will use the production site key

### Configuration Files

- **Web Configuration:** `/web/index.html` - JavaScript configuration
- **Flutter Configuration:** `/lib/core/config/app_config.dart` - Mobile keys
- **Service Integration:** `/lib/core/services/web_recaptcha_service.dart` - Service layer

### Troubleshooting

1. **reCAPTCHA not loading:**
   - Check browser console for error messages
   - Verify site key is correctly configured
   - Ensure network connectivity to Google reCAPTCHA servers

2. **Wrong site key being used:**
   - Check browser console for environment detection messages
   - Verify hostname matches expected localhost patterns
   - Clear browser cache and reload

3. **Site key validation errors:**
   - Ensure the site key is correctly copied (no extra spaces)
   - Verify the site key is configured for the correct domain
   - Check Google reCAPTCHA console for domain configuration

### Security Notes

- Never commit real site keys to version control for production
- Use environment variables or secure configuration management for production keys
- Localhost keys are only for development and should have domain restrictions enabled