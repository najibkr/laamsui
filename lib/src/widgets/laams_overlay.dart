import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laamsui/src/extensions/viewport_extension.dart';

class LaamsOverlay extends StatefulWidget {
  final AlignmentDirectional overlayAnchorAlignment;
  final AlignmentDirectional overlayPopupAlignment;
  final double height;
  final double? mobileHeight;
  final double width;
  final double yOffset;
  final double xOffset;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final BorderRadiusGeometry? borderRadius;
  final Widget anchor;
  final String? title;
  final Widget Function(BuildContext) contentBuilder;
  final Widget? content;

  const LaamsOverlay({
    super.key,
    this.overlayAnchorAlignment = AlignmentDirectional.bottomCenter,
    this.overlayPopupAlignment = AlignmentDirectional.topCenter,
    this.height = 300,
    this.mobileHeight,
    this.width = 250,
    this.yOffset = 0,
    this.xOffset = 0,
    this.margin = const EdgeInsets.all(5),
    this.padding = const EdgeInsets.all(10),
    this.backgroundColor,
    this.border,
    this.boxShadow,
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
    required this.anchor,
    this.title,
    this.content,
    required this.contentBuilder,
  });

  static LaamsOverlayProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LaamsOverlayProvider>();
  }

  static LaamsOverlayProvider of(BuildContext context) {
    final LaamsOverlayProvider? result = maybeOf(context);
    assert(result != null, 'No FrogColor found in context');
    return result!;
  }

  @override
  State<LaamsOverlay> createState() => _LaamsOverlayState();
}

class _LaamsOverlayState extends State<LaamsOverlay> {
  OverlayPortalController _controller = OverlayPortalController();
  late LayerLink _link = LayerLink();

  Future<T?> _handleOnTap<T>(BuildContext context) async {
    if (!context.isS) {
      _controller.show();
      return null;
    }
    return showModalBottomSheet<T>(
      context: context,
      barrierColor: Colors.grey.withOpacity(0.3),
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: false,
      showDragHandle: false,
      enableDrag: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (_) => LaamsOverlayProvider(
        show: () => _showOverlay(context),
        hide: () => _hideOverlay(context),
        isShown: _controller.isShowing,
        child: _OverlayContent(
          height: widget.mobileHeight,
          margin: null,
          padding: widget.padding,
          backgroundColor: widget.backgroundColor,
          borderRadius: null,
          boxShadow: widget.boxShadow,
          border: widget.border,
          content: Builder(builder: widget.contentBuilder),
        ),
      ),
    );
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

  void _showOverlay(BuildContext context) {
    if (!_controller.isShowing) return _controller.show();
    if (context.canPop()) context.pop();
  }

  void _hideOverlay(BuildContext context) {
    if (_controller.isShowing) return _controller.hide();
    if (context.canPop()) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    Widget overlay = widget.anchor;
    if (!(context.isS)) {
      overlay = OverlayPortal.targetsRootOverlay(
        controller: _controller,
        overlayChildBuilder: _buildOverlay,
        child: CompositedTransformTarget(link: _link, child: widget.anchor),
      );
    }

    return LaamsOverlayProvider(
      show: () => _showOverlay(context),
      hide: () => _hideOverlay(context),
      isShown: _controller.isShowing,
      child: GestureDetector(
        onTap: () => _handleOnTap(context),
        child: overlay,
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final theme = Theme.of(context);
    final boxShadow = [BoxShadow(color: theme.shadowColor, blurRadius: 5)];
    Widget container = _OverlayContent(
      height: widget.height,
      margin: widget.margin,
      padding: widget.padding,
      backgroundColor: widget.backgroundColor ?? theme.scaffoldBackgroundColor,
      borderRadius: widget.borderRadius,
      boxShadow: widget.boxShadow ?? boxShadow,
      border: widget.border,
      content: Builder(builder: widget.contentBuilder),
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
      height: widget.height,
      width: widget.width,
      child: container,
    );
  }
}

class LaamsOverlayProvider extends InheritedWidget {
  final void Function() show;
  final void Function() hide;
  final bool isShown;

  const LaamsOverlayProvider({
    super.key,
    required this.show,
    required this.hide,
    required super.child,
    required this.isShown,
  });

  static LaamsOverlayProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LaamsOverlayProvider>();
  }

  static LaamsOverlayProvider of(BuildContext context) {
    final LaamsOverlayProvider? result = maybeOf(context);
    assert(result != null, 'No FrogColor found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(LaamsOverlayProvider oldWidget) =>
      oldWidget.isShown != isShown;
}

class _OverlayContent extends StatelessWidget {
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final BorderRadiusGeometry? borderRadius;
  final Widget content;

  const _OverlayContent({
    required this.height,
    required this.margin,
    required this.padding,
    required this.backgroundColor,
    required this.border,
    required this.boxShadow,
    required this.borderRadius,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isS = context.isS;

    Widget newContent = content;
    if (isS) {
      final decoration = BoxDecoration(
        color: theme.shadowColor,
        borderRadius: BorderRadius.circular(25),
      );

      final indicator = Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          width: 50,
          height: 6,
          decoration: decoration,
        ),
      );

      newContent = Column(children: [indicator, Expanded(child: content)]);
    }

    final decoration = BoxDecoration(
      color: backgroundColor ?? theme.scaffoldBackgroundColor,
      border: border,
      boxShadow: boxShadow,
      borderRadius: isS ? null : borderRadius,
    );

    final newHeight = switch (context.isS) {
      true => height ?? context.screenSize.height - 150,
      false => null,
    };

    return NotificationListener(
      onNotification: (_) => true,
      child: Container(
        height: newHeight,
        margin: margin,
        padding: padding,
        decoration: decoration,
        child: newContent,
      ),
    );
  }
}
