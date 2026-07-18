import 'dart:convert';
import 'dart:ui' show Locale;

import 'package:flutter/services.dart' show rootBundle;

import '../models/tarot_card.dart';

class DeckRepository {
  static const String _assetPathEn = 'assets/data/tarot_cards.json';
  static const String _assetPathPt = 'assets/data/tarot_cards_pt.json';

  final Map<String, List<TarotCard>> _cache = {};

  Future<List<TarotCard>> loadDeck([Locale locale = const Locale('en')]) async {
    final languageCode = locale.languageCode == 'pt' ? 'pt' : 'en';

    final cached = _cache[languageCode];
    if (cached != null) return cached;

    final assetPath = languageCode == 'pt' ? _assetPathPt : _assetPathEn;
    final raw = await rootBundle.loadString(assetPath);
    final list = (jsonDecode(raw) as List)
        .map((e) => TarotCard.fromJson(e as Map<String, dynamic>))
        .toList();

    _cache[languageCode] = list;
    return list;
  }
}
