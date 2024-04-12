import 'package:flutter/material.dart';

enum CellType {
  text,
  editable,
  autocomplete,
  options,
}

extension CellTypeExt on CellType {
  bool get isText => this == CellType.text;
  bool get isEditable => this == CellType.editable;
  bool get isAutocomplete => this == CellType.autocomplete;
  bool get isOptions => this == CellType.options;
}

class LaamsTableCellData<Entity> {
  final int row;
  final int column;
  final bool isSelected;
  final double height;
  final double width;
  final Entity entity;

  const LaamsTableCellData({
    required this.row,
    required this.column,
    required this.isSelected,
    required this.height,
    required this.width,
    required this.entity,
  });
}

class LaamsTableCell<T> extends StatefulWidget {
  final void Function()? onTap;
  final double? height;
  final double? width;
  final double? menuWidth;
  final double? menuHeight;
  final void Function(String tag)? onSearch;
  final void Function(T? value)? onChanged;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final CellType type;
  final T? value;
  final TextStyle? valueStyle;
  final double? valueTextFontSize;
  final TextAlign? valueTextAlignment;
  final Color? valueTextColor;
  final FontWeight? valueTextFontWeight;
  final String? hintText;
  final List<DropdownMenuEntry<T>> entries;
  final List<LaamsTableCellPopupItem<T>> options;
  final Widget? optionsChild;

  const LaamsTableCell({
    super.key,
    this.onTap,
    this.height,
    this.width,
    this.menuWidth,
    this.menuHeight,
    this.onSearch,
    this.onChanged,
    this.alignment = AlignmentDirectional.centerStart,
    this.margin,
    this.padding = const EdgeInsets.symmetric(horizontal: 5),
    this.backgroundColor,
    this.type = CellType.text,
    required this.value,
    this.valueStyle,
    this.valueTextFontSize,
    this.valueTextAlignment,
    this.valueTextColor,
    this.valueTextFontWeight,
    this.hintText,
    this.entries = const [],
    this.options = const [],
    this.optionsChild,
  });

  @override
  State<LaamsTableCell<T>> createState() => _LaamsTableCellState<T>();
}

class _LaamsTableCellState<T> extends State<LaamsTableCell<T>> {
  T? _input;
  late TextEditingController _inputController;
  late TextEditingController _dropDownController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _input = widget.value;
    _inputController = TextEditingController(text: '${widget.value}');
    _dropDownController = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && widget.value != _input) {
        if (widget.onChanged != null) widget.onChanged!(_input);
      }
    });

    _dropDownController.addListener(() {
      if (widget.onSearch != null) {
        widget.onSearch!(_dropDownController.text.trim());
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _inputController.dispose();
    _dropDownController.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    if (T is String || T == String) {
      return setState(() => _input = value as T);
    }

    if (T is double || T == double) {
      return setState(() => _input = (double.tryParse(value) ?? 0) as T);
    }

    if (T is int || T == int) {
      return setState(() => _input = (int.tryParse(value) ?? 0) as T);
    }
  }

  void _onSelected(T? value) {
    if (value == null) return;
    if (widget.onChanged != null) widget.onChanged!(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: widget.valueTextFontWeight ?? FontWeight.w400,
      fontSize: widget.valueTextFontSize,
      color: widget.valueTextColor,
    );

    Widget cell = const SizedBox();
    if (widget.type.isText) {
      var text = Text(
        (widget.value as String?) ?? '',
        style: widget.valueStyle ?? style,
        textAlign: widget.valueTextAlignment,
      );

      cell = Container(
        color: widget.backgroundColor,
        margin: widget.margin,
        padding: widget.padding,
        child: text,
      );
    }

    if (widget.type.isEditable) {
      final border = OutlineInputBorder(
        borderSide: BorderSide(color: theme.shadowColor, width: 0.5),
        borderRadius: BorderRadius.zero,
      );

      final decoration = InputDecoration(
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
        hintText: widget.hintText,
      );

      cell = TextField(
        textAlign: widget.valueTextAlignment ?? TextAlign.start,
        style: widget.valueStyle ?? style,
        controller: _inputController,
        onChanged: _onChanged,
        focusNode: _focusNode,
        decoration: decoration,
      );
    }

    if (widget.type.isAutocomplete) {
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

      var shape =
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15));
      final menuStyle = MenuStyle(
        backgroundColor:
            MaterialStateProperty.all(theme.scaffoldBackgroundColor),
        shadowColor: MaterialStateProperty.all(theme.shadowColor),
        surfaceTintColor:
            MaterialStateProperty.all(theme.scaffoldBackgroundColor),
        elevation: MaterialStateProperty.all(10),
        shape: MaterialStateProperty.all(shape),
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 10, vertical: 20)),
      );

      cell = DropdownMenu<T>(
        controller: _dropDownController,
        requestFocusOnTap: true,
        enableSearch: true,
        enableFilter: false,
        expandedInsets: EdgeInsets.zero,
        textStyle: widget.valueStyle ?? style,
        trailingIcon: const Icon(Icons.arrow_downward, size: 16),
        selectedTrailingIcon: const Icon(Icons.arrow_upward, size: 16),
        inputDecorationTheme: decoration,
        hintText: widget.hintText,
        initialSelection: widget.entries.any((e) => e.value == widget.value)
            ? widget.value
            : null,
        onSelected: _onSelected,
        menuHeight: widget.menuHeight,
        menuStyle: menuStyle,
        dropdownMenuEntries: widget.entries.map(_mapEntry).toList(),
      );
    }

    if (widget.type.isOptions) {
      final theme = Theme.of(context);
      final hintText = Text(
        widget.hintText ?? '',
        style: widget.valueStyle ?? style,
        textAlign: widget.valueTextAlignment ?? TextAlign.center,
      );

      final found =
          switch (widget.options.any((e) => e.value == widget.value)) {
        true => widget.options.firstWhere((e) => e.value == widget.value),
        _ => null,
      };

      final child = switch (found == null) {
        true => widget.optionsChild ?? hintText,
        _ => LaamsTableCellPopupItem<T>(
            value: found?.value,
            label: found?.label ?? '',
            borderRadius: BorderRadius.zero,
            height: found?.height,
            width: found?.width,
            margin: const EdgeInsets.all(2),
            padding: found?.padding ?? const EdgeInsets.all(10),
            labelColor: found?.labelColor,
            backgroundColor: found?.backgroundColor,
            boxShadow: found?.boxShadow,
            border: found?.border,
            labelTextAlign: found?.labelTextAlign ?? TextAlign.center,
            labelTextStyle: found?.labelTextStyle,
            labelFontSize: found?.labelFontSize,
            labelFontWeight: found?.labelFontWeight,
            labelMaxLines: found?.labelMaxLines,
            subtitle: found?.subtitle,
          ),
      };

      cell = Theme(
        data: Theme.of(context).copyWith(
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: PopupMenuButton<T>(
          onSelected: _onSelected,
          enableFeedback: false,
          shadowColor: theme.shadowColor,
          initialValue: widget.value,
          color: theme.cardColor,
          iconColor: theme.primaryColor,
          surfaceTintColor: theme.scaffoldBackgroundColor,
          splashRadius: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          position: PopupMenuPosition.under,
          itemBuilder: _buildPopupItems,
          constraints: BoxConstraints.tightFor(
              width: widget.menuWidth ?? widget.width,
              height: widget.menuHeight),
          child: child,
        ),
      );
    }

    if (widget.onTap != null) {
      cell = GestureDetector(
        onTap: widget.onTap,
        child: cell,
      );
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
      borderRadius: BorderRadius.circular(5),
    );

    final style = ButtonStyle(
      textStyle: MaterialStateProperty.all(textStyle),
      backgroundColor: MaterialStateProperty.all(theme.scaffoldBackgroundColor),
      shadowColor: MaterialStateProperty.all(theme.shadowColor),
      surfaceTintColor: MaterialStateProperty.all(theme.shadowColor),
      overlayColor: MaterialStateProperty.all(theme.cardColor),
      padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
      shape: MaterialStateProperty.all(radius),
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

  List<PopupMenuEntry<T>> _buildPopupItems(BuildContext context) {
    return widget.options.map((e) {
      return PopupMenuItem(
        onTap: e.onPressed,
        value: e.value,
        height: e.height ?? 40,
        enabled: e.enabled,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: e,
      );
    }).toList();
  }
}

class LaamsTableCellPopupItem<T> extends StatelessWidget {
  final void Function()? onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final T? value;
  final String label;
  final TextStyle? labelTextStyle;
  final double? labelFontSize;
  final Color? labelColor;
  final FontWeight? labelFontWeight;
  final TextAlign labelTextAlign;
  final int? labelMaxLines;
  final String? subtitle;
  final bool enabled;

  const LaamsTableCellPopupItem({
    super.key,
    this.onPressed,
    this.height,
    this.width = 400.0,
    this.margin = const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(5)),
    this.border,
    this.boxShadow,
    required this.value,
    required this.label,
    this.labelTextStyle,
    this.labelFontSize,
    this.labelColor,
    this.labelFontWeight,
    this.labelMaxLines,
    this.labelTextAlign = TextAlign.center,
    this.subtitle,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleSyle = theme.textTheme.bodyLarge?.copyWith(
      fontSize: labelFontSize,
      fontWeight: labelFontWeight,
      color: labelColor,
    );

    final decoration = BoxDecoration(
      color: backgroundColor ?? theme.scaffoldBackgroundColor,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      border: border,
    );

    final title = Text(
      label,
      style: labelTextStyle ?? titleSyle,
      textAlign: labelTextAlign,
    );

    Widget? subtitleWidget;
    if (subtitle != null) {
      final titleStyle = theme.textTheme.bodyLarge?.copyWith(
        fontSize: labelFontSize,
        fontWeight: labelFontWeight,
        color: labelColor,
      );

      subtitleWidget = Text(
        subtitle!,
        style: titleStyle,
        textAlign: labelTextAlign,
        maxLines: labelMaxLines,
      );
    }

    Widget tile = title;
    if (subtitleWidget != null) {
      tile = Column(children: [Expanded(child: title), subtitleWidget]);
    }

    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: decoration,
      child: tile,
    );
  }
}
