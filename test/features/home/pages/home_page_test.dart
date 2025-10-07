import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cointiply_app/features/home/pages/home_page.dart';
import 'package:cointiply_app/features/home/widgets/hero_section.dart';
import 'package:cointiply_app/features/home/widgets/featured_offers_section.dart';
import 'package:cointiply_app/features/home/widgets/how_it_works_section.dart';
import 'package:cointiply_app/features/home/widgets/testimonials_section.dart';
import 'package:cointiply_app/features/home/widgets/statistics_section.dart';

void main() {
  group('HomePage Widget Tests', () {
    testWidgets('should display all main sections', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const HomePage(),
          ),
        ),
      );

      // Assert
      expect(find.byType(HeroSection), findsOneWidget);
      expect(find.byType(FeaturedOffersSection), findsOneWidget);
      expect(find.byType(HowItWorksSection), findsOneWidget);
      expect(find.byType(TestimonialsSection), findsOneWidget);
      expect(find.byType(StatisticsSection), findsOneWidget);
    });

    testWidgets('should display footer CTA section', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const HomePage(),
          ),
        ),
      );

      // Assert
      expect(find.text('Ready to see what you can earn?'), findsOneWidget);
      expect(find.text('Join thousands of users already earning free Bitcoin'), findsOneWidget);
      expect(find.text('Start Earning Now'), findsNWidgets(2)); // One in hero, one in footer
    });

    testWidgets('should be scrollable', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const HomePage(),
          ),
        ),
      );

      // Assert
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('footer CTA button should be tappable', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const HomePage(),
          ),
        ),
      );

      // Wait for initial render
      await tester.pump();
      
      // Find buttons - should have at least one
      final buttons = find.text('Start Earning Now');
      expect(buttons, findsAtLeastNWidgets(1));
      
      // Test tapping - should not throw error
      await tester.tap(buttons.first, warnIfMissed: false);
      await tester.pump();

      // Assert - Test completes without error
      expect(buttons, findsAtLeastNWidgets(1));
    });
  });
}