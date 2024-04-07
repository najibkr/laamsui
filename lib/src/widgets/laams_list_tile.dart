import 'package:flutter/material.dart';

class LaamsListTile extends StatelessWidget {
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final void Function()? onDoubleTap;
  final double? height;
  final double? width;

  /// The outer most alignment of the whole JaguarListTile
  final AlignmentGeometry? listTileBoxAlignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  // Content Fields:
  final Widget? header;
  final MainAxisAlignment contentMainAxisAlignment;
  final CrossAxisAlignment contentCrossAxisAlignment;
  final MainAxisSize contentMainAxisSize;

  /// This includes the alignment of leading, prefix,
  /// title, suffix and trailing relative to each other horizontally.
  final MainAxisAlignment innerMainAxisAlignment;

  /// This includes the alignment of leading, prefix,
  /// title, suffix and trailing relative to each other horizontally.
  final CrossAxisAlignment innerCrossAxisAlignment;

  /// This includes the alignment of leading, prefix,
  /// title, suffix and trailing relative to each other horizontally.
  final MainAxisSize innerMainAxisSize;

  /// This includes the alignment of prefix, title and suffix
  /// relative to each other horizontally.
  final MainAxisAlignment topMainAxisAlignment;

  /// This includes the alignment of prefix, title and suffix
  /// relative to each other horizontally.
  final CrossAxisAlignment topCrossAxisAlignment;

  /// This includes the alignment of top, sutitle and bottom
  final MainAxisSize topMainAxisSize;

  /// This includes the alignment of top, sutitle and bottom
  final MainAxisAlignment middleMainAxisAlignment;

  /// This includes the alignment of top, sutitle and bottom
  final CrossAxisAlignment middleCrossAxisAlignment;

  /// This includes the alignment of prefix, title and suffix
  /// relative to each other horizontally.
  final MainAxisSize middleMainAxisSize;

  // Leading Fields:
  final Widget? leading;
  final IconData? leadingIcon;
  final double leadingIconSize;
  final Color? leadingIconColor;

  // Prefix:
  final Widget? prefix;
  final IconData? prefixIcon;
  final double prefixIconSize;
  final Color? prefixIconColor;

  // Title Fields:
  final Widget? title;
  final int? titleFlex;
  final String? titleText;
  final double? titleTextFontSize;
  final Color? titleTextColor;
  final FontWeight? titleTextFontWeight;
  final TextStyle? titleTextStyle;
  final TextAlign? titleTextAlign;
  final int? titleTextMaxLines;
  final double? titleTextLineSpacing;
  final TextOverflow? titleTextOverflow;

  // Suffix Fields:
  final Widget? suffix;
  final int? suffixFlex;
  final String? suffixText;
  final double? suffixTextFontSize;
  final Color? suffixTextColor;
  final FontWeight? suffixTextFontWeight;
  final TextStyle? suffixTextStyle;
  final TextAlign? suffixTextAlign;
  final int? suffixTextMaxLines;
  final double? suffixTextLineSpacing;
  final TextOverflow? suffixTextOverflow;

  // Subtitle Fields:
  final Widget? subtitle;
  final String? subtitleText;
  final double? subtitleTextFontSize;
  final Color? subtitleTextColor;
  final FontWeight? subtitleTextFontWeight;
  final TextStyle? subtitleTextStyle;
  final TextAlign? subtitleTextAlign;
  final int? subtitleTextMaxLines;
  final double? subtitleTextLineSpacing;
  final TextOverflow? subtitleTextOverflow;
  final List<Widget> bottom;
  final Widget? trailing;
  final Widget? footer;

  final double horizontalSpacing;
  final double verticalSpacing;

  const LaamsListTile({
    super.key,
    this.onPressed,
    this.onLongPress,
    this.onDoubleTap,
    this.height,
    this.width,
    this.listTileBoxAlignment,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,

    // Content Fields
    this.header,
    this.contentMainAxisAlignment = MainAxisAlignment.center,
    this.contentCrossAxisAlignment = CrossAxisAlignment.center,
    this.contentMainAxisSize = MainAxisSize.min,
    this.innerMainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.innerCrossAxisAlignment = CrossAxisAlignment.center,
    this.innerMainAxisSize = MainAxisSize.min,
    this.topMainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.topCrossAxisAlignment = CrossAxisAlignment.center,
    this.topMainAxisSize = MainAxisSize.max,
    this.middleMainAxisAlignment = MainAxisAlignment.center,
    this.middleCrossAxisAlignment = CrossAxisAlignment.start,
    this.middleMainAxisSize = MainAxisSize.min,

    // Leading Fields:
    this.leading,
    this.leadingIcon,
    this.leadingIconColor,
    this.leadingIconSize = 25,

    // Prefix Fields:
    this.prefix,
    this.prefixIcon,
    this.prefixIconSize = 24,
    this.prefixIconColor,

    // Title Fields:
    this.title,
    this.titleFlex = 1,
    this.titleText,
    this.titleTextFontSize,
    this.titleTextColor,
    this.titleTextFontWeight,
    this.titleTextStyle,
    this.titleTextAlign,
    this.titleTextMaxLines,
    this.titleTextLineSpacing,
    this.titleTextOverflow,

    // Suffix Fields:
    this.suffix,
    this.suffixFlex,
    this.suffixText,
    this.suffixTextFontSize,
    this.suffixTextColor,
    this.suffixTextFontWeight,
    this.suffixTextStyle,
    this.suffixTextAlign,
    this.suffixTextMaxLines,
    this.suffixTextLineSpacing,
    this.suffixTextOverflow,

    // Subtitle Fields:
    this.subtitle,
    this.subtitleText,
    this.subtitleTextFontSize,
    this.subtitleTextColor,
    this.subtitleTextFontWeight,
    this.subtitleTextStyle,
    this.subtitleTextAlign,
    this.subtitleTextMaxLines,
    this.subtitleTextLineSpacing,
    this.subtitleTextOverflow,
    this.bottom = const [],
    this.trailing,
    this.footer,
    this.horizontalSpacing = 6,
    this.verticalSpacing = 3,
  });

  bool get _hasPrefixOrSuffix {
    if (prefix != null) return true;
    if (prefixIcon != null) return true;
    if (suffix != null) return true;
    if (suffixText != null) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final horizontalSpace = SizedBox(width: horizontalSpacing);
    final verticalSpace = SizedBox(height: verticalSpacing);
    final defaultTitleStyle = theme.textTheme.displaySmall?.copyWith(
      fontSize: titleTextFontSize,
      color: titleTextColor,
      fontWeight: titleTextFontWeight,
      height: titleTextLineSpacing,
    );

    final decoration = BoxDecoration(
      color: backgroundColor,
      borderRadius: borderRadius,
      border: border,
      boxShadow: boxShadow,
    );

    Widget content = Text(
      titleText ?? '',
      style: titleTextStyle ?? defaultTitleStyle,
      textAlign: titleTextAlign,
      maxLines: titleTextMaxLines,
      overflow: titleTextOverflow,
    );
    if (title != null) content = title!;

    if (_hasPrefixOrSuffix) {
      Widget? newPrefix;
      if (prefixIcon != null) {
        newPrefix = Icon(
          prefixIcon,
          color: prefixIconColor,
          size: prefixIconSize,
        );
      }
      if (prefix != null) newPrefix = prefix;

      Widget newTitle = content;
      if (titleFlex != null) {
        newTitle = Expanded(flex: titleFlex ?? 1, child: newTitle);
      }

      Widget? newSuffix;
      if (suffixText != null) {
        final style = theme.textTheme.bodyMedium?.copyWith(
          fontSize: suffixTextFontSize,
          color: suffixTextColor,
          fontWeight: suffixTextFontWeight,
          height: suffixTextLineSpacing,
        );
        newSuffix = Text(
          suffixText ?? '',
          style: suffixTextStyle ?? style,
          textAlign: suffixTextAlign,
          maxLines: suffixTextMaxLines,
          overflow: suffixTextOverflow,
        );
      }
      if (suffix != null) newSuffix = suffix;
      if (newSuffix != null && suffixFlex != null) {
        newSuffix = Expanded(flex: suffixFlex ?? 1, child: newSuffix);
      }

      content = Row(
        mainAxisAlignment: topMainAxisAlignment,
        crossAxisAlignment: topCrossAxisAlignment,
        mainAxisSize: topMainAxisSize,
        children: [
          if (newPrefix != null) newPrefix,
          if (prefix != null || prefixIcon != null) horizontalSpace,
          newTitle,
          if (suffix != null || suffixText != null) horizontalSpace,
          if (newSuffix != null) newSuffix,
        ],
      );
    }

    if (subtitle != null || subtitleText != null || bottom.isNotEmpty) {
      Widget? newSubtitle;
      if (subtitleText != null) {
        final style = theme.textTheme.bodyLarge?.copyWith(
          fontSize: subtitleTextFontSize,
          color: subtitleTextColor,
          fontWeight: subtitleTextFontWeight,
          height: subtitleTextLineSpacing,
        );
        newSubtitle = Text(
          subtitleText ?? '',
          style: subtitleTextStyle ?? style,
          textAlign: subtitleTextAlign,
          maxLines: subtitleTextMaxLines,
          overflow: subtitleTextOverflow,
        );
      }
      if (subtitle != null) newSubtitle = subtitle;

      content = Column(
        mainAxisAlignment: middleMainAxisAlignment,
        crossAxisAlignment: middleCrossAxisAlignment,
        mainAxisSize: middleMainAxisSize,
        children: [
          content,
          if (newSubtitle != null) verticalSpace,
          if (newSubtitle != null) newSubtitle,
          if (bottom.isNotEmpty) verticalSpace,
          ...bottom,
        ],
      );
    }

    if (leading != null || leadingIcon != null || trailing != null) {
      Widget? newLeading;
      if (leadingIcon != null) {
        newLeading = Icon(
          leadingIcon,
          size: leadingIconSize,
          color: leadingIconColor,
        );
      }
      if (leading != null) newLeading = leading;

      content = Row(
        mainAxisAlignment: innerMainAxisAlignment,
        crossAxisAlignment: innerCrossAxisAlignment,
        mainAxisSize: innerMainAxisSize,
        children: [
          if (newLeading != null) newLeading,
          if (newLeading != null) horizontalSpace,
          Expanded(child: content),
          if (trailing != null) horizontalSpace,
          if (trailing != null) trailing!,
        ],
      );
    }

    if (header != null || footer != null) {
      content = Column(
        mainAxisAlignment: contentMainAxisAlignment,
        crossAxisAlignment: contentCrossAxisAlignment,
        mainAxisSize: contentMainAxisSize,
        children: [
          if (header != null) header!,
          if (header != null) verticalSpace,
          content,
          if (footer != null) verticalSpace,
          if (footer != null) footer!,
        ],
      );
    }

    Widget tile = GestureDetector(
      onTap: onPressed,
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        padding: padding,
        decoration: decoration,
        child: content,
      ),
    );

    if (listTileBoxAlignment != null) {
      tile = Align(alignment: listTileBoxAlignment!, child: tile);
    }

    return tile;
  }
}
