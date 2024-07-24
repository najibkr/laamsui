import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'laams_image_placeholder.dart';

class LaamsSvgNetwork extends StatelessWidget {
  final AlignmentGeometry alignment;
  final Clip clipBehavior;
  final bool allowDrawingOutsideViewBox;
  final double? height;
  final double? width;
  final BoxFit boxFit;
  final SvgTheme? theme;
  final ColorFilter? colorFilter;
  final bool matchTextDirection;
  final Map<String, String>? headers;
  final String uri;
  final String semanticLabel;
  final bool excludeFromSemantics;
  final bool abbreviateSemanticLabel;
  final double semanticLabelSize;
  final Color? semanticLabelColor;

  const LaamsSvgNetwork.internal({
    super.key,
    required this.alignment,
    required this.clipBehavior,
    required this.allowDrawingOutsideViewBox,
    required this.height,
    required this.width,
    required this.boxFit,
    required this.theme,
    required this.colorFilter,
    required this.matchTextDirection,
    required this.headers,
    required this.uri,
    required this.semanticLabel,
    required this.excludeFromSemantics,
    required this.abbreviateSemanticLabel,
    required this.semanticLabelColor,
    required this.semanticLabelSize,
  });

  const LaamsSvgNetwork({
    super.key,
    this.alignment = Alignment.center,
    this.clipBehavior = Clip.hardEdge,
    this.allowDrawingOutsideViewBox = false,
    this.height,
    this.width,
    this.boxFit = BoxFit.contain,
    this.theme,
    this.colorFilter,
    this.matchTextDirection = false,
    this.headers,
    required this.uri,
    required this.semanticLabel,
    this.excludeFromSemantics = false,
    this.abbreviateSemanticLabel = true,
    this.semanticLabelColor,
    this.semanticLabelSize = 70,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      alignment: alignment,
      clipBehavior: clipBehavior,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      height: height,
      width: width,
      fit: boxFit,
      theme: theme,
      colorFilter: colorFilter,
      matchTextDirection: matchTextDirection,
      headers: headers,
      uri,
      semanticsLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      placeholderBuilder: _buildPlaceholder,
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
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
