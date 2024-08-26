import 'package:flutter/material.dart';

class LaamsTableColumn extends StatefulWidget {
  final void Function()? onSort;
  final IconData? sortIcon;
  final double width;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final String? label;
  final TextStyle? labelTextStyle;
  final Color? labelColor;
  final FontWeight? labelFontWeight;
  final double? labelFontSize;
  final double? labelLineSpacing;
  final TextAlign? labelTextAlignment;
  final int? labelMaxLines;
  final TextOverflow? labelOverflow;
  final Widget? overlay;
  final double? overlayStartPosition;
  final double? overlayTopPosition;
  final double? overlayEndPosition;
  final double? overlayBottomPosition;
  final bool isPinned;
  final bool isAscending;

  const LaamsTableColumn({
    super.key,
    this.onSort,
    this.sortIcon,
    required this.width,
    this.alignment = AlignmentDirectional.center,
    this.margin,
    this.padding = const EdgeInsets.symmetric(horizontal: 3),
    this.backgroundColor,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.label,
    this.labelTextStyle,
    this.labelColor,
    this.labelFontWeight,
    this.labelFontSize,
    this.labelLineSpacing,
    this.labelTextAlignment,
    this.labelMaxLines,
    this.labelOverflow,
    this.overlay,
    this.overlayStartPosition,
    this.overlayTopPosition,
    this.overlayEndPosition,
    this.overlayBottomPosition,
    this.isPinned = false,
    this.isAscending = true,
  });

  @override
  State<LaamsTableColumn> createState() => _LaamsTableColumnState();
}

class _LaamsTableColumnState extends State<LaamsTableColumn> {
  late OverlayPortalController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OverlayPortalController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyLarge?.copyWith(
      color: widget.labelColor,
      fontSize: widget.labelFontSize ?? 14,
      fontWeight: widget.labelFontWeight ?? FontWeight.w500,
      height: widget.labelLineSpacing,
    );

    Widget items = Text(
      widget.label ?? '',
      style: widget.labelTextStyle ?? style,
      textAlign: widget.labelTextAlignment,
      maxLines: widget.labelMaxLines,
      overflow: widget.labelOverflow,
    );

    if (widget.icon != null) {
      items = Icon(
        widget.icon,
        size: widget.iconSize,
        color: widget.iconColor,
      );
    }

    if (widget.sortIcon != null) {
      final color = theme.textTheme.bodyLarge?.color;
      final btn = GestureDetector(
        onTap: widget.onSort,
        child: Icon(widget.sortIcon, size: 20, color: color),
      );

      items = Row(children: [Expanded(child: items), btn]);
    }

    if (widget.onSort != null && widget.sortIcon == null) {
      items = GestureDetector(
        onTap: widget.onSort,
        child: items,
      );
    }

    Widget container = Container(
      margin: widget.margin,
      padding: widget.padding,
      child: items,
    );

    if (widget.overlay != null) {
      container = OverlayPortal(
        controller: _controller,
        overlayChildBuilder: _buildOverlay,
        child: container,
      );
    }

    return GestureDetector(
      onTap: () => _controller.toggle(),
      child: Align(alignment: widget.alignment, child: container),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return PositionedDirectional(
      start: widget.overlayStartPosition,
      top: widget.overlayTopPosition,
      end: widget.overlayEndPosition,
      bottom: widget.overlayBottomPosition,
      child: widget.overlay ?? const SizedBox(),
    );
  }
}
