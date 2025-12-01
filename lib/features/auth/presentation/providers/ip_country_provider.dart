import 'package:flutter_riverpod/legacy.dart';

import '../../domain/usecases/get_ip_country_usecase.dart';
import 'get_ip_country_notifier.dart';
import 'ip_country_state.dart';

final getIpCountryNotifierProvider =
    StateNotifierProvider.autoDispose<GetIpCountryNotifier, IpCountryState>(
  (ref) {
    ref.keepAlive();
    final usecase = ref.read(getIpCountryUseCaseProvider);
    final notifier = GetIpCountryNotifier(usecase);
    return notifier;
  },
);
