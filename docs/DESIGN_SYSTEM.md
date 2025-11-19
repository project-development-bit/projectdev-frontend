# Gigafaucet App Design System

This document describes the comprehensive design system for the Gigafaucet app, extracted from the website at https://doc.gigafaucet.com/doc/.

## Color Palette

### Primary Colors (Website Brand Colors)
Based on the actual Gigafaucet website color scheme:

- **Primary Orange**: `#E8631C` - Main brand color from the website
- **Primary Dark**: `#CF7A11` - Darker orange variant
- **Primary Light**: `#E6A030` - Lighter orange/gold variant
- **Website Gold**: `#E6A030` - Gold color for rewards and highlights

### Website-Specific Colors
Colors extracted directly from the Gigafaucet website:

- **Background Dark**: `#050317` - Main dark background
- **Background Start**: `#191921` - Gradient start color
- **Background End**: `#050317` - Gradient end color
- **Card Background**: `#313144` - Card and component backgrounds
- **Border Color**: `#2C2C38` - Borders and dividers
- **Text Color**: `#9692BC` - Primary text color on dark backgrounds
- **Accent Red**: `#B0251A` - Red accent color for alerts and highlights

### Status Colors
- **Success**: `#4CAF50` - Green for positive actions
- **Warning**: `#E6A030` - Orange/gold for warnings (matches website gold)
- **Error**: `#B0251A` - Red for errors (matches website accent)

### Cryptocurrency Colors
- **Bitcoin**: `#F7931A` - Bitcoin orange
- **Ethereum**: `#627EEA` - Ethereum blue  
- **Gold Reward**: `#E6A030` - Gold color for rewards
- **Silver Reward**: `#9692BC` - Silver color using website text color

## Typography

### Font Families
Based on the Gigafaucet website font usage:

#### Title/Header Font: **Orbitron**
- Used for: Titles, captions, headers, buttons, crypto amounts
- Source: Google Fonts
- Character: Futuristic, tech-inspired, clean geometric design
- Usage: Headlines, button labels, crypto displays, important text

#### Body Font: **Inter**
- Used for: Normal text, body content, descriptions
- Source: Google Fonts
- Character: Clean, modern, highly readable sans-serif
- Usage: Body content, paragraphs, captions, secondary text

#### Monospace Font: **Roboto Mono**
- Used for: Addresses, codes, technical information
- Source: Google Fonts
- Character: Monospaced for technical accuracy
- Usage: Wallet addresses, transaction IDs, API responses

### Typography Scale

#### Display Styles (Orbitron)
- **Display Large**: 57px, 700 weight, -0.25 letter-spacing
- **Display Medium**: 45px, 600 weight, 0 letter-spacing  
- **Display Small**: 36px, 600 weight, 0 letter-spacing

#### Headline Styles (Orbitron)
- **Headline Large**: 32px, 600 weight, 0 letter-spacing
- **Headline Medium**: 28px, 600 weight, 0 letter-spacing
- **Headline Small**: 24px, 600 weight, 0 letter-spacing

#### Title Styles (Orbitron)
- **Title Large**: 22px, 500 weight, 0 letter-spacing
- **Title Medium**: 16px, 500 weight, 0.15 letter-spacing
- **Title Small**: 14px, 500 weight, 0.1 letter-spacing

#### Body Styles (Inter)
- **Body Large**: 16px, 400 weight, 0.5 letter-spacing
- **Body Medium**: 14px, 400 weight, 0.25 letter-spacing
- **Body Small**: 12px, 400 weight, 0.4 letter-spacing

#### Label Styles (Orbitron)
- **Label Large**: 14px, 500 weight, 0.1 letter-spacing
- **Label Medium**: 12px, 500 weight, 0.5 letter-spacing
- **Label Small**: 11px, 500 weight, 0.5 letter-spacing

### Special Typography Effects

#### Crypto Display Text
- Font: Orbitron, 32px, 700 weight
- Color: Website Gold (`#E6A030`)
- Effects: Drop shadow, letter-spacing 1.0
- Usage: Large cryptocurrency amounts, rewards

#### Crypto Amount Text
- Font: Orbitron, 24px, 700 weight
- Color: Primary Light (`#E6A030`)
- Effects: Letter-spacing 0.5
- Usage: Numeric values, balances

#### Button Text
- Font: Orbitron, 16px, 600 weight
- Color: White or contrasting color
- Effects: Letter-spacing 0.5
- Usage: All button labels

#### Website-Style Effects
- **Glow Effect**: Subtle shadow with primary color
- **Website Shadow**: 2px offset, 4px blur, black 26% opacity
- **Gradient Text**: Linear gradient from primary light to primary

## Theme Implementation

### Light Theme
- Uses website colors adapted for light backgrounds
- Primary orange maintained for brand consistency
- Clean, accessible color contrasts

### Dark Theme (Website Style)
- Direct implementation of website color scheme
- Dark backgrounds with website gradients
- Website-specific card styling with borders
- Maintains website visual identity

### Component Styling

#### Cards
- Background: Website card color (`#313144`)
- Border: Website border color with opacity
- Shadow: Enhanced shadow for depth
- Border radius: 16px for modern feel

#### Buttons
- Primary: Website orange with white text
- Outlined: Website orange border with orange text
- Elevated shadow with website colors

#### Input Fields
- Background: Website card color
- Border: Website border color
- Focus: Primary orange border
- Rounded corners (12px) for consistency

#### Navigation
- AppBar: Website card background
- Text: White for contrast
- Icons: White theme

## Usage Guidelines

### When to Use Primary Colors
- **Primary Orange (`#E8631C`)**: Main actions, branding, CTAs
- **Website Gold (`#E6A030`)**: Rewards, achievements, success states
- **Primary Dark (`#CF7A11`)**: Hover states, pressed buttons

### When to Use Website Colors
- **Card Background (`#313144`)**: Component backgrounds
- **Website Text (`#9692BC`)**: Secondary text, descriptions
- **Website Accent (`#B0251A`)**: Alerts, important warnings
- **Website Border (`#2C2C38`)**: Dividers, card borders

### Typography Usage
- **Orbitron**: Titles, headers, buttons, labels, crypto amounts
- **Inter**: Body text, descriptions, captions, normal content
- **Roboto Mono**: Technical information, addresses, codes only

### Accessibility
- All color combinations meet WCAG 2.1 AA standards
- High contrast maintained throughout
- Text shadows provide additional readability
- Focus indicators clearly visible

## Development Tools

### Color Palette Showcase
```dart
// Use this widget to view all colors during development
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ColorPaletteShowcase(),
  ),
);
```

### Typography Testing
```dart
// Examples of proper typography usage with CommonText
CommonText.cryptoDisplay('Crypto Rewards')
CommonText.cryptoAmount('1,000')
CommonText.titleLarge('Page Title') // Uses Orbitron
CommonText.bodyMedium('Body content') // Uses Inter
CommonText.button('Click Me') // Uses Orbitron for buttons
```

### Theme Application
```dart
// Apply the theme in MaterialApp
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  // ... other properties
)
```

## File Structure

```
lib/core/theme/
├── app_colors.dart       # Complete color palette
├── app_typography.dart   # Typography system
├── app_theme.dart       # Theme configuration
└── ../widgets/
    └── color_palette_showcase.dart  # Development tool
```

This design system ensures visual consistency with the Gigafaucet website while providing a comprehensive foundation for the Flutter app.