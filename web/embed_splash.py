#!/usr/bin/env python3
import re

# Read base64 content
with open('splash_base64.txt', 'r') as f:
    splash_base64 = f.read().strip()

with open('splash_mobile_base64.txt', 'r') as f:
    splash_mobile_base64 = f.read().strip()

# Read index.html
with open('index.html', 'r') as f:
    html_content = f.read()

# Backup
with open('index.html.backup', 'w') as f:
    f.write(html_content)

# Replace desktop splash
html_content = html_content.replace(
    "background-image: url('splash_background.png');",
    f"background-image: url('data:image/png;base64,{splash_base64}');"
)

# Replace mobile splash
html_content = html_content.replace(
    "background-image: url('splash_background_mobile.png');",
    f"background-image: url('data:image/png;base64,{splash_mobile_base64}');"
)

# Write updated file
with open('index.html', 'w') as f:
    f.write(html_content)

print("✅ Successfully embedded base64 images into index.html")
print("📦 Original file backed up as index.html.backup")
print(f"📊 Desktop splash size: {len(splash_base64):,} characters")
print(f"📊 Mobile splash size: {len(splash_mobile_base64):,} characters")
