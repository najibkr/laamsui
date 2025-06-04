import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:laamsui/src/extensions/viewport_extension.dart';

class LaamsTabbedScaffold extends StatefulWidget {
  final double titleBarHeight;
  final void Function(BuildContext context)? onLeading;
  final Widget? leading;
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final double leadingIconSize;
  final Widget? title;
  final String? titleText;
  final double? titleTextFontSize;
  final Color? titleTextColor;
  final FontWeight? titleTextFontWeight;
  final bool centerTitle;
  final double titleSpacing;
  final List<Widget> actions;
  final void Function(String path) onTabSelected;
  final List<LaamsScaffoldTabData> tabs;
  final bool? areTabsScrollable;
  final bool hideSingleTab;
  final TabAlignment? tabsAlignment;
  final String currentPath;
  final Widget body;

  const LaamsTabbedScaffold({
    super.key,
    this.titleBarHeight = 50,
    this.onLeading,
    this.leading,
    this.leadingIcon,
    this.leadingIconColor,
    this.leadingIconSize = 24,
    this.title,
    this.titleText,
    this.titleTextFontSize,
    this.titleTextColor,
    this.titleTextFontWeight,
    this.centerTitle = false,
    this.titleSpacing = 8,
    this.actions = const <Widget>[],
    required this.onTabSelected,
    required this.tabs,
    this.areTabsScrollable,
    this.tabsAlignment,
    this.hideSingleTab = true,
    required this.currentPath,
    required this.body,
  });

  @override
  State<LaamsTabbedScaffold> createState() => _LaamsTabbedScaffoldState();
}

class _LaamsTabbedScaffoldState extends State<LaamsTabbedScaffold>
    with SingleTickerProviderStateMixin {
  int _tabIndex = 0;

  late ScrollController _scrollController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabIndex = _foundIndex;
    _tabController = TabController(
      initialIndex: _foundIndex,
      length: widget.tabs.length,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(covariant LaamsTabbedScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPath != widget.currentPath) {
      _tabIndex = _foundIndex;
      _tabController.animateTo(_foundIndex);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  int get _foundIndex {
    final prior = widget.tabs.indexWhere((e) => e.isSelected == true);
    if (prior >= 0) return prior;
    final path = widget.currentPath;
    final index = widget.tabs.indexWhere((e) => e.path == path);
    return switch (index < 0) {
      true => 0,
      false => index,
    };
  }

  bool get _hasTitleBar {
    if (widget.leadingIcon != null) return true;
    if (widget.leading != null) return true;
    if (widget.titleText != null) return true;
    if (widget.title != null) return true;
    if (widget.actions.isNotEmpty) return true;
    return false;
  }

  bool get _hasTopTabBar {
    if (widget.tabs.isEmpty) return false;
    if (widget.hideSingleTab && widget.tabs.length < 2) return false;
    return true;
  }

  double _toolbarHeight(BuildContext context) {
    final pad = MediaQuery.paddingOf(context).top;
    if (!_hasTitleBar && !_hasTopTabBar) return 0 + pad;
    if (_hasTitleBar && !_hasTopTabBar) return widget.titleBarHeight + pad;
    return widget.titleBarHeight + (40) + pad;
  }

  double _appBarHeight(BuildContext context) {
    return _toolbarHeight(context);
  }

  bool _areTabsScrollable(BuildContext context) {
    final areScrollable = widget.areTabsScrollable;
    if (areScrollable != null) return areScrollable;
    final screenSize = MediaQuery.of(context).size;
    if (screenSize.width <= 320) return true;
    if (screenSize.width <= 500) return widget.tabs.length <= 3 ? false : true;
    return true;
  }

  TabAlignment _getTabsAlignment(BuildContext context) {
    final alignment = widget.tabsAlignment;
    if (alignment != null) return alignment;
    final areScrollabel = _areTabsScrollable(context);
    if (areScrollabel) return TabAlignment.start;
    return TabAlignment.fill;
  }

  bool _listenToScroll(ScrollUpdateNotification note) {
    if (note.metrics.axis == Axis.horizontal) return false;
    final innerMaxExtent = note.metrics.maxScrollExtent;
    final outerOffset = _scrollController.offset;
    final innerOffset = note.metrics.pixels;
    final appBarHeight = _appBarHeight(context);

    if (outerOffset != innerOffset && innerOffset <= appBarHeight) {
      final smallInnerOffset = innerMaxExtent <= appBarHeight;
      final scrolledEnough = innerOffset >= innerMaxExtent;
      if (smallInnerOffset && scrolledEnough) return false;
      _scrollController.jumpTo(innerOffset);
    }

    if (innerOffset >= appBarHeight && outerOffset != appBarHeight) {
      _scrollController.jumpTo(appBarHeight);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final tab = widget.tabs[_tabIndex];
    final isL = context.isL;

    Widget scrollView = NotificationListener<ScrollUpdateNotification>(
      onNotification: _listenToScroll,
      child: NestedScrollView(
        controller: _scrollController,
        floatHeaderSlivers: false,
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: _builHeaders,
        body: SafeArea(child: widget.body),
      ),
    );

    if (tab.endSideBar == null || isL) return scrollView;

    return Row(
      children: [
        Expanded(child: scrollView),
        tab.endSideBar ?? const SizedBox(),
      ],
    );
  }

  List<Widget> _builHeaders(BuildContext context, bool innerBoxIsScrolled) {
    final theme = Theme.of(context);
    final tab = widget.tabs[_tabIndex];
    final devicePad = MediaQuery.paddingOf(context).top;

    Widget? titleBar;
    if (_hasTitleBar) {
      Widget? leading = widget.leading;
      if (widget.leadingIcon != null) {
        leading = _IconButton(
          onPressed:
              widget.onLeading == null
                  ? null
                  : () => widget.onLeading!(context),
          icon: widget.leadingIcon ?? Icons.menu,
          iconSize: widget.leadingIconSize,
          iconColor: theme.textTheme.bodyLarge?.color,
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(5),
        );
      }

      Widget? title;
      if (widget.titleText != null) {
        final style = theme.textTheme.displayLarge?.copyWith(
          color: widget.titleTextColor ?? theme.textTheme.bodyLarge?.color,
          fontSize: widget.titleTextFontSize,
          fontWeight: widget.titleTextFontWeight,
          fontVariations: const [
            FontVariation('wght', 700),
            FontVariation('slnt', 0),
          ],
        );

        title = Text(
          widget.titleText ?? '',
          style: style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: widget.centerTitle ? TextAlign.center : TextAlign.start,
        );
      }

      final children = [
        if (leading != null) leading,
        if (leading != null) SizedBox(width: widget.titleSpacing),
        if (title != null) Expanded(child: widget.title ?? title),
        if (widget.actions.isNotEmpty) SizedBox(width: widget.titleSpacing),
        ...widget.actions,
      ];

      final row = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );

      titleBar = Container(
        height: widget.titleBarHeight,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.fromLTRB(0, devicePad, 0, 0),
        child: row,
      );
    }

    PreferredSizeWidget? tabBar;
    if (widget.tabs.isNotEmpty) {
      _LaamsScaffoldTab tabs(LaamsScaffoldTabData data) {
        final index = widget.tabs.indexWhere((e) => e.label == data.label);
        return _LaamsScaffoldTab(
          data: data,
          tabsAlignment: _getTabsAlignment(context),
          isSelected: index == _tabIndex,
          tabsLength: widget.tabs.length,
        );
      }

      final tabPadding = switch (_getTabsAlignment(context)) {
        TabAlignment.fill => 0.0,
        TabAlignment.center => 5.0,
        _ => 12.0,
      };

      tabBar = TabBar(
        controller: _tabController,
        isScrollable: _areTabsScrollable(context),
        tabAlignment: _getTabsAlignment(context),
        indicatorColor: theme.textTheme.bodyLarge?.color,
        dividerColor: theme.cardColor,
        dividerHeight: 1.5,
        indicatorWeight: 2,
        onTap: (index) => widget.onTabSelected(widget.tabs[index].path),
        labelColor: theme.textTheme.bodyLarge?.color,
        unselectedLabelColor: theme.textTheme.bodyLarge?.color,
        labelStyle: theme.textTheme.bodyLarge?.copyWith(
          fontSize: 13,
          fontVariations: [
            const FontVariation('wght', 500),
            const FontVariation('slnt', 0),
          ],
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: tabPadding),
        overlayColor: WidgetStateProperty.all(theme.scaffoldBackgroundColor),
        tabs: widget.tabs.map(tabs).toList(),
      );
      if (widget.hideSingleTab && widget.tabs.length < 2) tabBar = null;
    }

    Widget sliverAppBar = SliverAppBar(
      automaticallyImplyLeading: false,
      // primary: widget.isAppBarPrimary,
      primary: false,
      // pinned: widget.isAppBarPinned,
      pinned: false,
      // floating: widget.isAppBarFloating,
      floating: true,
      snap: false,

      forceElevated: false,
      toolbarHeight: widget.titleBarHeight + MediaQuery.paddingOf(context).top,
      leadingWidth: 0,
      titleSpacing: 0,
      elevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: theme.scaffoldBackgroundColor,
      shadowColor: Colors.transparent,
      title: titleBar,
      centerTitle: true,
      bottom: switch (tabBar != null) {
        false => null,
        true => PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: tabBar ?? const SizedBox(),
        ),
      },
    );

    if (tab.hasScrollObsorber) {
      sliverAppBar = SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: sliverAppBar,
      );
    }

    return <Widget>[sliverAppBar];
  }
}

class LaamsScaffoldTabData {
  final String path;
  final bool hasScrollObsorber;
  final IconData? icon;
  final IconData? activeIcon;
  final double iconSize;
  final String label;
  final PreferredSizeWidget? header;

  // final Widget? body;
  final Widget? endSideBar;
  final bool? isSelected;

  const LaamsScaffoldTabData({
    required this.path,
    this.hasScrollObsorber = true,
    this.icon,
    this.activeIcon,
    this.iconSize = 18,
    required this.label,
    this.header,
    this.endSideBar,
    this.isSelected,
  });
}

class _LaamsScaffoldTab extends StatelessWidget {
  final LaamsScaffoldTabData data;
  final bool isSelected;
  final TabAlignment tabsAlignment;
  final int tabsLength;
  const _LaamsScaffoldTab({
    required this.data,
    required this.isSelected,
    required this.tabsAlignment,
    required this.tabsLength,
  });

  MainAxisAlignment _alignment(TabAlignment align) {
    if (align == TabAlignment.center) return MainAxisAlignment.center;
    if (align == TabAlignment.fill) return MainAxisAlignment.center;
    return MainAxisAlignment.start;
  }

  @override
  Widget build(BuildContext context) {
    final noIcon = data.icon == null && data.activeIcon == null;
    final isS = MediaQuery.of(context).size.width <= 500;

    const labelPad = EdgeInsetsDirectional.only(start: 5);
    final label = Padding(
      padding: noIcon ? EdgeInsets.zero : labelPad,
      child: Text(data.label),
    );

    if (noIcon) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: label,
      );
    }

    final icon = Icon(
      isSelected ? (data.activeIcon ?? data.icon) : data.icon,
      size: isS ? data.iconSize : data.iconSize,
    );

    final align = switch (isS) {
      true => tabsLength <= 3 ? TabAlignment.fill : tabsAlignment,
      _ => tabsAlignment,
    };

    var row = Row(
      mainAxisAlignment: _alignment(align),
      children: [icon, label],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: row,
    );
  }
}

class _IconButton extends StatefulWidget {
  final void Function()? onPressed;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  // final Color? backgroundColor;
  final IconData icon;
  final Color? iconColor;
  final double? iconSize;

  const _IconButton({
    required this.onPressed,
    this.margin = const EdgeInsets.symmetric(horizontal: 2),
    this.padding = const EdgeInsets.all(7),
    // this.backgroundColor,
    required this.icon,
    this.iconColor,
    this.iconSize,
  });

  @override
  State<_IconButton> createState() => _IconButtonState();
}

class _IconButtonState extends State<_IconButton> {
  bool _focused = false;
  bool _hovered = false;

  Color? _bgColor(Color? themeColor) {
    if (kIsWeb || Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      final enabled = widget.onPressed != null;
      if (!enabled) return null;
      final color = widget.iconColor ?? themeColor;
      if (_focused) return color?.withValues(alpha: 0.2);
      if (_hovered) return color?.withValues(alpha: 0.1);
      return null;
    }
    return null;
  }

  Color? _iconColor(Color? themeColor) {
    final color = widget.iconColor ?? themeColor;
    if (kIsWeb) return color;
    final faded = color?.withValues(alpha: 0.5);
    if (Platform.isIOS) return _focused ? faded : color;
    if (Platform.isAndroid) return _focused ? faded : color;
    return color;
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final theme = Theme.of(context);
    final decoration = BoxDecoration(
      color: _bgColor(theme.primaryIconTheme.color),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    );

    Widget button = Icon(
      widget.icon,
      size: widget.iconSize ?? theme.primaryIconTheme.size,
      color: _iconColor(theme.primaryIconTheme.color),
    );

    button = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeIn,
      margin: widget.margin,
      padding: widget.padding,
      decoration: decoration,
      child: button,
    );

    button = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? (_) => setState(() => _focused = true) : null,
      onTapUp: enabled ? (_) => setState(() => _focused = false) : null,
      onTapCancel: enabled ? () => setState(() => _focused = false) : null,
      onTap: widget.onPressed,
      child: Semantics(button: true, child: button),
    );

    button = FocusableActionDetector(
      onShowHoverHighlight: (v) => setState(() => _hovered = v),
      onShowFocusHighlight: (v) => setState(() => _focused = v),
      enabled: enabled,
      child: button,
    );

    button = MouseRegion(
      cursor: enabled && kIsWeb ? SystemMouseCursors.click : MouseCursor.defer,
      child: button,
    );

    return Align(alignment: Alignment.center, child: button);
  }
}
