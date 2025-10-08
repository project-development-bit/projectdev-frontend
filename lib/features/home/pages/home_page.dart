import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/locale_switch_widget.dart';
import '../../../core/widgets/theme_switch_widget.dart';
import '../../../core/extensions/context_extensions.dart';
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
      body: CustomScrollView(
        slivers: [
          // Sliver app bar that hides/shows on scroll
          SliverAppBar(
            expandedHeight: 80.0,
            floating: true,
            pinned: false,
            snap: true,
            backgroundColor: context.surface.withAlpha(242), // 0.95 * 255
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 1,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      context.surface.withAlpha(250), // 0.98 * 255
                      context.surface.withAlpha(235), // 0.92 * 255
                    ],
                  ),
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // App logo/title
                Row(
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: context.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.translate('app_name'),
                      style: context.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.onSurface,
                      ),
                    ),
                  ],
                ),
                // Theme and locale switches
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Profile button
                    IconButton(
                      onPressed: () => context.go('/profile'),
                      icon: const Icon(Icons.person),
                      tooltip: 'Profile',
                    ),
                    const ThemeSwitchWidget(),
                    const SizedBox(width: 8),
                    const LocaleSwitchWidget(),
                  ],
                ),
              ],
            ),
            titleSpacing: 16,
          ),

          // Main content
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