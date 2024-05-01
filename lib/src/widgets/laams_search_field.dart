import 'package:flutter/material.dart';

class LaamsSearchField extends StatefulWidget {
  final double? height;
  final double? width;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Color? backgrounColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final bool showKShadow;

  // Icons Related:
  final IconData searchIcon;
  final double searchIconSize;
  final Color? searchIconColor;

  // Field Related:
  final void Function(String value) onSearch;
  final bool autofocus;
  final int maxLength;

  // Delete Related:
  final IconData? deleteIcon;
  final double deleteIconSize;
  final Color? deleteIconColor;
  const LaamsSearchField({
    super.key,
    this.height = 60,
    this.width = 600,
    this.margin = const EdgeInsets.all(5),
    this.padding = const EdgeInsets.all(15),
    this.backgrounColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(100)),
    this.border,
    this.boxShadow,
    this.showKShadow = true,

    // Search Icon:
    this.searchIcon = Icons.search_outlined,
    this.searchIconSize = 22,
    this.searchIconColor,

    // Field Related:
    required this.onSearch,
    this.autofocus = false,
    this.maxLength = 250,

    // Delete:
    this.deleteIcon = Icons.close,
    this.deleteIconColor,
    this.deleteIconSize = 24,
  });

  @override
  State<LaamsSearchField> createState() => _LaamsSearchFieldState();
}

class _LaamsSearchFieldState extends State<LaamsSearchField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.value.text.length,
        );
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _cancelSearch() {
    _controller.text = '';
    widget.onSearch('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final boxShadow = BoxShadow(color: theme.shadowColor, blurRadius: 5);
    final boxDecoration = BoxDecoration(
      color: widget.backgrounColor ?? theme.scaffoldBackgroundColor,
      borderRadius: widget.borderRadius,
      border: widget.border,
      boxShadow: widget.boxShadow ?? (widget.showKShadow ? [boxShadow] : null),
    );

    final inputBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 1.0, color: theme.scaffoldBackgroundColor),
      borderRadius: BorderRadius.circular(100),
      gapPadding: 5,
    );

    var inputConstraints = BoxConstraints(
      maxHeight: widget.height ?? double.infinity,
      maxWidth: widget.width ?? double.infinity,
    );

    final searchIcon = Padding(
      padding: const EdgeInsetsDirectional.only(start: 8.0),
      child: Icon(
        widget.searchIcon,
        color: widget.searchIconColor,
        size: widget.searchIconSize,
      ),
    );

    Widget? deleteIcon;
    if (widget.deleteIcon != null) {
      final iconColor = switch (_controller.value.text.trim().isEmpty) {
        true => theme.shadowColor,
        false => theme.primaryColor,
      };
      final icon = Icon(
        widget.deleteIcon,
        color: widget.deleteIconColor ?? iconColor,
        size: widget.deleteIconSize,
      );

      deleteIcon = Padding(
        padding: const EdgeInsetsDirectional.only(end: 8.0),
        child: icon,
      );

      deleteIcon = GestureDetector(
        onTap: _cancelSearch,
        child: deleteIcon,
      );
    }

    final inputDecoration = InputDecoration(
      fillColor: theme.scaffoldBackgroundColor,
      hoverColor: theme.cardColor,
      focusColor: theme.scaffoldBackgroundColor,
      border: inputBorder,
      errorBorder: inputBorder,
      enabledBorder: inputBorder,
      focusedBorder: inputBorder,
      disabledBorder: inputBorder,
      focusedErrorBorder: inputBorder,
      constraints: inputConstraints,
      contentPadding: widget.padding,
      prefixIcon: searchIcon,
      suffixIcon: deleteIcon,
      counterText: '',
      counterStyle: const TextStyle(height: 0, fontSize: 0),
    );

    final textField = TextField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      autocorrect: false,
      decoration: inputDecoration,
      onChanged: (v) => widget.onSearch(v.trim()),
      autofocus: widget.autofocus,
      maxLength: widget.maxLength,
    );

    return Container(
      margin: widget.margin,
      decoration: boxDecoration,
      child: textField,
    );
  }
}
