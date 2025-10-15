#!/bin/bash

# Project Dev App Flavor Runner Script
# Usage: ./run_flavor.sh [dev|staging|prod] [android|ios]

set -e

# Default values
FLAVOR="dev"
PLATFORM="android"

# Parse arguments
if [ $# -gt 0 ]; then
    FLAVOR=$1
fi

if [ $# -gt 1 ]; then
    PLATFORM=$2
fi

# Validate flavor
if [[ ! "$FLAVOR" =~ ^(dev|staging|prod)$ ]]; then
    echo "❌ Invalid flavor: $FLAVOR"
    echo "Valid flavors: dev, staging, prod"
    exit 1
fi

# Validate platform
if [[ ! "$PLATFORM" =~ ^(android|ios)$ ]]; then
    echo "❌ Invalid platform: $PLATFORM"
    echo "Valid platforms: android, ios"
    exit 1
fi

echo "🚀 Running Project Dev with flavor: $FLAVOR on platform: $PLATFORM"

# Set the main dart file based on flavor
case $FLAVOR in
    "dev")
        MAIN_FILE="lib/main_dev.dart"
        ;;
    "staging")
        MAIN_FILE="lib/main_staging.dart"
        ;;
    "prod")
        MAIN_FILE="lib/main_prod.dart"
        ;;
esac

# Run flutter with the specified configuration (without --flavor since we use different entry points)
if [ "$PLATFORM" == "android" ]; then
    flutter run -t $MAIN_FILE
elif [ "$PLATFORM" == "ios" ]; then
    flutter run -t $MAIN_FILE
fi

echo "✅ App started successfully!"