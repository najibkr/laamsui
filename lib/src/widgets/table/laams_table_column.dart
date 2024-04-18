import 'package:flutter/material.dart';

class LaamsTableColumn extends StatefulWidget {
  final void Function()? onSort;
  final IconData? sortIcon;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final String label;
  final double width;
  final bool isPinned;
  final bool isAscending;

  const LaamsTableColumn({
    super.key,
    this.onSort,
    this.sortIcon,
    this.alignment = AlignmentDirectional.center,
    this.margin,
    this.padding = const EdgeInsets.symmetric(horizontal: 3),
    this.backgroundColor,
    required this.label,
    required this.width,
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
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );

    Widget items = Text(widget.label, style: style);
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

    // container = OverlayPortal(
    //   controller: _controller,
    //   overlayChildBuilder: (context) {
    //     return const PositionedDirectional(
    //       child: Padding(
    //         padding: EdgeInsets.all(228.0),
    //         child: Text("hello"),
    //       ),
    //     );
    //   },
    //   child: Align(alignment: widget.alignment, child: container),
    // );

    return GestureDetector(
      onTap: () => _controller.toggle(),
      child: Align(alignment: widget.alignment, child: container),
    );
  }
}
