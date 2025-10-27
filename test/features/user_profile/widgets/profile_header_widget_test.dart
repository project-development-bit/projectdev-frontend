import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/profile_header_widget.dart';
import 'package:cointiply_app/features/user_profile/domain/entities/user_profile.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import '../../../test_helpers/test_app_wrapper.dart';
import '../profile_test_data.dart';

void main() {
  group('ProfileHeaderWidget Tests', () {
    late UserProfile testProfile;

    setUp(() {
      testProfile = ProfileTestData.createTestProfile();
    });

    Widget buildProfileHeader({UserProfile? profile}) {
      return TestAppWrapper(
        child: ProfileHeaderWidget(
          profile: profile ?? testProfile,
        ),
      );
    }

    group('Widget Structure', () {
      testWidgets('renders main container with gradient background',
          (tester) async {
        await tester.pumpWidget(buildProfileHeader());
        await tester.pumpAndSettle();

        expect(find.byType(Container), findsWidgets);
        expect(find.byType(ProfileHeaderWidget), findsOneWidget);

        // Check gradient container exists
        final containers = tester.widgetList<Container>(find.byType(Container));
        final gradientContainer = containers.any((container) =>
            container.decoration != null &&
            (container.decoration as BoxDecoration?)?.gradient != null);
        expect(gradientContainer, isTrue);
      });

      testWidgets('displays user information in row layout', (tester) async {
        await tester.pumpWidget(buildProfileHeader());
        await tester.pumpAndSettle();

        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(Expanded), findsOneWidget);
      });
    });

    group('Profile Data Display', () {
      testWidgets('shows user display name correctly', (tester) async {
        final customProfile = ProfileTestData.createTestProfile(
          displayName: 'Custom Display Name',
        );

        await tester.pumpWidget(buildProfileHeader(profile: customProfile));
        await tester.pumpAndSettle();

        expect(find.text('Custom Display Name'), findsOneWidget);
      });

      testWidgets('falls back to username when display name is null',
          (tester) async {
        // Create a profile where we specifically pass null for displayName
        final profile = UserProfile(
          id: 'test-id',
          email: 'test@example.com',
          username: 'customuser',
          displayName: null, // Explicitly null
          profilePictureUrl: null,
          bio: 'Test bio',
          location: 'Test City',
          website: 'https://test.com',
          contactNumber: '+1234567890',
          dateOfBirth: DateTime(1990, 1, 1),
          gender: 'Other',
          accountCreated: DateTime(2022, 1, 1),
          lastLogin: DateTime.now(),
          accountStatus: AccountStatus.active,
          verificationStatus: VerificationStatus.verified,
          isEmailVerified: true,
          isPhoneVerified: true,
          stats: ProfileTestData.createTestStats(),
        );

        await tester.pumpWidget(buildProfileHeader(profile: profile));
        await tester.pumpAndSettle();

        // The widget logic shows displayName ?? username, so it should show the username
        expect(find.text('customuser'), findsOneWidget);
      });

      testWidgets('shows current level badge', (tester) async {
        await tester.pumpWidget(buildProfileHeader());
        await tester.pumpAndSettle();

        final level = testProfile.stats!.currentLevel;
        expect(find.textContaining('Level $level'), findsOneWidget);
      });

      testWidgets('shows experience points', (tester) async {
        await tester.pumpWidget(buildProfileHeader());
        await tester.pumpAndSettle();

        expect(find.textContaining('XP:'), findsOneWidget);
      });
    });

    group('Avatar Display', () {
      testWidgets('shows default person icon when no profile picture',
          (tester) async {
        final profileWithoutImage = ProfileTestData.createTestProfile(
          profilePictureUrl: null,
        );

        await tester
            .pumpWidget(buildProfileHeader(profile: profileWithoutImage));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.person), findsOneWidget);
      });

      testWidgets('has circular avatar container', (tester) async {
        await tester.pumpWidget(buildProfileHeader());
        await tester.pumpAndSettle();

        // Verify circular container exists
        final containers = tester.widgetList<Container>(find.byType(Container));
        final avatarContainer = containers.any((container) =>
            container.decoration != null &&
            (container.decoration as BoxDecoration?)?.shape == BoxShape.circle);
        expect(avatarContainer, isTrue);
      });
    });

    group('Level and Experience Display', () {
      testWidgets('displays level badge with rounded corners', (tester) async {
        await tester.pumpWidget(buildProfileHeader());
        await tester.pumpAndSettle();

        // Find containers with border radius (level badge)
        final containers = tester.widgetList<Container>(find.byType(Container));
        final levelBadgeExists = containers.any((container) =>
            container.decoration != null &&
            (container.decoration as BoxDecoration?)?.borderRadius != null);
        expect(levelBadgeExists, isTrue);
      });

      testWidgets('handles stats with default values when null',
          (tester) async {
        final profileWithoutStats = ProfileTestData.createTestProfile(
          stats: null,
        );

        await tester
            .pumpWidget(buildProfileHeader(profile: profileWithoutStats));
        await tester.pumpAndSettle();

        // Widget should handle null stats gracefully
        expect(find.textContaining('Level'), findsOneWidget);
        expect(find.textContaining('XP:'), findsOneWidget);
      });
    });

    group('Theme Responsiveness', () {
      testWidgets('adapts to light theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: ProfileHeaderWidget(profile: testProfile),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ProfileHeaderWidget), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('adapts to dark theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: ProfileHeaderWidget(profile: testProfile),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ProfileHeaderWidget), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('Layout and Styling', () {
      testWidgets('uses CommonText components for typography', (tester) async {
        await tester.pumpWidget(buildProfileHeader());
        await tester.pumpAndSettle();

        // Verify CommonText widgets are used for text styling
        expect(find.byType(CommonText), findsWidgets);
      });

      testWidgets('maintains consistent spacing', (tester) async {
        await tester.pumpWidget(buildProfileHeader());
        await tester.pumpAndSettle();

        // Verify spacing widgets are present
        expect(find.byType(SizedBox), findsWidgets);
        expect(find.byType(Padding),
            findsWidgets); // Multiple padding widgets expected
      });

      testWidgets('no layout overflow errors', (tester) async {
        await tester.pumpWidget(buildProfileHeader());
        await tester.pumpAndSettle();

        // Verify no overflow errors occurred
        expect(tester.takeException(), isNull);
      });
    });
  });
}
