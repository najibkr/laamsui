import 'package:flutter/material.dart';

class LaamsTextCell extends StatelessWidget {
  final void Function()? onTap;
  final double? height;
  final double? width;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final AlignmentGeometry? childAlignment;
  final Widget? child;
  final String? text;
  final Widget? textsTop;
  final MainAxisAlignment textsMainAxisAlignment;
  final CrossAxisAlignment textsCrossAxisAlignment;
  final MainAxisSize textsMainAxisSize;
  final List<String> texts;
  final Widget? textsBottom;
  final MapEntry<int, Widget> Function(int index, String text)? textBuilder;
  final TextStyle? textStyle;
  final double? textTextFontSize;
  final TextAlign? textTextAlignment;
  final Color? textColor;
  final FontWeight? textTextFontWeight;
  final double? textLineHeight;
  final int? textMaxLines;
  final TextOverflow? textOverflow;
  final bool isTextSelectable;
  final List<Widget> actions;

  const LaamsTextCell({
    super.key,
    this.onTap,
    this.height,
    this.width,
    this.alignment,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.child,
    this.text,
    this.textsTop,
    this.textsMainAxisAlignment = MainAxisAlignment.start,
    this.textsCrossAxisAlignment = CrossAxisAlignment.center,
    this.textsMainAxisSize = MainAxisSize.max,
    this.texts = const [],
    this.textsBottom,
    this.textBuilder,
    this.textStyle,
    this.textTextFontSize,
    this.textTextAlignment,
    this.textColor,
    this.textTextFontWeight,
    this.textLineHeight,
    this.textMaxLines,
    this.textOverflow,
    this.childAlignment,
    this.isTextSelectable = false,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: textTextFontWeight ?? FontWeight.w400,
      fontSize: textTextFontSize,
      color: textColor,
      height: textLineHeight,
    );

    Widget textWidget = Text(
      text ?? '',
      style: textStyle ?? style,
      textAlign: textTextAlignment,
      maxLines: textMaxLines,
      overflow: textOverflow,
    );

    if (isTextSelectable) {
      textWidget = SelectableText(
        text ?? '',
        style: textStyle ?? style,
        textAlign: textTextAlignment,
        maxLines: textMaxLines,
      );
    }

    if (actions.isNotEmpty) {
      textWidget = Row(children: [Expanded(child: textWidget), ...actions]);
    }

    if (texts.isNotEmpty) {
      MapEntry<int, Widget> mapTexts(int i, String text) {
        return MapEntry(i, Text(text, style: style));
      }

      final textsWidgets = texts.asMap().map(textBuilder ?? mapTexts);
      final children = [
        if (textsTop != null) textsTop!,
        ...textsWidgets.values,
        if (textsBottom != null) textsBottom!,
      ];
      textWidget = Column(
        mainAxisAlignment: textsMainAxisAlignment,
        crossAxisAlignment: textsCrossAxisAlignment,
        mainAxisSize: textsMainAxisSize,
        children: children,
      );
    }

    final decoration = BoxDecoration(
      color: backgroundColor,
      borderRadius: borderRadius,
      border: border,
      boxShadow: boxShadow,
    );

    Widget cell = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: decoration,
      alignment: childAlignment,
      child: child ?? textWidget,
    );

    if (alignment != null) cell = Align(alignment: alignment!, child: cell);
    if (onTap == null) return cell;
    return GestureDetector(onTap: onTap, child: cell);
  }
}
