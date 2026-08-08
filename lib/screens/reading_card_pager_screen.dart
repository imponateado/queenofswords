import 'package:flutter/material.dart';

import '../data/spreads_repository.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/reading.dart';
import '../models/spread.dart';
import '../widgets/tarot_card_widget.dart';

/// Full-screen, one-card-at-a-time viewer opened by tapping a revealed card
/// in [SpreadLayoutWidget]. Lets the user swipe left/right between the
/// reading's cards, with faint corner arrows as a discoverability hint for
/// the same gesture.
class ReadingCardPagerScreen extends StatefulWidget {
  const ReadingCardPagerScreen({
    super.key,
    required this.spread,
    required this.drawnCards,
    required this.initialIndex,
  });

  final Spread spread;
  final List<DrawnCard> drawnCards;
  final int initialIndex;

  @override
  State<ReadingCardPagerScreen> createState() =>
      _ReadingCardPagerScreenState();
}

class _ReadingCardPagerScreenState extends State<ReadingCardPagerScreen> {
  late final _controller = PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final arrowColor = colorScheme.onSurface.withValues(alpha: 0.35);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${positionLabel(context, widget.spread, widget.drawnCards[_index].position)}'
          ' · ${_index + 1}/${widget.drawnCards.length}',
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.drawnCards.length,
            onPageChanged: (index) => setState(() => _index = index),
            itemBuilder: (context, index) {
              final drawn = widget.drawnCards[index];
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TarotCardWidget(
                      card: drawn.card,
                      isRevealed: true,
                      isReversed: drawn.isReversed,
                      width: 220,
                      height: 360,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      drawn.card.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      positionMeaning(context, widget.spread, drawn.position),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            },
          ),
          if (_index > 0)
            Positioned(
              left: 4,
              child: IconButton(
                iconSize: 36,
                color: arrowColor,
                tooltip: l10n.cardDetailPreviousButton,
                icon: const Icon(Icons.chevron_left),
                onPressed: () => _goTo(_index - 1),
              ),
            ),
          if (_index < widget.drawnCards.length - 1)
            Positioned(
              right: 4,
              child: IconButton(
                iconSize: 36,
                color: arrowColor,
                tooltip: l10n.cardDetailNextButton,
                icon: const Icon(Icons.chevron_right),
                onPressed: () => _goTo(_index + 1),
              ),
            ),
        ],
      ),
    );
  }
}
