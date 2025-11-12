import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final tutorialProvider =
    StateNotifierProvider<TutorialNotifier, bool>((ref) => TutorialNotifier());

class TutorialNotifier extends StateNotifier<bool> {
  static const _tutorialShownKey = 'tutorial_shown';

  TutorialNotifier() : super(true) {
    _checkIfShown();
  }

  Future<void> _checkIfShown() async {
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString('user_id') ?? 'unknown_user';
    final shown = prefs.getBool(_tutorialShownKey + userID) ?? false;
    debugPrint('Tutorial shown: $shown');
    state = shown;
  }

  Future<void> markAsShown() async {
    //TODO: to add API call to mark tutorial as shown on server side
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString('user_id') ?? 'unknown_user';

    await prefs.setBool(_tutorialShownKey + userID, true);
    debugPrint(
        'Tutorial shown : Tutorial marked as shown ${prefs.getBool(_tutorialShownKey) ?? false}');
    state = true;
  }

  Future<void> closes() async {
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString('user_id') ?? 'unknown_user';
    await prefs.remove(_tutorialShownKey + userID);
    state = true;
  }

  Future<void> reset() async {
    // TODO: to add API call to reset tutorial status on server side
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString('user_id') ?? 'unknown_user';
    await prefs.remove(_tutorialShownKey + userID);
    state = false;
  }
}
