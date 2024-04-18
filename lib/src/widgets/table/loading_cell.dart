import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoadingCell extends StatelessWidget {
  const LoadingCell({super.key});

  @override
  Widget build(BuildContext context) {
    var boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(200),
      color: Theme.of(context).primaryColor.withOpacity(0.15),
    );
    var container = Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: boxDecoration,
      height: 20,
    );

    return Center(
      child: container
          .animate(onPlay: (c) => c.repeat())
          .shimmer(duration: 1500.ms, size: 2),
    );
  }
}
