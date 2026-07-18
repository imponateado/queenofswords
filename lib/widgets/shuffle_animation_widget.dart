import 'dart:math';

import 'package:flutter/material.dart';

import 'tarot_card_widget.dart';

/// A looping "riffle" animation of a handful of card backs, shown while the
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
    duration: const Duration(milliseconds: 900),
  )..repeat();

  static const _cardCount = 6;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              final phase = i * (2 * pi / _cardCount);
              final dx = sin(t * 2 * pi + phase) * 24;
              final dy = cos(t * 2 * pi * 1.3 + phase) * 10;
              final angle = sin(t * 2 * pi + phase) * 0.18;
              return Transform.translate(
                offset: Offset(dx, dy),
                child: Transform.rotate(
                  angle: angle,
                  child: const CardBackFace(width: 90, height: 140),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
