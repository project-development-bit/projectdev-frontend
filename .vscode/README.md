# VS Code Integration for Project Dev Flavor System

## 🚀 Quick Start

This VS Code workspace is fully configured for Flutter development with our multi-flavor system. You can now easily run, debug, and build different app flavors directly from VS Code.

## 🎯 Launch Configurations

### Available Debug Configurations

Open the **Run and Debug** panel (`Cmd+Shift+D` on macOS, `Ctrl+Shift+D` on Windows/Linux) and select from:

#### 🟢 Development Flavor
- **🟢 Project Dev (Dev)** - Debug mode with full logging
- **🟢 Project Dev (Dev - Profile)** - Profile mode for performance testing
- **🟢 Project Dev (Dev - Android)** - Android-specific debug
- **🟢 Project Dev (Dev - iOS)** - iOS-specific debug

#### 🟠 Staging Flavor
- **🟠 Project Dev (Staging)** - Pre-production testing
- **🟠 Project Dev (Staging - Profile)** - Profile mode for staging

#### 🔴 Production Flavor
- **🔴 Project Dev (Production)** - Production environment
- **🔴 Project Dev (Production - Profile)** - Production profile mode
- **🔴 Project Dev (Production - Release)** - Full release build

#### 🎯 Default
- **🎯 Project Dev (Default)** - Uses main.dart (dev flavor)

### How to Use

1. **Select Configuration**: Click the dropdown next to the play button in the Run and Debug panel
2. **Start Debugging**: Press `F5` or click the play button
3. **Hot Reload**: Make changes and save - hot reload happens automatically
4. **Stop Debugging**: Press `Shift+F5` or click the stop button

## 🔧 Build Tasks

Access build tasks via **Terminal > Run Task** or `Cmd+Shift+P` > "Tasks: Run Task":

### 🏗️ Build Tasks
- **🟢 Build APK (Dev)** - Build Android APK for development
- **🟠 Build APK (Staging)** - Build Android APK for staging
- **🔴 Build APK (Production)** - Build Android APK for production
- **🍎 Build iOS (Dev/Staging/Production)** - Build iOS apps for each flavor

### 🚀 Quick Tasks
- **🚀 Quick Run (Dev)** - Start development app in terminal
- **🚀 Quick Run (Staging)** - Start staging app in terminal
- **📦 Get Dependencies** - Run `flutter pub get`
- **🧹 Clean Project** - Run `flutter clean`
- **🔍 Analyze Code** - Run `flutter analyze`
- **🧪 Run Tests** - Run `flutter test`

## 💡 Code Snippets

Type these prefixes in `.dart` files for quick code generation:

### Flavor Checking
- `flavor-check` → Check current flavor condition
- `flavor-config` → Access flavor configuration
- `flavor-watch` → Watch flavor providers with Riverpod

### Widgets & UI
- `flavor-widget` → Conditional widget based on flavor
- `flavor-banner` → Wrap widget with flavor banner
- `flavor-consumer` → Create ConsumerWidget with flavor access

### Development & Debugging
- `flavor-debug` → Debug print for debug-enabled flavors
- `flavor-info` → Print comprehensive flavor information
- `flavor-api` → Get flavor-specific API URL
- `flavor-feature` → Check feature flag

### Advanced
- `flavor-main` → Create new flavor entry point
- `flavor-network` → Create network provider with flavor-aware Dio

## ⚙️ Workspace Settings

The workspace includes optimized settings for Flutter development:

### 🎨 Editor Configuration
- Auto-formatting on save
- 80-character ruler for Dart files
- Bracket pair colorization
- Smart suggestions and completions

### 🔍 Search & Files
- Excluded build directories from search
- Hidden generated files (but kept `*.g.dart` visible)
- Optimized file associations

### 🐛 Debug Configuration
- Enhanced Flutter UI guides
- Widget error notifications
- Hot reload on save enabled
- Inspector notifications

### 📱 Flutter Specific
- Default dev flavor for quick runs
- Platform creation for Android & iOS
- Automatic dependency inclusion in workspace symbols

## 🎭 Flavor Environment Variables

The workspace sets default environment variables:
- `FLUTTER_FLAVOR=dev` - Default to development flavor

## 📁 Workspace Structure

```
.vscode/
├── launch.json          # Debug configurations for all flavors
├── tasks.json           # Build and utility tasks
├── settings.json        # Workspace-specific settings
├── extensions.json      # Recommended extensions
└── snippets/
    └── dart.json        # Flavor-specific code snippets
```

## 🎨 Recommended Extensions

The workspace recommends these extensions (install via **Extensions** panel):

### Core Flutter Development
- **Dart & Flutter** - Essential language support
- **Material Icon Theme** - Better file icons
- **Better Comments** - Enhanced comment styling

### Development Tools
- **GitLens** - Enhanced Git capabilities
- **TODO Tree** - Track TODO comments
- **Path Intellisense** - Auto-complete file paths
- **Coverage Gutters** - Test coverage visualization

### Code Quality
- **Code Spell Checker** - Catch typos
- **Auto Rename Tag** - Sync tag renaming
- **Prettier** - Code formatting

## 🔧 Troubleshooting

### Common Issues

**"Configuration not found"**
- Ensure you're in the correct workspace
- Check that all flavor entry files exist (`main_dev.dart`, etc.)

**"Flutter not found"**
- Set `dart.flutterSdkPath` in settings if needed
- Restart VS Code after Flutter installation

**"Hot reload not working"**
- Check that `dart.hotReloadOnSave` is set to "all"
- Save the file to trigger hot reload

**"Wrong flavor running"**
- Check the selected debug configuration
- Verify the correct `program` path in launch.json

### Performance Tips

1. **Close unused tabs** - Reduce memory usage
2. **Use specific build configurations** - Faster than generic builds
3. **Enable hot reload** - Faster development cycles
4. **Use profile mode** - For performance testing

## 🚀 Keyboard Shortcuts

### Debug Controls
- `F5` - Start debugging
- `Shift+F5` - Stop debugging
- `Ctrl+Shift+F5` - Restart debugging
- `F10` - Step over
- `F11` - Step into

### Flutter Specific
- `Cmd+.` (macOS) / `Ctrl+.` (Windows/Linux) - Quick fix
- `Cmd+Shift+P` - Command palette
- `Cmd+Shift+R` - Hot reload (manual)

### Tasks
- `Cmd+Shift+P` → "Tasks: Run Task" - Run build tasks
- `Cmd+J` - Toggle terminal panel

## 📱 Device Management

### Running on Different Devices

1. **Select Device**: Use the device selector in status bar
2. **Multiple Devices**: Each debug configuration can target specific platforms
3. **Emulator**: Start Android emulator or iOS simulator before debugging

### Platform-Specific Tips

**Android:**
- Use Android-specific launch configurations
- Check `android/app/build.gradle` for flavor configurations

**iOS:**
- Use iOS-specific launch configurations
- Ensure Xcode is properly configured
- Check iOS schemes for flavor support

## 🔄 Workflow Recommendations

### Daily Development
1. Open VS Code in project root
2. Select **🟢 Project Dev (Dev)** configuration
3. Press `F5` to start debugging
4. Make changes and save for hot reload

### Testing & QA
1. Use **🟠 Project Dev (Staging)** for feature testing
2. Use **Profile mode** configurations for performance testing
3. Run **🔍 Analyze Code** task before commits

### Release Preparation
1. Test with **🔴 Project Dev (Production)** configuration
2. Run **🔴 Build APK (Production)** task
3. Verify all features work without debug tools

## 📚 Additional Resources

- [Flutter VS Code Documentation](https://docs.flutter.dev/development/tools/vs-code)
- [Dart Language Features](https://dart.dev/guides/language/language-tour)
- [VS Code Flutter Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)

## 💡 Pro Tips

1. **Use Command Palette** (`Cmd+Shift+P`) to quickly access Flutter commands
2. **Customize Shortcuts** in VS Code settings for frequently used tasks
3. **Use Breakpoints** effectively with different flavor configurations
4. **Monitor Performance** using Profile mode configurations
5. **Keep Extensions Updated** for best development experience

---

Happy coding with your fully configured Project Dev development environment! 🍔✨