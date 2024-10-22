import 'package:flutter/material.dart';

import '../shape/indicator_painter.dart';

/// BallScale.
class BallScale extends StatefulWidget {
  const BallScale({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BallScaleState createState() => _BallScaleState();
}

class _BallScaleState extends State<BallScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _opacityAnimation = ReverseAnimation(_scaleAnimation);
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: const IndicatorShapeWidget(shape: Shape.circle),
      ),
    );
  }
}
