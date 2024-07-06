import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laamsui/laamsui.dart' show LaamsIcons;

class LaamsMessageCard extends StatelessWidget {
  final bool isSliver;
  final double? height;
  final double width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;

  // Vector-Related Fields:
  final Widget? vector;
  final String? svgPath;
  final String svgPackage;
  final IconData? icon;
  final Color? iconColor;
  final double vectorSize;

  // Title-Related Fields:
  final String? titleText;
  final double? titleTextFontSize;
  final Color? titleTextColor;
  final FontWeight? titleTextFontWeight;
  final TextStyle? titleTextStyle;
  final TextAlign? titleTextAlign;
  final int? titleTextMaxLines;
  final double? titleTextLineSpacing;
  final TextOverflow? titleTextOverflow;

  // Message-Related Fields:
  final String? messageText;
  final double? messageTextFontSize;
  final Color? messageTextColor;
  final FontWeight? messageTextFontWeight;
  final TextStyle? messageTextStyle;
  final TextAlign? messageTextAlign;
  final int? messageTextMaxLines;
  final double? messageTextLineSpacing;
  final TextOverflow? messageTextOverflow;

  // Buttons-Related Fields:
  final void Function()? onAccept;
  final IconData? acceptIcon;
  final String? acceptLabel;
  final void Function()? onReject;
  final IconData? rejectIcon;
  final String? rejectLabel;
  final double? buttonsWidth;

  // Other Fields
  final double spacing;

  const LaamsMessageCard({
    super.key,
    this.height,
    this.width = 550,
    this.margin,
    this.padding = const EdgeInsets.all(20),
    this.vector,
    this.svgPath,
    this.svgPackage = 'laamsui',
    this.icon,
    this.iconColor,
    this.vectorSize = 120,

    // Title-Related Fields:
    this.titleText,
    this.titleTextFontSize,
    this.titleTextColor,
    this.titleTextFontWeight,
    this.titleTextStyle,
    this.titleTextAlign,
    this.titleTextMaxLines,
    this.titleTextLineSpacing,
    this.titleTextOverflow,

    // Message-Related Fields:
    this.messageText,
    this.messageTextFontSize,
    this.messageTextColor,
    this.messageTextFontWeight,
    this.messageTextStyle,
    this.messageTextAlign,
    this.messageTextMaxLines,
    this.messageTextLineSpacing,
    this.messageTextOverflow,

    // Buttons-Related Fields:
    this.onAccept,
    this.acceptIcon,
    this.acceptLabel,
    this.onReject,
    this.rejectIcon,
    this.rejectLabel,
    this.buttonsWidth = 140,

    // Other Fields:
    this.spacing = 12,
  }) : isSliver = false;

  const LaamsMessageCard.sliver({
    super.key,
    this.height,
    this.width = 550,
    this.margin,
    this.padding = const EdgeInsets.all(20),
    this.vector,
    this.svgPath,
    this.svgPackage = 'laamsui',
    this.icon,
    this.iconColor,
    this.vectorSize = 120,

    // Title-Related Fields:
    this.titleText,
    this.titleTextFontSize,
    this.titleTextColor,
    this.titleTextFontWeight,
    this.titleTextStyle,
    this.titleTextAlign,
    this.titleTextMaxLines,
    this.titleTextLineSpacing,
    this.titleTextOverflow,

    // Message-Related Fields:
    this.messageText,
    this.messageTextFontSize,
    this.messageTextColor,
    this.messageTextFontWeight,
    this.messageTextStyle,
    this.messageTextAlign,
    this.messageTextMaxLines,
    this.messageTextLineSpacing,
    this.messageTextOverflow,

    // Buttons-Related Fields:
    this.onAccept,
    this.acceptIcon,
    this.acceptLabel,
    this.onReject,
    this.rejectIcon,
    this.rejectLabel,
    this.buttonsWidth = 140,

    // Other Fields:
    this.spacing = 12,
  }) : isSliver = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = SizedBox(height: spacing, width: spacing);
    Widget? header;
    if (svgPath != null) {
      header = SvgPicture.asset(
        svgPath ?? '',
        semanticsLabel: 'Message',
        package: svgPackage,
        height: vectorSize,
        width: vectorSize,
        fit: BoxFit.contain,
        allowDrawingOutsideViewBox: true,
        placeholderBuilder: _buildsvgPlaceholder,
      );
    }

    if (icon != null) {
      header = Icon(
        icon,
        size: vectorSize,
        color: iconColor ?? theme.primaryColor,
      );
    }
    if (vector != null) header = vector;

    Widget? title;
    if ((titleText ?? '').trim().isNotEmpty) {
      final style = theme.textTheme.displayLarge?.copyWith(
        fontSize: titleTextFontSize,
        color: titleTextColor,
        fontWeight: titleTextFontWeight,
        height: titleTextLineSpacing,
      );

      title = Text(
        (titleText ?? '').toUpperCase(),
        style: titleTextStyle ?? style,
        textAlign: titleTextAlign ?? TextAlign.center,
        maxLines: titleTextMaxLines,
        overflow: titleTextOverflow,
      );
    }

    Widget? message;
    if ((messageText ?? '').trim().isNotEmpty) {
      final style = theme.textTheme.bodyLarge?.copyWith(
        fontSize: messageTextFontSize,
        color: messageTextColor,
        fontWeight: messageTextFontWeight,
        height: messageTextLineSpacing,
      );

      message = Text(
        messageText ?? '',
        style: messageTextStyle ?? style,
        textAlign: messageTextAlign ?? TextAlign.center,
        maxLines: messageTextMaxLines,
        overflow: messageTextOverflow,
      );
    }

    Widget? acceptBtn;
    if ((acceptLabel ?? '').trim().isNotEmpty) {
      acceptBtn = LaamsMessageBtn(
        onPressed: onAccept,
        icon: acceptIcon,
        label: acceptLabel ?? '',
        width: buttonsWidth,
        backgroundColor: const Color(0xFF00B050).withOpacity(0.2),
        foregroundColor: const Color(0xFF00b050),
      );
    }

    Widget? rejectBtn;
    if ((rejectLabel ?? '').trim().isNotEmpty) {
      rejectBtn = LaamsMessageBtn(
        onPressed: onReject,
        icon: rejectIcon,
        label: rejectLabel ?? '',
        width: buttonsWidth,
        backgroundColor: Colors.red[50],
        foregroundColor: Colors.red,
        hoverColor: Colors.red[100],
        focusedColor: Colors.red[200],
      );
    }

    Widget? buttons;
    if (acceptBtn != null || rejectBtn != null) {
      buttons = Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          if (acceptBtn != null) acceptBtn,
          if (rejectBtn != null) rejectBtn,
        ],
      );
    }

    Widget items = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (header != null) header,
        if (header != null && title != null) space,
        if (title != null) title,
        if (title != null && message != null) space,
        if (message != null) message,
        if (message != null || buttons != null) space,
        if (message != null || buttons != null) space,
        if (buttons != null) buttons,
      ],
    );

    Widget container = Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      child: items,
    );

    if (!isSliver) return Center(child: container);
    return SliverToBoxAdapter(child: Center(child: container));
  }

  Widget _buildsvgPlaceholder(BuildContext context) {
    return Icon(
      LaamsIcons.notifications_outline,
      size: 100,
      color: iconColor ?? Theme.of(context).primaryColor,
    );
  }
}

class LaamsMessageBtn extends StatelessWidget {
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
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final String label;
  final bool isExpanded;

  const LaamsMessageBtn({
    super.key,
    required this.onPressed,
    this.alignment,
    this.width,
    this.height,
    this.margin,
    this.padding = const EdgeInsetsDirectional.fromSTEB(5, 9, 15, 9),
    this.backgroundColor,
    this.foregroundColor,
    this.hoverColor,
    this.focusedColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(50)),
    this.icon,
    this.iconColor,
    this.iconSize = 20.0,
    required this.label,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.cardColor;
    final foreColor = foregroundColor ?? theme.primaryColor;

    Color? mapColor(Set<WidgetState> state) {
      final isHovered = state.contains(WidgetState.hovered);
      final defaultColor = theme.primaryColor.withOpacity(0.1);
      if (isHovered) return hoverColor ?? defaultColor;
      final isFocused = state.contains(WidgetState.focused);
      if (isFocused) return focusedColor ?? defaultColor;
      return null;
    }

    RoundedRectangleBorder? mapShape(Set<WidgetState> state) {
      return RoundedRectangleBorder(
        borderRadius: borderRadius,
      );
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
        child: Icon(icon, size: iconSize, color: iconColor),
      );
    }

    Widget content = Text(label);
    if (iconWidget != null) {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [iconWidget, Text(label)],
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
