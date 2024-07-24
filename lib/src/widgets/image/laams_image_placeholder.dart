import 'package:flutter/material.dart';

class LaamsImagePlaceholder extends StatelessWidget {
  final AlignmentGeometry alignment;
  final double? height;
  final double? width;
  final String semanticLabel;
  final bool abbreviateSemanticLabel;
  final double semanticLabelSize;
  final Color? semanticLabelColor;

  const LaamsImagePlaceholder({
    super.key,
    required this.alignment,
    required this.height,
    required this.width,
    required this.semanticLabel,
    required this.abbreviateSemanticLabel,
    required this.semanticLabelSize,
    required this.semanticLabelColor,
  });

  String get _abbreviatedLabel {
    if (semanticLabel.trim().isEmpty) return 'P';
    return semanticLabel.trim()[0];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayLarge?.copyWith(
      fontSize: semanticLabelSize,
      color: semanticLabelColor,
    );

    final text = Text(
      abbreviateSemanticLabel ? _abbreviatedLabel : semanticLabel,
      style: style,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );

    final container = SizedBox(
      height: height,
      width: width,
      child: Center(child: text),
    );

    return Align(alignment: alignment, child: container);
  }
}
