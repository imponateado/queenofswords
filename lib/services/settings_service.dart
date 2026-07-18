import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ai_provider_config.dart';

/// Non-secret settings — never anything that belongs in secure storage.
class SettingsService {
  static const _selectedProviderKey = 'selected_ai_provider';
  static const _askQuestionKey = 'ask_question_before_draw';
  static const _cleansingRitualKey = 'deck_cleansing_ritual_enabled';
  static const _allowReversedKey = 'allow_reversed_cards';
  static const _significatorKey = 'use_significator_card';
  static const _moonPhaseKey = 'show_moon_phase';
  static const _themeModeKey = 'theme_mode';

  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_themeModeKey);
    return ThemeMode.values.firstWhere(
      (m) => m.name == stored,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async =>
      (await SharedPreferences.getInstance()).setString(
        _themeModeKey,
        mode.name,
      );

  Future<AiProvider> getSelectedProvider() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_selectedProviderKey);
    if (stored == null) return AiProvider.claude;
    return AiProvider.values.firstWhere(
      (p) => p.name == stored,
      orElse: () => AiProvider.claude,
    );
  }

  Future<void> setSelectedProvider(AiProvider provider) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedProviderKey, provider.name);
  }

  Future<bool> getAskQuestionBeforeDraw() async =>
      (await SharedPreferences.getInstance()).getBool(_askQuestionKey) ?? false;

  Future<void> setAskQuestionBeforeDraw(bool value) async =>
      (await SharedPreferences.getInstance()).setBool(_askQuestionKey, value);

  Future<bool> getDeckCleansingRitual() async =>
      (await SharedPreferences.getInstance()).getBool(_cleansingRitualKey) ??
      false;

  Future<void> setDeckCleansingRitual(bool value) async =>
      (await SharedPreferences.getInstance()).setBool(
        _cleansingRitualKey,
        value,
      );

  Future<bool> getAllowReversedCards() async =>
      (await SharedPreferences.getInstance()).getBool(_allowReversedKey) ??
      true;

  Future<void> setAllowReversedCards(bool value) async =>
      (await SharedPreferences.getInstance()).setBool(_allowReversedKey, value);

  Future<bool> getUseSignificatorCard() async =>
      (await SharedPreferences.getInstance()).getBool(_significatorKey) ??
      false;

  Future<void> setUseSignificatorCard(bool value) async =>
      (await SharedPreferences.getInstance()).setBool(_significatorKey, value);

  Future<bool> getShowMoonPhase() async =>
      (await SharedPreferences.getInstance()).getBool(_moonPhaseKey) ?? true;

  Future<void> setShowMoonPhase(bool value) async =>
      (await SharedPreferences.getInstance()).setBool(_moonPhaseKey, value);
}
