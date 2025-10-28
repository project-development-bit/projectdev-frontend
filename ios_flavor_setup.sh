#!/bin/bash

# Script to add flavor build configurations to iOS Xcode project

PROJECT_DIR="/Users/saizayarhtet/burger_eats/project_dev_frontend"
PBXPROJ_FILE="$PROJECT_DIR/ios/Runner.xcodeproj/project.pbxproj"

echo "Adding iOS flavor build configurations..."

# First, let's create a backup
cp "$PBXPROJ_FILE" "$PBXPROJ_FILE.backup"

cd "$PROJECT_DIR"

# Use flutter tools to help create the configurations
echo "Running Flutter clean to ensure fresh build..."
flutter clean

echo "Running Flutter pub get..."
flutter pub get

echo "Attempting to build each flavor to trigger config creation..."

# This will attempt to create the configurations
flutter build ios --flavor dev -t lib/main_dev.dart --dry-run || true
flutter build ios --flavor staging -t lib/main_staging.dart --dry-run || true  
flutter build ios --flavor prod -t lib/main_prod.dart --dry-run || true

echo "iOS flavor configuration setup attempt completed."
echo "If you still get errors, you may need to manually create build configurations in Xcode."