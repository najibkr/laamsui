import 'package:flutter/material.dart';

import 'laams_image_placeholder.dart';

class LaamsImageAsset extends StatelessWidget {
  final AlignmentGeometry alignment;
  final double? height;
  final double? width;
  final BoxFit boxFit;
  final bool matchTextDirection;
  final String uri;
  final String semanticLabel;
  final bool excludeFromSemantics;
  final bool abbreviateSemanticLabel;
  final double semanticLabelSize;
  final Color? semanticLabelColor;
  final AssetBundle? bundle;
  final String? package;

  const LaamsImageAsset.internal({
    super.key,
    required this.alignment,
    required this.height,
    required this.width,
    required this.boxFit,
    required this.matchTextDirection,
    required this.uri,
    required this.semanticLabel,
    required this.excludeFromSemantics,
    required this.abbreviateSemanticLabel,
    required this.semanticLabelColor,
    required this.semanticLabelSize,
    required this.bundle,
    required this.package,
  });

  const LaamsImageAsset({
    super.key,
    this.alignment = Alignment.center,
    this.height,
    this.width,
    this.boxFit = BoxFit.contain,
    this.matchTextDirection = false,
    required this.uri,
    required this.semanticLabel,
    this.excludeFromSemantics = false,
    this.abbreviateSemanticLabel = true,
    this.semanticLabelColor,
    this.semanticLabelSize = 70,
    this.bundle,
    this.package = 'laamsui',
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      alignment: alignment,
      height: height,
      width: width,
      fit: boxFit,
      matchTextDirection: matchTextDirection,
      uri,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      package: package,
      bundle: bundle,
      errorBuilder: _buildError,
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
