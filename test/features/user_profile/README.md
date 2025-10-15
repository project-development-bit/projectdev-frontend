# User Profile Test Documentation

This directory contains comprehensive tests for the refactored user profile feature, following clean architecture principles.

## Test Structure

```
test/features/user_profile/
├── profile_test_data.dart          # Mock data factory for profile tests
├── pages/
│   └── profile_page_test.dart      # Tests for main ProfilePage (simplified)
└── widgets/
    ├── profile_header_widget_test.dart           # ProfileHeaderWidget tests
    ├── balances_section_widget_test.dart         # BalancesSectionWidget tests
    ├── profile_navigation_widget_test.dart       # (To be created)
    ├── level_rewards_section_widget_test.dart    # (To be created)
    ├── achievement_badges_section_widget_test.dart # (To be created)
    ├── profile_details_section_widget_test.dart  # (To be created)
    └── profile_state_widgets_test.dart           # (To be created)
```

## Test Coverage

### Completed Tests

#### ProfileTestData Factory ✅
- Mock UserProfile creation with various scenarios
- Test profile states (loading, error, success, empty)
- Different user types (new user, premium user)
- Configurable stats and profile data

#### ProfileHeaderWidget Tests ✅
- Widget structure and layout
- Profile data display (name, username, level, XP)
- Avatar handling (with/without image)
- Level badge and experience display
- Theme responsiveness (light/dark)
- Layout behavior and accessibility
- Text styling and spacing

#### BalancesSectionWidget Tests ✅
- Earnings display and formatting
- Null safety handling
- Theme adaptation
- Edge cases (negative, zero, small amounts)
- Responsive design

### In Progress Tests

#### ProfilePage Tests (Simplified) 🔄
- Basic structure and navigation tests
- State management tests simplified due to provider complexity
- Focus on UI composition rather than state mocking

### Pending Tests (To Be Created)

#### Individual Widget Tests 📋
- ProfileNavigationWidget
- LevelRewardsSectionWidget  
- AchievementBadgesSectionWidget
- ProfileDetailsSectionWidget
- ProfileStateWidgets (loading, error, empty)

## Testing Patterns

### 1. Widget Factory Pattern
```dart
Widget buildWidget({CustomParams? params}) {
  return TestAppWrapper(
    child: WidgetUnderTest(
      param: params ?? defaultValue,
    ),
  );
}
```

### 2. Test Data Factory
```dart
final testProfile = ProfileTestData.createTestProfile(
  displayName: 'Custom Name',
  stats: ProfileTestData.createTestStats(totalEarnings: 1000.0),
);
```

### 3. Theme Testing
```dart
testWidgets('adapts to light/dark theme', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData.light(), // or .dark()
      home: WidgetUnderTest(),
    ),
  );
});
```

### 4. Edge Case Testing
```dart
group('Edge Cases', () {
  testWidgets('handles null data gracefully', (tester) async {
    final profileWithNullStats = ProfileTestData.createTestProfile(stats: null);
    // Test widget handles null gracefully
  });
});
```

## Running Tests

### Run All Profile Tests
```bash
flutter test test/features/user_profile/
```

### Run Specific Widget Tests
```bash
flutter test test/features/user_profile/widgets/profile_header_widget_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage test/features/user_profile/
```

## Test Principles

### 1. **Isolation**
- Each widget tested independently
- Mock dependencies through TestAppWrapper
- No external API calls in tests

### 2. **Comprehensive Coverage**
- Widget structure verification
- Data display validation
- Theme responsiveness
- Edge case handling
- Accessibility considerations

### 3. **Clean Test Code**
- Descriptive test names
- Grouped related tests
- Reusable test utilities
- Clear arrange-act-assert pattern

### 4. **Maintainability**
- Test data factories for consistency
- Helper methods for common operations
- Documentation for complex test scenarios

## Test Data Scenarios

### Profile Types
- **New User**: Minimal stats, level 1
- **Regular User**: Standard stats and progress
- **Premium User**: High stats, advanced level
- **User Without Image**: Tests default avatar handling
- **User with Null Stats**: Tests fallback scenarios

### Profile States
- **Loading**: Shows loading indicators
- **Success**: Displays profile data
- **Error**: Shows error messages with retry
- **Empty**: Handles missing profile gracefully

## Known Limitations

### Provider Testing Complexity
- Direct provider mocking is complex with StateNotifier
- Simplified to focus on UI behavior rather than state management
- Integration tests handle end-to-end state flows

### Network Image Testing
- Mock network images in test environment
- Focus on image presence/absence rather than actual loading
- Use test-specific image URLs

## Next Steps

1. **Complete Remaining Widget Tests**
   - Create tests for all 7 extracted widgets
   - Follow established patterns and coverage areas

2. **Integration Testing**
   - Add tests for widget interactions
   - Test navigation callbacks
   - Verify state propagation

3. **Performance Testing**
   - Widget rebuild optimization
   - Memory usage validation
   - Rendering performance

4. **Accessibility Testing**
   - Screen reader compatibility
   - Touch target sizes
   - Color contrast validation