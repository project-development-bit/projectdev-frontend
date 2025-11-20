import 'package:cointiply_app/core/common/header/giga_faucet_header.dart';
import 'package:cointiply_app/core/theme/app_colors.dart';
import 'package:cointiply_app/features/home/presentation/widgets/mobile_drawer.dart';
import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';

/// A wrapper widget for shell routes that provides a common sliver-based layout.
/// This allows all pages under the ShellRoute (e.g., Home, Profile, Chat) to share
/// the same scrollable app bar and common UI elements.
class ShellRouteWrapper extends StatelessWidget {
  final Widget child;

  const ShellRouteWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      drawer: isMobile ? const MobileDrawer() : null,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            // Shared SliverAppBar that hides/shows on scroll
            SliverAppBar(
              expandedHeight: 80.0,
              floating: true,
              pinned: false,
              snap: true,
              backgroundColor: context.surface.withAlpha(242), // 0.95 * 255
              surfaceTintColor: AppColors.transparent,
              elevation: 0,
              scrolledUnderElevation: 1,
              automaticallyImplyLeading:
                  MediaQuery.of(context).size.width < 768,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  alignment: Alignment.center,
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
                  child: GigaFaucetHeader(
                    coinBalance: "14,212,568",
                    profileImageUrl: "https://your-img-url",
                  ),
                ),
              ),
              titleSpacing: 16,
            ),
          ];
        },
        body: child,
      ),
    );
  }
}
