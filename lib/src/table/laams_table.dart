import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:laamsui/models.dart';
import 'package:laamsui/src/animations.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import 'laams_table_cell.dart';
import 'laams_table_column.dart';
import 'laams_table_message.dart';
import 'laams_table_more.dart';
import 'laams_table_row.dart';
import 'laams_table_toolbar.dart';
import 'loading_cell.dart';

enum TableStatusType {
  idle,
  querying,
  loading,
  // fetchingMore,
  // searched,
  failure,
  emptySearch,
  empty,
}

extension LaamsTableStatusTypeExt on TableStatusType {
  bool get isIdle => this == TableStatusType.idle;
  bool get isQuerying => this == TableStatusType.querying;
  bool get isLoading => this == TableStatusType.loading;
  // bool get isFetchingMore => this == TableStatusType.fetchingMore;
  bool get isFailure => this == TableStatusType.failure;
  bool get isEmptySearch => this == TableStatusType.emptySearch;
  bool get isEmpty => this == TableStatusType.empty;

  bool get showTable {
    if (isIdle) return true;
    if (isQuerying) return true;
    // if (isFetchingMore) return true;
    return false;
  }
}

class TableStatus {
  final TableStatusType type;
  final String? assetName;
  final String? assetPackage;
  final String? title;
  final String? message;

  const TableStatus.querying({
    this.type = TableStatusType.querying,
    this.assetName,
    this.assetPackage,
    this.title,
    this.message,
  });

  const TableStatus.loading({
    this.type = TableStatusType.loading,
    this.assetName,
    this.assetPackage,
    this.title,
    required this.message,
  });

  const TableStatus.message({
    required this.type,
    this.assetName = svgNotfound03,
    this.assetPackage,
    required this.title,
    required this.message,
  });

  const TableStatus({
    this.type = TableStatusType.idle,
    this.assetName = svgNotfound03,
    this.assetPackage,
    this.title,
    this.message,
  });
}

class LaamsTable<Entity> extends StatelessWidget {
  final ScrollController? verticalScrollController;
  final TableStatus status;
  final void Function()? onCancel;
  final void Function()? onRetry;
  final void Function()? onFetchMore;
  final void Function(String value)? onCancelSearch;
  final void Function()? onAddNew;

  // Toolbar-Related Fields:
  final double? toolbarHeight;
  final double? toolbarWidth;
  final EdgeInsetsGeometry? toolbarMargin;
  final EdgeInsetsGeometry toolbarPadding;
  final Color? toolbarBackgroundColor;
  final BorderRadiusGeometry? toolbarBorderRadius;
  final BoxBorder? toolbarBorder;
  final List<BoxShadow>? toolbarBoxShadow;
  final void Function()? onSelectAll;
  final bool showSelectAll;
  final String? selectAllTooltip;
  final bool areAllSelected;
  final bool showSelectedItemsActions;
  final List<Widget> selectedItemsActions;
  final void Function(String searchTag)? onSearch;
  final String? searchHint;
  final List<Widget> toolBarActions;

  final Widget? titleBar;
  final List<LaamsTableColumn> columns;
  final double columnsHeight;
  final int rowsCount;
  final int loadingRowsCount;
  final double loadingRowsHeight;
  final int pinnedRows;
  final List<LaamsTableRow<Entity>> rows;
  final double mobileBreakPoint;
  final Widget? Function(BuildContext, int) mobileRowsBuilder;
  final bool isSliver;
  final Widget Function(BuildContext context, LaamsTableCellData<Entity> data)
      buildCell;

  final String cancelLabel;
  final String retryLabel;
  final String addNewLabel;
  final String loadMoreLabel;
  final bool areAllLoaded;
  final String allLoadedMessage;
  final bool isFetchingMore;
  final bool hasMoreButton;
  final Widget? footer;

  const LaamsTable({
    super.key,
    this.verticalScrollController,
    required this.status,
    this.onFetchMore,
    this.onCancel,
    this.onRetry,
    this.onCancelSearch,
    this.onAddNew,

    // Toolbar-Related Fields:
    this.toolbarHeight,
    this.toolbarWidth,
    this.toolbarMargin,
    this.toolbarPadding =
        const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
    this.toolbarBackgroundColor,
    this.toolbarBorderRadius,
    this.toolbarBorder,
    this.toolbarBoxShadow,
    this.onSelectAll,
    this.showSelectAll = false,
    this.selectAllTooltip,
    this.areAllSelected = false,
    this.showSelectedItemsActions = false,
    this.selectedItemsActions = const [],
    this.onSearch,
    this.searchHint,
    this.toolBarActions = const [],
    this.titleBar,
    this.columns = const [],
    this.columnsHeight = 38,
    this.rowsCount = 0,
    this.loadingRowsCount = 11,
    this.loadingRowsHeight = 40,
    this.pinnedRows = 0,
    this.rows = const [],
    this.mobileBreakPoint = 600.0,
    required this.mobileRowsBuilder,
    required this.buildCell,
    this.isSliver = true,
    this.cancelLabel = 'Cancel',
    this.retryLabel = 'Try Again',
    this.addNewLabel = 'Add New',
    this.loadMoreLabel = 'Load More',
    this.areAllLoaded = false,
    this.allLoadedMessage = 'All Data Loaded',
    this.isFetchingMore = false,
    this.hasMoreButton = true,
    this.footer,
  });

  int get _pinnedColumns {
    return columns.where((e) => e.isPinned).length;
  }

  double get _columnsWidth {
    return columns.map((e) => e.width).fold(0.0, (a, b) => a + b);
  }

  int get _pinnedRows {
    final headerCount = columns.isEmpty ? 0 : 1;
    return headerCount + pinnedRows;
  }

  int get _rowsCount {
    if (status.type.isQuerying) return loadingRowsCount;
    if (hasMoreButton) return rowsCount + 2;
    return rowsCount + 1;
  }

  double getSurplusWidth(double maxWidth) {
    if (maxWidth <= _columnsWidth) return 0;
    final extraWidth = maxWidth - _columnsWidth;
    return extraWidth / columns.length;
  }

  @override
  Widget build(BuildContext context) {
    Widget layout = LayoutBuilder(builder: _buildLayout);
    if (!isSliver) return layout;
    return SliverFillViewport(delegate: SliverChildListDelegate([layout]));
  }

  Widget _buildLayout(BuildContext context, BoxConstraints consts) {
    final widthSurplus = getSurplusWidth(consts.maxWidth);

    final toolbar = LaamsTableToolbar(
      height: toolbarHeight,
      width: toolbarWidth,
      margin: toolbarMargin,
      padding: toolbarPadding,
      backgroundColor: toolbarBackgroundColor,
      borderRadius: toolbarBorderRadius,
      border: toolbarBorder,
      boxShadow: toolbarBoxShadow,
      onSelectAll: onSelectAll,
      showSelectAll: showSelectAll,
      selectAllTooltip: selectAllTooltip,
      areAllSelected: areAllSelected,
      selectedItemsActions: selectedItemsActions,
      showSelectedItemsActions: showSelectedItemsActions,
      onSearch: onSearch,
      searchHint: searchHint,
      actions: toolBarActions,
    );

    Widget? table;
    if (status.type.isLoading) {
      table = LaamsLoading(
        indicatorType: IndicatorType.ballPulseRise,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        message: status.message,
        indicatorSize: const Size(80, 50),
        width: 400,
        onButtonPressed: onCancel,
        buttonLabel: cancelLabel,
        spacing: 15,
        messageMaxLines: 3,
      );
    }

    if (status.type.isFailure) {
      table = LaamsTableMessage(
        onButtonPressed: onRetry,
        assetName: status.assetName ?? svgNotfound03,
        assetPackage: status.assetPackage ?? 'jaguar',
        title: status.title ?? '',
        message: status.message ?? '',
        buttonLabel: retryLabel,
      );
    }

    if (status.type.isEmptySearch) {
      table = LaamsTableMessage(
        onButtonPressed:
            onCancelSearch != null ? () => onCancelSearch!('') : null,
        assetName: status.assetName ?? svgNotfound03,
        assetPackage: status.assetPackage ?? 'jaguar',
        title: status.title ?? '',
        message: status.message ?? '',
        buttonLabel: retryLabel,
      );
    }

    if (status.type.isEmpty) {
      table = LaamsTableMessage(
        onButtonPressed: onAddNew,
        assetName: status.assetName ?? svgNotfound03,
        assetPackage: status.assetPackage ?? 'jaguar',
        title: status.title ?? '',
        message: status.message ?? '',
        buttonLabel: addNewLabel,
      );
    }

    final isMobile = consts.maxWidth <= mobileBreakPoint;
    if (status.type.showTable && isMobile) {
      table = ListView.builder(
        padding: const EdgeInsets.only(bottom: 350),
        physics: const BouncingScrollPhysics(),
        itemCount: rowsCount,
        itemBuilder: mobileRowsBuilder,
      );
    }

    if (status.type.showTable && !isMobile) {
      TableSpan columnBuilder(int index) {
        final width = columns[index].width + widthSurplus;
        final color = columns[index].backgroundColor;
        return TableSpan(
          extent: FixedTableSpanExtent(width),
          backgroundDecoration: TableSpanDecoration(color: color),
          padding: null,
          foregroundDecoration: null,
        );
      }

      TableSpan rowBuilder(int index) {
        final theme = Theme.of(context);
        var side = BorderSide(color: theme.shadowColor, width: 0.5);
        final border = switch (index) {
          0 => TableSpanBorder(leading: side, trailing: side),
          _ => TableSpanBorder(trailing: side),
        };

        if (index == 0) {
          final decoration = TableSpanDecoration(
            color: theme.scaffoldBackgroundColor,
            border: border,
          );
          return TableSpan(
            backgroundDecoration: decoration,
            extent: FixedTableSpanExtent(columnsHeight),
          );
        }

        if (status.type.isQuerying) {
          final decoration = TableSpanDecoration(
            color: theme.scaffoldBackgroundColor,
            border: border,
          );
          return TableSpan(
            backgroundDecoration: decoration,
            extent: FixedTableSpanExtent(loadingRowsHeight),
          );
        }

        if (index == rows.length + 1) {
          return const TableSpan(
            backgroundDecoration: null,
            extent: FixedTableSpanExtent(100),
          );
        }

        final bgColor = switch (rows[index - 1].isSelected) {
          true => theme.cardColor,
          false => theme.scaffoldBackgroundColor,
        };

        final decoration = TableSpanDecoration(
          color: bgColor,
          border: border,
        );

        final row = rows[index - 1];
        return TableSpan(
          backgroundDecoration: decoration,
          extent: FixedTableSpanExtent(rows[index - 1].height),
          recognizerFactories: <Type, GestureRecognizerFactory>{
            TapGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
              () => TapGestureRecognizer(),
              (TapGestureRecognizer t) => t.onTap = row.onTap,
            ),
            LongPressGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                LongPressGestureRecognizer>(
              () => LongPressGestureRecognizer(),
              (LongPressGestureRecognizer t) => t.onLongPress = row.onLongPress,
            ),
          },
        );
      }

      table = TableView.builder(
        verticalDetails: ScrollableDetails.vertical(
          controller: verticalScrollController,
          physics: const BouncingScrollPhysics(),
        ),
        columnCount: columns.length,
        columnBuilder: columnBuilder,
        pinnedColumnCount: _pinnedColumns,
        pinnedRowCount: _pinnedRows,
        rowCount: _rowsCount,
        rowBuilder: rowBuilder,
        cellBuilder: _buildCell,
      );
    }

    final items = [
      if (titleBar != null) titleBar!,
      toolbar,
      Expanded(child: table ?? const SizedBox()),
      if (footer != null) footer!,
    ];

    return Column(children: items);
  }

  TableViewCell _buildCell(BuildContext context, TableVicinity v) {
    if (v.row == 0) return TableViewCell(child: columns[v.column]);

    if (status.type.isQuerying) {
      return const TableViewCell(child: LoadingCell());
    }

    if (v.row == rows.length + 1 && hasMoreButton) {
      final laamsTableMore = LaamsTableMore(
        onFetchMore: onFetchMore,
        loadMoreLabel: loadMoreLabel,
        allLoadedMessage: allLoadedMessage,
        isFetchingMore: isFetchingMore,
        areAllLoaded: areAllLoaded,
      );

      return TableViewCell(
        columnMergeStart: 0,
        columnMergeSpan: columns.length,
        child: laamsTableMore,
      );
    }

    final data = LaamsTableCellData<Entity>(
      row: v.row - 1,
      column: v.column,
      height: rows[v.row - 1].height,
      width: columns[v.column].width,
      isSelected: rows[v.row - 1].isSelected,
      entity: rows[v.row - 1].entity,
    );

    return TableViewCell(child: buildCell(context, data));
  }
}
