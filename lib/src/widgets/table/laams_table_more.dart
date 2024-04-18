import 'package:flutter/material.dart';
import 'package:laamsui/src/animations.dart';

class LaamsTableMore extends StatelessWidget {
  final void Function()? onFetchMore;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final String loadMoreLabel;
  final String? allLoadedMessage;
  final bool isFetchingMore;
  final bool areAllLoaded;
  const LaamsTableMore({
    super.key,
    this.margin = const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    required this.loadMoreLabel,
    this.allLoadedMessage,
    required this.onFetchMore,
    required this.isFetchingMore,
    required this.areAllLoaded,
  });

  @override
  Widget build(BuildContext context) {
    if (isFetchingMore) return const LaamsLoading();

    if (areAllLoaded && allLoadedMessage != null) {
      final theme = Theme.of(context);
      return Padding(
        padding: margin,
        child: Text(
          allLoadedMessage ?? '',
          style: theme.textTheme.displaySmall,
          textAlign: TextAlign.center,
        ),
      );
    }

    if (!areAllLoaded) {
      final theme = Theme.of(context);
      var buttonStyle = ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.disabled)) return null;
            if (states.contains(MaterialState.hovered)) {
              return theme.primaryColor;
            }
            return theme.primaryColor.withOpacity(0.8);
          },
        ),
      );

      Widget content = Padding(
        padding: padding,
        child: Text(loadMoreLabel),
      );

      content = TextButton(
        onPressed: onFetchMore,
        style: buttonStyle,
        child: content,
      );

      return Center(child: Padding(padding: margin, child: content));
    }
    return const SizedBox();
  }
}
