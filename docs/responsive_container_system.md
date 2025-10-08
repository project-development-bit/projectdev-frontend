# Responsive Container System

## Overview

This project now includes a Bootstrap-like responsive container system that limits content width for better readability and visual hierarchy on larger screens.

## Components

### 1. ResponsiveContainer

A widget that constrains content width based on screen size breakpoints:

**Breakpoints:**
- **Mobile**: Full width with 16px horizontal padding (when `fullWidthOnMobile: true`)
- **Mobile (constrained)**: Screen width - 32px margins
- **Tablet**: 768px max width
- **Desktop Small**: 1140px max width (≤1200px screens)
- **Desktop Medium**: 1320px max width (≤1400px screens)  
- **Desktop Large**: 1400px max width (>1400px screens)

**Usage:**
```dart
ResponsiveContainer(
  child: YourContent(),
  maxWidth: 1200, // Optional custom max width
  fullWidthOnMobile: true, // Default: true
  padding: EdgeInsets.symmetric(horizontal: 16),
)
```

### 2. ResponsiveSection

A higher-level widget that combines background styling with responsive containers:

**Features:**
- Full-width background colors/styling
- Constrained content width
- Consistent vertical padding
- Easy-to-use API

**Usage:**
```dart
ResponsiveSection(
  backgroundColor: Colors.blue.shade50,
  padding: EdgeInsets.symmetric(vertical: 40),
  child: YourContent(),
)
```

## Implementation

All home page sections have been updated to use `ResponsiveSection`:

### Before:
```dart
Container(
  width: double.infinity,
  padding: EdgeInsets.symmetric(
    horizontal: context.isMobile ? 16 : 32,
    vertical: 40,
  ),
  child: content,
)
```

### After:
```dart
ResponsiveSection(
  padding: EdgeInsets.symmetric(vertical: 40),
  child: content,
)
```

## Benefits

1. **Improved Readability**: Content doesn't stretch across ultra-wide screens
2. **Better Visual Hierarchy**: Clear content boundaries
3. **Responsive Design**: Adapts to different screen sizes
4. **Consistent Spacing**: Standardized horizontal margins
5. **Maintainable**: Centralized responsive logic
6. **Bootstrap-like**: Familiar container behavior

## Updated Sections

All home page sections now use responsive containers:
- ✅ **HeroSection**: Uses `ResponsiveContainer` with gradient background
- ✅ **FeaturedOffersSection**: Uses `ResponsiveSection`
- ✅ **HowItWorksSection**: Uses `ResponsiveSection` with surface background
- ✅ **OfferWallsSection**: Uses `ResponsiveSection` with container background  
- ✅ **TestimonialsSection**: Uses `ResponsiveSection`
- ✅ **StatisticsSection**: Uses `ResponsiveSection` with container background

## Visual Result

- **Mobile**: Content uses full width with appropriate padding
- **Tablet**: Content is centered with 768px max width
- **Desktop**: Content is centered with 1140px-1400px max width
- **Ultra-wide**: Content doesn't stretch beyond comfortable reading width

The system provides a professional, modern layout that improves user experience across all device sizes while maintaining the visual impact of full-width background colors and gradients.