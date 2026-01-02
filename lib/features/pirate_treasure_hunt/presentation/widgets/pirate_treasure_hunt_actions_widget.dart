import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/entity/pirate_treasure_hunt_action_item.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/providers/treasure_hunt_notifier_providers.dart';

class PirateTreasureHuntActionsWidget extends ConsumerWidget {
  PirateTreasureHuntActionsWidget({super.key});

  final List<PirateTreasureHuntActionItem> items = [
    PirateTreasureHuntActionItem(
      title: "Survey",
      iconPath: "assets/images/pirate_treasure_hunt/survey3x.png",
      taskKey: "survey",
    ),
    PirateTreasureHuntActionItem(
      title: "Offer\nBoost",
      iconPath: "assets/images/rewards/offer_boast@3x.png",
      taskKey: "offer",
    ),
    PirateTreasureHuntActionItem(
      title: "Visit\nWebsites",
      iconPath: "assets/images/pirate_treasure_hunt/visit-websites.png",
      taskKey: "website",
    ),
    PirateTreasureHuntActionItem(
      title: "Play Game\nApps",
      iconPath: "assets/images/pirate_treasure_hunt/play-games.png",
      taskKey: "game",
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final treasureHuntStatus = ref.watch(treasureHuntStatusNotifierProvider);

    final availableTasks =
        treasureHuntStatus.data?.availableTasks ?? const <String>[];

    final availableItems =
        items.where((item) => availableTasks.contains(item.taskKey)).toList();

    return SizedBox(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: availableItems
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: SizedBox(
                    width: 130,
                    height: 119,
                    child: ActionCard(item: item),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final PirateTreasureHuntActionItem item;

  const ActionCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 119,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
        ),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0B0F2B),
            const Color(0xFF141A3C),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            item.iconPath,
            width: 48,
            height: 48,
          ),
          const SizedBox(height: 12),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
