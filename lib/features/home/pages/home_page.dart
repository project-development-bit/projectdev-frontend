import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/hero_section.dart';
import '../widgets/featured_offers_section.dart';
import '../widgets/how_it_works_section.dart';
import '../widgets/offer_walls_section.dart';
import '../widgets/testimonials_section.dart';
import '../widgets/statistics_section.dart';

/// The main home page replicating Cointiply's homepage design
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero section with main value proposition
            const HeroSection(),
            
            // Featured offers section
            const FeaturedOffersSection(),
            
            // How it works section
            const HowItWorksSection(),
            
            // Offer walls section
            const OfferWallsSection(),
            
            // User testimonials
            const TestimonialsSection(),
            
            // Platform statistics and level progression
            const StatisticsSection(),
            
            // Footer call-to-action
            _buildFooterCTA(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterCTA(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 40,
      ),
      child: Column(
        children: [
          Text(
            'Ready to see what you can earn?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Join thousands of users already earning free Bitcoin',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to signup/login
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Start Earning Now',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}