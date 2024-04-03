import 'package:flutter/material.dart';

/// This is an extension of the text widget, which makes the [Text] Widget,
/// for more easy to use and configure. Additionally it has more functionalities
/// For instance, you can make the text editable or selectable.
class LaamsText extends StatelessWidget {
  final AlignmentGeometry? alignment;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;

  // Text Fields
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final String? noneAsciiFontFamily;
  final double? letterSpacing;
  final double? wordSpacing;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextOverflow? textOverflow;
  final int? maxlines;

  // Directionality-related Fields:

  final bool hasAdaptiveFont;

  bool get _isLabelAscii {
    if (!hasAdaptiveFont) return true;
    if (text.contains(RegExp(r'[A-Z]'))) return true;
    if (text.contains(RegExp(r'[a-z]'))) return true;
    return false;
  }

  const LaamsText(
    this.text, {
    super.key,
    this.alignment,
    this.height,
    this.width,
    this.margin,
    this.padding = const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
    this.backgroundColor,
    this.boxShadow,
    this.border,
    this.borderRadius = const BorderRadius.all(Radius.circular(5)),

    // Text Fields:
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.noneAsciiFontFamily = 'Vazir',
    this.wordSpacing,
    this.letterSpacing,
    this.style,
    this.textOverflow,
    this.maxlines,
    this.textAlign = TextAlign.center,
    this.hasAdaptiveFont = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = theme.textTheme.bodySmall?.copyWith(
      fontWeight: fontWeight,
      color: color,
      fontFamily: _isLabelAscii ? fontFamily : noneAsciiFontFamily,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
    );

    Widget labelWidget = Text(
      text,
      style: style ?? defaultStyle,
      textAlign: textAlign,
      maxLines: maxlines,
      overflow: textOverflow,
    );

    final decoration = BoxDecoration(
      color: backgroundColor,
      borderRadius: borderRadius,
      border: border,
      boxShadow: boxShadow,
    );

    Widget jaguarText = Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: decoration,
      child: labelWidget,
    );

    if (alignment != null) {
      jaguarText = Align(alignment: alignment!, child: jaguarText);
    }

    return jaguarText;
  }
}
