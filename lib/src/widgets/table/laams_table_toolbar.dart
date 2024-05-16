import 'package:flutter/material.dart';
import 'package:laamsui/src/laams_icons.dart';

import 'laams_table_button.dart';

class LaamsTableToolbar extends StatefulWidget {
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  // Selection-Related Fields:
  final void Function()? onSelectAll;
  final bool areAllSelected;
  final bool showSelectAll;
  final bool showSelectedItemsActions;
  final String? selectAllTooltip;
  final List<Widget> selectedItemsActions;

  // Actions-Related Fields
  final void Function(String tag)? onSearch;
  final String? searchHint;
  final List<Widget> actions;

  const LaamsTableToolbar({
    super.key,
    // Box-Related Fields
    required this.height,
    required this.width,
    required this.margin,
    required this.padding,
    required this.backgroundColor,
    required this.borderRadius,
    required this.border,
    required this.boxShadow,

    // Select-Related Fields:
    required this.onSelectAll,
    required this.selectAllTooltip,
    required this.areAllSelected,
    required this.showSelectAll,
    required this.showSelectedItemsActions,
    required this.selectedItemsActions,

    // Actions-Related Fields:
    required this.onSearch,
    required this.searchHint,
    required this.actions,
  });

  @override
  State<LaamsTableToolbar> createState() => _LaamsTableToolbarState();
}

class _LaamsTableToolbarState extends State<LaamsTableToolbar> {
  late TextEditingController _searchController;
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _cancelSearch() {
    if (_searchController.text.isNotEmpty) {
      _searchController.clear();
      setState(() => _showSearchBar = false);
      if (widget.onSearch != null) widget.onSearch!('');
      return;
    }
    setState(() => _showSearchBar = false);
    // if (widget.status.isSearched) {
    //   if (widget.onSearch != null) widget.onSearch!('');
    // }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget? checkbox;
    if (widget.showSelectAll) {
      checkbox = _Checkbox(
        onSelected: widget.onSelectAll,
        areAllSelected: widget.areAllSelected,
        tooltip: widget.selectAllTooltip,
      );
    }

    Widget? searchBtn;
    if (!_showSearchBar && widget.onSearch != null) {
      searchBtn = LaamsTableButton(
        onPressed: () => setState(() => _showSearchBar = true),
        icon: LaamsIcons.search,
        tooltip: widget.searchHint,
      );
    }

    Widget? searchBar;
    if (_showSearchBar) {
      final isS = MediaQuery.of(context).size.width <= 500;
      final border = OutlineInputBorder(
        borderSide: BorderSide(color: theme.scaffoldBackgroundColor, width: 1),
        borderRadius: BorderRadius.circular(100),
      );

      const prefixIcon = Padding(
        padding: EdgeInsetsDirectional.only(start: 10.0),
        child: Icon(Icons.search_outlined, size: 25),
      );

      final cancelBtn = Padding(
        padding: const EdgeInsetsDirectional.only(end: 8.0),
        child: GestureDetector(
          onTap: _cancelSearch,
          child: const Icon(Icons.close, size: 20, color: Colors.red),
        ),
      );

      final inputDecoration = InputDecoration(
        isDense: true,
        hintText: widget.searchHint ?? 'Search...',
        enabledBorder: border,
        border: border,
        errorBorder: border,
        focusedBorder: border,
        suffixIcon: cancelBtn,
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
        controller: _searchController,
        autofocus: true,
        expands: true,
        maxLines: null,
        onChanged: widget.onSearch,
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
          width: 600,
          margin: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: boxDecoration,
          child: textField,
        ),
      );
    }

    final content = <Widget>[
      if (checkbox != null && !_showSearchBar) checkbox,
      if (widget.showSelectedItemsActions && !_showSearchBar)
        ...widget.selectedItemsActions,
      if (!_showSearchBar) const Spacer(),
      if (searchBar != null) Expanded(child: searchBar),
      if (searchBtn != null) searchBtn,
      if (!_showSearchBar) ...widget.actions,
    ];

    final boxDecoration = BoxDecoration(
      color: widget.backgroundColor,
      boxShadow: widget.boxShadow,
      border: widget.border,
      borderRadius: widget.borderRadius,
    );

    return Container(
      height: widget.height,
      width: widget.width,
      margin: widget.margin,
      padding: widget.padding,
      decoration: boxDecoration,
      child: Row(children: content),
    );
  }
}

class _Checkbox extends StatelessWidget {
  final void Function()? onSelected;
  final bool areAllSelected;
  final String? tooltip;
  const _Checkbox({
    required this.onSelected,
    required this.areAllSelected,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hColor = theme.primaryColor.withOpacity(0.2);
    Widget checkbox = Checkbox(
      onChanged: onSelected == null ? null : (_) => onSelected!(),
      value: areAllSelected,
      activeColor: theme.scaffoldBackgroundColor,
      checkColor: Colors.white,
      hoverColor: hColor,
      side: BorderSide(width: 2, color: theme.primaryColor),
      fillColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.hovered)) {
            return hColor;
          } else if (states.contains(WidgetState.selected)) {
            return theme.primaryColor;
          } else if (states.contains(WidgetState.disabled)) {
            return theme.cardColor;
          }
          return Colors.transparent;
        },
      ),
    );

    if (tooltip != null) {
      final style = theme.textTheme.bodyMedium?.copyWith(
        color: theme.primaryColor,
        fontWeight: FontWeight.w400,
      );
      final boxDecoration = BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      );

      checkbox = Tooltip(
        message: tooltip,
        textAlign: TextAlign.center,
        decoration: boxDecoration,
        textStyle: style,
        child: checkbox,
      );
    }

    return checkbox;
  }
}
