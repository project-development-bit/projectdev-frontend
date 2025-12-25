#!/bin/bash

# Read base64 files
SPLASH_BASE64=$(cat splash_base64.txt | tr -d '\n')
SPLASH_MOBILE_BASE64=$(cat splash_mobile_base64.txt | tr -d '\n')

# Backup original index.html
cp index.html index.html.backup

# Replace the desktop splash background URL
sed -i '' "s|background-image: url('splash_background.png');|background-image: url('data:image/png;base64,${SPLASH_BASE64}');|g" index.html

# Replace the mobile splash background URL  
sed -i '' "s|background-image: url('splash_background_mobile.png');|background-image: url('data:image/png;base64,${SPLASH_MOBILE_BASE64}');|g" index.html

echo "✅ Successfully embedded base64 images into index.html"
echo "📦 Original file backed up as index.html.backup"
