import 'package:flutter/material.dart';

import 'loading/decorate/decorate.dart';
import 'loading/indicator_type.dart';
import 'loading/indicators/audio_equalizer.dart';
import 'loading/indicators/ball_beat.dart';
import 'loading/indicators/ball_clip_rotate.dart';
import 'loading/indicators/ball_clip_rotate_multiple.dart';
import 'loading/indicators/ball_clip_rotate_pulse.dart';
import 'loading/indicators/ball_grid_beat.dart';
import 'loading/indicators/ball_grid_pulse.dart';
import 'loading/indicators/ball_pulse.dart';
import 'loading/indicators/ball_pulse_rise.dart';
import 'loading/indicators/ball_pulse_sync.dart';
import 'loading/indicators/ball_rotate.dart';
import 'loading/indicators/ball_rotate_chase.dart';
import 'loading/indicators/ball_scale.dart';
import 'loading/indicators/ball_scale_multiple.dart';
import 'loading/indicators/ball_scale_ripple.dart';
import 'loading/indicators/ball_scale_ripple_multiple.dart';
import 'loading/indicators/ball_spin_fade_loader.dart';
import 'loading/indicators/ball_triangle_path.dart';
import 'loading/indicators/ball_triangle_path_colored.dart';
import 'loading/indicators/ball_zig_zag.dart';
import 'loading/indicators/ball_zig_zag_deflect.dart';
import 'loading/indicators/circle_stroke_spin.dart';
import 'loading/indicators/circular_loading.dart';
import 'loading/indicators/cube_transition.dart';
import 'loading/indicators/line_scale.dart';
import 'loading/indicators/line_scale_party.dart';
import 'loading/indicators/line_scale_pulse_out.dart';
import 'loading/indicators/line_scale_pulse_out_rapid.dart';
import 'loading/indicators/line_spin_fade_loader.dart';
import 'loading/indicators/orbit.dart';
import 'loading/indicators/pacman.dart';
import 'loading/indicators/semi_circle_spin.dart';
import 'loading/indicators/square_spin.dart';
import 'loading/indicators/triangle_skew_spin.dart';

enum WidgetType { card, sliver, screen }

class LaamsLoading extends StatelessWidget {
  final WidgetType type;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;

  /// Indicator-Related Fields:
  final IndicatorType indicatorType;
  final Size indicatorSize;
  final List<Color>? indicatorColors;
  final double? indicatorStrokeWidth;
  final Color? indicatorPathBackgroundColor;

  /// Message-Related Fields:
  final String? message;
  final TextStyle? messageStyle;
  final double? messageFontSize;
  final Color? messageColor;
  final FontWeight? messageFontWeight;
  final int? messageMaxLines;

  final void Function()? onButtonPressed;
  final String? buttonLabel;

  final double spacing;

  const LaamsLoading.card(
    this.message, {
    super.key,
    this.height,
    this.width,
    this.margin,
    this.messageStyle,
    this.messageColor,
    this.messageFontSize,
    this.messageFontWeight,
    this.messageMaxLines = 2,
    this.padding,
    this.backgroundColor,
    this.boxShadow,
    this.border,
    this.borderRadius,
    this.indicatorType = IndicatorType.circular,
    this.indicatorSize = const Size(50, 50),
    this.indicatorColors = const [
      Colors.deepOrangeAccent,
      Colors.pinkAccent,
      Colors.amber,
      Colors.deepOrange,
      Colors.lightGreen,
      Colors.indigo,
      Colors.orangeAccent,
      Colors.blueAccent,
    ],
    this.indicatorPathBackgroundColor,
    this.indicatorStrokeWidth,
    this.onButtonPressed,
    this.buttonLabel,
    this.spacing = 10,
  }) : type = WidgetType.card;

  const LaamsLoading.sliver(
    this.message, {
    super.key,
    this.height,
    this.width,
    this.margin,
    this.messageStyle,
    this.messageColor,
    this.messageFontSize,
    this.messageFontWeight,
    this.messageMaxLines = 2,
    this.padding,
    this.backgroundColor,
    this.boxShadow,
    this.border,
    this.borderRadius,
    this.indicatorType = IndicatorType.circular,
    this.indicatorSize = const Size(50, 50),
    this.indicatorColors = const [
      Colors.deepOrangeAccent,
      Colors.pinkAccent,
      Colors.amber,
      Colors.deepOrange,
      Colors.lightGreen,
      Colors.indigo,
      Colors.orangeAccent,
      Colors.blueAccent,
    ],
    this.indicatorPathBackgroundColor,
    this.indicatorStrokeWidth,
    this.onButtonPressed,
    this.buttonLabel,
    this.spacing = 10,
  }) : type = WidgetType.sliver;

  const LaamsLoading.screen(
    this.message, {
    super.key,
    this.height,
    this.width,
    this.margin,
    this.messageStyle,
    this.messageColor,
    this.messageFontSize,
    this.messageFontWeight,
    this.messageMaxLines = 2,
    this.padding,
    this.backgroundColor,
    this.boxShadow,
    this.border,
    this.borderRadius,
    this.indicatorType = IndicatorType.circular,
    this.indicatorSize = const Size(50, 50),
    this.indicatorColors = const [
      Colors.deepOrangeAccent,
      Colors.pinkAccent,
      Colors.amber,
      Colors.deepOrange,
      Colors.lightGreen,
      Colors.indigo,
      Colors.orangeAccent,
      Colors.blueAccent,
    ],
    this.indicatorPathBackgroundColor,
    this.indicatorStrokeWidth,
    this.onButtonPressed,
    this.buttonLabel,
    this.spacing = 10,
  }) : type = WidgetType.screen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<Color> safeColors = indicatorColors == null || indicatorColors!.isEmpty
        ? [theme.primaryColor]
        : indicatorColors!;

    final loading = switch (indicatorType) {
      IndicatorType.ballPulse => const BallPulse(),
      IndicatorType.ballGridPulse => const BallGridPulse(),
      IndicatorType.ballClipRotate => const BallClipRotate(),
      IndicatorType.squareSpin => const SquareSpin(),
      IndicatorType.ballClipRotatePulse => const BallClipRotatePulse(),
      IndicatorType.ballClipRotateMultiple => const BallClipRotateMultiple(),
      IndicatorType.ballPulseRise => const BallPulseRise(),
      IndicatorType.ballRotate => const BallRotate(),
      IndicatorType.cubeTransition => const CubeTransition(),
      IndicatorType.ballZigZag => const BallZigZag(),
      IndicatorType.ballZigZagDeflect => const BallZigZagDeflect(),
      IndicatorType.ballTrianglePath => const BallTrianglePath(),
      IndicatorType.ballTrianglePathColored => const BallTrianglePathColored(),
      IndicatorType.ballTrianglePathColoredFilled =>
        const BallTrianglePathColored(isFilled: true),
      IndicatorType.ballScale => const BallScale(),
      IndicatorType.lineScale => const LineScale(),
      IndicatorType.lineScaleParty => const LineScaleParty(),
      IndicatorType.ballScaleMultiple => const BallScaleMultiple(),
      IndicatorType.ballPulseSync => const BallPulseSync(),
      IndicatorType.ballBeat => const BallBeat(),
      IndicatorType.lineScalePulseOut => const LineScalePulseOut(),
      IndicatorType.lineScalePulseOutRapid => const LineScalePulseOutRapid(),
      IndicatorType.ballScaleRipple => const BallScaleRipple(),
      IndicatorType.ballScaleRippleMultiple => const BallScaleRippleMultiple(),
      IndicatorType.ballSpinFadeLoader => const BallSpinFadeLoader(),
      IndicatorType.lineSpinFadeLoader => const LineSpinFadeLoader(),
      IndicatorType.triangleSkewSpin => const TriangleSkewSpin(),
      IndicatorType.pacman => const Pacman(),
      IndicatorType.ballGridBeat => const BallGridBeat(),
      IndicatorType.semiCircleSpin => const SemiCircleSpin(),
      IndicatorType.ballRotateChase => const BallRotateChase(),
      IndicatorType.orbit => const Orbit(),
      IndicatorType.audioEqualizer => const AudioEqualizer(),
      IndicatorType.circleStrokeSpin => const CircleStrokeSpin(),
      _ => const CircularLoading(),
    };

    final decoration = DecorateData(
      indicator: indicatorType,
      colors: safeColors,
      strokeWidth: indicatorStrokeWidth,
      pathBackgroundColor: indicatorPathBackgroundColor,
    );

    Widget indicator = SizedBox(
      height: indicatorSize.height,
      width: indicatorSize.width,
      child: DecorateContext(decorateData: decoration, child: loading),
    );

    Widget? btn;
    if (buttonLabel != null) {
      btn = Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Text(buttonLabel ?? ''),
      );

      final buttonStyle = ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.red),
        backgroundColor: MaterialStateProperty.all(Colors.red.withOpacity(0.1)),
        surfaceTintColor:
            MaterialStateProperty.all(Colors.red.withOpacity(0.2)),
        overlayColor: MaterialStateProperty.all(Colors.red.withOpacity(0.2)),
      );

      btn = TextButton(
        onPressed: onButtonPressed,
        style: buttonStyle,
        child: btn,
      );
    }

    if ((message ?? '').trim().isEmpty) {
      if (btn != null) {
        final space = SizedBox(height: spacing);
        indicator = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [indicator, space, btn],
        );
      }

      final boxDecoration = BoxDecoration(
        color: backgroundColor,
        boxShadow: boxShadow,
        border: border,
        borderRadius: borderRadius,
      );

      indicator = Container(
        height: height,
        width: width,
        padding: padding,
        margin: margin,
        decoration: boxDecoration,
        child: indicator,
      );

      return switch (type) {
        WidgetType.sliver =>
          SliverToBoxAdapter(child: Center(child: indicator)),
        WidgetType.screen => Scaffold(body: Center(child: indicator)),
        _ => Center(child: indicator),
      };
    }

    final style = theme.textTheme.bodyLarge?.copyWith(
      fontSize: messageFontSize,
      fontWeight: messageFontWeight,
      color: messageColor,
    );

    var text = Text(
      message ?? '',
      maxLines: messageMaxLines,
      textAlign: TextAlign.center,
      style: messageStyle ?? style,
    );

    final space = SizedBox(height: spacing);
    indicator = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [indicator, space, text, space, if (btn != null) btn],
    );

    final boxDecoration = BoxDecoration(
      color: backgroundColor,
      boxShadow: boxShadow,
      border: border,
      borderRadius: borderRadius,
    );

    indicator = Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: boxDecoration,
      child: indicator,
    );

    return switch (type) {
      WidgetType.sliver => SliverToBoxAdapter(child: Center(child: indicator)),
      WidgetType.screen => Scaffold(body: Center(child: indicator)),
      _ => Center(child: indicator),
    };
  }
}
