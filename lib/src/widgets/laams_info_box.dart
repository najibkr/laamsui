import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laamsui/src/animations/laams_loading.dart';
import 'package:laamsui/src/constants/svgs_constants.dart';
import 'package:laamsui/src/extensions/viewport_extension.dart';

enum LaamsInfoBoxStatus {
  idle,
  invalid,
  loading,
  failure,
}

extension LaamsInfoBoxStatusExt on LaamsInfoBoxStatus {
  bool get isIdle => this == LaamsInfoBoxStatus.idle;
  bool get isInvalid => this == LaamsInfoBoxStatus.invalid;
  bool get isLoading => this == LaamsInfoBoxStatus.loading;
  bool get isFailure => this == LaamsInfoBoxStatus.failure;
}

class LaamsInfoBox extends StatelessWidget {
  final AlignmentGeometry? alignment;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? failureBackgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  final String vectorUrl;
  final double vectorSize;

  /// Displayed when info box is in the message state
  final String? idleMessage;
  final String? invalidMessage;
  final String? loadingMessage;
  final String? failureMessage;
  final String? successMessage;
  final bool isSliver;
  final LaamsInfoBoxStatus status;

  const LaamsInfoBox({
    super.key,
    this.alignment,
    this.height,
    this.width = 550,
    this.margin = const EdgeInsets.symmetric(vertical: 10),
    this.padding = const EdgeInsets.all(12),
    this.backgroundColor,
    this.failureBackgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.border,
    this.boxShadow,
    this.vectorUrl = svgIdea01,
    this.vectorSize = 50,
    required this.isSliver,
    this.idleMessage,
    this.invalidMessage,
    this.loadingMessage,
    this.failureMessage,
    this.successMessage,
    this.status = LaamsInfoBoxStatus.idle,
  });

  @override
  Widget build(BuildContext context) {
    final message = switch (status) {
      LaamsInfoBoxStatus.idle => idleMessage ?? '',
      LaamsInfoBoxStatus.invalid => invalidMessage ?? '',
      LaamsInfoBoxStatus.loading => loadingMessage ?? '',
      LaamsInfoBoxStatus.failure => failureMessage ?? '',
    };
    if (status.isIdle && message.isEmpty) return const SizedBox();

    final theme = Theme.of(context);
    final isNarrow = context.isM;
    final defultMsgStyle = theme.textTheme.bodyMedium?.copyWith(
      fontSize: isNarrow ? null : theme.textTheme.bodyLarge?.fontSize,
      color: status.isFailure ? Colors.red : theme.primaryColor,
    );

    final leading = switch (status.isLoading) {
      true => LaamsLoading.card(
          null,
          indicatorSize: Size(vectorSize, vectorSize),
          margin: EdgeInsetsDirectional.only(end: isNarrow ? 8 : 15.0),
        ),
      false => SvgPicture.asset(
          vectorUrl,
          height: vectorSize,
          width: vectorSize,
          semanticsLabel: 'Info',
          package: 'laamsui',
        ),
    };

    // Message:
    Widget newMessage = Text(
      message,
      style: defultMsgStyle,
    );

    final bgkColor = switch (status.isFailure || status.isInvalid) {
      true => switch (failureBackgroundColor != null) {
          true => failureBackgroundColor,
          false => Colors.red.withOpacity(0.08),
        },
      false => switch (backgroundColor != null) {
          true => backgroundColor,
          false => theme.primaryColor.withOpacity(0.08),
        },
    };

    final boxDecoration = BoxDecoration(
      color: bgkColor,
      borderRadius: borderRadius,
      border: border,
      boxShadow: boxShadow,
    );

    Widget infoContainer = Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: boxDecoration,
      child: Row(children: [leading, Expanded(child: newMessage)]),
    );

    if (alignment != null) {
      infoContainer = Align(alignment: alignment!, child: infoContainer);
    }

    if (isSliver) return SliverToBoxAdapter(child: infoContainer);
    return infoContainer;
  }
}
