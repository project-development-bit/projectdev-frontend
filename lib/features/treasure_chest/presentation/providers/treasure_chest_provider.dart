import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/treasure_chest_status.dart';
import '../../domain/usecases/get_treasure_chest_status_usecase.dart';
import '../../data/repositories/treasure_chest_repository_impl.dart';

// =============================================================================
// TREASURE CHEST STATE CLASSES
// =============================================================================

/// Treasure chest state for the application
@immutable
sealed class TreasureChestState {
  const TreasureChestState();
}

/// Initial treasure chest state
class TreasureChestInitial extends TreasureChestState {
  const TreasureChestInitial();
}

/// Treasure chest loading state
class TreasureChestLoading extends TreasureChestState {
  const TreasureChestLoading();
}

/// Treasure chest loaded successfully
class TreasureChestLoaded extends TreasureChestState {
  const TreasureChestLoaded(this.status);

  final TreasureChestStatus status;
}

/// Treasure chest error state
class TreasureChestError extends TreasureChestState {
  const TreasureChestError({
    required this.message,
    this.isNetworkError = false,
  });

  final String message;
  final bool isNetworkError;
}

// =============================================================================
// TREASURE CHEST STATE NOTIFIER
// =============================================================================

/// StateNotifier for managing treasure chest operations
class TreasureChestNotifier extends StateNotifier<TreasureChestState> {
  TreasureChestNotifier(this._ref) : super(const TreasureChestInitial());

  final Ref _ref;

  /// Fetch treasure chest status
  Future<void> fetchTreasureChestStatus({
    VoidCallback? onSuccess,
    Function(String)? onError,
  }) async {
    debugPrint('🎁 Starting fetch treasure chest status');
    debugPrint('🎁 Current state: ${state.runtimeType}');

    state = const TreasureChestLoading();

    try {
      final useCase = GetTreasureChestStatusUseCase(
        _ref.read(treasureChestRepositoryProvider),
      );

      final result = await useCase.call(NoParams());

      result.fold(
        (failure) {
          debugPrint('🎁 Failed to fetch status: ${failure.message}');

          // Check if it's a network error (ServerFailure without status code)
          final isNetworkError =
              failure is ServerFailure && failure.statusCode == null;

          state = TreasureChestError(
            message: failure.message ?? 'Failed to load treasure chest status',
            isNetworkError: isNetworkError,
          );
          onError?.call(failure.message ?? 'Failed to load status');
        },
        (status) {
          debugPrint('🎁 Successfully fetched treasure chest status');
          debugPrint('🎁 Total chests: ${status.chests.total}');
          debugPrint('🎁 Can open: ${status.canOpen}');
          state = TreasureChestLoaded(status);
          onSuccess?.call();
        },
      );
    } catch (e) {
      debugPrint('🎁 Exception in fetchTreasureChestStatus: $e');
      state = TreasureChestError(
        message: 'Unexpected error: ${e.toString()}',
      );
      onError?.call(e.toString());
    }
  }

  /// Refresh treasure chest status
  Future<void> refreshTreasureChestStatus() async {
    await fetchTreasureChestStatus();
  }

  /// Reset state to initial
  void reset() {
    state = const TreasureChestInitial();
  }
}

// =============================================================================
// TREASURE CHEST PROVIDER
// =============================================================================

/// Provider for treasure chest state management
final treasureChestProvider =
    StateNotifierProvider<TreasureChestNotifier, TreasureChestState>(
  (ref) => TreasureChestNotifier(ref),
);
