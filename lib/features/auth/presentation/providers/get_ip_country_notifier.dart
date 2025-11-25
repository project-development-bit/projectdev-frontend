import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/auth/domain/usecases/get_ip_country_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ip_country_state.dart';

class GetIpCountryNotifier extends StateNotifier<IpCountryState> {
  final GetIpCountryUseCase getIpCountryUseCase;

  GetIpCountryNotifier(this.getIpCountryUseCase)
      : super(const IpCountryState());

  Future<void> detectCountry() async {
    if (state.status == GetIpCountryStatus.loading) return;

    state = state.copyWith(
      status: GetIpCountryStatus.loading,
      error: null,
    );

    final result = await getIpCountryUseCase.call();

    state = result.fold(
      (failure) => state.copyWith(
        status: GetIpCountryStatus.error,
        error: _mapFailureToMessage(failure),
      ),
      (country) => state.copyWith(
        status: GetIpCountryStatus.success,
        country: country,
        error: null,
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message ?? 'Failed to detect country';
    }
    return 'Unexpected error occurred';
  }
}
