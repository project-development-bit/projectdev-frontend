import 'package:cointiply_app/core/common/common_image_widget.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:cointiply_app/routing/routing.dart';
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: const Color(0xFF00131E), //TODO use colorScheme
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // ----------------- Earn Cryptos -----------------
                _buildParent(
                  key: "earn",
                  label: context.translate('earn_cryptos'),
                  colorScheme: colorScheme,
                ),
                if (expanded["earn"] == true) ...[
                  _buildSubItem(context,
                      route: '/daily-rewards',
                      label: context.translate('daily_rewards'), onTap: () {
                    context.pop();
                  }, colorScheme: colorScheme),
                  _buildSubItem(
                      route: '/watch-ads',
                      context,
                      label: context.translate('watch_ads'), onTap: () {
                    context.pop();
                  }, colorScheme: colorScheme),
                  _buildSubItem(context,
                      route: '/offer-walls',
                      label: context.translate('spin_earn'), onTap: () {
                    context.pop();
                  }, colorScheme: colorScheme),
                ],

                _buildParent(
                  key: "contests",
                  label: context.translate('contests'),
                  colorScheme: colorScheme,
                ),

                _buildParent(
                  key: "events",
                  label: context.translate('events'),
                  colorScheme: colorScheme,
                ),

                _buildParent(
                  key: "shop",
                  label: context.translate('shop'),
                  colorScheme: colorScheme,
                ),

                _buildParent(
                  key: "help",
                  label: context.translate('help'),
                  colorScheme: colorScheme,
                ),

                _buildParent(
                  key: "blog",
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
          imageUrl: "assets/images/giga_faucet_text_logo.png",
          width: 180,
          height: 74,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildParent(
      {required String key,
      required String label,
      required ColorScheme colorScheme}) {
    final bool open = expanded[key] == true;

    return GestureDetector(
      onTap: () {
        setState(() {
          expanded.updateAll((k, v) => false);
          expanded[key] = !open;
        });
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 18, right: 9.5, top: 18, bottom: 18),
        child: Row(
          children: [
            Expanded(
              child: CommonText.bodyLarge(
                label,
                color: open ? colorScheme.primary : colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            Transform.rotate(
              angle: open ? 3.1416 : 0,
              child: Icon(Icons.keyboard_arrow_down,
                  size: 20,
                  color: open ? colorScheme.primary : colorScheme.onPrimary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubItem(
    BuildContext context, {
    required String label,
    required String route,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    // final currentRoute = GoRouterState.of(context).uri.toString();
    final bool isActive = "/daily-rewards".startsWith(route);
    return GestureDetector(
      onTap: () {
        onTap();
        context.pop(); // close drawer
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- Left Active Bar ---
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 3,
              height: 18,
              margin: const EdgeInsets.only(left: 22, right: 12),
              decoration: BoxDecoration(
                color: isActive ? colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // --- Label ---
            CommonText.bodyLarge(
              label,
              color: isActive
                  ? colorScheme.primary
                  : Color(0xFF98989A), //TODO use colorScheme
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
