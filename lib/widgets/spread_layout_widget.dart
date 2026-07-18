import 'package:flutter/material.dart';

import '../data/spreads_repository.dart';
import '../models/reading.dart';
import '../models/spread.dart';
import 'tarot_card_widget.dart';

/// Lays out the drawn cards of a reading. Uses a wrapping grid so it reads
/// well for any spread size (1, 3, or 10 cards) without hard-coding a
/// layout per spread — a true positional Celtic Cross layout is a nice
/// visual polish item to revisit later (see plan M9).
class SpreadLayoutWidget extends StatelessWidget {
  const SpreadLayoutWidget({
    super.key,
    required this.spread,
    required this.drawnCards,
    required this.isRevealed,
    this.onCardTap,
  });

  final Spread spread;
  final List<DrawnCard> drawnCards;
  final bool isRevealed;
  final void Function(DrawnCard drawnCard)? onCardTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 20,
      children: drawnCards.map((drawn) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TarotCardWidget(
              card: drawn.card,
              isRevealed: isRevealed,
              isReversed: drawn.isReversed,
              onTap: onCardTap == null ? null : () => onCardTap!(drawn),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 120,
              child: Tooltip(
                message: positionMeaning(context, spread, drawn.position),
                child: Text(
                  positionLabel(context, spread, drawn.position),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
