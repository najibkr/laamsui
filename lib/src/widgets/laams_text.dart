import 'package:flutter/material.dart';

class LaamsText extends StatelessWidget {
  final AlignmentGeometry? alignment;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final BorderRadiusGeometry? borderRadius;

  // Text-Related Fields:
  final String text;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final Color? color;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? lineSpacing;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextOverflow? textOverflow;
  final int? maxlines;

  const LaamsText(
    this.text, {
    super.key,
    this.alignment,
    this.height,
    this.width,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.border,
    this.boxShadow,
    this.borderRadius,

    // Text-Related Fields:
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.color,
    this.wordSpacing,
    this.letterSpacing,
    this.lineSpacing,
    this.style,
    this.textOverflow,
    this.maxlines,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = theme.textTheme.bodySmall?.copyWith(
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize,
      color: color,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      height: lineSpacing,
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
      border: border,
      boxShadow: boxShadow,
      borderRadius: borderRadius,
    );

    Widget content = Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: decoration,
      child: labelWidget,
    );

    if (alignment != null) {
      content = Align(alignment: alignment!, child: content);
    }

    return content;
  }
}
