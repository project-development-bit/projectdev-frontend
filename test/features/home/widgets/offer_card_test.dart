import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cointiply_app/features/home/widgets/offer_card.dart';
import 'package:cointiply_app/features/home/models/offer_model.dart';

void main() {
  group('OfferCard Widget Tests', () {
    const testOffer = OfferModel(
      id: '1',
      title: 'Test Game',
      description: 'Test game description for testing purposes',
      earning: 25.50,
      imageUrl: 'https://example.com/image.jpg',
      type: OfferType.game,
      duration: 'Multi Day',
      isHot: true,
      rating: 4.5,
    );

    testWidgets('should display offer information correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OfferCard(offer: testOffer),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Game'), findsOneWidget);
      expect(find.text('Test game description for testing purposes'), findsOneWidget);
      expect(find.text('\$25.50'), findsOneWidget);
      expect(find.text('Multi Day'), findsOneWidget);
      expect(find.text('Game'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
    });

    testWidgets('should display HOT badge when offer is hot', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OfferCard(offer: testOffer),
          ),
        ),
      );

      // Assert
      expect(find.text('HOT'), findsOneWidget);
    });

    testWidgets('should not display HOT badge when offer is not hot', (WidgetTester tester) async {
      // Arrange
      const normalOffer = OfferModel(
        id: '2',
        title: 'Normal Game',
        description: 'Normal game description',
        earning: 15.00,
        imageUrl: 'https://example.com/image.jpg',
        type: OfferType.game,
        isHot: false,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OfferCard(offer: normalOffer),
          ),
        ),
      );

      // Assert
      expect(find.text('HOT'), findsNothing);
    });

    testWidgets('should display progress bar when showProgress is true and progress is available', (WidgetTester tester) async {
      // Arrange
      const offerWithProgress = OfferModel(
        id: '3',
        title: 'Progress Game',
        description: 'Game with progress',
        earning: 30.00,
        imageUrl: 'https://example.com/image.jpg',
        type: OfferType.game,
        progress: 75.0,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OfferCard(
              offer: offerWithProgress,
              showProgress: true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('75% Complete'), findsOneWidget);
    });

    testWidgets('should call onTap when card is tapped', (WidgetTester tester) async {
      // Arrange
      bool tapped = false;
      void onTap() {
        tapped = true;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OfferCard(
              offer: testOffer,
              onTap: onTap,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(OfferCard));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets('should display correct button text based on showProgress', (WidgetTester tester) async {
      // Test with showProgress false
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OfferCard(
              offer: testOffer,
              showProgress: false,
            ),
          ),
        ),
      );

      expect(find.text('Start Offer'), findsOneWidget);

      // Test with showProgress true
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OfferCard(
              offer: testOffer,
              showProgress: true,
            ),
          ),
        ),
      );

      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('should display rating when available', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OfferCard(offer: testOffer),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
    });

    testWidgets('should handle offers without rating', (WidgetTester tester) async {
      // Arrange
      const offerWithoutRating = OfferModel(
        id: '4',
        title: 'No Rating Game',
        description: 'Game without rating',
        earning: 20.00,
        imageUrl: 'https://example.com/image.jpg',
        type: OfferType.game,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OfferCard(offer: offerWithoutRating),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.star), findsNothing);
    });
  });
}