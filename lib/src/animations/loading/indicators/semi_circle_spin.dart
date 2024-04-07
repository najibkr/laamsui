import 'package:flutter/material.dart';

import '../shape/indicator_painter.dart';

/// SemiCircleSpin.
class SemiCircleSpin extends StatefulWidget {
  const SemiCircleSpin({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SemiCircleSpinState createState() => _SemiCircleSpinState();
}

class _SemiCircleSpinState extends State<SemiCircleSpin>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _animation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.5), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.0), weight: 1),
    ]).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: const IndicatorShapeWidget(shape: Shape.circleSemi),
    );
  }
}
