import 'package:flutter/material.dart';
import 'package:laamsui/src/extensions/viewport_extension.dart';

class LaamsOptionsCell<V> extends StatefulWidget {
  final AlignmentDirectional overlayAnchorAlignment;
  final AlignmentDirectional overlayPopupAlignment;
  final double xOffset;
  final double yOffset;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double menuHeight;
  final double menuWidth;
  final EdgeInsetsGeometry? optionsMargin;
  final EdgeInsetsGeometry optionsPadding;
  final String? hintText;
  final Widget? optionsHeader;
  final ScrollController? optionsScrollController;
  final List<LaamsCellOption<V>> options;
  final V? initialValue;
  final void Function(V?)? onSelected;
  final bool enabled;
  final Widget? cell;
  final Widget? optionsFooter;

  // Anchor-Related Fields;
  final AlignmentGeometry anchorAlignment;

  const LaamsOptionsCell({
    super.key,
    this.overlayAnchorAlignment = AlignmentDirectional.bottomCenter,
    this.overlayPopupAlignment = AlignmentDirectional.topCenter,
    this.xOffset = 0,
    this.yOffset = 0,
    this.height,
    this.width,
    this.margin = const EdgeInsets.all(0.5),
    this.padding = const EdgeInsets.symmetric(horizontal: 3),
    this.menuHeight = 350,
    this.menuWidth = 280,
    this.optionsMargin,
    this.optionsPadding =
        const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
    this.hintText,
    this.optionsHeader,
    this.optionsScrollController,
    this.options = const [],
    this.initialValue,
    this.onSelected,
    this.enabled = true,
    this.cell,
    this.optionsFooter,

    // Anchor-Related Field:
    this.anchorAlignment = AlignmentDirectional.center,
  });

  @override
  State<LaamsOptionsCell<V>> createState() => _LaamsOptionsCellState();
}

class _LaamsOptionsCellState<V> extends State<LaamsOptionsCell<V>> {
  bool _isHovered = false;
  bool _isFocused = false;
  OverlayPortalController _controller = OverlayPortalController();
  late LayerLink _link = LayerLink();

  Alignment _inferAlignment(
    BuildContext context,
    AlignmentDirectional alignment,
  ) {
    final isRTL = context.isRTL;

    final isTopEnd = alignment == AlignmentDirectional.topEnd;
    if (isTopEnd) return isRTL ? Alignment.topLeft : Alignment.topRight;

    final isEnd = alignment == AlignmentDirectional.centerEnd;
    if (isEnd) return isRTL ? Alignment.centerLeft : Alignment.centerRight;

    final isBotEnd = alignment == AlignmentDirectional.bottomEnd;
    if (isBotEnd) return isRTL ? Alignment.bottomLeft : Alignment.bottomRight;

    final isTopStart = alignment == AlignmentDirectional.topStart;
    if (isTopStart) return isRTL ? Alignment.topRight : Alignment.topLeft;

    final isStart = alignment == AlignmentDirectional.centerStart;
    if (isStart) return isRTL ? Alignment.centerRight : Alignment.centerLeft;

    final isBStart = alignment == AlignmentDirectional.bottomStart;
    if (isBStart) return isRTL ? Alignment.bottomRight : Alignment.bottomLeft;

    final isTopCenter = alignment == AlignmentDirectional.topCenter;
    if (isTopCenter) return Alignment.topCenter;

    final isBCenter = alignment == AlignmentDirectional.bottomCenter;
    if (isBCenter) return Alignment.bottomCenter;

    return Alignment.center;
  }

  void _handleOnSelected(V? value) {
    _controller.hide();
    if (widget.onSelected != null) widget.onSelected!(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintStyle = theme.inputDecorationTheme.hintStyle;

    final hint = Text(
      widget.hintText ?? '',
      style: hintStyle?.copyWith(fontSize: 14),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    final border = Border.all(width: 2, color: theme.primaryColor);
    final radius = BorderRadius.circular(5);
    final decoration = BoxDecoration(
      color: (_isHovered || _isFocused) ? theme.cardColor : null,
      borderRadius: _isFocused ? radius : null,
      border: _isFocused ? border : null,
    );

    Widget cell = Container(
      alignment: widget.anchorAlignment,
      height: widget.height,
      width: widget.width,
      margin: widget.margin,
      padding: widget.padding,
      decoration: decoration,
      child: widget.cell ?? hint,
    );

    final optionExists = widget.options.any(
      (e) => e.value == widget.initialValue,
    );

    if (widget.initialValue != null && optionExists && widget.cell == null) {
      final found = widget.options.firstWhere(
        (e) => e.value == widget.initialValue,
      );

      cell = LaamsCellOption<V>(
        value: found.value,
        height: widget.height,
        width: widget.width,
        borderRadius: _isFocused ? radius : null,
        border: _isFocused ? border : null,
        alignment: widget.anchorAlignment,
        margin: const EdgeInsets.symmetric(horizontal: 0.5, vertical: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 3),
        backgroundColor: found.backgroundColor,
        foregroundColor: found.foregroundColor,
        titleText: found.titleText,
      );
    }

    if (widget.enabled) {
      cell = CompositedTransformTarget(
        link: _link,
        child: cell,
      );

      cell = OverlayPortal.targetsRootOverlay(
        controller: _controller,
        overlayChildBuilder: _buildOverlay,
        child: cell,
      );
    }

    final detector = FocusableActionDetector(
      onFocusChange: (v) => v ? _controller.show() : _controller.hide(),
      onShowFocusHighlight: (v) => setState(() => _isFocused = v),
      onShowHoverHighlight: (v) => setState(() => _isHovered = v),
      enabled: widget.enabled,
      child: cell,
    );

    return GestureDetector(
      onTap: _controller.show,
      child: detector,
    );
  }

  Widget _buildOverlay(BuildContext context) {
    Widget container = _OverlayContent(
      onSelected: _handleOnSelected,
      margin: widget.optionsMargin,
      padding: widget.optionsPadding,
      header: widget.optionsHeader,
      scrollController: widget.optionsScrollController,
      initialValue: widget.initialValue,
      options: widget.options,
      footer: widget.optionsFooter,
    );

    container = TapRegion(
      onTapOutside: (_) => _controller.hide(),
      child: container,
    );

    container = CompositedTransformFollower(
      link: _link,
      showWhenUnlinked: false,
      targetAnchor: _inferAlignment(context, widget.overlayAnchorAlignment),
      followerAnchor: _inferAlignment(context, widget.overlayPopupAlignment),
      offset: Offset(widget.xOffset, widget.yOffset),
      child: container,
    );

    return PositionedDirectional(
      height: widget.menuHeight,
      width: widget.menuWidth,
      child: container,
    );
  }
}

class _OverlayContent<V> extends StatefulWidget {
  final void Function(V?) onSelected;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? header;
  final ScrollController? scrollController;
  final V? initialValue;
  final List<LaamsCellOption<V>> options;
  final Widget? footer;

  const _OverlayContent({
    required this.onSelected,
    required this.margin,
    required this.padding,
    required this.header,
    required this.scrollController,
    required this.initialValue,
    required this.options,
    required this.footer,
  });

  @override
  State<_OverlayContent<V>> createState() => _OverlayContentState<V>();
}

class _OverlayContentState<V> extends State<_OverlayContent<V>> {
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.scrollController ?? ScrollController();
  }

  @override
  void dispose() {
    if (widget.scrollController == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final decoration = BoxDecoration(
      color: theme.scaffoldBackgroundColor,
      boxShadow: [BoxShadow(color: theme.shadowColor, blurRadius: 5)],
      borderRadius: BorderRadius.circular(15),
    );

    final items = ListView.builder(
      controller: _controller,
      itemCount: widget.options.length,
      itemBuilder: _buildOptions,
    );

    final body = Column(
      children: [
        if (widget.header != null) widget.header!,
        Expanded(child: items),
        if (widget.footer != null) widget.footer!,
      ],
    );

    final container = Container(
      height: double.infinity,
      width: double.infinity,
      margin: widget.margin,
      padding: widget.padding,
      alignment: Alignment.center,
      decoration: decoration,
      clipBehavior: Clip.hardEdge,
      child: body,
    );

    return NotificationListener(onNotification: (_) => true, child: container);
  }

  Widget? _buildOptions(BuildContext context, int index) {
    final option = widget.options[index];
    final selected = option.value == widget.initialValue;
    return LaamsCellOption<V>(
      onTap: option.onTap ?? () => widget.onSelected(option.value),
      height: option.height,
      width: option.width,
      margin: option.margin,
      padding: option.padding,
      clipBehavior: option.clipBehavior,
      backgroundColor: option.backgroundColor,
      selectedBackroundColor: option.selectedBackroundColor,
      foregroundColor: option.foregroundColor,
      border: option.border,
      boxShadow: option.boxShadow,
      borderRadius: option.borderRadius,
      value: option.value,

      // Content-Related Fields:
      contentMainAxisAlignment: option.contentMainAxisAlignment,
      contentCrossAxisAlignment: option.contentCrossAxisAlignment,
      contentMainAxisSize: option.contentMainAxisSize,

      // Leading-Related Fields:
      leading: option.leading,
      leadingSize: option.leadingSize,
      leadingImageUrl: option.leadingImageUrl,
      leadingImageLabel: option.leadingImageLabel,
      leadingIcon: option.leadingIcon,
      leadingIconColor: option.leadingIconColor,

      // Title-Related Fields:
      titleText: option.titleText,
      titleFlex: option.titleFlex,
      titleTextFontSize: option.titleTextFontSize,
      titleTextColor: option.titleTextColor,
      titleTextFontWeight: option.titleTextFontWeight,
      titleTextStyle: option.titleTextStyle,
      titleTextAlign: option.titleTextAlign,
      titleTextMaxLines: option.titleTextMaxLines,
      titleTextLineSpacing: option.titleTextLineSpacing,
      titleTextOverflow: option.titleTextOverflow,

      // Subtitle-Related Fields:
      subtitleText: option.subtitleText,
      subtitleTextFontSize: option.subtitleTextFontSize,
      subtitleTextColor: option.subtitleTextColor,
      subtitleTextFontWeight: option.subtitleTextFontWeight,
      subtitleTextStyle: option.subtitleTextStyle,
      subtitleTextAlign: option.subtitleTextAlign,
      subtitleTextMaxLines: option.subtitleTextMaxLines,
      subtitleTextLineSpacing: option.subtitleTextLineSpacing,
      subtitleTextOverflow: option.subtitleTextOverflow,

      // Suffix Fields:
      trailing: option.trailing,
      trailingFlex: option.trailingFlex,
      trailingText: option.trailingText,
      trailingTextFontSize: option.trailingTextFontSize,
      trailingTextColor: option.trailingTextColor,
      trailingTextFontWeight: option.trailingTextFontWeight,
      trailingTextStyle: option.trailingTextStyle,
      trailingTextAlign: option.trailingTextAlign,
      trailingTextMaxLines: option.trailingTextMaxLines,
      trailingTextLineSpacing: option.trailingTextLineSpacing,
      trailingTextOverflow: option.trailingTextOverflow,

      // Other Fields:
      horizontalSpacing: option.horizontalSpacing,
      verticalSpacing: option.verticalSpacing,
      enabled: option.enabled,
      selected: option.selected ?? selected,
    );
  }
}

class LaamsCellOption<V> extends StatelessWidget {
  final void Function()? onTap;
  final AlignmentGeometry alignment;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Clip clipBehavior;
  final Color? backgroundColor;
  final Color? selectedBackroundColor;
  final Color? foregroundColor;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final BorderRadiusGeometry? borderRadius;
  final V value;

  // Content-Related Fields:
  final MainAxisAlignment contentMainAxisAlignment;
  final CrossAxisAlignment contentCrossAxisAlignment;
  final MainAxisSize contentMainAxisSize;

  // Leading Fields:
  final Widget? leading;
  final IconData? leadingIcon;
  final String? leadingImageUrl;
  final String leadingImageLabel;
  final double leadingSize;
  final Color? leadingIconColor;

  // Title-Related Fields:
  final String titleText;
  final int? titleFlex;
  final double? titleTextFontSize;
  final Color? titleTextColor;
  final FontWeight? titleTextFontWeight;
  final TextStyle? titleTextStyle;
  final TextAlign? titleTextAlign;
  final int? titleTextMaxLines;
  final double? titleTextLineSpacing;
  final TextOverflow? titleTextOverflow;

  // Subtitle-Related Fields:
  final String? subtitleText;
  final double? subtitleTextFontSize;
  final Color? subtitleTextColor;
  final FontWeight? subtitleTextFontWeight;
  final TextStyle? subtitleTextStyle;
  final TextAlign? subtitleTextAlign;
  final int? subtitleTextMaxLines;
  final double? subtitleTextLineSpacing;
  final TextOverflow? subtitleTextOverflow;

  // Trailing-Related Fields:
  final Widget? trailing;
  final int? trailingFlex;
  final String? trailingText;
  final double? trailingTextFontSize;
  final Color? trailingTextColor;
  final FontWeight? trailingTextFontWeight;
  final TextStyle? trailingTextStyle;
  final TextAlign? trailingTextAlign;
  final int? trailingTextMaxLines;
  final double? trailingTextLineSpacing;
  final TextOverflow? trailingTextOverflow;

  // Other Fields:
  final double horizontalSpacing;
  final double verticalSpacing;
  final bool enabled;
  final bool? selected;

  const LaamsCellOption({
    super.key,
    this.onTap,
    this.alignment = AlignmentDirectional.centerStart,
    this.height,
    this.width,
    this.margin = const EdgeInsets.symmetric(vertical: 2.5),
    this.padding = const EdgeInsets.all(8),
    this.clipBehavior = Clip.none,
    this.backgroundColor,
    this.selectedBackroundColor,
    this.foregroundColor,
    this.border,
    this.boxShadow,
    this.borderRadius = const BorderRadius.all(Radius.circular(7)),
    required this.value,

    // Content-Related Fields:
    this.contentMainAxisAlignment = MainAxisAlignment.start,
    this.contentCrossAxisAlignment = CrossAxisAlignment.center,
    this.contentMainAxisSize = MainAxisSize.max,

    // Leading-Related Fields:
    this.leading,
    this.leadingSize = 22,
    this.leadingImageUrl,
    this.leadingImageLabel = 'Image',
    this.leadingIcon,
    this.leadingIconColor,

    // Title-Related Fields:
    required this.titleText,
    this.titleFlex = 1,
    this.titleTextFontSize,
    this.titleTextColor,
    this.titleTextFontWeight,
    this.titleTextStyle,
    this.titleTextAlign,
    this.titleTextMaxLines,
    this.titleTextLineSpacing,
    this.titleTextOverflow,

    // Subtitle-Related Fields:
    this.subtitleText,
    this.subtitleTextFontSize,
    this.subtitleTextColor,
    this.subtitleTextFontWeight,
    this.subtitleTextStyle,
    this.subtitleTextAlign,
    this.subtitleTextMaxLines,
    this.subtitleTextLineSpacing,
    this.subtitleTextOverflow,

    // Suffix Fields:
    this.trailing,
    this.trailingFlex,
    this.trailingText,
    this.trailingTextFontSize,
    this.trailingTextColor,
    this.trailingTextFontWeight,
    this.trailingTextStyle,
    this.trailingTextAlign,
    this.trailingTextMaxLines,
    this.trailingTextLineSpacing,
    this.trailingTextOverflow,

    // Other Fields:
    this.horizontalSpacing = 5,
    this.verticalSpacing = 3,
    this.enabled = true,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final space = SizedBox(height: verticalSpacing, width: horizontalSpacing);
    final defaultTitleStyle = theme.textTheme.bodyLarge?.copyWith(
      fontSize: titleTextFontSize,
      color: titleTextColor ?? foregroundColor,
      fontWeight: titleTextFontWeight ?? FontWeight.w500,
      height: titleTextLineSpacing,
    );

    Widget? newLeading = leading;
    if (leadingIcon != null) {
      newLeading = Icon(
        leadingIcon,
        size: leadingSize,
        color: leadingIconColor ?? foregroundColor,
      );
    }

    Widget title = Text(
      titleText,
      style: titleTextStyle ?? defaultTitleStyle,
      textAlign: titleTextAlign,
      maxLines: titleTextMaxLines,
      overflow: titleTextOverflow,
    );

    Widget? subtitle;
    if (subtitleText != null) {
      final style = theme.textTheme.bodySmall?.copyWith(
        fontSize: subtitleTextFontSize,
        color: subtitleTextColor ?? foregroundColor,
        fontWeight: subtitleTextFontWeight,
        height: subtitleTextLineSpacing,
      );

      subtitle = Text(
        subtitleText ?? '',
        style: subtitleTextStyle ?? style,
        textAlign: subtitleTextAlign,
        maxLines: subtitleTextMaxLines,
        overflow: subtitleTextOverflow,
      );
    }

    Widget? newTrailing;
    if (trailingText != null) {
      final style = theme.textTheme.bodyMedium?.copyWith(
        fontSize: trailingTextFontSize,
        color: trailingTextColor ?? foregroundColor,
        fontWeight: trailingTextFontWeight,
        height: trailingTextLineSpacing,
      );

      newTrailing = Text(
        trailingText ?? '',
        style: trailingTextStyle ?? style,
        textAlign: trailingTextAlign,
        maxLines: trailingTextMaxLines,
        overflow: trailingTextOverflow,
      );
    }
    if (trailing != null) newTrailing = trailing;
    if (newTrailing != null && trailingFlex != null) {
      newTrailing = Expanded(flex: trailingFlex ?? 1, child: newTrailing);
    }

    Widget content = title;
    if (subtitle != null) {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [title, space, subtitle],
      );
    }

    if (newLeading != null || newTrailing != null) {
      content = Row(
        mainAxisAlignment: contentMainAxisAlignment,
        crossAxisAlignment: contentCrossAxisAlignment,
        mainAxisSize: contentMainAxisSize,
        children: [
          if (newLeading != null) newLeading,
          if (newLeading != null) space,
          Expanded(child: content),
          if (newTrailing != null) space,
          if (newTrailing != null) newTrailing,
        ],
      );
    }

    final bgColor = switch (selected == true) {
      true => selectedBackroundColor ?? theme.cardColor,
      false => backgroundColor ?? theme.scaffoldBackgroundColor,
    };

    final decoration = BoxDecoration(
      color: bgColor,
      border: border ?? Border.all(width: 0.5, color: theme.shadowColor),
      boxShadow: boxShadow,
      borderRadius: borderRadius,
    );

    Widget container = Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      clipBehavior: clipBehavior,
      alignment: alignment,
      decoration: decoration,
      child: content,
    );

    if (onTap != null && enabled) {
      container = InkWell(
        focusColor: Colors.red,
        onTap: onTap,
        child: container,
      );
    }

    return container;
  }
}
