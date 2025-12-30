import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/usecases/get_treasure_hunt_history_usecase.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/usecases/get_treasure_hunt_status_usecase.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/usecases/start_treasure_hunt_usecase.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/domain/usecases/uncover_treasure_hunt_usecase.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/providers/start_treasure_hunt_notifier.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/providers/start_treasure_hunt_notifier_state.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/providers/treasure_hunt_history_notifier.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/providers/treasure_hunt_history_state.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/providers/treasure_hunt_state.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/providers/treasure_hunt_status_notifier.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/providers/treasure_hunt_status_state.dart';
import 'package:gigafaucet/features/pirate_treasure_hunt/presentation/providers/uncover_treasure_notifier.dart';

// STATUS
final treasureHuntStatusNotifierProvider = StateNotifierProvider.autoDispose<
    TreasureHuntStatusNotifier, TreasureHuntStatusState>(
  (ref) {
    final usecase = ref.read(getTreasureHuntStatusUseCaseProvider);
    return TreasureHuntStatusNotifier(usecase);
  },
);

// START
final startTreasureHuntNotifierProvider = StateNotifierProvider.autoDispose<
    StartTreasureHuntNotifier, StartTreasureHuntNotifierState>(
  (ref) {
    final usecase = ref.read(startTreasureHuntUseCaseProvider);
    return StartTreasureHuntNotifier(usecase);
  },
);

// UNCOVER
final uncoverTreasureNotifierProvider = StateNotifierProvider.autoDispose<
    UncoverTreasureNotifier, TreasureHuntState>(
  (ref) {
    final usecase = ref.read(uncoverTreasureUseCaseProvider);
    return UncoverTreasureNotifier(usecase, ref);
  },
);

// HISTORY
final treasureHuntHistoryNotifierProvider = StateNotifierProvider<
    TreasureHuntHistoryNotifier, TreasureHuntHistoryState>(
  (ref) {
    final usecase = ref.read(getTreasureHuntHistoryUseCaseProvider);
    return TreasureHuntHistoryNotifier(usecase);
  },
);
