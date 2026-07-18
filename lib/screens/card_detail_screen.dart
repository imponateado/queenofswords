import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/tarot_card.dart';
import '../utils/suit_label.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/tarot_card_widget.dart';

class CardDetailScreen extends StatelessWidget {
  const CardDetailScreen({super.key, required this.card});

  final TarotCard card;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final arcanaLabel = card.arcana == Arcana.major
        ? l10n.majorArcanaLabel
        : l10n.minorArcanaLabel;
    final suitPart = card.suit != null
        ? ', ${suitLabel(context, card.suit!)}'
        : '';

    return AppScaffold(
      title: card.name,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: TarotCardWidget(
              card: card,
              isRevealed: true,
              width: 150,
              height: 240,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text('$arcanaLabel$suitPart', style: textTheme.labelMedium),
          ),
          const SizedBox(height: 24),
          Text(l10n.cardUprightSectionTitle, style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final k in card.uprightKeywords) Chip(label: Text(k)),
            ],
          ),
          const SizedBox(height: 12),
          Text(card.uprightMeaning, style: textTheme.bodyMedium),
          const SizedBox(height: 24),
          Text(l10n.cardReversedSectionTitle, style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final k in card.reversedKeywords) Chip(label: Text(k)),
            ],
          ),
          const SizedBox(height: 12),
          Text(card.reversedMeaning, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
