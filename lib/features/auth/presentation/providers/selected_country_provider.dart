import 'package:gigafaucet/features/user_profile/domain/entities/country.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedCountryProvider =
    StateProvider.autoDispose<Country?>((ref) => null);
