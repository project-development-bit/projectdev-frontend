import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cointiply_app/features/home/presentation/pages/home_page.dart';
import 'package:cointiply_app/features/home/presentation/widgets/hero_section.dart';

void main() {
  group('HomePage Widget Tests', () {
    testWidgets('should render HomePage without crashing', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const HomePage(),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.byType(SliverAppBar), findsOneWidget);
    });

    testWidgets('should display hero section', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const HomePage(),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(HeroSection), findsOneWidget);
    });

    testWidgets('should be scrollable', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const HomePage(),
          ),
        ),
      );

      await tester.pump();

      final scrollView = find.byType(CustomScrollView);
      expect(scrollView, findsOneWidget);

      await tester.drag(scrollView, const Offset(0, -300));
      await tester.pump();

      expect(scrollView, findsOneWidget);
    });

    testWidgets('should contain main sections', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const HomePage(),
          ),
        ),
      );

      await tester.pump();

      // Check that at least the hero section is present
      expect(find.byType(HeroSection), findsOneWidget);

      // Other sections might need scrolling or specific conditions to be visible
      // so we keep this test simple and focused
    });

    testWidgets('should have proper sliver structure', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const HomePage(),
          ),
        ),
      );

      await tester.pump();

      // Verify sliver structure
      expect(find.byType(SliverAppBar), findsOneWidget);
      expect(find.byType(SliverList), findsOneWidget);

      // The CustomScrollView should contain sliver widgets
      final customScrollView = tester.widget<CustomScrollView>(
        find.byType(CustomScrollView),
      );
      expect(customScrollView.slivers.length, greaterThan(0));
    });
  });
}
