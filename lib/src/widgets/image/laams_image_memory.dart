import 'dart:typed_data' show Uint8List;

import 'package:flutter/material.dart';

import 'laams_image_placeholder.dart';

class LaamsImageMemory extends StatelessWidget {
  final AlignmentGeometry alignment;
  final double? height;
  final double? width;
  final BoxFit boxFit;
  final bool matchTextDirection;
  final Uint8List bytes;
  final String semanticLabel;
  final bool excludeFromSemantics;
  final bool abbreviateSemanticLabel;
  final double semanticLabelSize;
  final Color? semanticLabelColor;

  const LaamsImageMemory.internal({
    super.key,
    required this.alignment,
    required this.height,
    required this.width,
    required this.boxFit,
    required this.matchTextDirection,
    required this.bytes,
    required this.semanticLabel,
    required this.excludeFromSemantics,
    required this.abbreviateSemanticLabel,
    required this.semanticLabelColor,
    required this.semanticLabelSize,
  });

  const LaamsImageMemory({
    super.key,
    this.alignment = Alignment.center,
    this.height,
    this.width,
    this.boxFit = BoxFit.contain,
    this.matchTextDirection = false,
    required this.bytes,
    required this.semanticLabel,
    this.excludeFromSemantics = false,
    this.abbreviateSemanticLabel = true,
    this.semanticLabelColor,
    this.semanticLabelSize = 70,
  });

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      alignment: alignment,
      height: height,
      width: width,
      fit: boxFit,
      matchTextDirection: matchTextDirection,
      bytes,
      errorBuilder: _buildError,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
    );
  }

  Widget _buildError(BuildContext context, Object data, StackTrace? stack) {
    return LaamsImagePlaceholder(
      alignment: alignment,
      height: height,
      width: width,
      semanticLabel: semanticLabel,
      semanticLabelColor: semanticLabelColor,
      semanticLabelSize: semanticLabelSize,
      abbreviateSemanticLabel: abbreviateSemanticLabel,
    );
  }
}
