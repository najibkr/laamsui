import 'package:flutter/material.dart';
import 'package:laamsui/src/laams_icons.dart';

class LaamsDateTimeCell extends StatefulWidget {
  final void Function()? onTap;
  final void Function(DateTime? value)? onChanged;
  final void Function(DateTime? value)? onSaved;
  final void Function(DateTime? value)? onUnfocused;
  final double? height;
  final double? width;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? hintText;
  final DateTime? value;
  final TextStyle? valueStyle;
  final double? valueTextFontSize;
  final TextAlign valueTextAlignment;
  final Color? valueTextColor;
  final FontWeight? valueTextFontWeight;
  final String calendarTitle;
  final IconData? calendarIcon;
  final Color? calendarIconColor;
  final double? calendarIconSize;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool enabled;
  final bool isRequired;

  const LaamsDateTimeCell({
    super.key,
    this.onTap,
    this.onChanged,
    this.onSaved,
    this.onUnfocused,
    this.height,
    this.width,
    this.alignment = AlignmentDirectional.centerStart,
    this.margin,
    this.padding = const EdgeInsets.symmetric(horizontal: 5),
    this.backgroundColor,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.hintText,
    required this.value,
    this.valueStyle,
    this.valueTextFontSize,
    this.valueTextAlignment = TextAlign.start,
    this.valueTextColor,
    this.valueTextFontWeight,
    required this.calendarTitle,
    this.calendarIcon,
    this.calendarIconColor,
    this.calendarIconSize,
    required this.firstDate,
    required this.lastDate,
    this.enabled = true,
    this.isRequired = false,
  });

  @override
  State<LaamsDateTimeCell> createState() => _LaamsDateTimeCellState();
}

class _LaamsDateTimeCellState extends State<LaamsDateTimeCell> {
  late TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _stringifyDate(widget.value));
    _focusNode = FocusNode();
    _focusNode.addListener(() => _handleUnfocus());
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  String? _stringifyDate(DateTime? value) {
    if (value != null) {
      var day = '${value.day}'.padLeft(2, '0');
      var month = '${value.month}'.padLeft(2, '0');
      var year = '${value.year}'.padLeft(2, '0');
      return '$day/$month/$year';
    }
    return null;
  }

  DateTime? _parseDateTime(String? input) {
    if (input == null || input.isEmpty) return null;
    var value = input
        .replaceAll('۰', '0')
        .replaceAll('۱', '1')
        .replaceAll('۲', '2')
        .replaceAll('۳', '3')
        .replaceAll('۴', '4')
        .replaceAll('۵', '5')
        .replaceAll('۶', '6')
        .replaceAll('۷', '7')
        .replaceAll('۸', '8')
        .replaceAll('۹', '9');

    List<String> parts = [];
    if (value.contains('-')) parts = value.split('-');
    if (value.contains('/')) parts = value.split('/');
    if (value.contains('\\')) parts = value.split('\\');
    if (value.contains(':')) parts = value.split(':');
    if (parts.length < 3 || parts.length > 3) return null;

    final day = int.tryParse(parts[0]);
    if (day == null || day < 1 || day > 31) return null;

    final month = int.tryParse(parts[1]);
    if (month == null || month < 1 || month > 12) return null;

    final year = int.tryParse(parts[2]);
    if (year == null) return null;

    return DateTime(year, month, day);
  }

  void _onChanged(String? value) {
    if (widget.onChanged == null) return;
    final parsedDate = _parseDateTime(value);
    return widget.onChanged!(parsedDate);
  }

  void _handleUnfocus() {
    if (_focusNode.hasFocus) return;
    final parsedDate = _parseDateTime(_controller.text);
    _controller.text = _stringifyDate(parsedDate) ?? '';
    if (widget.onUnfocused == null) return;
    return widget.onUnfocused!(parsedDate);
  }

  void _onSaved(String? value) {
    if (widget.onSaved == null) return;
    final parsedDate = _parseDateTime(value);
    return widget.onSaved!(parsedDate);
  }

  String? _validate(String? value) {
    if (!widget.isRequired) return null;
    if ((value ?? '').trim().isEmpty) return '';
    return null;
  }

  void _displayCalendar(BuildContext context, Locale locale) async {
    var result = await showDatePicker(
      context: context,
      currentDate: DateTime.now(),
      initialDate: widget.value,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      initialDatePickerMode: DatePickerMode.year,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: widget.calendarTitle.toUpperCase(),
      locale: locale,
    );

    // setState(() => _selectedDate = result);
    _controller.text = _stringifyDate(result) ?? '';
    if (widget.onChanged != null) return widget.onChanged!(result);
    if (widget.onUnfocused != null) return widget.onUnfocused!(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final style = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: widget.valueTextFontWeight ?? FontWeight.w400,
      fontSize: widget.valueTextFontSize,
      color: widget.valueTextColor,
    );

    final border = OutlineInputBorder(
      borderSide: BorderSide(color: theme.shadowColor, width: 0.5),
      borderRadius: BorderRadius.zero,
    );

    const errorBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 0.5),
      borderRadius: BorderRadius.zero,
    );

    final icon = Icon(
      widget.calendarIcon ?? LaamsIcons.calendar_outline,
      size: widget.calendarIconSize,
      color: widget.calendarIconColor,
    );

    final btnPickDate = GestureDetector(
      onTap: () => _displayCalendar(context, locale),
      child: icon,
    );

    final decoration = InputDecoration(
      border: border,
      focusColor: widget.backgroundColor ?? theme.cardColor,
      fillColor: widget.backgroundColor ?? theme.scaffoldBackgroundColor,
      hoverColor: widget.backgroundColor ?? theme.cardColor,
      errorBorder: errorBorder,
      enabledBorder: border,
      focusedBorder: border,
      disabledBorder: border,
      focusedErrorBorder: errorBorder,
      contentPadding: widget.padding,
      hintText: widget.hintText,
      suffixIcon: btnPickDate,
      errorStyle: const TextStyle(height: 0, fontSize: 0),
      counterText: '',
    );

    Widget field = TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: TextInputType.datetime,
      textInputAction: widget.textInputAction,
      textAlign: widget.valueTextAlignment,
      style: widget.valueStyle ?? style,
      decoration: decoration,
      enabled: widget.enabled,
      onChanged: _onChanged,
      onSaved: _onSaved,
      validator: _validate,
      autovalidateMode: AutovalidateMode.always,
      maxLength: 10,
    );

    field = Align(alignment: widget.alignment, child: field);
    if (widget.onTap == null) return field;
    return GestureDetector(onTap: widget.onTap, child: field);
  }
}
