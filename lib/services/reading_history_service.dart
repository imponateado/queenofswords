import 'package:flutter/material.dart' show Locale;
import 'package:hive_flutter/hive_flutter.dart';

import '../data/deck_repository.dart';
import '../data/spreads_repository.dart';
import '../models/ai_provider_config.dart';
import '../models/reading.dart';
import '../models/tarot_card.dart';

/// Persists reading history locally via Hive. Only lightweight references
/// (card id, position id, spread id) are stored — full card/spread content
/// is looked up again from [DeckRepository]/[SpreadsRepository] on load, so
/// history entries stay small and never go stale relative to deck content.
class ReadingHistoryService {
  static const String boxName = 'reading_history';

  final DeckRepository _deckRepository;

  ReadingHistoryService({DeckRepository? deckRepository})
    : _deckRepository = deckRepository ?? DeckRepository();

  Future<Box<Map>> _box() async {
    if (!Hive.isBoxOpen(boxName)) {
      return Hive.openBox<Map>(boxName);
    }
    return Hive.box<Map>(boxName);
  }

  Future<void> save(Reading reading) async {
    final box = await _box();
    await box.put(reading.id, _toStorageMap(reading));
  }

  Future<void> delete(String readingId) async {
    final box = await _box();
    await box.delete(readingId);
  }

  Future<void> clear() async {
    final box = await _box();
    await box.clear();
  }

  Future<List<Reading>> loadAll(Locale locale) async {
    final box = await _box();
    final deck = await _deckRepository.loadDeck(locale);
    final cardsById = {for (final card in deck) card.id: card};

    final readings =
        box.values
            .map(
              (raw) =>
                  _fromStorageMap(Map<String, dynamic>.from(raw), cardsById),
            )
            .whereType<Reading>()
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return readings;
  }

  Map<String, dynamic> _toStorageMap(Reading reading) => {
    'id': reading.id,
    'createdAt': reading.createdAt.toIso8601String(),
    'spreadId': reading.spread.id,
    'randomSource': reading.randomSource.name,
    'aiInterpretation': reading.aiInterpretation,
    'aiProviderUsed': reading.aiProviderUsed?.name,
    'question': reading.question,
    'drawnCards': reading.drawnCards
        .map(
          (d) => {
            'cardId': d.card.id,
            'positionId': d.position.id,
            'isReversed': d.isReversed,
          },
        )
        .toList(),
  };

  Reading? _fromStorageMap(
    Map<String, dynamic> map,
    Map<String, TarotCard> cardsById,
  ) {
    final spread = SpreadsRepository.all.firstWhere(
      (s) => s.id == map['spreadId'],
      orElse: () => SpreadsRepository.singleCard,
    );
    final positionsById = {for (final p in spread.positions) p.id: p};

    final drawnCards = (map['drawnCards'] as List)
        .map((raw) {
          final entry = Map<String, dynamic>.from(raw as Map);
          final card = cardsById[entry['cardId']];
          final position = positionsById[entry['positionId']];
          if (card == null || position == null) return null;
          return DrawnCard(
            card: card,
            position: position,
            isReversed: entry['isReversed'] as bool,
          );
        })
        .whereType<DrawnCard>()
        .toList();

    if (drawnCards.isEmpty) return null;

    return Reading(
      id: map['id'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      spread: spread,
      drawnCards: drawnCards,
      randomSource: RandomSource.values.firstWhere(
        (s) => s.name == map['randomSource'],
      ),
      aiInterpretation: map['aiInterpretation'] as String?,
      aiProviderUsed: map['aiProviderUsed'] == null
          ? null
          : AiProvider.values.firstWhere(
              (p) => p.name == map['aiProviderUsed'],
            ),
      question: map['question'] as String?,
    );
  }
}
