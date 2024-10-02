import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laamsui/src/extensions/viewport_extension.dart';

class LaamsTimelineCell extends StatefulWidget {
  final AlignmentDirectional overlayAnchorAlignment;
  final AlignmentDirectional overlayPopupAlignment;
  final double xOffset;
  final double yOffset;
  final double? height;
  final double? width;
  final double menuHeight;
  final double menuWidth;
  final EdgeInsetsGeometry? pickerMargin;
  final EdgeInsetsGeometry? pickerPadding;
  final String? hintText;
  final DateTime? firstDate;
  final DateTime? currentDate;
  final DateTime? lastDate;
  final List<DateTime?> selectedDates;
  final void Function(List<DateTime>) onSelected;
  final bool enabled;
  final String suffixText;

  // Anchor-Related Fields;
  final AlignmentGeometry anchorAlignment;

  const LaamsTimelineCell({
    super.key,
    this.overlayAnchorAlignment = AlignmentDirectional.bottomCenter,
    this.overlayPopupAlignment = AlignmentDirectional.topCenter,
    this.xOffset = 0,
    this.yOffset = 0,
    this.height,
    this.width,
    this.menuHeight = 350,
    this.menuWidth = 320,
    this.pickerMargin,
    this.pickerPadding,
    this.hintText,
    this.firstDate,
    this.currentDate,
    this.lastDate,
    this.selectedDates = const [],
    required this.onSelected,
    this.enabled = true,
    this.suffixText = 'Days',

    // Anchor-Related Field:
    this.anchorAlignment = AlignmentDirectional.center,
  });

  @override
  State<LaamsTimelineCell> createState() => _LaamsTimelineCellState();
}

class _LaamsTimelineCellState<V> extends State<LaamsTimelineCell> {
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

  String get _inferText {
    if (widget.selectedDates.length != 2) return widget.hintText ?? '';
    if (_isHovered || _isFocused) {
      final first = widget.selectedDates.first;
      final second = widget.selectedDates.last;
      final days = second?.difference(first ?? DateTime.now()).inDays;
      return '$days ${widget.suffixText}';
    }
    return widget.selectedDates.map((e) {
      if (e == null) return e;
      return DateFormat.yMMMd(context.currentLocale.languageCode).format(e);
    }).join(' - ');
  }

  void _handleOnSelected(List<DateTime> value) {
    if (value.length == 2) widget.onSelected(value);
  }

  Future<void> _displayDialog(BuildContext context) async {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.transparent,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 10,
      builder: (context) => _BottomSheetContent(
        onSelected: widget.onSelected,
        firstDate: widget.firstDate,
        currentDate: widget.currentDate,
        lastDate: widget.lastDate,
        selectedDates: widget.selectedDates,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isS = context.isS;
    final theme = Theme.of(context);
    final hintStyle = switch (_isHovered || _isFocused) {
      true => theme.inputDecorationTheme.labelStyle,
      false => theme.textTheme.bodyMedium,
    };

    final hint = Text(
      _inferText,
      style: hintStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    final border = Border.all(width: 2, color: theme.primaryColor);
    final radius = BorderRadius.circular(5);
    final decoration = BoxDecoration(
      color: (_isHovered || _isFocused) ? theme.cardColor : null,
      border: _isFocused ? border : null,
      borderRadius: _isFocused ? radius : null,
    );

    Widget cell = Container(
      alignment: widget.anchorAlignment,
      height: widget.height,
      width: widget.width,
      margin: const EdgeInsets.all(0.5),
      padding: const EdgeInsets.symmetric(horizontal: 3),
      decoration: decoration,
      child: hint,
    );

    if (widget.enabled && !isS) {
      cell = CompositedTransformTarget(
        link: _link,
        child: cell,
      );

      cell = OverlayPortal(
        controller: _controller,
        overlayChildBuilder: _buildOverlay,
        child: cell,
      );
    }

    Widget detector = FocusableActionDetector(
      onFocusChange: (v) => v ? _controller.show() : _controller.hide(),
      onShowFocusHighlight: (v) => setState(() => _isFocused = v),
      onShowHoverHighlight: (v) => setState(() => _isHovered = v),
      enabled: widget.enabled,
      child: cell,
    );

    if (widget.enabled) {
      detector = GestureDetector(
        onTap: isS ? () => _displayDialog(context) : _controller.show,
        child: detector,
      );
    }

    return detector;
  }

  Widget _buildOverlay(BuildContext context) {
    Widget container = _OverlayContent(
      onSelected: _handleOnSelected,
      margin: widget.pickerMargin,
      padding: widget.pickerPadding,
      firstDate: widget.firstDate,
      currentDate: widget.currentDate,
      lastDate: widget.lastDate,
      selectedDates: widget.selectedDates,
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

class _OverlayContent extends StatelessWidget {
  final void Function(List<DateTime>) onSelected;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final DateTime? firstDate;
  final DateTime? currentDate;
  final DateTime? lastDate;
  final List<DateTime?> selectedDates;

  const _OverlayContent({
    required this.onSelected,
    required this.margin,
    required this.padding,
    required this.firstDate,
    required this.currentDate,
    required this.lastDate,
    required this.selectedDates,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final decoration = BoxDecoration(
      color: theme.scaffoldBackgroundColor,
      boxShadow: [BoxShadow(color: theme.shadowColor, blurRadius: 5)],
      borderRadius: BorderRadius.circular(15),
    );

    final datesPicker = _DatesPicker(
      onSelected: onSelected,
      firstDate: firstDate,
      currentDate: currentDate,
      lastDate: lastDate,
      selectedDates: selectedDates,
    );

    final container = Container(
      height: double.infinity,
      width: double.infinity,
      margin: margin,
      padding: padding,
      alignment: Alignment.center,
      decoration: decoration,
      clipBehavior: Clip.hardEdge,
      child: datesPicker,
    );

    return NotificationListener(onNotification: (_) => true, child: container);
  }
}

class _BottomSheetContent extends StatelessWidget {
  final void Function(List<DateTime>) onSelected;
  final DateTime? firstDate;
  final DateTime? currentDate;
  final DateTime? lastDate;
  final List<DateTime?> selectedDates;

  const _BottomSheetContent({
    required this.onSelected,
    required this.firstDate,
    required this.currentDate,
    required this.lastDate,
    required this.selectedDates,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final datesPicker = _DatesPicker(
      onSelected: onSelected,
      firstDate: firstDate,
      currentDate: currentDate,
      lastDate: lastDate,
      selectedDates: selectedDates,
    );

    const radius = Radius.circular(25);
    final decoration = BoxDecoration(
      color: theme.scaffoldBackgroundColor,
      borderRadius: const BorderRadius.only(topLeft: radius, topRight: radius),
      boxShadow: [BoxShadow(color: theme.shadowColor, blurRadius: 5)],
    );

    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 30),
      decoration: decoration,
      child: datesPicker,
    );
  }
}

class _DatesPicker extends StatelessWidget {
  final void Function(List<DateTime>) onSelected;
  final DateTime? firstDate;
  final DateTime? currentDate;
  final DateTime? lastDate;
  final List<DateTime?> selectedDates;
  const _DatesPicker({
    required this.onSelected,
    required this.currentDate,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDates,
  });

  @override
  Widget build(BuildContext context) {
    final isS = context.isS;
    final date = currentDate ?? DateTime.now();
    final theme = Theme.of(context);
    final ctrlsStyle = theme.textTheme.bodyLarge;

    return CalendarDatePicker2(
      config: CalendarDatePicker2Config(
        calendarType: CalendarDatePicker2Type.range,
        calendarViewMode: CalendarDatePicker2Mode.day,
        firstDate: firstDate ?? DateTime(date.year - 100),
        currentDate: currentDate,
        dayTextStyle: isS ? theme.textTheme.displaySmall : null,
        controlsTextStyle: ctrlsStyle?.copyWith(fontWeight: FontWeight.bold),
        lastDate: lastDate ?? DateTime(date.year + 100),
      ),
      value: selectedDates
        ..removeWhere((e) => e == null)
        ..sort(),
      onValueChanged: onSelected,
    );
  }
}
