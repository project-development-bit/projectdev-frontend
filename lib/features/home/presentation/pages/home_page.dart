import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/features/faucet/presentation/provider/faucet_notifier_provider.dart';
import 'package:gigafaucet/features/home/presentation/widgets/event/home_event_section.dart';
import 'package:gigafaucet/features/home/presentation/widgets/home_features_section.dart';
import 'package:gigafaucet/features/user_profile/presentation/providers/current_user_provider.dart';
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
      final isAuthenticated = ref.read(isAuthenticatedObservableProvider);
      if (isAuthenticated) {
        ref.read(currentUserProvider.notifier).initializeUser();
      }
      fectchApi(isAuthenticated);
    });

    ref.listenManual<bool>(isAuthenticatedObservableProvider, (previous, next) {
      // Refetch faucet status and user data on authentication state change
      if (next != previous) {
        fectchApi(next);
      }
    });
    super.initState();
  }

  void fectchApi(bool isAuthenticated) {
    ref.read(getFaucetNotifierProvider.notifier).fetchFaucetStatus(
          isPublic: !isAuthenticated,
        );
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
}
