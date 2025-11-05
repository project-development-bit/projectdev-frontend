import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final tutorialProvider =
    StateNotifierProvider<TutorialNotifier, bool>((ref) => TutorialNotifier());

class TutorialNotifier extends StateNotifier<bool> {
  static const _tutorialShownKey = 'tutorial_shown';

  TutorialNotifier() : super(true) {
    // _checkIfShown();
    state = false;
  }

  Future<void> _checkIfShown() async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool(_tutorialShownKey) ?? false;
    debugPrint('Tutorial shown: $shown');
    state = shown;
  }

  Future<void> markAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tutorialShownKey, true);
    debugPrint(
        'Tutorial shown : Tutorial marked as shown ${prefs.getBool(_tutorialShownKey) ?? false}');
    state = true;
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tutorialShownKey);
    state = false;
  }
}
