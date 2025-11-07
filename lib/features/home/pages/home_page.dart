import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/providers/auth_provider.dart';
import '../../user_profile/presentation/providers/profile_providers.dart';
import '../widgets/hero_section.dart';
import '../widgets/featured_offers_section.dart';
import '../widgets/how_it_works_section.dart';
import '../widgets/offer_walls_section.dart';
import '../widgets/testimonials_section.dart';
import '../widgets/statistics_section.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileNotifierProvider.notifier).loadProfile();
      // Only initialize user if authenticated
      final isAuthenticated = ref.read(isAuthenticatedObservableProvider);
      if (isAuthenticated) {
        ref.read(currentUserProvider.notifier).initializeUser();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Load profile data when the page builds

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
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
            ]),
          ),
        ],
      ),
    );
  }

  /// Handle logout functionality

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
            context.translate('ready_to_earn'),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            context.translate('join_thousands'),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withAlpha(230), // 0.9 * 255
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to login page
              context.goToLogin();
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
            child: Text(
              context.translate('start_earning_now'),
              style: const TextStyle(
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
