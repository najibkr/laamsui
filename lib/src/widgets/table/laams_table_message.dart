import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laamsui/models.dart';

class LaamsTableMessage extends StatelessWidget {
  final void Function()? onAccept;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? assetHeight;
  final double? assetWidth;
  final String assetName;
  final String? assetPackage;
  final String title;
  final String message;
  final String? buttonLabel;
  final double spacing;

  const LaamsTableMessage({
    super.key,
    this.onAccept,
    this.width = 500,
    this.margin,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    this.assetHeight = 180,
    this.assetWidth,
    this.assetName = svgNotfound03,
    this.assetPackage = 'laamsui',
    required this.title,
    required this.message,
    this.buttonLabel,
    this.spacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final btnColor = theme.primaryColor;
    final defaultDescStyle = theme.textTheme.bodyLarge;
    final defaultTitleStyle = theme.textTheme.displayLarge?.copyWith(
      fontSize: 22,
    );

    final sp = SizedBox(height: spacing);

    final Widget svg = SvgPicture.asset(
      assetName,
      package: assetPackage,
      semanticsLabel: title,
      height: assetHeight,
      width: assetWidth,
    );

    final titleWidget = Text(
      title,
      style: defaultTitleStyle,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      maxLines: 1,
    );

    final desc = Text(
      message,
      style: defaultDescStyle,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
    );

    Widget? btn;
    if (buttonLabel != null) {
      btn = Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Text(buttonLabel ?? ''),
      );
      final buttonStyle = ButtonStyle(
        foregroundColor: MaterialStateProperty.all(btnColor),
        backgroundColor: MaterialStateProperty.all(btnColor.withOpacity(0.1)),
        surfaceTintColor: MaterialStateProperty.all(btnColor.withOpacity(0.2)),
        overlayColor: MaterialStateProperty.all(btnColor.withOpacity(0.2)),
      );

      btn = TextButton(
        onPressed: onAccept,
        style: buttonStyle,
        child: btn,
      );
    }

    final box = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [svg, sp, titleWidget, sp, desc, sp, if (btn != null) btn],
    );

    final container = Container(
      width: width,
      margin: margin,
      padding: padding,
      child: box,
    );

    return Center(child: container);
  }
}
