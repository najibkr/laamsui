import 'package:material_ui/material_ui.dart';

/// Animates the y axis scale of a transformed widget.
class ScaleYTransition extends AnimatedWidget {
  const ScaleYTransition({
    super.key,
    required Animation<double> scaleY,
    this.alignment = Alignment.center,
    this.child,
  }) : super(listenable: scaleY);

  Animation<double> get scaleY => listenable as Animation<double>;

  final Alignment alignment;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final double scaleYValue = scaleY.value;
    final Matrix4 transform = Matrix4.diagonal3Values(
      1.0, // scaleX
      scaleYValue, // scaleY
      1.0, // scaleZ
    );
    return Transform(transform: transform, alignment: alignment, child: child);
  }
}
