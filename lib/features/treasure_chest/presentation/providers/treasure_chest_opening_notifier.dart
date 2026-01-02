import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/treasure_chest_open_response.dart';
import '../../domain/usecases/open_treasure_chest_usecase.dart';
import '../../data/repositories/treasure_chest_repository_impl.dart';

// =============================================================================
// TREASURE CHEST OPENING STATE CLASSES
// =============================================================================

/// Treasure chest opening state for the application
@immutable
sealed class TreasureChestOpeningState {
  const TreasureChestOpeningState();
}

/// Initial opening state
class TreasureChestOpeningInitial extends TreasureChestOpeningState {
  const TreasureChestOpeningInitial();
}

/// Treasure chest is being opened
class TreasureChestOpening extends TreasureChestOpeningState {
  const TreasureChestOpening();
}

/// Treasure chest opened successfully
class TreasureChestOpened extends TreasureChestOpeningState {
  const TreasureChestOpened(this.openResponse);

  final TreasureChestOpenResponse openResponse;
}

/// Treasure chest opening error
class TreasureChestOpeningError extends TreasureChestOpeningState {
  const TreasureChestOpeningError({
    required this.message,
    this.isNetworkError = false,
  });

  final String message;
  final bool isNetworkError;
}

// =============================================================================
// TREASURE CHEST OPENING NOTIFIER
// =============================================================================

/// StateNotifier for managing treasure chest opening operations
class TreasureChestOpeningNotifier
    extends StateNotifier<TreasureChestOpeningState> {
  TreasureChestOpeningNotifier(this._ref)
      : super(const TreasureChestOpeningInitial());

  final Ref _ref;

  /// Open treasure chest
  Future<void> openTreasureChest({
    String? deviceFingerprint,
    Function(TreasureChestOpenResponse)? onSuccess,
    Function(String)? onError,
  }) async {
    debugPrint('🎁 Opening treasure chest');
    debugPrint('🎁 Current opening state: ${state.runtimeType}');

    state = const TreasureChestOpening();

    try {
      final useCase = OpenTreasureChestUseCase(
        _ref.read(treasureChestRepositoryProvider),
      );

      final result = await useCase.call(
        OpenTreasureChestParams(deviceFingerprint: deviceFingerprint),
      );

      result.fold(
        (failure) {
          debugPrint('🎁 Failed to open chest: ${failure.message}');

          // Check if it's a network error
          final isNetworkError =
              failure is ServerFailure && failure.statusCode == null;

          state = TreasureChestOpeningError(
            message: failure.message ?? 'Failed to open treasure chest',
            isNetworkError: isNetworkError,
          );
          onError?.call(failure.message ?? 'Failed to open chest');
        },
        (openResponse) {
          debugPrint('🎁 Successfully opened treasure chest');
          debugPrint('🎁 Reward: ${openResponse.reward.label}');
          debugPrint(
              '🎁 Remaining chests: ${openResponse.chestsRemaining.total}');

          state = TreasureChestOpened(openResponse);
          onSuccess?.call(openResponse);
        },
      );
    } catch (e) {
      debugPrint('🎁 Exception in openTreasureChest: $e');
      state = TreasureChestOpeningError(
        message: 'Unexpected error: ${e.toString()}',
      );
      onError?.call(e.toString());
    }
  }

  /// Reset state to initial
  void reset() {
    state = const TreasureChestOpeningInitial();
  }
}

// =============================================================================
// TREASURE CHEST OPENING PROVIDER
// =============================================================================

/// Provider for treasure chest opening state management
final treasureChestOpeningProvider = StateNotifierProvider<
    TreasureChestOpeningNotifier, TreasureChestOpeningState>(
  (ref) => TreasureChestOpeningNotifier(ref),
);
