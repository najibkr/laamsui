import 'package:material_ui/material_ui.dart';

import '../decorate/decorate.dart';

/// CircleStrokeSpin.
class CircleStrokeSpin extends StatelessWidget {
  const CircleStrokeSpin({super.key});

  @override
  Widget build(BuildContext context) {
    final color = DecorateContext.of(context)!.decorateData.colors.first;
    return CircularProgressIndicator(
      strokeWidth: 2,
      color: color,
      backgroundColor: DecorateContext.of(
        context,
      )!.decorateData.pathBackgroundColor,
    );
  }
}
