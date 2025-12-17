import 'package:gigafaucet/core/common/common_image_widget.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/extensions/extensions.dart';
import 'package:gigafaucet/features/home/presentation/widgets/drawer_item.dart';
import 'package:gigafaucet/features/home/presentation/widgets/drawer_sub_item.dart';
import 'package:gigafaucet/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart' show GoRouterState;

class MobileDrawer extends ConsumerStatefulWidget {
  const MobileDrawer({super.key});

  @override
  ConsumerState<MobileDrawer> createState() => _MobileDrawerState();
}

class _MobileDrawerState extends ConsumerState<MobileDrawer> {
  final Map<String, bool> expanded = {
    "earn": false,
    "contests": false,
    "events": false,
    "shop": false,
    "blog": false,
  };

  void toggle(String key) {
    bool isexpanded = expanded[key] == true;
    setState(() {
      expanded.updateAll((k, v) => false);
      expanded[key] = !isexpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ParentItemWidget(
                  isOpen: expanded["earn"] == true,
                  onTap: () {
                    toggle("earn");
                  },
                  label: context.translate('earn_cryptos'),
                  colorScheme: colorScheme,
                ),
                if (expanded["earn"] == true) ...[
                  DrawerSubItem(
                    route: '/daily-rewards',
                    label: context.translate('daily_rewards'),
                    onTap: () {},
                  ),
                  DrawerSubItem(
                    route: '/watch-ads',
                    label: context.translate('watch_ads'),
                    onTap: () {},
                  ),
                  DrawerSubItem(
                    route: '/offer-walls',
                    label: context.translate('spin_earn'),
                    onTap: () {},
                  ),
                ],
                ParentItemWidget(
                  isOpen: expanded["contests"] == true,
                  onTap: () {
                    setState(() {
                      expanded.updateAll((k, v) => false);
                      expanded["contests"] = !(expanded["contests"] == true);
                    });
                  },
                  label: context.translate('contests'),
                  colorScheme: colorScheme,
                ),
                ParentItemWidget(
                  isOpen: expanded["events"] == true,
                  onTap: () {
                    toggle("events");
                  },
                  label: context.translate('events'),
                  colorScheme: colorScheme,
                ),
                ParentItemWidget(
                  isOpen: expanded["shop"] == true,
                  onTap: () {
                    toggle("shop");
                  },
                  label: context.translate('shop'),
                  colorScheme: colorScheme,
                ),
                ParentItemWidget(
                  isOpen: expanded["help"] == true,
                  onTap: () {
                    toggle("help");
                  },
                  label: context.translate('help'),
                  colorScheme: colorScheme,
                ),
                ParentItemWidget(
                  isOpen: expanded["blog"] == true,
                  onTap: () {
                    toggle("blog");
                  },
                  label: context.translate('blog'),
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentRoute = GoRouterState.of(context).uri.toString();
        if (!currentRoute.contains('home')) {
          context.go('/home');
        }
        context.pop();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        alignment: Alignment.centerLeft,
        child: CommonImage(
          imageUrl: AppLocalImages.gigaFaucetLogo,
          width: 180,
          height: 74,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
