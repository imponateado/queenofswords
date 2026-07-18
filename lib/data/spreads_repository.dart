import 'package:flutter/widgets.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/spread.dart';

class SpreadsRepository {
  static const Spread singleCard = Spread(
    id: 'single_card',
    positions: [SpreadPosition(id: 'focus')],
  );

  static const Spread threeCard = Spread(
    id: 'three_card',
    positions: [
      SpreadPosition(id: 'past'),
      SpreadPosition(id: 'present'),
      SpreadPosition(id: 'future'),
    ],
  );

  static const Spread fiveCard = Spread(
    id: 'five_card',
    positions: [
      SpreadPosition(id: 'situation'),
      SpreadPosition(id: 'obstacle'),
      SpreadPosition(id: 'advice'),
      SpreadPosition(id: 'underlying'),
      SpreadPosition(id: 'outcome'),
    ],
  );

  static const Spread celticCross = Spread(
    id: 'celtic_cross',
    positions: [
      SpreadPosition(id: 'present'),
      SpreadPosition(id: 'challenge'),
      SpreadPosition(id: 'foundation'),
      SpreadPosition(id: 'recent_past'),
      SpreadPosition(id: 'best_outcome'),
      SpreadPosition(id: 'near_future'),
      SpreadPosition(id: 'self'),
      SpreadPosition(id: 'external'),
      SpreadPosition(id: 'hopes_fears'),
      SpreadPosition(id: 'outcome'),
    ],
  );

  static const List<Spread> all = [
    singleCard,
    threeCard,
    fiveCard,
    celticCross,
  ];
}

/// Localized display name for [spread]. Resolved at render time from
/// [spread.id] rather than stored on the (const, locale-agnostic) model.
String spreadName(BuildContext context, Spread spread) {
  final l10n = AppLocalizations.of(context)!;
  return switch (spread.id) {
    'single_card' => l10n.spreadSingleCardName,
    'three_card' => l10n.spreadThreeCardName,
    'five_card' => l10n.spreadFiveCardName,
    'celtic_cross' => l10n.spreadCelticCrossName,
    _ => spread.id,
  };
}

/// Localized description for [spread].
String spreadDescription(BuildContext context, Spread spread) {
  final l10n = AppLocalizations.of(context)!;
  return switch (spread.id) {
    'single_card' => l10n.spreadSingleCardDescription,
    'three_card' => l10n.spreadThreeCardDescription,
    'five_card' => l10n.spreadFiveCardDescription,
    'celtic_cross' => l10n.spreadCelticCrossDescription,
    _ => '',
  };
}

/// Localized label for [position] within [spread].
///
/// Position ids are reused across spreads with different meanings (e.g.
/// `present` appears in both `three_card` and `celtic_cross`, `outcome` in
/// both `five_card` and `celtic_cross`), so the lookup is namespaced by both
/// the spread id and the position id — never by the bare position id alone.
String positionLabel(
  BuildContext context,
  Spread spread,
  SpreadPosition position,
) {
  final l10n = AppLocalizations.of(context)!;
  return switch ((spread.id, position.id)) {
    ('single_card', 'focus') => l10n.spreadSingleCardPositionFocusLabel,
    ('three_card', 'past') => l10n.spreadThreeCardPositionPastLabel,
    ('three_card', 'present') => l10n.spreadThreeCardPositionPresentLabel,
    ('three_card', 'future') => l10n.spreadThreeCardPositionFutureLabel,
    ('five_card', 'situation') => l10n.spreadFiveCardPositionSituationLabel,
    ('five_card', 'obstacle') => l10n.spreadFiveCardPositionObstacleLabel,
    ('five_card', 'advice') => l10n.spreadFiveCardPositionAdviceLabel,
    ('five_card', 'underlying') => l10n.spreadFiveCardPositionUnderlyingLabel,
    ('five_card', 'outcome') => l10n.spreadFiveCardPositionOutcomeLabel,
    ('celtic_cross', 'present') => l10n.spreadCelticCrossPositionPresentLabel,
    ('celtic_cross', 'challenge') =>
      l10n.spreadCelticCrossPositionChallengeLabel,
    ('celtic_cross', 'foundation') =>
      l10n.spreadCelticCrossPositionFoundationLabel,
    ('celtic_cross', 'recent_past') =>
      l10n.spreadCelticCrossPositionRecentPastLabel,
    ('celtic_cross', 'best_outcome') =>
      l10n.spreadCelticCrossPositionBestOutcomeLabel,
    ('celtic_cross', 'near_future') =>
      l10n.spreadCelticCrossPositionNearFutureLabel,
    ('celtic_cross', 'self') => l10n.spreadCelticCrossPositionSelfLabel,
    ('celtic_cross', 'external') => l10n.spreadCelticCrossPositionExternalLabel,
    ('celtic_cross', 'hopes_fears') =>
      l10n.spreadCelticCrossPositionHopesFearsLabel,
    ('celtic_cross', 'outcome') => l10n.spreadCelticCrossPositionOutcomeLabel,
    _ => position.id,
  };
}

/// Localized meaning for [position] within [spread]. Namespaced the same way
/// as [positionLabel] — see that function's doc comment.
String positionMeaning(
  BuildContext context,
  Spread spread,
  SpreadPosition position,
) {
  final l10n = AppLocalizations.of(context)!;
  return switch ((spread.id, position.id)) {
    ('single_card', 'focus') => l10n.spreadSingleCardPositionFocusMeaning,
    ('three_card', 'past') => l10n.spreadThreeCardPositionPastMeaning,
    ('three_card', 'present') => l10n.spreadThreeCardPositionPresentMeaning,
    ('three_card', 'future') => l10n.spreadThreeCardPositionFutureMeaning,
    ('five_card', 'situation') => l10n.spreadFiveCardPositionSituationMeaning,
    ('five_card', 'obstacle') => l10n.spreadFiveCardPositionObstacleMeaning,
    ('five_card', 'advice') => l10n.spreadFiveCardPositionAdviceMeaning,
    ('five_card', 'underlying') => l10n.spreadFiveCardPositionUnderlyingMeaning,
    ('five_card', 'outcome') => l10n.spreadFiveCardPositionOutcomeMeaning,
    ('celtic_cross', 'present') => l10n.spreadCelticCrossPositionPresentMeaning,
    ('celtic_cross', 'challenge') =>
      l10n.spreadCelticCrossPositionChallengeMeaning,
    ('celtic_cross', 'foundation') =>
      l10n.spreadCelticCrossPositionFoundationMeaning,
    ('celtic_cross', 'recent_past') =>
      l10n.spreadCelticCrossPositionRecentPastMeaning,
    ('celtic_cross', 'best_outcome') =>
      l10n.spreadCelticCrossPositionBestOutcomeMeaning,
    ('celtic_cross', 'near_future') =>
      l10n.spreadCelticCrossPositionNearFutureMeaning,
    ('celtic_cross', 'self') => l10n.spreadCelticCrossPositionSelfMeaning,
    ('celtic_cross', 'external') =>
      l10n.spreadCelticCrossPositionExternalMeaning,
    ('celtic_cross', 'hopes_fears') =>
      l10n.spreadCelticCrossPositionHopesFearsMeaning,
    ('celtic_cross', 'outcome') => l10n.spreadCelticCrossPositionOutcomeMeaning,
    _ => '',
  };
}
