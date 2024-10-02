import 'package:flutter/material.dart';
import 'package:laamsui/src/extensions/viewport_extension.dart';

import 'laams_loading_cell.dart';

class LaamsMenuCell<V> extends StatefulWidget {
  final AlignmentDirectional overlayAnchorAlignment;
  final AlignmentDirectional overlayPopupAlignment;
  final double xOffset;
  final double yOffset;
  final double height;
  final double width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final String hintText;
  final Widget? header;
  final ScrollController? scrollController;
  final List<CellMenuItem<V>> options;
  final V? initialValue;
  final String? initialValueTitle;
  final String? initialImageUrl;
  final void Function(CellMenuItem<V>?) onSelected;
  final int? maxLength;
  final bool enabled;
  final Widget? footer;

  // Anchor-Related Fields;
  final AlignmentGeometry anchorAlignment;
  final bool isLoading;
  final bool selectAllOnFocus;

  const LaamsMenuCell({
    super.key,
    this.overlayAnchorAlignment = AlignmentDirectional.bottomCenter,
    this.overlayPopupAlignment = AlignmentDirectional.topCenter,
    this.xOffset = 0,
    this.yOffset = 0,
    this.height = 350,
    required this.width,
    this.margin,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
    required this.hintText,
    this.header,
    this.scrollController,
    this.options = const [],
    required this.initialValue,
    required this.initialValueTitle,
    this.initialImageUrl,
    required this.onSelected,
    this.maxLength = 255,
    this.enabled = true,
    this.footer,

    // Anchor-Related Field:
    this.anchorAlignment = AlignmentDirectional.center,
    this.isLoading = false,
    this.selectAllOnFocus = true,
  });

  @override
  State<LaamsMenuCell<V>> createState() => _LaamsMenuCellState();
}

class _LaamsMenuCellState<V> extends State<LaamsMenuCell<V>> {
  OverlayPortalController _overlayController = OverlayPortalController();
  LayerLink _link = LayerLink();
  late TextEditingController _textController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialValueTitle);
    _focusNode = FocusNode();
    _focusNode.addListener(() async {
      if (_focusNode.hasFocus && widget.enabled) {
        if (widget.selectAllOnFocus) {
          _textController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _textController.text.length,
          );
        }
        _overlayController.show();
      }

      if (!_focusNode.hasFocus) {
        await Future.delayed(const Duration(milliseconds: 10));
        _overlayController.hide();
      }
    });
  }

  @override
  void didUpdateWidget(covariant LaamsMenuCell<V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _textController.text = widget.initialValueTitle ?? _textController.text;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

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

  void _handleManualSelect(CellMenuItem<V>? value, bool hideMenu) {
    if (hideMenu) _overlayController.hide();
    _focusNode.requestFocus();
    _focusNode.nextFocus();
    widget.onSelected(value);
  }

  void _handleEditingCompleted() {
    try {
      final found = widget.options.firstWhere(_find);
      widget.onSelected(found);
      _focusNode.nextFocus();
    } catch (_) {}
  }

  bool _find(CellMenuItem<V> e) {
    final title = e.titleText.toLowerCase();
    final text = _textController.text.toLowerCase();
    return title.contains(text.trim().toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) return const LaamsLoadingCell();
    final theme = Theme.of(context);

    const inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: Colors.transparent),
    );

    final inputFocusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: theme.primaryColor, width: 2),
    );

    final decoration = InputDecoration(
      hintText: widget.hintText,
      fillColor: theme.scaffoldBackgroundColor,
      focusColor: theme.cardColor,
      hoverColor: theme.cardColor,
      focusedBorder: inputFocusedBorder,
      border: inputBorder,
      disabledBorder: inputBorder,
      enabledBorder: inputBorder,
      counterText: '',
    );

    Widget cell = TextField(
      controller: _textController,
      focusNode: _focusNode,
      textInputAction: TextInputAction.next,
      onTap: widget.enabled ? _overlayController.show : null,
      decoration: decoration,
      enabled: widget.enabled,
      maxLength: widget.maxLength,
      onEditingComplete: _handleEditingCompleted,
    );

    if (widget.enabled) {
      cell = CompositedTransformTarget(
        link: _link,
        child: cell,
      );

      cell = OverlayPortal.targetsRootOverlay(
        controller: _overlayController,
        overlayChildBuilder: _buildOverlay,
        child: cell,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(0.5),
      child: cell,
    );
  }

  Widget _buildOverlay(BuildContext context) {
    Widget container = _OverlayContent(
      onSelected: _handleManualSelect,
      margin: widget.margin,
      padding: widget.padding,
      header: widget.header,
      scrollController: widget.scrollController,
      textController: _textController,
      initialValue: widget.initialValue,
      options: widget.options,
      footer: widget.footer,
    );

    container = TapRegion(
      onTapOutside: (_) => _overlayController.hide(),
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
      height: widget.height,
      width: widget.width,
      child: container,
    );
  }
}

class _OverlayContent<V> extends StatefulWidget {
  final void Function(CellMenuItem<V>?, bool hideMenu) onSelected;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? header;
  final ScrollController? scrollController;
  final TextEditingController textController;
  final V? initialValue;
  final List<CellMenuItem<V>> options;
  final Widget? footer;

  const _OverlayContent({
    required this.onSelected,
    required this.margin,
    required this.padding,
    required this.header,
    required this.scrollController,
    required this.textController,
    required this.initialValue,
    required this.options,
    required this.footer,
  });

  @override
  State<_OverlayContent<V>> createState() => _OverlayContentState<V>();
}

class _OverlayContentState<V> extends State<_OverlayContent<V>> {
  V? _found;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _found = widget.initialValue;
    _controller = widget.scrollController ?? ScrollController();
    widget.textController.addListener(() => _findItem());
  }

  void _findItem() {
    try {
      final found = widget.options.firstWhere(
        (e) {
          final title = e.titleText.toLowerCase();
          final text = widget.textController.text.toLowerCase();
          return title.contains(text);
        },
      );
      setState(() => _found = found.value);
    } catch (_) {}
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
    return CellMenuItem<V>(
      onTap: option.onTap ?? () => widget.onSelected(option, true),
      height: option.height,
      width: option.width,
      margin: option.margin,
      padding: option.padding,
      clipBehavior: option.clipBehavior,
      backgroundColor: option.backgroundColor,
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
      selected: option.value == _found,
    );
  }
}

class CellMenuItem<V> extends StatelessWidget {
  final void Function()? onTap;
  final AlignmentGeometry alignment;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Clip clipBehavior;
  final Color? backgroundColor;
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
  final bool selected;

  const CellMenuItem({
    super.key,
    this.onTap,
    this.alignment = AlignmentDirectional.centerStart,
    this.height,
    this.width,
    this.margin = const EdgeInsets.symmetric(vertical: 2.5),
    this.padding = const EdgeInsets.all(8),
    this.clipBehavior = Clip.none,
    this.backgroundColor,
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
    this.selected = false,
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

    final decoration = BoxDecoration(
      color: switch (selected) {
        true => theme.cardColor,
        false => backgroundColor ?? theme.scaffoldBackgroundColor,
      },
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
      container = InkWell(onTap: onTap, child: container);
    }

    return container;
  }
}
