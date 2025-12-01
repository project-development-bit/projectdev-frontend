import 'package:cointiply_app/features/user_profile/data/enum/profile_tab_type.dart';
import 'package:flutter_riverpod/legacy.dart';

final profileTabProvider =
    StateProvider<ProfileTabType>((ref) => ProfileTabType.overview);
