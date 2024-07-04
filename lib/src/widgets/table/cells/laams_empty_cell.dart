import 'package:flutter/material.dart';

class LaamsEmptyCell extends StatelessWidget {
  final double height;
  final double width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  const LaamsEmptyCell({
    super.key,
    required this.height,
    required this.width,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBorder = Border.all(width: 0.5, color: theme.shadowColor);
    final decoration = BoxDecoration(
      color: backgroundColor ?? theme.cardColor,
      borderRadius: borderRadius,
      border: border ?? defaultBorder,
      boxShadow: boxShadow,
    );

    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: decoration,
    );
  }
}
