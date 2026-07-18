import 'dart:math';

import 'package:flutter/material.dart';

import '../models/tarot_card.dart';

/// Renders a single tarot card with a flip animation between its back and
/// its face. The face renders the card's Rider-Waite-Smith artwork, rotated
/// upside-down when the draw came up reversed.
class TarotCardWidget extends StatefulWidget {
  const TarotCardWidget({
    super.key,
    required this.card,
    required this.isRevealed,
    this.isReversed = false,
    this.width = 120,
    this.height = 200,
    this.onTap,
  });

  final TarotCard card;
  final bool isRevealed;
  final bool isReversed;
  final double width;
  final double height;
  final VoidCallback? onTap;

  @override
  State<TarotCardWidget> createState() => _TarotCardWidgetState();
}

class _TarotCardWidgetState extends State<TarotCardWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  @override
  void initState() {
    super.initState();
    if (widget.isRevealed) _controller.value = 1;
  }

  @override
  void didUpdateWidget(covariant TarotCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRevealed != oldWidget.isRevealed) {
      widget.isRevealed ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * pi;
          final showFront = _controller.value >= 0.5;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0015)
              ..rotateY(angle),
            child: showFront
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: _CardFace(
                      card: widget.card,
                      isReversed: widget.isReversed,
                      width: widget.width,
                      height: widget.height,
                    ),
                  )
                : CardBackFace(width: widget.width, height: widget.height),
          );
        },
      ),
    );
  }
}

/// The card-back visual, shared between [TarotCardWidget] and
/// [ShuffleAnimationWidget].
class CardBackFace extends StatelessWidget {
  const CardBackFace({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primary, colorScheme.tertiary],
        ),
        border: Border.all(color: colorScheme.outline, width: 1),
      ),
      child: Center(
        child: Icon(
          Icons.auto_awesome,
          color: colorScheme.onPrimary.withValues(alpha: 0.6),
          size: 32,
        ),
      ),
    );
  }
}

class _CardFace extends StatelessWidget {
  const _CardFace({
    required this.card,
    required this.isReversed,
    required this.width,
    required this.height,
  });

  final TarotCard card;
  final bool isReversed;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Transform.rotate(
      angle: isReversed ? pi : 0,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: colorScheme.surfaceContainerHigh,
          border: Border.all(color: colorScheme.outline, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          card.imageAsset,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_border, color: colorScheme.primary, size: 28),
                const SizedBox(height: 8),
                Text(
                  card.name,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall?.copyWith(
                    fontSize: 15,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
