import 'package:flutter/material.dart';

class LaamsTabbedScaffold extends StatefulWidget {
  final double titleBarHeight;
  final bool isAppBarPrimary;
  final bool isAppBarPinned;
  final bool isAppBarFloating;
  final void Function(BuildContext context)? onLeading;
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final double leadingIconSize;
  final double? leadingWidth;
  final Widget? leading;
  final String? titleText;
  final Widget? title;
  final bool centerTitle;
  final double titleSpacing;
  final List<Widget> actions;
  final List<LaamsScaffoldTabData> tabs;
  final bool areTabsScrollable;
  final bool hideSingleTab;
  final TabAlignment tabsAlignment;
  final int currentTab;

  const LaamsTabbedScaffold({
    super.key,
    this.titleBarHeight = 50,
    this.isAppBarPrimary = false,
    this.isAppBarPinned = false,
    this.isAppBarFloating = false,
    this.leadingIcon,
    this.leadingIconColor,
    this.leadingIconSize = 25,
    this.onLeading,
    this.leadingWidth,
    this.leading,
    this.titleText,
    this.title,
    this.centerTitle = false,
    this.titleSpacing = 12,
    this.actions = const <Widget>[],
    required this.tabs,
    this.areTabsScrollable = true,
    this.tabsAlignment = TabAlignment.start,
    this.hideSingleTab = true,
    this.currentTab = 0,
  });

  @override
  State<LaamsTabbedScaffold> createState() => _LaamsTabbedScaffoldState();
}

class _LaamsTabbedScaffoldState extends State<LaamsTabbedScaffold>
    with SingleTickerProviderStateMixin {
  int _currentTab = 0;
  late ScrollController _scrollController;
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.currentTab;
    _scrollController = ScrollController();
    _pageController = PageController(initialPage: _currentTab);
    _tabController = TabController(
      initialIndex: _currentTab,
      length: widget.tabs.length,
      vsync: this,
    );

    _tabController.addListener(() {
      _pageController.animateToPage(
        _tabController.index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    _pageController.dispose();
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

  double get _appBarHeight {
    final extra = widget.tabs[_currentTab].headerHeight ?? 0;
    if (!_hasTitleBar) return widget.titleBarHeight + extra;
    return widget.titleBarHeight + extra + 49;
  }

  bool _listenToScroll(ScrollUpdateNotification note) {
    if (note.metrics.axis == Axis.horizontal) return false;
    final outerOffset = _scrollController.offset;
    final innerOffset = note.metrics.pixels;

    if (outerOffset != innerOffset && innerOffset <= _appBarHeight) {
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
    Widget page = PageView.builder(
      controller: _pageController,
      itemCount: widget.tabs.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) => widget.tabs[i].child,
    );

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

    final physics = switch (tab.listenToInnerScroll) {
      true => const NeverScrollableScrollPhysics(),
      false => const BouncingScrollPhysics(),
    };

    Widget scrollView = NestedScrollView(
      controller: _scrollController,
      floatHeaderSlivers: widget.isAppBarFloating,
      physics: physics,
      headerSliverBuilder: _builHeaders,
      body: page,
    );

    if (tab.listenToInnerScroll) {
      scrollView = NotificationListener<ScrollUpdateNotification>(
        onNotification: _listenToScroll,
        child: scrollView,
      );
    }

    return scrollView;
  }

  List<Widget> _builHeaders(BuildContext context, bool innerBoxIsScrolled) {
    final theme = Theme.of(context);
    final isS = MediaQuery.of(context).size.width <= 500;
    final tab = widget.tabs[_currentTab];

    Widget? leading = widget.leading;
    if (widget.leading == null && widget.leadingIcon != null) {
      leading = Icon(
        widget.leadingIcon,
        color: widget.leadingIconColor ?? theme.textTheme.bodyLarge?.color,
        size: widget.leadingIconSize,
      );
    }

    if (widget.onLeading != null && leading != null) {
      leading = GestureDetector(
        onTap: () => widget.onLeading!(context),
        child: Padding(padding: const EdgeInsets.all(2.5), child: leading),
      );
    }

    Widget? title;
    if (widget.titleText != null) {
      final style = theme.textTheme.displayLarge?.copyWith(
        color: theme.textTheme.bodyLarge?.color,
      );
      title = Text(
        widget.titleText ?? '',
        style: style,
        textAlign: widget.centerTitle ? TextAlign.center : TextAlign.start,
      );
    }

    Widget? titleBar;
    if (_hasTitleBar) {
      final children = [
        if (leading != null) leading,
        const SizedBox(width: 8),
        if (title != null) Expanded(child: title),
        const SizedBox(width: 8),
        ...widget.actions,
      ];

      final row = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );

      titleBar = Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: widget.titleBarHeight,
        child: row,
      );
    }

    final areTabsScrollable = switch (isS) {
      true => widget.tabs.length <= 3 ? false : true,
      _ => widget.areTabsScrollable,
    };

    final tabsAlignment = switch (isS) {
      true =>
        widget.tabs.length <= 3 ? TabAlignment.fill : widget.tabsAlignment,
      _ => widget.tabsAlignment,
    };

    PreferredSizeWidget? tabBar = TabBar(
      onTap: (index) => setState(() => _currentTab = index),
      controller: _tabController,
      isScrollable: areTabsScrollable,
      tabAlignment: tabsAlignment,
      indicatorColor: theme.primaryColor,
      dividerColor: theme.cardColor,
      dividerHeight: 2,
      indicatorWeight: 3,
      labelColor: theme.primaryColor,
      unselectedLabelColor: theme.textTheme.bodyLarge?.color,
      labelStyle: theme.textTheme.bodyLarge?.copyWith(fontSize: isS ? 17 : 14),
      labelPadding: EdgeInsets.symmetric(horizontal: isS ? 10 : 15),
      overlayColor: MaterialStateProperty.all(theme.scaffoldBackgroundColor),
      tabs: widget.tabs.map(_mapTab).toList(),
    );
    if (widget.hideSingleTab && widget.tabs.length < 2) tabBar = null;

    Widget? toolBar;
    if (tabBar == null && titleBar != null) toolBar = titleBar;
    if (tabBar != null && titleBar == null) toolBar = tabBar;
    if (tabBar != null && titleBar != null) {
      toolBar = Column(children: [titleBar, tabBar]);
    }

    Widget? header;
    if (tab.hasHeader) {
      header = _LaamsScaffoldHeader(
        data: tab,
        hasTitleBar: _hasTitleBar,
      );
      header = FlexibleSpaceBar(
        background: header,
        collapseMode: CollapseMode.none,
        stretchModes: const [StretchMode.fadeTitle],
      );
    }

    Widget sliverAppBar = SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: tab.headerHeight,
      collapsedHeight: switch (_hasTitleBar) {
        true => widget.titleBarHeight + (tabBar?.preferredSize.height ?? 0),
        false => tabBar?.preferredSize.height ?? 0,
      },
      toolbarHeight: switch (_hasTitleBar) {
        true => widget.titleBarHeight + (tabBar?.preferredSize.height ?? 0),
        false => tabBar?.preferredSize.height ?? 0,
      },
      leadingWidth: 0,
      primary: widget.isAppBarPrimary,
      pinned: widget.isAppBarPinned,
      floating: widget.isAppBarFloating,
      snap: false,
      forceElevated: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: theme.scaffoldBackgroundColor,
      shadowColor: Colors.transparent,
      title: toolBar,
      titleSpacing: 0,
      centerTitle: true,
      flexibleSpace: header,
      elevation: 0,
      // bottom: _hasTitleBar ? tabBar : null,
      // bottom: header,
    );

    if (tab.hasScrollObsorber) {
      sliverAppBar = SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: sliverAppBar,
      );
    }

    return <Widget>[sliverAppBar];
  }

  _LaamsScaffoldTab _mapTab(LaamsScaffoldTabData data) {
    final dataIndex = widget.tabs.indexWhere((e) => e.label == data.label);
    return _LaamsScaffoldTab(
      data: data,
      tabsAlignment: widget.tabsAlignment,
      isSelected: dataIndex == _currentTab,
    );
  }
}

class LaamsScaffoldTabData {
  final bool listenToInnerScroll;
  final bool hasScrollObsorber;
  final IconData? icon;
  final IconData? activeIcon;
  final double iconSize;
  final String label;
  final PreferredSizeWidget? header;
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

  final Widget? child;

  const LaamsScaffoldTabData({
    this.listenToInnerScroll = false,
    this.hasScrollObsorber = true,
    this.icon,
    this.activeIcon,
    this.iconSize = 20,
    required this.label,
    this.header,
    this.headerHeight,
    this.headerBackgroundColor,
    this.headerBoxAlignment = AlignmentDirectional.center,
    this.headerMainAxisAlignment = MainAxisAlignment.center,
    this.headerCrossAxisAlignment = CrossAxisAlignment.center,
    this.headerTitle,
    this.headerTitleMaxLines = 1,
    this.headerDescription,
    this.headerDescriptonMaxLines = 3,
    this.headerDescriptionWidth = 650,
    this.headerTextsAlignment = TextAlign.center,
    this.headerSpacing = 8,
    this.onSearch,
    this.searchLabel,
    this.searchFieldWidth = 600,
    this.bodyWidth,
    this.bodyHeight,
    this.bodyAlignment = Alignment.center,
    this.bodyMargin,
    required this.child,
  });

  bool get hasHeader {
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
  const _LaamsScaffoldTab({
    required this.data,
    required this.isSelected,
    required this.tabsAlignment,
  });

  MainAxisAlignment get _alignment {
    if (tabsAlignment == TabAlignment.center) return MainAxisAlignment.center;
    if (tabsAlignment == TabAlignment.fill) return MainAxisAlignment.center;
    return MainAxisAlignment.start;
  }

  @override
  Widget build(BuildContext context) {
    final noIcon = data.icon == null && data.activeIcon == null;
    final isS = MediaQuery.of(context).size.width <= 500;

    final labelPad = EdgeInsetsDirectional.only(start: isS ? 4 : 5);
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
      size: isS ? data.iconSize + 2 : data.iconSize,
    );

    var row = Row(
      mainAxisAlignment: _alignment,
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
  final bool hasTitleBar;
  const _LaamsScaffoldHeader({required this.data, required this.hasTitleBar});

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
        descWidget,
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

    if (data.bodyMargin != null) {
      header = Padding(
        padding: data.bodyMargin!,
        child: header,
      );
    }

    header = Padding(
      padding: EdgeInsets.only(top: hasTitleBar ? 100 : 50),
      child: header,
    );

    if (data.headerBackgroundColor != null) {
      final decoration = BoxDecoration(color: data.headerBackgroundColor);
      header = DecoratedBox(decoration: decoration, child: header);
    }

    return header;
  }
}
