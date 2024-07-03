import 'package:flutter/material.dart';

class LaamsScaffoldState extends StatefulWidget {
  final Widget child;
  const LaamsScaffoldState({super.key, required this.child});
  @override
  State<LaamsScaffoldState> createState() => _LaamsScaffoldStateState();
}

class _LaamsScaffoldStateState extends State<LaamsScaffoldState> {
  bool _displaySideBar = true;

  void _toggleSideBar() => setState(() => _displaySideBar = !_displaySideBar);
  void _openSideBar() => setState(() => _displaySideBar = true);
  void _closeSideBar() => setState(() => _displaySideBar = false);

  @override
  Widget build(BuildContext context) {
    return LaamsScaffoldData(
      toggleSideBar: _toggleSideBar,
      openSideBar: _openSideBar,
      closeSideBar: _closeSideBar,
      displaySideBar: _displaySideBar,
      child: widget.child,
    );
  }
}

class LaamsScaffoldData extends InheritedWidget {
  final void Function() toggleSideBar;
  final void Function() openSideBar;
  final void Function() closeSideBar;
  final bool displaySideBar;

  const LaamsScaffoldData({
    super.key,
    required this.toggleSideBar,
    required this.openSideBar,
    required this.closeSideBar,
    required super.child,
    required this.displaySideBar,
  });

  @override
  bool updateShouldNotify(LaamsScaffoldData oldWidget) {
    if (oldWidget.displaySideBar != displaySideBar) return true;
    return false;
  }

  static LaamsScaffoldData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LaamsScaffoldData>();
  }

  static LaamsScaffoldData of(BuildContext context) {
    final LaamsScaffoldData? result = maybeOf(context);
    assert(result != null, 'No JaguarScaffoldData found in context');
    return result!;
  }
}
