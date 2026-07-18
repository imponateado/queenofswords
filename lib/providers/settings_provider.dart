import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode;

import '../models/ai_provider_config.dart';
import '../services/secure_storage_service.dart';
import '../services/settings_service.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider({
    SettingsService? settingsService,
    SecureStorageService? secureStorage,
  }) : _settingsService = settingsService ?? SettingsService(),
       _secureStorage = secureStorage ?? SecureStorageService();

  final SettingsService _settingsService;
  final SecureStorageService _secureStorage;

  AiProvider _selectedProvider = AiProvider.claude;
  final Map<AiProvider, bool> _hasApiKey = {
    for (final p in AiProvider.values) p: false,
  };
  bool _isLoaded = false;

  bool _askQuestionBeforeDraw = false;
  bool _deckCleansingRitual = false;
  bool _allowReversedCards = true;
  bool _useSignificatorCard = false;
  bool _showMoonPhase = true;
  ThemeMode _themeMode = ThemeMode.system;

  AiProvider get selectedProvider => _selectedProvider;
  bool get isLoaded => _isLoaded;
  bool hasApiKey(AiProvider provider) => _hasApiKey[provider] ?? false;

  bool get askQuestionBeforeDraw => _askQuestionBeforeDraw;
  bool get deckCleansingRitual => _deckCleansingRitual;
  bool get allowReversedCards => _allowReversedCards;
  bool get useSignificatorCard => _useSignificatorCard;
  bool get showMoonPhase => _showMoonPhase;
  ThemeMode get themeMode => _themeMode;

  Future<void> load() async {
    if (_isLoaded) return;
    _selectedProvider = await _settingsService.getSelectedProvider();
    for (final provider in AiProvider.values) {
      final key = await _secureStorage.getApiKey(provider);
      _hasApiKey[provider] = key != null && key.isNotEmpty;
    }
    _askQuestionBeforeDraw = await _settingsService.getAskQuestionBeforeDraw();
    _deckCleansingRitual = await _settingsService.getDeckCleansingRitual();
    _allowReversedCards = await _settingsService.getAllowReversedCards();
    _useSignificatorCard = await _settingsService.getUseSignificatorCard();
    _showMoonPhase = await _settingsService.getShowMoonPhase();
    _themeMode = await _settingsService.getThemeMode();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _settingsService.setThemeMode(mode);
    notifyListeners();
  }

  Future<void> selectProvider(AiProvider provider) async {
    _selectedProvider = provider;
    await _settingsService.setSelectedProvider(provider);
    notifyListeners();
  }

  Future<void> setAskQuestionBeforeDraw(bool value) async {
    _askQuestionBeforeDraw = value;
    await _settingsService.setAskQuestionBeforeDraw(value);
    notifyListeners();
  }

  Future<void> setDeckCleansingRitual(bool value) async {
    _deckCleansingRitual = value;
    await _settingsService.setDeckCleansingRitual(value);
    notifyListeners();
  }

  Future<void> setAllowReversedCards(bool value) async {
    _allowReversedCards = value;
    await _settingsService.setAllowReversedCards(value);
    notifyListeners();
  }

  Future<void> setUseSignificatorCard(bool value) async {
    _useSignificatorCard = value;
    await _settingsService.setUseSignificatorCard(value);
    notifyListeners();
  }

  Future<void> setShowMoonPhase(bool value) async {
    _showMoonPhase = value;
    await _settingsService.setShowMoonPhase(value);
    notifyListeners();
  }

  Future<void> setApiKey(AiProvider provider, String apiKey) async {
    await _secureStorage.setApiKey(provider, apiKey);
    _hasApiKey[provider] = apiKey.isNotEmpty;
    notifyListeners();
  }

  Future<void> clearApiKey(AiProvider provider) async {
    await _secureStorage.clearApiKey(provider);
    _hasApiKey[provider] = false;
    notifyListeners();
  }
}
