import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/ai_provider_config.dart';
import '../models/reading.dart';
import '../models/spread.dart';
import '../models/tarot_card.dart';
import '../services/ai/ai_result.dart';
import '../services/ai/ai_service.dart';
import '../services/random/random_org_service.dart';
import '../services/reading_history_service.dart';

enum InterpretationStatus { idle, loading, success, copiedToClipboard, error }

class ReadingProvider extends ChangeNotifier {
  ReadingProvider({
    RandomOrgService? randomService,
    AiService? aiService,
    ReadingHistoryService? historyService,
  }) : _randomService = randomService ?? RandomOrgService(),
       _aiService = aiService ?? AiService(),
       _historyService = historyService ?? ReadingHistoryService();

  final RandomOrgService _randomService;
  final AiService _aiService;
  final ReadingHistoryService _historyService;
  final Random _orientationRng = Random.secure();

  Reading? _reading;
  bool _isDrawing = false;
  InterpretationStatus _interpretationStatus = InterpretationStatus.idle;
  AiNoticeKind? _interpretationNoticeKind;
  String? _interpretationNoticeProviderName;
  String? _interpretationError;

  Reading? get reading => _reading;
  bool get isDrawing => _isDrawing;
  InterpretationStatus get interpretationStatus => _interpretationStatus;
  AiNoticeKind? get interpretationNoticeKind => _interpretationNoticeKind;
  String? get interpretationNoticeProviderName =>
      _interpretationNoticeProviderName;
  String? get interpretationError => _interpretationError;
  RandomOrgService get randomService => _randomService;

  Future<void> drawReading({
    required Spread spread,
    required List<TarotCard> deck,
    String? question,
    bool allowReversed = true,
  }) async {
    _isDrawing = true;
    _interpretationStatus = InterpretationStatus.idle;
    _interpretationNoticeKind = null;
    _interpretationNoticeProviderName = null;
    _interpretationError = null;
    notifyListeners();

    final indices = await _randomService.drawCardIndices(
      spread.cardCount,
      deck.length,
    );
    final source = _randomService.lastDrawSource == LastDrawSource.randomOrg
        ? RandomSource.randomOrg
        : RandomSource.localSecure;

    final drawnCards = <DrawnCard>[];
    for (var i = 0; i < indices.length; i++) {
      drawnCards.add(
        DrawnCard(
          card: deck[indices[i]],
          position: spread.positions[i],
          isReversed: allowReversed && _orientationRng.nextBool(),
        ),
      );
    }

    _reading = Reading(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
      spread: spread,
      drawnCards: drawnCards,
      randomSource: source,
      question: question,
    );

    _isDrawing = false;
    notifyListeners();
  }

  Future<void> requestInterpretation(
    AiProvider provider, {
    required String Function(SpreadPosition position) positionLabel,
    required String noQuestionText,
    required String questionIntro,
    required String cardsIntro,
    required String closingQuestion,
    required String orientationUpright,
    required String orientationReversed,
  }) async {
    final current = _reading;
    if (current == null) return;

    _interpretationStatus = InterpretationStatus.loading;
    _interpretationNoticeKind = null;
    _interpretationNoticeProviderName = null;
    _interpretationError = null;
    notifyListeners();

    final result = await _aiService.getInterpretation(
      reading: current,
      provider: provider,
      positionLabel: positionLabel,
      noQuestionText: noQuestionText,
      questionIntro: questionIntro,
      cardsIntro: cardsIntro,
      closingQuestion: closingQuestion,
      orientationUpright: orientationUpright,
      orientationReversed: orientationReversed,
    );

    switch (result.status) {
      case AiResultStatus.success:
        _reading = current.copyWith(
          aiInterpretation: result.text,
          aiProviderUsed: provider,
        );
        _interpretationStatus = InterpretationStatus.success;
        await _historyService.save(_reading!);
        break;
      case AiResultStatus.copiedToClipboard:
        _interpretationNoticeKind = result.noticeKind;
        _interpretationNoticeProviderName = result.noticeProviderName;
        _interpretationStatus = InterpretationStatus.copiedToClipboard;
        await _historyService.save(current);
        break;
      case AiResultStatus.error:
        _interpretationError = result.errorMessage;
        _interpretationStatus = InterpretationStatus.error;
        break;
    }
    notifyListeners();
  }

  void reset() {
    _reading = null;
    _interpretationStatus = InterpretationStatus.idle;
    _interpretationNoticeKind = null;
    _interpretationNoticeProviderName = null;
    _interpretationError = null;
    notifyListeners();
  }
}
