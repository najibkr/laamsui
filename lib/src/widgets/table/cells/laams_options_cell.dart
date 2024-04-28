import 'package:flutter/material.dart';

class LaamsOptionsCell<T> extends StatelessWidget {
  final void Function()? onTap;
  final double? height;
  final double? width;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? menuWidth;
  final double? menuHeight;
  final void Function(T? value)? onSelected;
  final T? value;
  final TextStyle? valueStyle;
  final double? valueTextFontSize;
  final TextAlign? valueTextAlignment;
  final Color? valueTextColor;
  final FontWeight? valueTextFontWeight;
  final String? hintText;
  final List<LaamsCellOption<T>> options;
  final Widget? optionsChild;

  const LaamsOptionsCell({
    super.key,
    this.onTap,
    this.height,
    this.width,
    this.menuWidth,
    this.menuHeight,
    this.alignment = AlignmentDirectional.centerStart,
    this.margin,
    this.padding = const EdgeInsets.symmetric(horizontal: 5),
    this.backgroundColor,
    this.onSelected,
    required this.value,
    this.valueStyle,
    this.valueTextFontSize,
    this.valueTextAlignment,
    this.valueTextColor,
    this.valueTextFontWeight,
    this.hintText,
    required this.options,
    this.optionsChild,
  });

  List<PopupMenuEntry<T>> _buildPopupItems(BuildContext context) {
    return options.map((e) {
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

  void _onSelected(T? value) {
    if (onSelected != null) onSelected!(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: valueTextFontWeight ?? FontWeight.w400,
      fontSize: valueTextFontSize,
      color: valueTextColor,
    );

    final hint = Text(
      hintText ?? '',
      style: valueStyle ?? style,
      textAlign: valueTextAlignment ?? TextAlign.center,
    );

    final found = switch (options.any((e) => e.value == value)) {
      true => options.firstWhere((e) => e.value == value),
      _ => null,
    };

    final option = switch (found == null) {
      true => optionsChild ?? hint,
      _ => LaamsCellOption<T>(
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

    Widget cell = Theme(
      data: Theme.of(context).copyWith(
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: PopupMenuButton<T>(
        onSelected: _onSelected,
        enableFeedback: false,
        shadowColor: theme.shadowColor,
        initialValue: value,
        color: theme.cardColor,
        iconColor: theme.primaryColor,
        surfaceTintColor: theme.scaffoldBackgroundColor,
        splashRadius: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        position: PopupMenuPosition.under,
        itemBuilder: _buildPopupItems,
        constraints: BoxConstraints.tightFor(
          width: menuWidth ?? width,
          height: menuHeight,
        ),
        child: option,
      ),
    );

    if (onTap != null) {
      cell = GestureDetector(
        onTap: onTap,
        child: cell,
      );
    }

    return Align(alignment: alignment, child: cell);
  }
}

class LaamsCellOption<T> extends StatelessWidget {
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

  const LaamsCellOption({
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
