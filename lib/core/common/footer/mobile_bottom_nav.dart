import 'package:cointiply_app/core/common/footer/bottom_nav_item.dart';
import 'package:cointiply_app/core/config/app_local_images.dart';
import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/chat/presentation/provider/right_chat_overlay_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileBottomNav extends ConsumerStatefulWidget {
  const MobileBottomNav({
    super.key,
  });

  @override
  ConsumerState<MobileBottomNav> createState() => _MobileBottomNavState();
}

class _MobileBottomNavState extends ConsumerState<MobileBottomNav> {
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
    if (index == 3) {
      ref.read(rightChatOverlayProvider.notifier).toggle();
    } else {
      final isChatOpen = ref.read(rightChatOverlayProvider);
      if (isChatOpen) ref.read(rightChatOverlayProvider.notifier).close();
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final localizations = AppLocalizations.of(context);

    const backgroundColor = Color(0xFF00131E);

    return context.isMobile
        ? Container(
            height: 60,
            width: double.infinity,
            clipBehavior: Clip.none,
            decoration: const BoxDecoration(
              color: backgroundColor,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                /// Bottom Navigation Items Row
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BottomNavItem(
                        index: 0,
                        label: localizations?.translate("nav_home") ?? "Home",
                        iconPath: AppLocalImages.homeMenuIcon,
                        currentIndex: currentIndex,
                        onTap: onTap,
                      ),
                      BottomNavItem(
                        index: 1,
                        label:
                            localizations?.translate("nav_wallet") ?? "Wallet",
                        iconPath: AppLocalImages.walletIcon,
                        currentIndex: currentIndex,
                        onTap: onTap,
                      ),

                      /// Gap for center big star
                      const SizedBox(width: 72),

                      BottomNavItem(
                        index: 2,
                        label: localizations?.translate("nav_account") ??
                            "Account",
                        iconPath: AppLocalImages.accountIcon,
                        currentIndex: currentIndex,
                        onTap: onTap,
                      ),
                      BottomNavItem(
                        index: 3,
                        label: localizations?.translate("nav_chat") ?? "Chat",
                        iconPath: AppLocalImages.chatIcon,
                        currentIndex: currentIndex,
                        onTap: onTap,
                      ),
                    ],
                  ),
                ),

                /// Center BIG STAR button
                Positioned(
                  top: -24,
                  child: GestureDetector(
                    onTap: () => onTap(4),
                    child: Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child:
                            CommonImage(imageUrl: AppLocalImages.starNavIcon)),
                  ),
                ),
              ],
            ),
          )
        : SizedBox.shrink();
  }
}
