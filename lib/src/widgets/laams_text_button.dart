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
  final Color? hoverColor;
  final Color? focusedColor;
  final BorderRadiusGeometry borderRadius;
  final BorderSide border;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final String label;
  final double? labelFontSize;
  final Color? labelColor;
  final FontWeight? labelfontWeight;
  final IconData? trailingIcon;
  final Color? trailingIconColor;
  final double? trailingIconSize;
  final bool isExpanded;

  const LaamsTextButton({
    super.key,
    required this.onPressed,
    this.alignment,
    this.width,
    this.height,
    this.margin,
    this.padding = const EdgeInsetsDirectional.fromSTEB(10, 10, 15, 10),
    this.backgroundColor,
    this.foregroundColor,
    this.hoverColor,
    this.focusedColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(50)),
    this.border = BorderSide.none,
    this.icon,
    this.iconColor,
    this.iconSize = 20.0,
    required this.label,
    this.labelColor,
    this.labelFontSize,
    this.labelfontWeight,
    this.trailingIcon,
    this.trailingIconColor,
    this.trailingIconSize = 20.0,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.cardColor;
    final foreColor = foregroundColor ?? theme.primaryColor;
    final defLabelStyle = theme.textTheme.bodyLarge?.copyWith(
      fontSize: labelFontSize,
      fontWeight: labelfontWeight ?? FontWeight.w500,
      color: labelColor ?? foreColor,
    );

    Color? mapColor(Set<WidgetState> state) {
      final isHovered = state.contains(WidgetState.hovered);
      final defaultColor = theme.primaryColor.withOpacity(0.1);
      if (isHovered) return hoverColor ?? defaultColor;
      final isFocused = state.contains(WidgetState.focused);
      if (isFocused) return focusedColor ?? defaultColor;
      return null;
    }

    RoundedRectangleBorder? mapShape(Set<WidgetState> state) {
      return RoundedRectangleBorder(borderRadius: borderRadius, side: border);
    }

    var buttonStyle = ButtonStyle(
      visualDensity: VisualDensity.compact,
      backgroundColor: WidgetStateProperty.all(bgColor),
      foregroundColor: WidgetStateProperty.all(foreColor),
      overlayColor: WidgetStateProperty.resolveWith(mapColor),
      shape: WidgetStateProperty.resolveWith(mapShape),
    );

    Widget? iconWidget;
    if (icon != null) {
      iconWidget = Padding(
        padding: const EdgeInsetsDirectional.only(end: 5),
        child: Icon(icon, size: iconSize, color: iconColor ?? foreColor),
      );
    }

    Widget content = Text(label, style: defLabelStyle);

    Widget? trailing;
    if (trailingIcon != null) {
      trailing = Padding(
        padding: const EdgeInsetsDirectional.only(start: 5),
        child: Icon(
          trailingIcon,
          size: trailingIconSize,
          color: trailingIconColor ?? foreColor,
        ),
      );
    }

    if (iconWidget != null || trailing != null) {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconWidget != null) iconWidget,
          content,
          if (trailing != null) trailing,
        ],
      );
    }

    if (isExpanded) content = Center(child: content);
    Widget button = TextButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Padding(padding: padding, child: content),
    );

    if (height != null || width != null) {
      button = SizedBox(width: width, height: height, child: button);
    }

    if (margin != null) {
      button = Padding(padding: margin!, child: button);
    }

    if (alignment != null) {
      button = Align(alignment: alignment!, child: button);
    }

    return button;
  }
}
