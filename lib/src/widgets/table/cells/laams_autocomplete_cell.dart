import 'package:flutter/material.dart';

class LaamsAutocompleteCell<T> extends StatefulWidget {
  final void Function()? onTap;
  final double? height;
  final double? width;
  final double? menuWidth;
  final double? menuHeight;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final void Function(String tag)? onSearch;
  final void Function(T? value)? onSelected;
  final T? initialValue;
  final TextStyle? valueStyle;
  final double? valueTextFontSize;
  final TextAlign? valueTextAlignment;
  final Color? valueTextColor;
  final FontWeight? valueTextFontWeight;
  final String? hintText;
  final List<DropdownMenuEntry<T>> entries;

  const LaamsAutocompleteCell({
    super.key,
    this.onTap,
    this.height,
    this.width,
    this.menuWidth = 400,
    this.menuHeight = 350,
    this.alignment = AlignmentDirectional.centerStart,
    this.margin,
    this.padding = const EdgeInsets.symmetric(horizontal: 5),
    this.backgroundColor,
    this.onSearch,
    this.onSelected,
    required this.initialValue,
    this.valueStyle,
    this.valueTextFontSize,
    this.valueTextAlignment,
    this.valueTextColor,
    this.valueTextFontWeight,
    this.hintText,
    this.entries = const [],
  });

  @override
  State<LaamsAutocompleteCell<T>> createState() =>
      _LaamsAutocompleteCellState<T>();
}

class _LaamsAutocompleteCellState<T> extends State<LaamsAutocompleteCell<T>> {
  late TextEditingController _dropDownController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _dropDownController = TextEditingController();
    _focusNode = FocusNode();
    _dropDownController.addListener(() {
      if (widget.onSearch != null) {
        widget.onSearch!(_dropDownController.text.trim());
      }
    });
  }

  @override
  void dispose() {
    _dropDownController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSelected(T? value) {
    _focusNode.nextFocus();
    if (widget.onSelected != null) widget.onSelected!(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: widget.valueTextFontWeight ?? FontWeight.w400,
      fontSize: widget.valueTextFontSize,
      color: widget.valueTextColor,
    );

    final border = OutlineInputBorder(
      borderSide: BorderSide(color: theme.shadowColor, width: 0.5),
      borderRadius: BorderRadius.zero,
    );

    final decoration = InputDecorationTheme(
      border: border,
      focusColor: widget.backgroundColor ?? theme.cardColor,
      fillColor: widget.backgroundColor ?? theme.scaffoldBackgroundColor,
      hoverColor: widget.backgroundColor ?? theme.cardColor,
      errorBorder: border,
      enabledBorder: border,
      focusedBorder: border,
      disabledBorder: border,
      focusedErrorBorder: border,
      contentPadding: widget.padding,
      isDense: true,
      constraints: BoxConstraints.tightFor(height: widget.height ?? 40),
    );

    var shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(15));
    final menuStyle = MenuStyle(
      backgroundColor: WidgetStateProperty.all(theme.scaffoldBackgroundColor),
      shadowColor: WidgetStateProperty.all(theme.shadowColor),
      surfaceTintColor: WidgetStateProperty.all(theme.scaffoldBackgroundColor),
      elevation: WidgetStateProperty.all(10),
      shape: WidgetStateProperty.all(shape),
      padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 10, vertical: 20)),
    );
    final val = widget.initialValue;
    final initialValue = switch (widget.entries.any((e) => e.value == val)) {
      true => widget.initialValue,
      _ => null,
    };

    Widget cell = DropdownMenu<T>(
      controller: _dropDownController,
      focusNode: _focusNode,
      requestFocusOnTap: true,
      enableSearch: true,
      enableFilter: false,
      expandedInsets: EdgeInsets.zero,
      textStyle: widget.valueStyle ?? style,
      inputDecorationTheme: decoration,
      hintText: widget.hintText,
      initialSelection: initialValue,
      onSelected: _onSelected,
      menuHeight: widget.menuHeight,
      menuStyle: menuStyle,
      dropdownMenuEntries: widget.entries.map(_mapEntry).toList(),
    );

    if (widget.onTap != null) {
      cell = GestureDetector(onTap: widget.onTap, child: cell);
    }

    return Align(alignment: widget.alignment, child: cell);
  }

  DropdownMenuEntry<T> _mapEntry(DropdownMenuEntry<T> e) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w400,
    );
    var radius = RoundedRectangleBorder(
      side: BorderSide(color: theme.shadowColor, width: 0.5),
      borderRadius: BorderRadius.circular(0),
    );

    final style = ButtonStyle(
      textStyle: WidgetStateProperty.all(textStyle),
      backgroundColor: WidgetStateProperty.all(theme.scaffoldBackgroundColor),
      shadowColor: WidgetStateProperty.all(theme.shadowColor),
      surfaceTintColor: WidgetStateProperty.all(theme.shadowColor),
      overlayColor: WidgetStateProperty.all(theme.cardColor),
      padding: WidgetStateProperty.all(const EdgeInsets.all(10)),
      shape: WidgetStateProperty.all(radius),
    );

    return DropdownMenuEntry<T>(
      value: e.value,
      label: e.label,
      leadingIcon: e.leadingIcon,
      labelWidget: e.labelWidget,
      trailingIcon: e.trailingIcon,
      enabled: e.enabled,
      style: e.style ?? style,
    );
  }
}
