import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/locale_switch_widget.dart';
import '../../../core/widgets/theme_switch_widget.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/providers/auth_provider.dart';
import '../../auth/presentation/providers/logout_provider.dart';
import '../../user_profile/presentation/providers/profile_providers.dart';
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
    // Load profile data when the page builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileNotifierProvider.notifier).loadProfile();
    });

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
                // App logo/title with user name
                Row(
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: context.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.translate('app_name'),
                          style: context.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.onSurface,
                          ),
                        ),
                        // User name from profile (only show if authenticated)
                        Consumer(
                          builder: (context, ref, child) {
                            return FutureBuilder<bool>(
                              future: ref
                                  .read(authProvider.notifier)
                                  .isAuthenticated(),
                              builder: (context, snapshot) {
                                final isAuthenticated = snapshot.data ?? false;
                                final profile =
                                    ref.watch(currentUserProfileProvider);

                                if (isAuthenticated && profile != null) {
                                  return Text(
                                    'Welcome, ${profile.displayName ?? profile.username}!',
                                    style: context.bodySmall?.copyWith(
                                      color: context.onSurface.withOpacity(0.7),
                                    ),
                                  );
                                } else {
                                  return Text(
                                    'Welcome to Gigafaucet!',
                                    style: context.bodySmall?.copyWith(
                                      color: context.onSurface.withOpacity(0.7),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                // Theme and locale switches + Auth buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Authentication-dependent buttons
                    Consumer(
                      builder: (context, ref, child) {
                        // Use the observable authentication provider for real-time updates
                        final isAuthenticated = ref.watch(isAuthenticatedObservableProvider);

                        if (isAuthenticated) {
                              // Show profile and logout buttons for authenticated users
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Profile button
                                  IconButton(
                                    onPressed: () => context.pushNamedProfile(),
                                    icon: const Icon(Icons.person),
                                    tooltip: 'Profile',
                                  ),
                                  // Logout button
                                  Consumer(
                                    builder: (context, ref, child) {
                                      final isLoading =
                                          ref.watch(isLogoutLoadingProvider);
                                      return IconButton(
                                        onPressed: isLoading
                                            ? null
                                            : () => _handleLogout(context, ref),
                                        icon: isLoading
                                            ? SizedBox(
                                                width: 16,
                                                height: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    context.primary,
                                                  ),
                                                ),
                                              )
                                            : const Icon(Icons.logout),
                                        tooltip: isLoading
                                            ? 'Logging out...'
                                            : 'Logout',
                                      );
                                    },
                                  ),
                                ],
                              );
                            } else {
                              // Show login button for unauthenticated users
                              return ElevatedButton.icon(
                                onPressed: () => context.go('/auth/login'),
                                icon: const Icon(Icons.login),
                                label: const Text('Login'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: context.onPrimary,
                                  backgroundColor: context.primary,
                                ),
                              );
                            }
                      },
                    ),
                    const SizedBox(width: 8),
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

  /// Handle logout functionality
  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.translate('logout')),
        content: Text(context.translate('logout_confirmation')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.translate('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: context.error,
            ),
            child: Text(context.translate('logout')),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      try {
        // Perform logout - the UI should automatically update via the observable provider
        await ref.read(logoutNotifierProvider.notifier).logout();

        // Check the final state after logout
        final logoutState = ref.read(logoutNotifierProvider);

        if (logoutState is LogoutSuccess) {
          // Show success message but don't navigate - let UI update naturally
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Logged out successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else if (logoutState is LogoutError) {
          // Show error message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(logoutState.message),
                backgroundColor: context.error,
              ),
            );
          }
        }
      } catch (e) {
        // Handle any unexpected errors
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logout failed: $e'),
              backgroundColor: context.error,
            ),
          );
        }
      }
    }
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
