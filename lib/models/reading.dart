import 'package:equatable/equatable.dart';

import 'ai_provider_config.dart';
import 'spread.dart';
import 'tarot_card.dart';

enum RandomSource { randomOrg, localSecure }

class DrawnCard extends Equatable {
  final TarotCard card;
  final SpreadPosition position;
  final bool isReversed;

  const DrawnCard({
    required this.card,
    required this.position,
    required this.isReversed,
  });

  String get orientationLabel => isReversed ? 'Reversed' : 'Upright';

  @override
  List<Object?> get props => [card, position, isReversed];
}

class Reading extends Equatable {
  final String id;
  final DateTime createdAt;
  final Spread spread;
  final List<DrawnCard> drawnCards;
  final RandomSource randomSource;
  final String? aiInterpretation;
  final AiProvider? aiProviderUsed;
  final String? question;

  const Reading({
    required this.id,
    required this.createdAt,
    required this.spread,
    required this.drawnCards,
    required this.randomSource,
    this.aiInterpretation,
    this.aiProviderUsed,
    this.question,
  });

  Reading copyWith({String? aiInterpretation, AiProvider? aiProviderUsed}) =>
      Reading(
        id: id,
        createdAt: createdAt,
        spread: spread,
        drawnCards: drawnCards,
        randomSource: randomSource,
        aiInterpretation: aiInterpretation ?? this.aiInterpretation,
        aiProviderUsed: aiProviderUsed ?? this.aiProviderUsed,
        question: question,
      );

  @override
  List<Object?> get props => [
    id,
    createdAt,
    spread,
    drawnCards,
    randomSource,
    aiInterpretation,
    aiProviderUsed,
    question,
  ];
}
