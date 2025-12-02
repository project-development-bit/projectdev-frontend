import 'package:cointiply_app/core/config/app_local_images.dart';
import 'package:cointiply_app/features/home/presentation/widgets/event/home_event_section.dart';
import 'package:cointiply_app/features/home/presentation/widgets/home_features_section.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/providers/auth_provider.dart';
import '../widgets/home_banner_section.dart';
import '../widgets/home_level_and_reward_section.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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

    return Column(
      children: [
        /// home banner section
        HomeBannerSection(),
        Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  repeat: ImageRepeat.repeat,
                  image: AssetImage(
                    context.isMobile
                        ? AppLocalImages.homeBackgroundMobile
                        : AppLocalImages.homeBackgroundDesktop,
                  ),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter),
            ),
            child: Column(
              children: [
                HomeFeaturesSection(),
                HomeLevelAndRewardSection(),
                SizedBox(height: context.isMobile ? 20 : 50),
                HomeEventSection(),
                SizedBox(height: context.isMobile ? 20 : 50),
              ],
            )),
      ],
    );
  }

  /// Handle logout functionality

  // Widget _buildFooterCTA(BuildContext context) {
  //   final colorScheme = Theme.of(context).colorScheme;

  //   return Container(
  //     width: double.infinity,
  //     color: Theme.of(context).primaryColor,
  //     padding: const EdgeInsets.symmetric(
  //       horizontal: 24,
  //       vertical: 40,
  //     ),
  //     child: Column(
  //       children: [
  //         Text(
  //           context.translate('ready_to_earn'),
  //           style: Theme.of(context).textTheme.headlineMedium?.copyWith(
  //                 color: colorScheme.onError,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //           textAlign: TextAlign.center,
  //         ),
  //         const SizedBox(height: 12),
  //         Text(
  //           context.translate('join_thousands'),
  //           style: Theme.of(context).textTheme.bodyLarge?.copyWith(
  //                 color: colorScheme.onError.withAlpha(230), // 0.9 * 255
  //               ),
  //           textAlign: TextAlign.center,
  //         ),
  //         const SizedBox(height: 24),
  //         ElevatedButton(
  //           onPressed: () {
  //             // Navigate to login page
  //             context.goToLogin();
  //           },
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: colorScheme.onError,
  //             foregroundColor: Theme.of(context).primaryColor,
  //             padding: const EdgeInsets.symmetric(
  //               horizontal: 32,
  //               vertical: 16,
  //             ),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //           ),
  //           child: Text(
  //             context.translate('start_earning_now'),
  //             style: const TextStyle(
  //               fontSize: 18,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
