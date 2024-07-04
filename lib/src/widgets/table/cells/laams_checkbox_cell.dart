import 'package:flutter/material.dart';

class LaamsCheckboxCell extends StatelessWidget {
  final void Function(bool?)? onChanged;
  final bool? value;
  final bool enabled;
  final String? semanticLabel;
  const LaamsCheckboxCell({
    super.key,
    this.onChanged,
    this.value,
    this.enabled = true,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overalyColor = theme.primaryColor.withOpacity(0.1);
    Color? fillColor(Set<WidgetState> data) {
      if (data.contains(WidgetState.selected)) {
        return theme.shadowColor;
      }
      return Colors.transparent;
    }

    return Checkbox(
      onChanged: enabled ? onChanged : null,
      value: value,
      fillColor: WidgetStateProperty.resolveWith(fillColor),
      checkColor: theme.textTheme.bodyLarge?.color,
      overlayColor: WidgetStateProperty.all(overalyColor),
      focusColor: theme.cardColor,
      hoverColor: theme.cardColor,
    );
  }
}
