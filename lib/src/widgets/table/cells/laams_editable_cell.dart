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
  final bool enabled;

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
    this.enabled = true,
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

  void _handleUnfocus() {
    if (_focusNode.hasFocus) return;
    if (widget.value == _controller.text) return;
    if (widget.onUnfocused == null) return;

    if (T is String || T == String) {
      return widget.onUnfocused!(_controller.text as T);
    }
    if (T is double || T == double) {
      return widget.onUnfocused!(double.tryParse(_controller.text) as T?);
    }

    if (T is int || T == int) {
      return widget.onUnfocused!(int.tryParse(_controller.text) as T?);
    }
  }

  void _onChanged(String value) {
    if (widget.onChanged == null) return;

    if (T is String || T == String) {
      return widget.onChanged!(value as T);
    }

    if (T is double || T == double) {
      return widget.onChanged!(double.tryParse(value) as T?);
    }

    if (T is int || T == int) {
      return widget.onChanged!(int.tryParse(value) as T?);
    }
  }

  void _onSaved(String? value) {
    if (widget.onSaved == null) return;
    if (value == null) return widget.onSaved!(null);

    if (T is String || T == String) {
      return widget.onSaved!(value as T);
    }

    if (T is double || T == double) {
      return widget.onSaved!(double.tryParse(value) as T?);
    }

    if (T is int || T == int) {
      return widget.onSaved!(int.tryParse(value) as T?);
    }
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

    Widget cell = Align(
      alignment: widget.alignment,
      child: TextFormField(
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
      ),
    );

    if (widget.onTap == null) return cell;
    return GestureDetector(onTap: widget.onTap, child: cell);
  }
}
