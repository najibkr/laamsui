import 'package:flutter/material.dart';

class LaamsTextButton extends StatelessWidget {
  final void Function()? onPressed;
  final AlignmentGeometry? alignment;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData icon;
  final Color? iconColor;
  final double iconSize;
  final String label;

  const LaamsTextButton({
    super.key,
    required this.onPressed,
    this.alignment,
    this.width = 130,
    this.height,
    this.margin,
    this.padding = const EdgeInsetsDirectional.fromSTEB(5, 10, 10, 10),
    this.backgroundColor,
    this.foregroundColor,
    required this.icon,
    this.iconColor,
    this.iconSize = 20.0,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.scaffoldBackgroundColor;
    final foreColor = foregroundColor ?? theme.primaryColor;
    var buttonStyle = ButtonStyle(
      visualDensity: VisualDensity.compact,
      backgroundColor: WidgetStateProperty.all(bgColor),
      foregroundColor: WidgetStateProperty.all(foreColor),
    );
    var iconWidget = Padding(
      padding: const EdgeInsetsDirectional.only(end: 5),
      child: Icon(icon, size: iconSize, color: iconColor),
    );

    var content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [iconWidget, Text(label)],
    );

    Widget button = TextButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Padding(padding: padding, child: content),
    );

    if (height != null || width != null) {
      button = SizedBox(width: width, height: height, child: button);
    }

    if (alignment != null) {
      button = Align(alignment: alignment!, child: button);
    }

    return button;
  }
}
