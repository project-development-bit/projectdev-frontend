import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cointiply_app/features/home/providers/home_providers.dart';
import 'package:cointiply_app/features/home/models/offer_model.dart';
import 'package:cointiply_app/features/home/models/home_models.dart';

void main() {
  group('Home Providers Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('featuredOffersProvider', () {
      test('should provide default featured offers', () {
        // Act
        final offers = container.read(featuredOffersProvider);

        // Assert
        expect(offers, isA<List<OfferModel>>());
        expect(offers.length, greaterThan(0));
        expect(offers.any((offer) => offer.title == 'Time Master'), isTrue);
        expect(offers.any((offer) => offer.isHot), isTrue);
        expect(offers.every((offer) => offer.earning > 0), isTrue);
      });

      test('should contain offers with correct types', () {
        // Act
        final offers = container.read(featuredOffersProvider);

        // Assert
        expect(offers.any((offer) => offer.type == OfferType.game), isTrue);
        expect(offers.any((offer) => offer.type == OfferType.crypto), isTrue);
        expect(offers.every((offer) => offer.imageUrl.isNotEmpty), isTrue);
      });
    });

    group('offerWallsProvider', () {
      test('should provide default offer walls', () {
        // Act
        final offerWalls = container.read(offerWallsProvider);

        // Assert
        expect(offerWalls, isA<List<OfferWallModel>>());
        expect(offerWalls.length, greaterThan(0));
        expect(offerWalls.any((wall) => wall.name == 'AdGate Media'), isTrue);
        expect(offerWalls.every((wall) => wall.offerCount > 0), isTrue);
        expect(offerWalls.every((wall) => wall.rating >= 4.0), isTrue);
      });
    });

    group('testimonialsProvider', () {
      test('should provide default testimonials', () {
        // Act
        final testimonials = container.read(testimonialsProvider);

        // Assert
        expect(testimonials, isA<List<TestimonialModel>>());
        expect(testimonials.length, greaterThan(0));
        expect(testimonials.every((t) => t.earning > 0), isTrue);
        expect(testimonials.every((t) => t.level > 0), isTrue);
        expect(testimonials.every((t) => t.message.isNotEmpty), isTrue);
      });
    });

    group('platformStatsProvider', () {
      test('should provide valid platform statistics', () {
        // Act
        final stats = container.read(platformStatsProvider);

        // Assert
        expect(stats, isA<PlatformStatsModel>());
        expect(stats.fastestPayoutTime, isNotEmpty);
        expect(stats.averageEarnings, greaterThan(0));
        expect(stats.countriesCount, greaterThan(0));
        expect(stats.totalUsers, greaterThan(0));
      });
    });

    group('numerical providers', () {
      test('highestPayoutProvider should return valid amount', () {
        // Act
        final highestPayout = container.read(highestPayoutProvider);

        // Assert
        expect(highestPayout, greaterThan(0));
        expect(highestPayout, 596.0);
      });

      test('totalOffersProvider should return valid count', () {
        // Act
        final totalOffers = container.read(totalOffersProvider);

        // Assert
        expect(totalOffers, greaterThan(0));
        expect(totalOffers, 2836);
      });

      test('welcomeBonusProvider should return valid amount', () {
        // Act
        final welcomeBonus = container.read(welcomeBonusProvider);

        // Assert
        expect(welcomeBonus, greaterThan(0));
        expect(welcomeBonus, 500.0);
      });
    });

    group('user state providers', () {
      test('isLoggedInProvider should default to false', () {
        // Act
        final isLoggedIn = container.read(isLoggedInProvider);

        // Assert
        expect(isLoggedIn, isFalse);
      });

      test('lastPayoutProvider should provide valid payout info', () {
        // Act
        final lastPayout = container.read(lastPayoutProvider);

        // Assert
        expect(lastPayout, isA<Map<String, dynamic>>());
        expect(lastPayout['amount'], isA<double>());
        expect(lastPayout['timeAgo'], isA<String>());
        expect(lastPayout['amount'], greaterThan(0));
        expect(lastPayout['timeAgo'], isNotEmpty);
      });
    });
  });
}