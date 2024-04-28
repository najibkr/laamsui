import 'package:flutter/material.dart';

class LaamsEditableCell<T> extends StatefulWidget {
  final void Function()? onTap;
  final void Function(T? value)? onChanged;
  final void Function(T? value)? onSaved;
  final void Function(T? value)? onUnfocused;
  final double? height;
  final double? width;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? hintText;
  final T? value;
  final TextStyle? valueStyle;
  final double? valueTextFontSize;
  final TextAlign valueTextAlignment;
  final Color? valueTextColor;
  final FontWeight? valueTextFontWeight;
  final String? unit;
  final double? unitFontSize;
  final Color? unitColor;
  final FontWeight? unitFontWeight;
  final bool enabled;
  final double? minValue;
  final double? maxValue;

  const LaamsEditableCell({
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
    this.unit,
    this.unitFontSize,
    this.unitFontWeight,
    this.unitColor,
    this.enabled = true,
    this.minValue,
    this.maxValue,
  });

  @override
  State<LaamsEditableCell<T>> createState() => _LaamsEditableCellState<T>();
}

class _LaamsEditableCellState<T> extends State<LaamsEditableCell<T>> {
  late TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _initialValue);
    _focusNode = FocusNode();
    _focusNode.addListener(() => _handleUnfocus());
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  String? get _initialValue {
    if (widget.value == null) return null;
    if (T is String || T == String) return widget.value as String;
    if (T is double || T == double) return '${widget.value}';
    if (T is int || T == int) return '${widget.value}';
    return null;
  }

  TextInputType? get _keyboardType {
    if (widget.keyboardType != null) return widget.keyboardType;
    if (T is String || T == String) return TextInputType.text;
    if (T is int || T == int) return TextInputType.number;
    if (T is double || T == double) {
      return const TextInputType.numberWithOptions(
        signed: true,
        decimal: false,
      );
    }
    return null;
  }

  String _translateNumbers(String value) {
    return value
        .replaceAll('۰', '0')
        .replaceAll("۱", "1")
        .replaceAll("۲", "2")
        .replaceAll("۳", "3")
        .replaceAll("۴", "4")
        .replaceAll("۵", "5")
        .replaceAll("۶", "6")
        .replaceAll("۷", "7")
        .replaceAll("۸", "8")
        .replaceAll("۹", "9");
  }

  void _handleUnfocus() {
    if (_focusNode.hasFocus) return;
    if (widget.value == _controller.text) return;
    if (widget.onUnfocused == null) return;

    if (T is String || T == String) {
      return widget.onUnfocused!(_controller.text as T);
    }
    if (T is double || T == double) {
      final translated = _translateNumbers(_controller.text);
      _controller.text = translated;
      return widget.onUnfocused!(double.tryParse(translated) as T?);
    }

    if (T is int || T == int) {
      final translated = _translateNumbers(_controller.text);
      _controller.text = translated;
      return widget.onUnfocused!(int.tryParse(translated) as T?);
    }
  }

  void _onChanged(String? value) {
    if (widget.onChanged == null) return;
    if (value == null) return widget.onChanged!(null);

    if (T is String || T == String) {
      return widget.onChanged!(value as T?);
    }

    if (T is double || T == double) {
      final translated = _translateNumbers(value);
      return widget.onChanged!(double.tryParse(translated) as T?);
    }

    if (T is int || T == int) {
      final translated = _translateNumbers(value);
      return widget.onChanged!(int.tryParse(translated) as T?);
    }
  }

  void _onSaved(String? value) {
    if (widget.onSaved == null) return;
    if (value == null) return widget.onSaved!(null);

    if (T is String || T == String) {
      return widget.onSaved!(value as T);
    }

    if (T is double || T == double) {
      final translated = _translateNumbers(value);
      return widget.onSaved!(double.tryParse(translated) as T?);
    }

    if (T is int || T == int) {
      final translated = _translateNumbers(value);
      return widget.onSaved!(int.tryParse(translated) as T?);
    }
  }

  String? _validator(String? input) {
    final value = input ?? '';
    if (widget.minValue == null && widget.maxValue == null) return null;
    final hasMin = widget.minValue != null && widget.maxValue == null;
    final hasMax = widget.minValue == null && widget.maxValue != null;
    final hasMinMax = widget.minValue != null && widget.maxValue != null;

    if (hasMin && (T is String || T == String)) {
      return switch (value.length < (widget.minValue as int)) {
        true => '',
        _ => null,
      };
    }

    if (hasMin && (T is double || T == double)) {
      final doubleValue = double.tryParse(value) ?? 0.0;
      return switch (doubleValue < (widget.minValue ?? 0)) {
        true => '',
        _ => null,
      };
    }

    if (hasMin && (T is int || T == int)) {
      final intValue = int.tryParse(value) ?? 0;
      return switch (intValue < (widget.minValue as int)) {
        true => '',
        _ => null,
      };
    }

    if (hasMax && (T is String || T == String)) {
      return switch (value.length > (widget.maxValue as int)) {
        true => '',
        _ => null,
      };
    }

    if (hasMax && (T is double || T == double)) {
      final doubleValue = double.tryParse(value) ?? 0.0;
      return switch (doubleValue > (widget.maxValue ?? 0)) {
        true => '',
        _ => null,
      };
    }

    if (hasMax && (T is int || T == int)) {
      final intValue = int.tryParse(value) ?? 0;
      return switch (intValue > (widget.maxValue as int)) {
        true => '',
        _ => null,
      };
    }

    if (hasMinMax && (T is String || T == String)) {
      return switch ((value.length < (widget.minValue as int)) ||
          (value.length > (widget.maxValue as int))) {
        true => '',
        _ => null,
      };
    }

    if (hasMinMax && (T is double || T == double)) {
      final doubleValue = double.tryParse(value) ?? 0.0;
      return switch ((doubleValue < (widget.minValue ?? 0)) ||
          (doubleValue > (widget.maxValue ?? 0))) {
        true => '',
        _ => null,
      };
    }

    if (hasMinMax && (T is int || T == int)) {
      final intValue = int.tryParse(value) ?? 0;
      return switch ((intValue < (widget.minValue as int)) ||
          (intValue > (widget.maxValue as int))) {
        true => '',
        _ => null,
      };
    }

    return null;
  }

  int? get _maxLength {
    if (widget.maxValue == null) return null;
    if ((T is String || T == String)) return widget.maxValue as int?;
    if ((T is int || T == int)) return '${widget.maxValue}'.length;
    return (widget.maxValue ?? 0).toStringAsFixed(2).split('.').first.length;
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

    const errorBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 0.5),
      borderRadius: BorderRadius.zero,
    );

    Widget? suffix;
    if ((widget.unit ?? '').isNotEmpty) {
      final style = theme.textTheme.bodyLarge?.copyWith(
        fontSize: widget.unitFontSize,
        fontWeight: widget.unitFontWeight,
        color: widget.unitColor,
      );

      suffix = Text(
        widget.unit ?? '',
        style: style,
        textAlign: TextAlign.center,
      );
    }

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
      suffix: suffix,
      errorStyle: const TextStyle(height: 0, fontSize: 0),
      counterText: '',
    );

    Widget field = TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: _keyboardType,
      textInputAction: widget.textInputAction,
      textAlign: widget.valueTextAlignment,
      style: widget.valueStyle ?? style,
      decoration: decoration,
      enabled: widget.enabled,
      onChanged: _onChanged,
      onSaved: _onSaved,
      validator: _validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: _maxLength == null ? null : (_maxLength ?? 0) + 5,
    );

    field = Align(alignment: widget.alignment, child: field);
    if (widget.onTap == null) return field;
    return GestureDetector(onTap: widget.onTap, child: field);
  }
}
