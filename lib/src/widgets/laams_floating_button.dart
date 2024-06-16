import 'package:flutter/material.dart';
import 'package:laamsui/src/extensions/viewport_extension.dart';

class LaamsFloatingButton extends StatelessWidget {
  final void Function()? onPressed;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? decorationColor;
  final BoxBorder? border;
  final BorderRadiusGeometry borderRadius;
  final List<BoxShadow>? boxShadow;
  final IconData icon;
  final double iconSize;
  final Color? iconColor;
  final String titleText;
  final TextStyle? titleStyle;
  final Widget? title;
  final String? tooltip;
  final double spacing;

  const LaamsFloatingButton({
    super.key,
    this.onPressed,
    this.height,
    this.width,
    this.margin,
    this.backgroundColor,
    this.decorationColor,
    this.border,
    this.borderRadius = const BorderRadius.all(Radius.circular(50)),
    this.boxShadow,
    this.padding,
    this.icon = Icons.add_outlined,
    this.iconColor,
    this.iconSize = 24,
    required this.titleText,
    this.titleStyle,
    this.title,
    this.tooltip,
    this.spacing = 5,
  });

  double _inferVerticalPadding(BuildContext context) {
    final isXs = context.isXS;
    final isS = context.isS;
    if (isXs) return 6;
    if (isS) return 7;
    return 8;
  }

  @override
  Widget build(BuildContext context) {
    final isXs = context.isXS;
    final isS = context.isS;
    final theme = Theme.of(context);

    final defShadow = BoxShadow(
      color: decorationColor?.withOpacity(0.5) ??
          theme.primaryColor.withOpacity(0.5),
      blurRadius: 8,
    );
    final defPadding = EdgeInsetsDirectional.only(
      start: 10,
      top: _inferVerticalPadding(context),
      end: 18,
      bottom: _inferVerticalPadding(context),
    );

    final double smallSize = isXs ? 13 : 14;
    final defTitleSyle = theme.textTheme.displaySmall?.copyWith(
      color: decorationColor ?? theme.primaryColor,
      fontSize: isS ? smallSize : 15,
      fontWeight: FontWeight.w500,
    );

    final iconWidget = Icon(
      icon,
      color: iconColor ?? theme.primaryColor,
      size: iconSize,
    );

    Widget titleWidget = Text(
      titleText.toUpperCase(),
      style: titleStyle ?? defTitleSyle,
    );

    if (title != null) titleWidget = title!;

    final space = SizedBox(width: isXs ? spacing / 2 : spacing);
    Widget buttonItems = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [iconWidget, space, titleWidget],
    );

    final btnDecoration = BoxDecoration(
      color: backgroundColor ?? theme.scaffoldBackgroundColor,
      borderRadius: borderRadius,
      border: border ??
          Border.all(
            width: 3,
            color: decorationColor ?? theme.primaryColor,
          ),
      boxShadow: boxShadow ?? [defShadow],
    );

    buttonItems = Container(
      height: height,
      width: width,
      padding: padding ?? defPadding,
      decoration: btnDecoration,
      child: buttonItems,
    );

    if (tooltip != null) {
      var tooltipDecoration = BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.primaryColor,
      );

      buttonItems = Tooltip(
        message: tooltip,
        decoration: tooltipDecoration,
        child: buttonItems,
      );
    }

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(onTap: onPressed, child: buttonItems),
    );
  }
}
