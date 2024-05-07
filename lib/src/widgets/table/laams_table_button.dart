import 'package:flutter/material.dart';
import 'package:laamsui/src/extensions/viewport_extension.dart';

class LaamsTableButton extends StatefulWidget {
  final void Function()? onPressed;
  final double? childHeight;
  final double? childWidth;
  final EdgeInsetsGeometry? childMargin;
  final EdgeInsetsGeometry? childPadding;
  final Color? childBackgroundColor;
  final BorderRadiusGeometry? childBorderRadius;
  final BoxBorder? childBorder;
  final List<BoxShadow>? childBoxShadow;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final String? label;
  final String? tooltip;
  final Widget? child;

  final double overlayTopPosition;
  final double? overlayStartPosition;
  final double? overlayEndPosition;
  final double overlayHeight;
  final double? overlayMobileHeight;
  final double overlayWidth;
  final EdgeInsetsGeometry overlayMargin;
  final EdgeInsetsGeometry? overlayPadding;
  final Color? overlayBackgroundColor;
  final BorderRadiusGeometry? overlayBorderRadius;
  final BoxBorder? overlayBorder;
  final List<BoxShadow>? overlayBoxShadow;
  final Color? barrierColor;
  final Widget? overlayChild;
  final List<Widget> overlayActions;
  final Widget? overlayActionsSepartor;

  const LaamsTableButton({
    super.key,
    this.onPressed,
    this.childHeight,
    this.childWidth,
    this.childMargin = const EdgeInsetsDirectional.only(start: 5),
    this.childPadding = const EdgeInsets.all(3),
    this.childBackgroundColor,
    this.childBorderRadius,
    this.childBorder,
    this.childBoxShadow,
    this.icon,
    this.iconColor,
    this.iconSize = 24,
    this.label,
    this.tooltip,
    this.overlayTopPosition = 45,
    this.overlayStartPosition,
    this.overlayEndPosition,
    this.overlayHeight = 300,
    this.overlayMobileHeight,
    this.overlayWidth = 280,
    this.overlayMargin = const EdgeInsets.only(top: 5, left: 5, right: 5),
    this.overlayPadding =
        const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
    this.overlayBackgroundColor,
    this.overlayBorderRadius = const BorderRadius.all(Radius.circular(10)),
    this.overlayBorder,
    this.overlayBoxShadow,
    this.overlayActions = const [],
    this.overlayActionsSepartor,
    this.overlayChild,
    this.barrierColor,
    this.child,
  });

  @override
  State<LaamsTableButton> createState() => _LaamsTableButtonState();
}

class _LaamsTableButtonState extends State<LaamsTableButton> {
  late OverlayPortalController _overlayController;

  @override
  void initState() {
    super.initState();
    _overlayController = OverlayPortalController();
  }

  void _handleOnTap(BuildContext context) {
    if (widget.onPressed != null) return widget.onPressed!();
    if (!context.isS) return _overlayController.show();
    _showBottomSheet(context);
  }

  Future<void> _showBottomSheet(BuildContext context) async {
    final theme = Theme.of(context);

    var shadows = [BoxShadow(color: theme.shadowColor, blurRadius: 5)];
    const borderRadius = BorderRadius.only(
      topLeft: Radius.circular(30),
      topRight: Radius.circular(30),
    );

    final decoration = BoxDecoration(
      color: widget.overlayBackgroundColor ?? theme.scaffoldBackgroundColor,
      borderRadius: borderRadius,
      boxShadow: widget.childBoxShadow ?? shadows,
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      barrierColor: widget.barrierColor ?? Colors.grey.withOpacity(0.3),
      shape: const RoundedRectangleBorder(borderRadius: borderRadius),
      builder: (context) => _ButtonMobileDialog(
        height: widget.overlayMobileHeight,
        padding: widget.overlayPadding,
        decoration: decoration,
        actions: widget.overlayActions,
        separator: widget.overlayActionsSepartor,
        child: widget.overlayChild,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final isMobile = context.isS;
    // final isMobile = LaamsDevice.isS(context);
    final theme = Theme.of(context);

    Widget? child;
    if (widget.icon != null) {
      child = Icon(
        widget.icon,
        color: widget.iconColor,
        size: widget.iconSize,
      );
    }

    if (widget.label != null) {
      final defLabelStyle = theme.textTheme.displaySmall?.copyWith(
        fontSize: 14,
        color: Colors.white,
      );
      const spacing = SizedBox(width: 4);
      final label = Text(widget.label ?? '', style: defLabelStyle);

      child = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [if (child != null) child, spacing, label, spacing],
      );
    }

    final childDecoration = BoxDecoration(
      color: widget.childBackgroundColor,
      border: widget.childBorder,
      borderRadius: widget.childBorderRadius,
      boxShadow: widget.childBoxShadow,
    );

    child = Container(
      height: widget.childHeight,
      width: widget.childWidth,
      padding: widget.childPadding,
      decoration: childDecoration,
      child: child,
    );

    if (widget.child != null) child = widget.child!;

    if (widget.tooltip != null) {
      final style = theme.textTheme.bodyMedium;
      final boxDecoration = BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [BoxShadow(color: theme.shadowColor, blurRadius: 2)],
      );
      child = Tooltip(
        message: widget.tooltip,
        decoration: boxDecoration,
        textAlign: TextAlign.center,
        textStyle: style?.copyWith(color: theme.primaryColor),
        child: child,
      );
    }

    if (!context.isS && widget.onPressed == null) {
      child = OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: _buildOverlay,
        child: child,
      );
    }

    child = GestureDetector(
      onTap: () => _handleOnTap(context),
      child: child,
    );

    return Padding(
      padding: widget.childMargin ?? EdgeInsets.zero,
      child: child,
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final theme = Theme.of(context);

    var shadows = [BoxShadow(color: theme.shadowColor, blurRadius: 5)];
    final decoration = BoxDecoration(
      color: widget.overlayBackgroundColor ?? theme.scaffoldBackgroundColor,
      borderRadius: widget.overlayBorderRadius,
      boxShadow: widget.childBoxShadow ?? shadows,
    );

    Widget child = widget.overlayChild ?? const SizedBox();
    if (widget.overlayActions.isNotEmpty) {
      child = ListView.separated(
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (_, __) =>
            widget.overlayActionsSepartor ?? const SizedBox(),
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        itemCount: widget.overlayActions.length,
        itemBuilder: (context, index) => widget.overlayActions[index],
      );
    }

    child = Container(
      height: widget.overlayHeight,
      width: widget.overlayWidth,
      margin: widget.overlayMargin,
      padding: widget.overlayPadding,
      decoration: decoration,
      child: child,
    );

    child = TapRegion(
      onTapOutside: (_) => _overlayController.hide(),
      child: child,
    );

    return PositionedDirectional(
      top: widget.overlayTopPosition,
      start: widget.overlayStartPosition,
      end: widget.overlayEndPosition,
      child: child,
    );
  }
}

class _ButtonMobileDialog extends StatelessWidget {
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration decoration;
  final List<Widget> actions;
  final Widget? separator;
  final Widget? child;

  const _ButtonMobileDialog({
    required this.height,
    required this.padding,
    required this.decoration,
    required this.actions,
    required this.separator,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    var indicatorDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: theme.shadowColor,
    );
    final top = Container(
      height: 7,
      width: 50,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: indicatorDecoration,
    );

    Widget? newChild = child;
    if (actions.isNotEmpty) {
      newChild = ListView.separated(
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (_, __) => separator ?? const SizedBox(),
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        itemCount: actions.length,
        itemBuilder: (context, index) => actions[index],
      );
    }

    return Container(
      height: height ?? (screenSize.height - 150),
      width: screenSize.width,
      padding: padding,
      decoration: decoration,
      child: Column(
          children: [top, Expanded(child: newChild ?? const SizedBox())]),
    );
  }
}

class LaamsTableAction extends StatelessWidget {
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final void Function()? onPressed;
  final IconData icon;
  final Color? iconColor;
  final double iconSize;
  final String label;
  final double? labelFontSize;
  final Color? labelColor;
  final FontWeight? labelFontWeight;
  final double spacing;

  const LaamsTableAction({
    super.key,
    this.height,
    this.width,
    this.margin = const EdgeInsets.only(bottom: 4),
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.onPressed,
    required this.icon,
    this.iconColor,
    this.iconSize = 24,
    required this.label,
    this.labelFontSize,
    this.labelColor,
    this.labelFontWeight,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    const space = SizedBox(width: 8);
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyLarge?.copyWith(
      color: labelColor,
      fontSize: labelFontSize,
      fontWeight: labelFontWeight ?? FontWeight.w500,
    );

    final iconWidget = Icon(
      icon,
      color: iconColor,
      size: iconSize,
    );

    final title = Text(
      label,
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [iconWidget, space, Expanded(child: title), space],
    );

    final decoration = BoxDecoration(
      color: backgroundColor,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      border: border ?? Border.all(width: 0.5, color: theme.shadowColor),
      boxShadow: boxShadow,
    );

    final child = Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: decoration,
      child: content,
    );

    return GestureDetector(
      onTap: onPressed,
      child: child,
    );
  }
}
