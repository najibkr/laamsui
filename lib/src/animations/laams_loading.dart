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
  final double? height;
  final double? width;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final WidgetType widgetType;
  final bool centered;
  final String? message;
  final TextStyle? messageStyle;
  final double? messageFontSize;
  final Color? messageColor;
  final FontWeight? messageFontWeight;
  final int? messageMaxLines;

  /// Indicate which type.
  final IndicatorType type;

  /// The color you draw on the shape.
  final List<Color>? colors;

  /// The stroke width of line.
  final double? strokeWidth;

  /// Applicable to which has cut edge of the shape
  final Color? pathBackgroundColor;

  const LaamsLoading.card({
    super.key,
    this.height,
    this.width,
    this.alignment = Alignment.center,
    this.margin,
    this.message,
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
    this.centered = true,
    this.type = IndicatorType.circular,
    this.colors = const [
      Colors.deepOrangeAccent,
      Colors.pinkAccent,
      Colors.amber,
      Colors.deepOrange,
      Colors.lightGreen,
      Colors.indigo,
      Colors.orangeAccent,
      Colors.blueAccent,
    ],
    this.strokeWidth,
    this.pathBackgroundColor,
  }) : widgetType = WidgetType.card;

  @Deprecated('Use JaguarLoading.card()')
  const LaamsLoading.box({
    super.key,
    this.height,
    this.message,
    this.messageStyle,
    this.messageColor,
    this.messageFontSize,
    this.messageFontWeight,
    this.messageMaxLines = 2,
    this.width,
    this.alignment = Alignment.center,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.boxShadow,
    this.border,
    this.borderRadius,
    this.centered = true,
    this.type = IndicatorType.circular,
    this.colors = const [
      Colors.amber,
      Colors.deepOrangeAccent,
      Colors.pinkAccent,
      Colors.purple,
      Colors.yellow,
      Colors.lightGreen,
      Colors.orangeAccent,
      Colors.blueAccent,
    ],
    this.strokeWidth,
    this.pathBackgroundColor,
  }) : widgetType = WidgetType.card;

  const LaamsLoading.sliver({
    super.key,
    this.height,
    this.width,
    this.message,
    this.messageStyle,
    this.messageColor,
    this.messageFontSize,
    this.messageFontWeight,
    this.messageMaxLines = 2,
    this.alignment = Alignment.center,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.boxShadow,
    this.border,
    this.borderRadius,
    this.centered = true,
    this.type = IndicatorType.circular,
    this.colors = const [
      Colors.amber,
      Colors.deepOrangeAccent,
      Colors.pinkAccent,
      Colors.purple,
      Colors.yellow,
      Colors.lightGreen,
      Colors.orangeAccent,
      Colors.blueAccent,
    ],
    this.strokeWidth,
    this.pathBackgroundColor,
  }) : widgetType = WidgetType.sliver;

  const LaamsLoading.screen({
    super.key,
    this.height,
    this.width,
    this.message,
    this.messageStyle,
    this.messageColor,
    this.messageFontSize,
    this.messageFontWeight,
    this.messageMaxLines = 2,
    this.alignment = Alignment.center,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.boxShadow,
    this.border,
    this.borderRadius,
    this.centered = true,
    this.type = IndicatorType.circular,
    this.colors = const [
      Colors.amber,
      Colors.deepOrangeAccent,
      Colors.pinkAccent,
      Colors.purple,
      Colors.yellow,
      Colors.lightGreen,
      Colors.orangeAccent,
      Colors.blueAccent,
    ],
    this.strokeWidth,
    this.pathBackgroundColor,
  }) : widgetType = WidgetType.screen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<Color> safeColors =
        colors == null || colors!.isEmpty ? [theme.primaryColor] : colors!;

    final loading = switch (type) {
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
      indicator: type,
      colors: safeColors,
      strokeWidth: strokeWidth,
      pathBackgroundColor: pathBackgroundColor,
    );

    Widget newIndicator = AspectRatio(
      aspectRatio: 1,
      child: DecorateContext(decorateData: decoration, child: loading),
    );

    if ((message ?? '').isEmpty && WidgetType.card == widgetType) {
      return Center(child: newIndicator);
    }

    if ((message ?? '').isEmpty && WidgetType.sliver == widgetType) {
      return SliverToBoxAdapter(child: Center(child: newIndicator));
    }

    if ((message ?? '').isEmpty && WidgetType.screen == widgetType) {
      return Scaffold(body: Center(child: newIndicator));
    }

    if ((message ?? '').isNotEmpty) {
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

      const space = SizedBox(height: 10);
      newIndicator = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [newIndicator, space, text],
      );

      final boxDecoration = BoxDecoration(
        color: backgroundColor,
        boxShadow: boxShadow,
        border: border,
        borderRadius: borderRadius,
      );

      newIndicator = Container(
        height: height,
        width: width,
        padding: padding,
        margin: margin,
        decoration: boxDecoration,
        child: newIndicator,
      );
    }

    if (widgetType == WidgetType.sliver) {
      return SliverToBoxAdapter(child: Center(child: newIndicator));
    }

    if (widgetType == WidgetType.screen) {
      return Scaffold(body: Center(child: newIndicator));
    }

    return Center(child: newIndicator);
  }
}
