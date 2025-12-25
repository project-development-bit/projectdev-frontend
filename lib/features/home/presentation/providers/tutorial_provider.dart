import 'package:gigafaucet/features/user_profile/data/models/request/user_update_request.dart';
import 'package:gigafaucet/features/user_profile/presentation/providers/update_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final tutorialProvider = StateNotifierProvider<TutorialNotifier, bool>(
    (ref) => TutorialNotifier(ref));

class TutorialNotifier extends StateNotifier<bool> {
  static const _tutorialShownKey = 'tutorial_shown';
  final Ref ref;

  TutorialNotifier(this.ref) : super(true) {
    _checkIfShown();
  }

  Future<void> _checkIfShown() async {
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString('user_id') ?? 'unknown_user';
    final shown = prefs.getBool(_tutorialShownKey + userID) ?? false;
    debugPrint('Tutorial shown: $_tutorialShownKey $userID $shown');
    state = shown;
  }

  Future<void> markAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString('user_id') ?? 'unknown_user';
    final profileNotifier = ref.read(updateProfileProvider.notifier);
    profileNotifier.updateProfile(
      UserUpdateRequest(
        id: userID,
        showOnboarding: 0,
      ),
    );

    await prefs.setBool(_tutorialShownKey + userID, true);
    debugPrint(
        'Tutorial shown : Tutorial marked as shown ${prefs.getBool(_tutorialShownKey) ?? false}');
    state = true;
  }

  Future<void> closes() async {
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString('user_id') ?? 'unknown_user';
    await prefs.setBool(_tutorialShownKey + userID, true);
    debugPrint(
        'Tutorial shown : Tutorial marked as shown ${prefs.getBool(_tutorialShownKey) ?? false}');
    state = true;
  }

  Future<void> reset() async {
    // TODO: to add API call to reset tutorial status on server side
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString('user_id') ?? 'unknown_user';
    await prefs.remove(_tutorialShownKey + userID);
    bool? shown = prefs.getBool(_tutorialShownKey + userID);
    debugPrint(
        'Tutorial reset: Resetting tutorial status for $userID to $shown');
    state = false;
  }
}
