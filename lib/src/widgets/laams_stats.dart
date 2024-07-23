import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laamsui/extensions.dart';
import 'package:laamsui/laamsui.dart' show LaamsLoading, IndicatorType;

class LaamsStats extends StatelessWidget {
  final bool isSliver;
  final AlignmentGeometry? alignment;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final List<Widget> stats;

  const LaamsStats({
    super.key,
    this.isSliver = true,
    this.alignment,
    this.width = 1200,
    this.margin = const EdgeInsets.all(15),
    this.padding,
    this.stats = const [],
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Wrap(
      spacing: 10,
      runSpacing: 10,
      children: stats,
    );

    if (width != null || margin != null || padding != null) {
      content = Container(
        width: width,
        margin: margin,
        padding: padding,
        child: content,
      );

      if (alignment != null) {
        content = Align(alignment: alignment!, child: content);
      }
    }

    if (!isSliver) return content;

    return SliverToBoxAdapter(child: content);
  }
}

class LaamsStatsCard<Stat extends num> extends StatefulWidget {
  final void Function(BuildContext context)? onInitialize;
  final void Function(BuildContext context)? onPressed;
  final MaterialColor color;
  final IconData icon;
  final String title;
  final Stat stat;
  final String? unit;
  final bool isLoading;

  const LaamsStatsCard({
    super.key,
    this.onInitialize,
    this.onPressed,
    required this.color,
    required this.icon,
    required this.title,
    required this.stat,
    this.unit,
    this.isLoading = false,
  });

  @override
  State<LaamsStatsCard<Stat>> createState() => _LaamsStatsCardState<Stat>();
}

class _LaamsStatsCardState<Stat extends num>
    extends State<LaamsStatsCard<Stat>> {
  @override
  void initState() {
    super.initState();
    if (widget.onInitialize != null) widget.onInitialize!(context);
  }

  String _formatStat(String lang) {
    return '${NumberFormat.decimalPatternDigits(
      locale: lang,
      decimalDigits: 0,
    ).format(widget.stat)} ${widget.unit ?? ''}'
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final isS = context.isS;
    final theme = Theme.of(context);
    const space = SizedBox(width: 8);
    final lang = context.currentLocale.languageCode;
    final statsStyle =
        theme.textTheme.displayLarge?.copyWith(color: widget.color);
    final titleStyle = theme.textTheme.displaySmall?.copyWith(
      fontWeight: FontWeight.w500,
      color: theme.textTheme.bodyLarge?.color,
      fontSize: isS ? 15 : 16,
    );

    var iconGradient = RadialGradient(
      colors: [
        if (widget.color[50] != null) widget.color[50]!,
        if (widget.color[100] != null) widget.color[100]!,
        if (widget.color[200] != null) widget.color[200]!,
      ],
    );

    final iconDecoration = BoxDecoration(
      color: widget.color.withOpacity(0.3),
      gradient: iconGradient,
      boxShadow: [BoxShadow(color: widget.color[100]!, blurRadius: 4)],
      borderRadius: BorderRadius.circular(200),
    );

    final iconWidget = Container(
      padding: const EdgeInsets.all(7),
      decoration: iconDecoration,
      child: Icon(widget.icon, size: isS ? 30 : 35, color: widget.color),
    );

    final newTitle = Text(
      widget.title,
      style: titleStyle,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );

    Widget newStat = Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text(_formatStat(lang), style: statsStyle),
    );

    if (widget.isLoading) {
      newStat = const LaamsLoading.card(
        null,
        margin: EdgeInsets.only(top: 2),
        indicatorType: IndicatorType.ballBeat,
        indicatorSize: Size(30, 15),
      );
    }

    Widget detail = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [newTitle, Expanded(child: FittedBox(child: newStat))],
    );

    detail = SizedBox(
      height: 60,
      child: Align(alignment: AlignmentDirectional.centerStart, child: detail),
    );

    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [iconWidget, space, Expanded(child: detail)],
    );

    final cardGradient = LinearGradient(
      begin: AlignmentDirectional.topStart,
      end: AlignmentDirectional.bottomEnd,
      colors: [
        if (widget.color[50] != null) widget.color[50]!,
        if (widget.color[100] != null) widget.color[100]!,
        if (widget.color[50] != null) widget.color[50]!,
      ],
    );

    Widget card = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
      decoration: BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.circular(10),
      ),
      child: content,
    );

    if (widget.onPressed != null) {
      card = GestureDetector(
        onTap:
            widget.onPressed == null ? null : () => widget.onPressed!(context),
        child: card,
      );
    }

    return SizedBox(
      width: isS ? ((context.screenSize.width / 2) - 20) : 220,
      child: card,
    );
  }
}
