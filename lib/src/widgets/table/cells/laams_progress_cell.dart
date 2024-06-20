import 'package:flutter/material.dart';

class LaamsProgressCell extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry margin;
  final double percentage;
  final Color? indicatorColor;
  const LaamsProgressCell({
    super.key,
    this.height = double.infinity,
    this.margin = const EdgeInsets.all(2),
    required this.percentage,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (indicatorColor == null) {
      true => const Color(0xFF00B050),
      false => indicatorColor,
    };

    final progress = LinearProgressIndicator(
      value: percentage / 100,
      backgroundColor: color?.withOpacity(0.1),
      color: color?.withOpacity(0.25),
      semanticsValue: '20%',
      semanticsLabel: '20%',
      minHeight: height,
    );

    final title = Text(
      '${percentage.toStringAsFixed(0)} %',
      textAlign: TextAlign.center,
      style: theme.textTheme.bodyLarge?.copyWith(color: color),
    );

    final stack = Stack(
      alignment: Alignment.center,
      children: [progress, Positioned(child: title)],
    );

    return Padding(padding: margin, child: stack);
  }
}
