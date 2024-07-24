import 'dart:typed_data' show Uint8List;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'image/laams_image_asset.dart';
import 'image/laams_image_memory.dart';
import 'image/laams_image_network.dart';
import 'image/laams_image_placeholder.dart';
import 'image/laams_svg_asset.dart';
import 'image/laams_svg_memory.dart';
import 'image/laams_svg_network.dart';

enum LaamsImageType {
  svgAsset,
  svgNetwork,
  svgMemory,
  imageNetwork,
  imageAsset,
  imageMemory,
  auto,
}

extension LaamsImageTypeExt on LaamsImageType {
  bool get isSvgAsset => this == LaamsImageType.svgAsset;
  bool get isSvgNetwork => this == LaamsImageType.svgNetwork;
  bool get isSvgMemory => this == LaamsImageType.svgMemory;
  bool get isImageNetwork => this == LaamsImageType.imageNetwork;
  bool get isImageAsset => this == LaamsImageType.imageAsset;
  bool get isImageMemory => this == LaamsImageType.imageMemory;
  bool get isAuto => this == LaamsImageType.auto;
}

class LaamsImage extends StatelessWidget {
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final void Function()? onDoubleTap;
  final AlignmentGeometry? alignment;
  final Clip clipBehavior;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final BorderRadiusGeometry? borderRadius;
  final double radiusOffset;
  final Alignment imageAlignment;
  final bool allowDrawingOutsideViewBox;
  final BoxFit boxFit;
  final SvgTheme? svgTheme;
  final ColorFilter? colorFilter;
  final bool matchTextDirection;
  final LaamsImageType type;
  final Map<String, String>? headers;
  final String? uri;
  final Uint8List? bytes;
  final String semanticLabel;
  final bool excludeFromSemantics;
  final bool abbreviateSemanticLabel;
  final double? semanticLabelSize;
  final Color? semanticLabelColor;
  final AssetBundle? bundle;
  final String? package;
  final AlignmentGeometry stackAlignment;
  final List<Widget> positionedChildren;

  const LaamsImage({
    super.key,
    this.onDoubleTap,
    this.onLongPress,
    this.onPressed,
    this.alignment,
    this.clipBehavior = Clip.none,
    this.height,
    this.width,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.backgroundGradient,
    this.border,
    this.boxShadow,
    this.borderRadius,
    this.radiusOffset = 5,
    this.imageAlignment = Alignment.center,
    this.allowDrawingOutsideViewBox = false,
    this.boxFit = BoxFit.contain,
    this.svgTheme,
    this.colorFilter,
    this.matchTextDirection = false,
    this.type = LaamsImageType.auto,
    this.headers,
    this.uri,
    this.bytes,
    required this.semanticLabel,
    this.excludeFromSemantics = false,
    this.abbreviateSemanticLabel = true,
    this.semanticLabelColor,
    this.semanticLabelSize,
    this.bundle,
    this.package = 'laamsui',
    this.stackAlignment = Alignment.center,
    this.positionedChildren = const [],
  });

  double get _inferSemanticSize {
    if (semanticLabelSize != null) return semanticLabelSize!;
    if (height != null && abbreviateSemanticLabel) return height! / 1.5;
    if (width != null && abbreviateSemanticLabel) return width! / 1.5;
    return 70;
  }

  LaamsImageType get _type {
    if (!type.isAuto) return type;
    final newUri = (uri ?? '').trim();
    final isNetwork = newUri.startsWith('https://');
    final isSvg = newUri.contains('.svg');

    if (!isNetwork && !isSvg) {
      return LaamsImageType.imageAsset;
    } else if (!isNetwork && isSvg) {
      return LaamsImageType.svgAsset;
    } else if (isNetwork && isSvg) {
      return LaamsImageType.svgNetwork;
    } else if (bytes != null) {
      return LaamsImageType.imageMemory;
    } else {
      return LaamsImageType.imageNetwork;
    }
  }

  @override
  Widget build(BuildContext context) {
    final inferedType = _type;
    Widget image = LaamsImagePlaceholder(
      alignment: Alignment.center,
      height: height,
      width: width,
      semanticLabel: semanticLabel,
      semanticLabelColor: semanticLabelColor,
      semanticLabelSize: semanticLabelSize ?? _inferSemanticSize,
      abbreviateSemanticLabel: abbreviateSemanticLabel,
    );

    if ((uri ?? '').isNotEmpty && inferedType.isSvgAsset) {
      image = LaamsSvgAsset.internal(
        alignment: imageAlignment,
        clipBehavior: clipBehavior,
        allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
        height: height,
        width: width,
        boxFit: boxFit,
        theme: svgTheme,
        colorFilter: colorFilter,
        matchTextDirection: matchTextDirection,
        uri: uri ?? '',
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        semanticLabelColor: semanticLabelColor,
        semanticLabelSize: semanticLabelSize ?? _inferSemanticSize,
        abbreviateSemanticLabel: abbreviateSemanticLabel,
        bundle: bundle,
        package: package,
      );
    } else if ((uri ?? '').isNotEmpty && inferedType.isSvgNetwork) {
      image = LaamsSvgNetwork.internal(
        alignment: imageAlignment,
        clipBehavior: clipBehavior,
        allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
        height: height,
        width: width,
        boxFit: boxFit,
        theme: svgTheme,
        colorFilter: colorFilter,
        matchTextDirection: matchTextDirection,
        headers: headers,
        uri: uri ?? '',
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        semanticLabelColor: semanticLabelColor,
        semanticLabelSize: semanticLabelSize ?? _inferSemanticSize,
        abbreviateSemanticLabel: abbreviateSemanticLabel,
      );
    } else if (bytes != null && inferedType.isSvgMemory) {
      image = LaamsSvgMemory.internal(
        alignment: imageAlignment,
        clipBehavior: clipBehavior,
        allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
        height: height,
        width: width,
        boxFit: boxFit,
        theme: svgTheme,
        colorFilter: colorFilter,
        matchTextDirection: matchTextDirection,
        bytes: bytes ?? Uint8List.fromList([]),
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        semanticLabelColor: semanticLabelColor,
        semanticLabelSize: semanticLabelSize ?? _inferSemanticSize,
        abbreviateSemanticLabel: abbreviateSemanticLabel,
      );
    } else if ((uri ?? '').isNotEmpty && inferedType.isImageAsset) {
      image = LaamsImageAsset.internal(
        alignment: imageAlignment,
        height: height,
        width: width,
        boxFit: boxFit,
        matchTextDirection: matchTextDirection,
        uri: uri ?? '',
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        semanticLabelColor: semanticLabelColor,
        semanticLabelSize: semanticLabelSize ?? _inferSemanticSize,
        abbreviateSemanticLabel: abbreviateSemanticLabel,
        bundle: bundle,
        package: package,
      );
    } else if ((uri ?? '').isNotEmpty && inferedType.isImageNetwork) {
      image = LaamsImageNetwork.internal(
        alignment: imageAlignment,
        height: height,
        width: width,
        boxFit: boxFit,
        matchTextDirection: matchTextDirection,
        headers: headers,
        uri: uri ?? '',
        semanticLabel: semanticLabel,
        semanticLabelColor: semanticLabelColor,
        semanticLabelSize: semanticLabelSize ?? _inferSemanticSize,
        abbreviateSemanticLabel: abbreviateSemanticLabel,
      );
    } else if (bytes != null && inferedType.isImageMemory) {
      image = LaamsImageMemory.internal(
        alignment: imageAlignment,
        height: height,
        width: width,
        boxFit: boxFit,
        matchTextDirection: matchTextDirection,
        bytes: bytes ?? Uint8List.fromList([]),
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        semanticLabelColor: semanticLabelColor,
        semanticLabelSize: semanticLabelSize ?? _inferSemanticSize,
        abbreviateSemanticLabel: abbreviateSemanticLabel,
      );
    }

    if (borderRadius != null) {
      var minus = BorderRadius.circular(radiusOffset);
      image = ClipRRect(
        borderRadius: borderRadius!.subtract(minus),
        clipBehavior: clipBehavior,
        child: image,
      );
    }

    final decoration = BoxDecoration(
      color: backgroundColor,
      border: border,
      boxShadow: boxShadow,
      borderRadius: borderRadius,
      gradient: backgroundGradient,
    );

    image = Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: decoration,
      child: image,
    );

    if (positionedChildren.isNotEmpty) {
      image = Stack(
        alignment: stackAlignment,
        children: positionedChildren,
      );
    }

    if (onPressed != null || onLongPress != null || onDoubleTap != null) {
      image = GestureDetector(
        onTap: onPressed,
        onLongPress: onLongPress,
        onDoubleTap: onDoubleTap,
        child: image,
      );
    }

    if (alignment == null) return image;
    return Align(alignment: alignment!, child: image);
  }
}
