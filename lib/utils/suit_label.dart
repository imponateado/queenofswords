import 'package:flutter/widgets.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/tarot_card.dart';

/// Localized display name for a Minor Arcana [suit]. Shared between the card
/// detail screen and the card encyclopedia screen.
String suitLabel(BuildContext context, Suit suit) {
  final l10n = AppLocalizations.of(context)!;
  return switch (suit) {
    Suit.wands => l10n.suitWands,
    Suit.cups => l10n.suitCups,
    Suit.swords => l10n.suitSwords,
    Suit.pentacles => l10n.suitPentacles,
  };
}
