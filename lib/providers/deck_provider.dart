import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Locale;

import '../data/deck_repository.dart';
import '../models/tarot_card.dart';

class DeckProvider extends ChangeNotifier {
  DeckProvider({DeckRepository? repository})
    : _repository = repository ?? DeckRepository();

  final DeckRepository _repository;

  List<TarotCard> _cards = [];
  bool _isLoading = false;
  Object? _error;
  Locale? _loadedLocale;

  List<TarotCard> get cards => _cards;
  bool get isLoading => _isLoading;
  Object? get error => _error;

  Future<void> load(Locale locale) async {
    if ((_cards.isNotEmpty && _loadedLocale == locale) || _isLoading) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cards = await _repository.loadDeck(locale);
      _loadedLocale = locale;
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
