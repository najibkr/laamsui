import 'package:flutter/material.dart';

/// This helps you create a scaffold with multiple tabs.
class LaamsTabbedScaffold extends StatefulWidget {
  final bool isAppBarPrimary;
  final bool isAppBarPinned;
  final bool isAppBarFloating;
  final double titleBarHeight;
  final EdgeInsetsGeometry titleBarPadding;
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
  final FlexibleSpaceBar? header;
  final double? headerHeight;
  final Widget body;

  const LaamsTabbedScaffold({
    super.key,
    this.isAppBarPrimary = false,
    this.isAppBarPinned = false,
    this.isAppBarFloating = false,
    this.titleBarHeight = 50,
    this.titleBarPadding = const EdgeInsets.symmetric(horizontal: 22),
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
    this.titleSpacing = 12,
    this.actions = const <Widget>[],
    required this.onTabSelected,
    required this.tabs,
    this.areTabsScrollable,
    this.tabsAlignment,
    this.hideSingleTab = true,
    required this.currentPath,
    this.header,
    this.headerHeight,
    required this.body,
  });

  @override
  State<LaamsTabbedScaffold> createState() => _LaamsTabbedScaffoldState();
}

class _LaamsTabbedScaffoldState extends State<LaamsTabbedScaffold>
    with SingleTickerProviderStateMixin {
  // final int _index = 0;
  int _currentTab = 0;
  late ScrollController _scrollController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    final index = widget.tabs.indexWhere((e) => e.path == widget.currentPath);
    if (index >= 0) _currentTab = index;

    _tabController = TabController(
      initialIndex: _currentTab,
      length: widget.tabs.length,
      vsync: this,
    );

    _tabController.addListener(() {
      widget.onTabSelected(widget.tabs[_tabController.index].path);
      setState(() => _currentTab = _tabController.index);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
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
    if (widget.header != null) return false;
    if (widget.tabs.isEmpty) return false;
    if (widget.hideSingleTab && widget.tabs.length < 2) return false;
    return true;
  }

  double get _toolbarHeight {
    if (!_hasTitleBar && !_hasTopTabBar) return 0;
    if (_hasTitleBar && !_hasTopTabBar) return widget.titleBarHeight;
    if (!_hasTitleBar && _hasTopTabBar) return 46 + 3;
    return widget.titleBarHeight + (46 + 3);
  }

  double get _appBarHeight {
    final hHeight =
        widget.headerHeight ?? widget.tabs[_currentTab].headerHeight;
    if (hHeight != null) return hHeight;
    return _toolbarHeight;
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

    if (outerOffset != innerOffset && innerOffset <= _appBarHeight) {
      final smallInnerOffset = innerMaxExtent <= _appBarHeight;
      final scrolledEnough = innerOffset >= innerMaxExtent;
      if (smallInnerOffset && scrolledEnough) return false;
      _scrollController.jumpTo(innerOffset);
    }

    if (innerOffset >= _appBarHeight && outerOffset != _appBarHeight) {
      _scrollController.jumpTo(_appBarHeight);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final tab = widget.tabs[_currentTab];

    Widget page = widget.body;
    if (tab.bodyWidth != null || tab.bodyHeight != null) {
      page = SizedBox(
        height: tab.bodyHeight,
        width: tab.bodyWidth,
        child: page,
      );
      page = Align(alignment: tab.bodyAlignment, child: page);
    }

    if (tab.bodyMargin != null) {
      page = Padding(padding: tab.bodyMargin!, child: page);
    }

    Widget scrollView = NestedScrollView(
      controller: _scrollController,
      floatHeaderSlivers: false,
      physics: const NeverScrollableScrollPhysics(),
      headerSliverBuilder: _builHeaders,
      body: page,
    );

    return NotificationListener<ScrollUpdateNotification>(
      onNotification: _listenToScroll,
      child: scrollView,
    );
  }

  List<Widget> _builHeaders(BuildContext context, bool innerBoxIsScrolled) {
    final theme = Theme.of(context);
    final isS = MediaQuery.of(context).size.width <= 500;
    final tab = widget.tabs[_currentTab];

    Widget? leading = widget.leading;
    if (widget.leadingIcon != null) {
      leading = Icon(
        widget.leadingIcon,
        color: widget.leadingIconColor ?? theme.textTheme.bodyLarge?.color,
        size: widget.leadingIconSize,
      );

      leading = GestureDetector(
        onTap: () => widget.onLeading!(context),
        child: Padding(padding: const EdgeInsets.all(2.5), child: leading),
      );
    }

    Widget? title;
    if (widget.titleText != null) {
      final style = theme.textTheme.displayLarge?.copyWith(
        color: widget.titleTextColor ?? theme.textTheme.bodyLarge?.color,
        fontSize: widget.titleTextFontSize,
        fontWeight: widget.titleTextFontWeight,
      );

      title = Text(
        widget.titleText ?? '',
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: widget.centerTitle ? TextAlign.center : TextAlign.start,
      );
    }

    Widget? titleBar;
    if (_hasTitleBar) {
      final children = [
        if (leading != null) leading,
        const SizedBox(width: 8),
        if (title != null) Expanded(child: widget.title ?? title),
        const SizedBox(width: 8),
        ...widget.actions,
      ];

      final row = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );

      titleBar = Container(
        height: widget.titleBarHeight,
        padding: widget.titleBarPadding,
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
          isSelected: index == _currentTab,
          tabsLength: widget.tabs.length,
        );
      }

      final tabPadding = switch (_getTabsAlignment(context)) {
        TabAlignment.fill => 3.0,
        TabAlignment.center => 5.0,
        _ => isS ? 16.0 : 18.0,
      };

      tabBar = TabBar(
        controller: _tabController,
        isScrollable: _areTabsScrollable(context),
        tabAlignment: _getTabsAlignment(context),
        indicatorColor: theme.primaryColor,
        dividerColor: theme.cardColor,
        dividerHeight: 2,
        indicatorWeight: 3,
        labelColor: theme.primaryColor,
        unselectedLabelColor: theme.textTheme.bodyLarge?.color,
        labelStyle:
            theme.textTheme.bodyLarge?.copyWith(fontSize: isS ? 15 : 14),
        labelPadding: EdgeInsets.symmetric(horizontal: tabPadding),
        overlayColor: MaterialStateProperty.all(theme.scaffoldBackgroundColor),
        tabs: widget.tabs.map(tabs).toList(),
      );
      if (widget.hideSingleTab && widget.tabs.length < 2) tabBar = null;
    }

    Widget? toolBar;
    if (titleBar != null || tabBar != null) {
      if (titleBar != null && tabBar == null) toolBar = titleBar;
      if (titleBar == null && tabBar != null) toolBar = tabBar;
      if (titleBar != null && tabBar != null) {
        toolBar = Column(children: [titleBar, tabBar]);
      }
      if (widget.header != null) toolBar = titleBar;
    }

    Widget? header = widget.header ?? tab.header;
    if (header == null && tab.hasHeader) {
      header = FlexibleSpaceBar(
        background: _LaamsScaffoldHeader(data: tab, topSpacing: _toolbarHeight),
        collapseMode: CollapseMode.none,
        stretchModes: const [StretchMode.zoomBackground],
      );
    }

    Widget sliverAppBar = SliverAppBar(
      automaticallyImplyLeading: false,
      primary: widget.isAppBarPrimary,
      pinned: widget.isAppBarPinned,
      floating: widget.isAppBarFloating,
      snap: false,
      forceElevated: false,
      expandedHeight: _appBarHeight,
      collapsedHeight: _toolbarHeight,
      toolbarHeight: _toolbarHeight,
      leadingWidth: 0,
      titleSpacing: 0,
      elevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: theme.scaffoldBackgroundColor,
      shadowColor: Colors.transparent,
      title: toolBar,
      centerTitle: true,
      flexibleSpace: header,
      bottom: widget.header != null ? tabBar : null,
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
  final EdgeInsetsGeometry? headerMargin;
  final double? headerHeight;
  final Color? headerBackgroundColor;
  final AlignmentDirectional headerBoxAlignment;
  final MainAxisAlignment headerMainAxisAlignment;
  final CrossAxisAlignment headerCrossAxisAlignment;
  final String? headerTitle;
  final int? headerTitleMaxLines;
  final String? headerDescription;
  final int? headerDescriptonMaxLines;
  final double? headerDescriptionWidth;
  final TextAlign headerTextsAlignment;
  final double headerSpacing;
  final void Function(String)? onSearch;
  final String? searchLabel;
  final double? searchFieldWidth;

  // Body Fields:
  final double? bodyWidth;
  final double? bodyHeight;
  final AlignmentGeometry bodyAlignment;
  final EdgeInsetsGeometry? bodyMargin;

  // final Widget? body;

  const LaamsScaffoldTabData({
    required this.path,
    this.hasScrollObsorber = true,
    this.icon,
    this.activeIcon,
    this.iconSize = 20,
    required this.label,
    this.header,
    this.headerMargin = const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
    this.headerHeight,
    this.headerBackgroundColor,
    this.headerBoxAlignment = AlignmentDirectional.center,
    this.headerMainAxisAlignment = MainAxisAlignment.center,
    this.headerCrossAxisAlignment = CrossAxisAlignment.start,
    this.headerTitle,
    this.headerTitleMaxLines = 1,
    this.headerDescription,
    this.headerDescriptonMaxLines = 2,
    this.headerDescriptionWidth = 650,
    this.headerTextsAlignment = TextAlign.start,
    this.headerSpacing = 4,
    this.onSearch,
    this.searchLabel,
    this.searchFieldWidth = 600,
    this.bodyWidth,
    this.bodyHeight,
    this.bodyAlignment = Alignment.center,
    this.bodyMargin,
    // required this.body,
  });

  bool get hasHeader {
    if (header != null) return true;
    if ((headerTitle ?? '').isNotEmpty) return true;
    if ((headerDescription ?? '').isNotEmpty) return true;
    if ((searchLabel ?? '').isNotEmpty) return true;
    if (onSearch != null) return true;
    return false;
  }
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

    const labelPad = EdgeInsetsDirectional.only(start: 6);
    final label = Padding(
      padding: noIcon ? EdgeInsets.zero : labelPad,
      child: Text(data.label),
    );

    if (noIcon) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: row,
    );
  }
}

class _LaamsScaffoldHeader extends StatelessWidget {
  final LaamsScaffoldTabData data;
  final double topSpacing;
  const _LaamsScaffoldHeader({required this.data, required this.topSpacing});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _buildState);
  }

  Widget _buildState(BuildContext context, BoxConstraints consts) {
    final isS = consts.maxWidth <= 500;
    final isM = consts.maxWidth <= 770;
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.displaySmall?.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: isS ? 22 : 35,
    );

    final titleWidget = Text(
      data.headerTitle ?? '',
      style: titleStyle,
      textAlign: data.headerTextsAlignment,
      maxLines: data.headerTitleMaxLines,
      overflow: TextOverflow.ellipsis,
    );

    final descWidget = Container(
      width: isM ? null : data.headerDescriptionWidth,
      padding: EdgeInsets.only(top: data.headerSpacing),
      child: Text(
        data.headerDescription ?? '',
        style: theme.textTheme.bodyLarge,
        textAlign: data.headerTextsAlignment,
        maxLines: data.headerDescriptonMaxLines,
        overflow: TextOverflow.ellipsis,
      ),
    );

    Widget? searchBar;
    if ((data.searchLabel ?? '').isNotEmpty || data.onSearch != null) {
      final border = OutlineInputBorder(
        borderSide: BorderSide(color: theme.scaffoldBackgroundColor, width: 1),
        borderRadius: BorderRadius.circular(100),
      );

      const prefixIcon = Padding(
        padding: EdgeInsetsDirectional.only(start: 10.0),
        child: Icon(Icons.search_outlined, size: 25),
      );

      final inputDecoration = InputDecoration(
        isDense: true,
        hintText: data.searchLabel,
        enabledBorder: border,
        border: border,
        errorBorder: border,
        focusedBorder: border,
        disabledBorder: border,
        focusedErrorBorder: border,
        focusColor: theme.scaffoldBackgroundColor,
        hoverColor: theme.scaffoldBackgroundColor,
        fillColor: theme.scaffoldBackgroundColor,
        prefixIcon: prefixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 25),
        constraints: BoxConstraints(maxHeight: isS ? 48 : 56, minHeight: 48),
      );

      final textField = TextField(
        expands: true,
        maxLines: null,
        onChanged: data.onSearch,
        decoration: inputDecoration,
        textInputAction: TextInputAction.search,
      );

      final boxDecoration = BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [BoxShadow(color: theme.shadowColor, blurRadius: 5)],
      );

      searchBar = Center(
        child: Container(
          width: data.searchFieldWidth,
          margin: EdgeInsets.only(top: data.headerSpacing * 2),
          alignment: Alignment.center,
          decoration: boxDecoration,
          child: textField,
        ),
      );
    }

    Widget header = Column(
      mainAxisAlignment: data.headerMainAxisAlignment,
      crossAxisAlignment: data.headerCrossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        titleWidget,
        if ((data.headerDescription ?? '').isNotEmpty) descWidget,
        if (searchBar != null) searchBar,
      ],
    );

    header = SizedBox(
      width: data.bodyWidth,
      height: data.headerHeight,
      child: header,
    );

    header = Align(
      alignment: data.headerBoxAlignment,
      child: header,
    );

    if (data.headerMargin != null) {
      header = Padding(
        padding: data.headerMargin!,
        child: header,
      );
    }

    header = Padding(
      padding: EdgeInsets.only(top: topSpacing),
      child: header,
    );

    if (data.headerBackgroundColor != null) {
      final decoration = BoxDecoration(color: data.headerBackgroundColor);
      header = DecoratedBox(decoration: decoration, child: header);
    }

    return header;
  }
}
