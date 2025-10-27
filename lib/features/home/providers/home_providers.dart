import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/offer_model.dart';
import '../models/home_models.dart';

/// Provider for featured offers
final featuredOffersProvider = StateProvider<List<OfferModel>>((ref) {
  return [
    const OfferModel(
      id: '1',
      title: 'Time Master',
      description:
          'Become a Coin Master! Travel to unique islands, spin the slot machine & collect gold coins in Time Master!',
      earning: 185.89,
      imageUrl:
          'https://cdn.mychips.io/thumbnail/5a19234a88ed2629d38cc16f2fcfacb3.jpg',
      type: OfferType.game,
      duration: 'Multi Day',
      isHot: true,
      rating: 4.8,
    ),
    const OfferModel(
      id: '2',
      title: 'Ever Legion',
      description:
          'Dive into a dark fantasy world in Ever Legion! Summon epic heroes, battle undead hordes, and conquer powerful foes!',
      earning: 96.96,
      imageUrl:
          'https://cdn.mychips.io/thumbnail/29db928e62479b3b103b75c148e3c0b7.png',
      type: OfferType.game,
      duration: 'Multi Day',
      rating: 4.7,
    ),
    const OfferModel(
      id: '3',
      title: 'Survivor Idle Run',
      description: 'Complete Quests one after another to progress',
      earning: 178.66,
      imageUrl:
          'https://cdn.mychips.io/thumbnail/abe7009045453de4c9555aff3825f02c.png',
      type: OfferType.game,
      duration: 'Multi Day',
      rating: 4.6,
    ),
    const OfferModel(
      id: '4',
      title: 'Travel Stories: Merge Journey',
      description:
          'Embark on an unforgettable journey in the captivating merge puzzle game, "Tales of Travel".',
      earning: 54.13,
      imageUrl:
          'https://cdn.mychips.io/thumbnail/bda29a3bc32a90ac968ea3bb58644398.png',
      type: OfferType.game,
      duration: 'Multi Day',
      rating: 4.7,
    ),
    const OfferModel(
      id: '5',
      title: 'Merge Designer - Decor & Story',
      description:
          'Become an excellent designer & have fun! Merge items and decorate your dream house.',
      earning: 53.63,
      imageUrl:
          'https://cdn.mychips.io/thumbnail/3aa170e9e0a37c82cd79236d7e4837b0.png',
      type: OfferType.game,
      duration: 'Multi Day',
      rating: 4.5,
    ),
    const OfferModel(
      id: '6',
      title: 'Crypto.com',
      description:
          'Experience Seamless Crypto Trading on Crypto.com and Grab a chance to win 1 Bitcoin.',
      earning: 36.16,
      imageUrl:
          'https://cdn.mychips.io/thumbnail/29db928e62479b3b103b75c148e3c0b7.png',
      type: OfferType.crypto,
      duration: 'Multi Day',
      rating: 4.3,
    ),
  ];
});

/// Provider for offer walls
final offerWallsProvider = StateProvider<List<OfferWallModel>>((ref) {
  return [
    const OfferWallModel(
      id: '1',
      name: 'AdGate Media',
      code: 'AM',
      offerCount: 1245,
      averagePayout: 15.50,
      rating: 4.8,
      logoUrl: 'https://cointiply.com/img/partners/adgatemedia-bw-240x60.png',
    ),
    const OfferWallModel(
      id: '2',
      name: 'Torox',
      code: 'TX',
      offerCount: 892,
      averagePayout: 22.30,
      rating: 4.6,
      logoUrl: 'https://cointiply.com/img/partners/offertoro-bw-240x60.png',
    ),
    const OfferWallModel(
      id: '3',
      name: 'Adscend Media',
      code: 'AS',
      offerCount: 1567,
      averagePayout: 12.80,
      rating: 4.9,
      logoUrl: 'https://cointiply.com/img/partners/adscendmedia-bw-240x60.png',
    ),
    const OfferWallModel(
      id: '4',
      name: 'AdGem',
      code: 'AG',
      offerCount: 743,
      averagePayout: 18.90,
      rating: 4.7,
      logoUrl: 'https://cointiply.com/img/partners/adgem-bw-240x60.png',
    ),
    const OfferWallModel(
      id: '5',
      name: 'Theorem Reach',
      code: 'TR',
      offerCount: 456,
      averagePayout: 2.56,
      rating: 4.5,
      logoUrl: 'https://cointiply.com/img/partners/theorem-reach-bw-240x60.png',
    ),
    const OfferWallModel(
      id: '6',
      name: 'CPX Research',
      code: 'CX',
      offerCount: 678,
      averagePayout: 5.25,
      rating: 4.5,
      logoUrl: 'https://cointiply.com/img/partners/cpx-research-bw-240x60.png',
    ),
  ];
});

/// Provider for user testimonials
final testimonialsProvider = StateProvider<List<TestimonialModel>>((ref) {
  return [
    const TestimonialModel(
      id: '1',
      username: 'Sarah M.',
      level: 72,
      badge: '🥇',
      message: 'Made \$112 in 3 days. Didn\'t believe it at first.',
      timeAgo: '2m ago',
      earning: 112.0,
    ),
    const TestimonialModel(
      id: '2',
      username: 'Jamal R.',
      level: 45,
      badge: '🎯',
      message: 'Easy as watching videos. Crypto hits fast.',
      timeAgo: '5m ago',
      earning: 89.5,
    ),
    const TestimonialModel(
      id: '3',
      username: 'Mike T.',
      level: 58,
      badge: '🚀',
      message: 'Best side hustle I\'ve found. Already cashed out twice!',
      timeAgo: '8m ago',
      earning: 156.3,
    ),
  ];
});

/// Provider for platform statistics
final platformStatsProvider = StateProvider<PlatformStatsModel>((ref) {
  return const PlatformStatsModel(
    fastestPayoutTime: '42s',
    averageEarnings: 27.0,
    countriesCount: 91,
    totalUsers: 5000000,
  );
});

/// Provider for highest payout amount
final highestPayoutProvider = StateProvider<double>((ref) => 596.0);

/// Provider for total available offers count
final totalOffersProvider = StateProvider<int>((ref) => 2836);

/// Provider for last payout info
final lastPayoutProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {
    'amount': 46.82,
    'timeAgo': '12s ago',
  };
});

/// Provider to check if user is logged in
final isLoggedInProvider = StateProvider<bool>((ref) => false);

/// Provider for welcome bonus amount
final welcomeBonusProvider = StateProvider<double>((ref) => 500.0);
