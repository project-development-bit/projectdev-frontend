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

# Also replace already-embedded base64 (useful when index.html was previously patched)
pattern = re.compile(
    r"background-image:\s*url\('data:image/png;base64,([A-Za-z0-9+/=]{1000,})'\);"
)

match_index = 0

def _replace_embedded(match: re.Match[str]) -> str:
    global match_index
    replacement = splash_base64 if match_index == 0 else splash_mobile_base64
    match_index += 1
    return f"background-image: url('data:image/png;base64,{replacement}');"

html_content, replaced = pattern.subn(_replace_embedded, html_content)

if replaced not in (0, 2):
    print(
        f"⚠️ Warning: expected to replace 0 or 2 embedded base64 splash images, but replaced {replaced}."
    )

# Write updated file
with open('index.html', 'w') as f:
    f.write(html_content)

print("✅ Successfully embedded base64 images into index.html")
print("📦 Original file backed up as index.html.backup")
print(f"📊 Desktop splash size: {len(splash_base64):,} characters")
print(f"📊 Mobile splash size: {len(splash_mobile_base64):,} characters")
