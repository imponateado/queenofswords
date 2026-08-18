import 'dart:math';

import 'package:flutter/material.dart';

import 'tarot_card_widget.dart';

/// A looping riffle-shuffle animation: cards alternate dropping in from the
/// left and right hand, arcing down into the center pile, shown while the
/// real shuffle/draw (random.org call) happens in the background. Loops
/// continuously for as long as it stays mounted — the parent screen decides
/// when the real work is done and removes it, rather than the animation
/// dictating a fixed duration.
class ShuffleAnimationWidget extends StatefulWidget {
  const ShuffleAnimationWidget({super.key});

  @override
  State<ShuffleAnimationWidget> createState() => _ShuffleAnimationWidgetState();
}

class _ShuffleAnimationWidgetState extends State<ShuffleAnimationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  static const _cardCount = 8;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Fades a card in/out at the edges of its drop cycle so the loop reset
  // (local wrapping 1 -> 0) isn't visible as a pop.
  double _opacityFor(double local) {
    if (local < 0.08) return local / 0.08;
    if (local > 0.85) return (1 - local) / 0.15;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 220,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          return Stack(
            alignment: Alignment.center,
            children: List.generate(_cardCount, (i) {
              final side = i.isEven ? -1.0 : 1.0;
              // Stagger each card's drop across the loop so cards from
              // alternating hands cascade into the pile continuously.
              final local = (t + i / _cardCount) % 1.0;
              final fall = Curves.easeIn.transform(local);
              final settle = Curves.easeOut.transform(local);

              final dx = side * 46 * (1 - settle);
              final dy = -34 + 60 * fall;
              final angle = side * 0.35 * (1 - settle) + sin(local * 2 * pi) * 0.03;

              return Opacity(
                opacity: _opacityFor(local).clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset(dx, dy),
                  child: Transform.rotate(
                    angle: angle,
                    child: const CardBackFace(width: 90, height: 140),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
