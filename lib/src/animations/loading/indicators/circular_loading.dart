import 'dart:math';

import 'package:flutter/material.dart';

class CircularLoading extends StatefulWidget {
  final double radius;
  final double dotRadius;
  const CircularLoading([
    this.radius = 18,
    this.dotRadius = 6,
    Key? key,
  ]) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CircularLoadingState createState() => _CircularLoadingState();
}

class _CircularLoadingState extends State<CircularLoading>
    with SingleTickerProviderStateMixin {
  late Animation<double> animationRotation;
  late Animation<double> animationRadiusIn;
  late Animation<double> animationRadiusOut;
  late AnimationController controller;

  late double radius;
  late double dotRadius;

  @override
  void initState() {
    super.initState();
    radius = widget.radius;
    dotRadius = widget.dotRadius;

    controller = AnimationController(
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: const Duration(milliseconds: 3000),
        vsync: this);

    animationRotation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    animationRadiusIn = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.75, 1.0, curve: Curves.elasticIn),
      ),
    );

    animationRadiusOut = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.25, curve: Curves.elasticOut),
      ),
    );

    controller.addListener(() {
      setState(() {
        if (controller.value >= 0.75 && controller.value <= 1.0) {
          radius = widget.radius * animationRadiusIn.value;
        } else if (controller.value >= 0.0 && controller.value <= 0.25) {
          radius = widget.radius * animationRadiusOut.value;
        }
      });
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {}
    });

    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color newColor = theme.cardColor;
    if (theme.brightness == Brightness.light) newColor = Colors.black12;
    final a = Transform.translate(
      offset: const Offset(0.0, 0.0),
      child: Dot(radius: radius, color: newColor),
    );

    final b = Transform.translate(
      offset: Offset(radius * cos(0.0), radius * sin(0.0)),
      child: Dot(radius: dotRadius, color: Colors.amber),
    );

    final c = Transform.translate(
      offset: Offset(
        radius * cos(0.0 + 1 * pi / 4),
        radius * sin(0.0 + 1 * pi / 4),
      ),
      child: Dot(radius: dotRadius, color: Colors.deepOrangeAccent),
    );

    final d = Transform.translate(
      offset: Offset(
        radius * cos(0.0 + 2 * pi / 4),
        radius * sin(0.0 + 2 * pi / 4),
      ),
      child: Dot(radius: dotRadius, color: Colors.pinkAccent),
    );

    final e = Transform.translate(
      offset: Offset(
        radius * cos(0.0 + 3 * pi / 4),
        radius * sin(0.0 + 3 * pi / 4),
      ),
      child: Dot(radius: dotRadius, color: Colors.purple),
    );

    final f = Transform.translate(
      offset: Offset(
        radius * cos(0.0 + 4 * pi / 4),
        radius * sin(0.0 + 4 * pi / 4),
      ),
      child: Dot(radius: dotRadius, color: Colors.yellow),
    );

    final g = Transform.translate(
      offset: Offset(
        radius * cos(0.0 + 5 * pi / 4),
        radius * sin(0.0 + 5 * pi / 4),
      ),
      child: Dot(radius: dotRadius, color: Colors.lightGreen),
    );

    final h = Transform.translate(
      offset: Offset(
        radius * cos(0.0 + 6 * pi / 4),
        radius * sin(0.0 + 6 * pi / 4),
      ),
      child: Dot(radius: dotRadius, color: Colors.orangeAccent),
    );

    final i = Transform.translate(
      offset: Offset(
        radius * cos(0.0 + 7 * pi / 4),
        radius * sin(0.0 + 7 * pi / 4),
      ),
      child: Dot(radius: dotRadius, color: Colors.blueAccent),
    );

    Widget loading = Stack(children: <Widget>[a, b, c, d, e, f, g, h, i]);
    loading = RotationTransition(turns: animationRotation, child: loading);
    return loading;
  }
}

class Dot extends StatelessWidget {
  final double? radius;
  final Color color;
  const Dot({
    super.key,
    this.radius,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
