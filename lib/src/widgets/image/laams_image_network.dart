import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

import 'laams_image_placeholder.dart';

class LaamsImageNetwork extends StatelessWidget {
  final Alignment alignment;
  final double? height;
  final double? width;
  final BoxFit boxFit;
  final bool matchTextDirection;
  final Map<String, String>? headers;
  final String uri;
  final String semanticLabel;
  final bool abbreviateSemanticLabel;
  final double semanticLabelSize;
  final Color? semanticLabelColor;

  const LaamsImageNetwork.internal({
    super.key,
    required this.alignment,
    required this.height,
    required this.width,
    required this.boxFit,
    required this.matchTextDirection,
    required this.headers,
    required this.uri,
    required this.semanticLabel,
    required this.abbreviateSemanticLabel,
    required this.semanticLabelSize,
    required this.semanticLabelColor,
  });

  const LaamsImageNetwork({
    super.key,
    this.alignment = Alignment.center,
    this.height,
    this.width,
    this.boxFit = BoxFit.contain,
    this.matchTextDirection = false,
    this.headers,
    required this.uri,
    required this.semanticLabel,
    this.abbreviateSemanticLabel = true,
    this.semanticLabelSize = 50,
    this.semanticLabelColor,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.network(
        uri,
        alignment: alignment,
        height: height,
        width: width,
        fit: boxFit,
        matchTextDirection: matchTextDirection,
        headers: headers,
        errorBuilder: (c, o, s) => _buildError(c, o.toString(), s),
        loadingBuilder: (c, child, s) =>
            _buildPlaceholder(context, s.toString()),
      );
    }
    return CachedNetworkImage(
      alignment: alignment,
      height: height,
      width: width,
      fit: boxFit,
      matchTextDirection: matchTextDirection,
      imageUrl: uri,
      httpHeaders: headers,
      errorWidget: _buildError,
      placeholder: _buildPlaceholder,
    );
  }

  Widget _buildError(BuildContext context, String data, dynamic error) {
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

  Widget _buildPlaceholder(BuildContext context, String data) {
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
