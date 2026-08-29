import 'dart:math';

import 'package:material_ui/material_ui.dart';

import '../shape/indicator_painter.dart';

/// CubeTransition.
class CubeTransition extends StatefulWidget {
  const CubeTransition({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CubeTransitionState createState() => _CubeTransitionState();
}

class _CubeTransitionState extends State<CubeTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Size?> _translateAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _translateAnimation =
        TweenSequence([
          TweenSequenceItem(
            tween: SizeTween(
              begin: const Size(0.0, 0.0),
              end: const Size(1.0, 0.0),
            ),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: SizeTween(
              begin: const Size(1.0, 0.0),
              end: const Size(1.0, 1.0),
            ),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: SizeTween(
              begin: const Size(1.0, 1.0),
              end: const Size(0.0, 1.0),
            ),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: SizeTween(
              begin: const Size(0.0, 1.0),
              end: const Size(0.0, 0.0),
            ),
            weight: 1,
          ),
        ]).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.linear),
        );

    _rotateAnimation =
        TweenSequence([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -pi / 2), weight: 1),
          TweenSequenceItem(
            tween: Tween(begin: -pi / 2, end: -pi),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: Tween(begin: -pi, end: -pi * 1.5),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: Tween(begin: -pi * 1.5, end: -pi * 2),
            weight: 1,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _scaleAnimation =
        TweenSequence([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.5), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.5), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.0), weight: 1),
        ]).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraint) {
        final squareSize = constraint.maxWidth / 5;

        final deltaX = constraint.maxWidth - squareSize;
        final deltaY = constraint.maxHeight - squareSize;

        return AnimatedBuilder(
          animation: _animationController,
          builder: (_, child) => Stack(
            children: [
              Positioned.fromRect(
                rect: Rect.fromLTWH(0, 0, squareSize, squareSize),
                child: Transform(
                  alignment: Alignment.center,
                  transform:
                      Matrix4.translationValues(
                        _translateAnimation.value!.width * deltaX,
                        _translateAnimation.value!.height * deltaY,
                        0.0, // z translation
                      ) *
                      Matrix4.rotationZ(_rotateAnimation.value) *
                      Matrix4.diagonal3Values(
                        _scaleAnimation.value, // scaleX
                        _scaleAnimation.value, // scaleY
                        1.0, // scaleZ
                      ),
                  child: const IndicatorShapeWidget(
                    shape: Shape.rectangle,
                    index: 0,
                  ),
                ),
              ),
              Positioned.fromRect(
                rect: Rect.fromLTWH(
                  constraint.maxWidth - squareSize,
                  constraint.maxHeight - squareSize,
                  squareSize,
                  squareSize,
                ),
                child: Transform(
                  alignment: Alignment.center,
                  transform:
                      Matrix4.translationValues(
                        -_translateAnimation.value!.width * deltaX,
                        -_translateAnimation.value!.height * deltaY,
                        0.0, // z-axis translation
                      ) *
                      Matrix4.rotationZ(_rotateAnimation.value) *
                      Matrix4.diagonal3Values(
                        _scaleAnimation.value, // scaleX
                        _scaleAnimation.value, // scaleY
                        1.0, // scaleZ
                      ),
                  child: const IndicatorShapeWidget(
                    shape: Shape.rectangle,
                    index: 1,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
