import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laamsui/extensions.dart';
import 'package:laamsui/laamsui.dart' show IndicatorType, LaamsLoading;

class LaamsStatsTile<Stat extends num> extends StatelessWidget {
  final void Function(BuildContext context)? onPressed;
  final double? height;
  final double width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color color;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final BorderRadiusGeometry borderRadius;
  final IconData icon;
  final double? iconSize;
  final String title;
  final TextStyle? titleStyle;
  final Stat stat;
  final String? unit;
  final double spacing;
  final bool isLoading;

  const LaamsStatsTile({
    super.key,
    this.onPressed,
    this.height,
    this.width = 250,
    this.margin,
    this.padding,
    required this.color,
    this.boxShadow,
    this.border,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.icon = Icons.star_outline,
    this.iconSize,
    required this.title,
    this.titleStyle,
    required this.stat,
    this.unit,
    this.spacing = 8,
    required this.isLoading,
  });

  String _formatStat(String lang) {
    return '${NumberFormat.decimalPatternDigits(
      locale: lang,
      decimalDigits: 0,
    ).format(stat)} ${unit ?? ''}'
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    // General:
    final lang = context.currentLocale.languageCode;
    final theme = Theme.of(context);
    final isS = context.isS;

    final fmtStat = _formatStat(lang);

    final double statFontSize = switch (fmtStat.length) {
      > 11 => isS ? 14 : 15,
      <= 6 => 28,
      <= 9 => isS ? 20 : 24,
      <= 11 => isS ? 18 : 22,
      _ => 28,
    };

    // Defaults
    final defIconSize = isS ? 25.0 : 32.0;

    // final defPadding =
    //     isMobile ? const EdgeInsets.all(8) : const EdgeInsets.all(8);
    final defStatsStyle = theme.textTheme.displayLarge?.copyWith(
      color: color,
      fontSize: statFontSize,
    );
    final defTitleStyle = theme.textTheme.displaySmall?.copyWith(
      fontWeight: FontWeight.w500,
      color: theme.textTheme.bodyLarge?.color,
      fontSize: isS ? 13 : theme.textTheme.bodyLarge?.fontSize,
    );

    final backgroundGradient = LinearGradient(
      begin: AlignmentDirectional.topStart,
      end: AlignmentDirectional.bottomEnd,
      colors: [
        color.withOpacity(0.1),
        color.withOpacity(0.3),
        color.withOpacity(0.1),
      ],
    );
    final boxDecoration = BoxDecoration(
      gradient: backgroundGradient,
      boxShadow: boxShadow,
      border: border,
      borderRadius: borderRadius,
    );

    final iconWidget = Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.2),
            color.withOpacity(0.4),
          ],
        ),
        boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 3)],
        borderRadius: BorderRadius.circular(200),
      ),
      child: Icon(icon, size: iconSize ?? defIconSize, color: color),
    );

    final space = SizedBox(
      width: isS ? spacing : spacing + 5,
      height: spacing,
    );

    final newTitle = Text(
      title.toUpperCase(),
      style: titleStyle ?? defTitleStyle,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );

    Widget newStat = Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(_formatStat(lang), style: titleStyle ?? defStatsStyle),
    );

    if (isLoading) {
      newStat = LaamsLoading.card(
        null,
        margin: EdgeInsets.only(top: spacing),
        indicatorType: IndicatorType.ballBeat,
        indicatorSize: const Size(80, 15),
      );
    }

    final details = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [newTitle, newStat],
      ),
    );

    final container = Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(8),
      decoration: boxDecoration,
      child: Row(children: [iconWidget, space, details]),
    );

    if (onPressed == null) return container;

    return GestureDetector(
      onTap: () => onPressed!(context),
      child: container,
    );
  }
}
