import 'package:cointiply_app/core/common/header/giga_faucet_header.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/core/theme/app_colors.dart';
import 'package:cointiply_app/features/chat/presentation/provider/right_chat_overlay_provider.dart';
import 'package:cointiply_app/features/home/presentation/widgets/mobile_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

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
    final screenWidth = context.screenWidth;
    return Scaffold(
      drawer: screenWidth < 850 ? const MobileDrawer() : null,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 80.0,
              floating: true,
              pinned: false,
              snap: true,
              backgroundColor: context.surface.withAlpha(242),
              surfaceTintColor: AppColors.transparent,
              elevation: 0,
              scrolledUnderElevation: 1,
              automaticallyImplyLeading: false,
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
                  child: GigaFaucetHeader(),
                ),
              ),
              titleSpacing: 16,
            ),
          ];
        },
        body: child,
      ),
      floatingActionButton: Consumer(builder: (context, ref, child) {
        final isChatOpen = ref.watch(rightChatOverlayProvider);
        if (isChatOpen) {
          return const SizedBox.shrink();
        }
        return GestureDetector(
          onTap: () {
            ref.read(rightChatOverlayProvider.notifier).toggle();
          },
          child: SvgPicture.asset(
            'assets/images/icons/chat_message.svg',
            width: 72,
            height: 72,
          ),
        );
      }),
    );
  }
}
