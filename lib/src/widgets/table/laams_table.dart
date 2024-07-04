import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:laamsui/models.dart';
import 'package:laamsui/src/animations.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import 'cells/laams_cell_data.dart';
import 'cells/laams_loading_cell.dart';
import 'laams_table_column.dart';
import 'laams_table_message.dart';
import 'laams_table_more.dart';
import 'laams_table_row.dart';
import 'laams_table_toolbar.dart';

enum TableStatusType {
  querying,
  success,
  loading,
  failure,
  emptySearch,
  empty,
}

extension LaamsTableStatusTypeExt on TableStatusType {
  bool get isQuerying => this == TableStatusType.querying;
  bool get isSuccess => this == TableStatusType.success;
  bool get isLoading => this == TableStatusType.loading;
  bool get isFailure => this == TableStatusType.failure;
  bool get isEmptySearch => this == TableStatusType.emptySearch;
  bool get isEmpty => this == TableStatusType.empty;

  bool get showTable {
    if (isSuccess) return true;
    if (isQuerying) return true;
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
    this.type = TableStatusType.success,
    this.assetName = svgNotfound03,
    this.assetPackage,
    this.title,
    this.message,
  });
}

class LaamsTable<Entity> extends StatelessWidget {
  final Key? formKey;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  // Header-Related Fields:
  final Widget? titleBar;
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

  // Table-Related Fields:
  final TableStatus status;
  final ScrollController? verticalScrollController;
  final double? tableHeight;
  final double? tableWidth;
  final double columnsHeight;
  final List<LaamsTableColumn> columns;
  final int loadingRowsCount;
  final double loadingRowsHeight;
  final List<LaamsTableRow<Entity>> rows;

  final void Function()? onCancel;
  final void Function()? onRetry;
  final void Function(String value)? onCancelSearch;
  final void Function()? onAddNew;

  final double mobileBreakPoint;
  final Widget? Function(BuildContext, int)? mobileRowBuilder;
  final bool isSliver;
  final Widget Function(BuildContext, LaamsCellData<Entity>) cellBuilder;

  final double totalsHeight;
  final int totalsCount;
  final Widget Function(BuildContext, LaamsCellData<String?>)? totalsBuilder;

  final String cancelLabel;
  final String retryLabel;
  final String? addNewLabel;
  final LaamsTableMore? moreButton;
  final double moreButtonHeight;
  final Widget? footer;

  const LaamsTable({
    super.key,
    this.formKey,
    this.height,
    this.width,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,

    // Header-Related Fields:
    this.titleBar,
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

    // Table-Related Fields:
    this.status = const TableStatus(),
    this.verticalScrollController,
    this.tableHeight,
    this.tableWidth,
    this.columnsHeight = 38,
    required this.columns,
    this.loadingRowsCount = 10,
    this.loadingRowsHeight = 40,
    this.rows = const [],
    this.onCancel,
    this.onRetry,
    this.onCancelSearch,
    this.onAddNew,
    this.mobileBreakPoint = 600.0,
    this.mobileRowBuilder,
    required this.cellBuilder,
    this.totalsHeight = 40,
    this.totalsCount = 1,
    this.totalsBuilder,
    this.isSliver = true,
    this.cancelLabel = 'Cancel',
    this.retryLabel = 'Try Again',
    this.addNewLabel = 'Add New',
    this.moreButton,
    this.moreButtonHeight = 100,
    this.footer,
  });

  bool get _hasTableBoxFields {
    if (height != null) return true;
    if (width != null) return true;
    if (margin != null) return true;
    if (padding != null) return true;
    if (backgroundColor != null) return true;
    if (borderRadius != null) return true;
    if (border != null) return true;
    if (boxShadow != null) return true;
    return false;
  }

  bool _shouldShowMobileView(double maxWidth) {
    final isMobile = maxWidth <= mobileBreakPoint;
    final hasMobileBuilder = mobileRowBuilder != null;
    final showTable = status.type.isSuccess || status.type.isQuerying;
    return isMobile && hasMobileBuilder && showTable;
  }

  int get _pinnedColumns {
    return columns.where((e) => e.isPinned).length;
  }

  double get _columnsTotalWidth {
    return columns.map((e) => e.width).fold(0.0, (a, b) => a + b);
  }

  int get _pinnedRows {
    final headerCount = columns.isEmpty ? 0 : 1;
    return headerCount + rows.where((e) => e.isPinned).length;
  }

  int get _rowsCount {
    if (status.type.isQuerying) return loadingRowsCount;
    final extraRows = switch (totalsBuilder != null) {
      true => moreButton != null ? 2 + totalsCount : 1 + totalsCount,
      false => moreButton != null ? 2 : 1,
    };
    if (moreButton != null) return rows.length + extraRows;
    return rows.length + extraRows;
  }

  double _getSurplusWidth(double maxWidth) {
    if ((tableWidth ?? maxWidth) <= _columnsTotalWidth) return 0;
    final extraWidth = (tableWidth ?? maxWidth) - _columnsTotalWidth;
    return extraWidth / columns.length;
  }

  @override
  Widget build(BuildContext context) {
    Widget layout = LayoutBuilder(builder: _buildLayout);
    if (!isSliver) return layout;
    return SliverFillViewport(delegate: SliverChildListDelegate([layout]));
  }

  Widget _buildLayout(BuildContext context, BoxConstraints consts) {
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

    Widget table = switch (_shouldShowMobileView(consts.maxWidth)) {
      true => _LaamsTableMoible(
          itemCount: rows.length,
          moreButton: moreButton,
          itemBuilder: mobileRowBuilder!,
        ),
      _ => TableView.builder(
          verticalDetails: ScrollableDetails.vertical(
            controller: verticalScrollController,
            physics: const BouncingScrollPhysics(),
          ),
          columnCount: columns.length,
          columnBuilder: (i) => _buildColumn(context, i, consts.maxWidth),
          pinnedColumnCount: _pinnedColumns,
          pinnedRowCount: _pinnedRows,
          rowCount: _rowsCount,
          rowBuilder: (i) => _buildRow(context, i),
          cellBuilder: _buildCell,
        ),
    };

    table = switch (tableHeight != null || tableWidth != null) {
      true => SizedBox(
          width: tableWidth,
          height: (tableHeight ?? 0) + columnsHeight,
          child: table,
        ),
      false => Expanded(child: table),
    };

    table = switch (status.type) {
      TableStatusType.loading => LaamsLoading.card(
          status.message,
          indicatorType: IndicatorType.ballPulseRise,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          indicatorSize: const Size(80, 50),
          width: 400,
          onButtonPressed: onCancel,
          buttonLabel: cancelLabel,
          spacing: 15,
          messageMaxLines: 3,
        ),
      TableStatusType.failure => LaamsTableMessage(
          onAccept: onRetry,
          assetName: status.assetName ?? svgNotfound03,
          assetPackage: status.assetPackage ?? 'jaguar',
          title: status.title ?? '',
          message: status.message ?? '',
          buttonLabel: retryLabel,
        ),
      TableStatusType.emptySearch => LaamsTableMessage(
          onAccept: onCancelSearch != null ? () => onCancelSearch!('') : null,
          assetName: status.assetName ?? svgNotfound03,
          assetPackage: status.assetPackage ?? 'jaguar',
          title: status.title ?? '',
          message: status.message ?? '',
          buttonLabel: retryLabel,
        ),
      TableStatusType.empty => LaamsTableMessage(
          onAccept: onAddNew,
          assetName: status.assetName ?? svgNotfound03,
          assetPackage: status.assetPackage ?? 'jaguar',
          title: status.title ?? '',
          message: status.message ?? '',
          buttonLabel: addNewLabel,
        ),
      _ => table,
    };

    final items = [
      if (titleBar != null) titleBar!,
      toolbar,
      table,
      if (footer != null) footer!,
    ];

    if (!_hasTableBoxFields) return Column(children: items);

    final decrotion = BoxDecoration(
      color: backgroundColor,
      borderRadius: borderRadius,
      border: border,
      boxShadow: boxShadow,
    );

    Widget column = Column(children: items);
    if (formKey != null) column = Form(key: formKey, child: column);
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: decrotion,
      child: column,
    );
  }

  TableSpan _buildColumn(BuildContext ctxt, int index, double maxWidth) {
    final surplus = _getSurplusWidth(maxWidth);
    final width = columns[index].width + surplus;
    final color = columns[index].backgroundColor;
    return TableSpan(
      extent: FixedTableSpanExtent(width),
      backgroundDecoration: TableSpanDecoration(color: color),
      padding: null,
      foregroundDecoration: null,
    );
  }

  TableSpan _buildRow(BuildContext context, int index) {
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

    if (index == rows.length + 1 && totalsBuilder != null) {
      return TableSpan(
        backgroundDecoration: null,
        extent: FixedTableSpanExtent(totalsHeight),
      );
    }

    if (index == rows.length + 1 && totalsBuilder == null) {
      return TableSpan(
        backgroundDecoration: null,
        extent: FixedTableSpanExtent(moreButtonHeight),
      );
    }

    if (index == rows.length + 2) {
      return TableSpan(
        backgroundDecoration: null,
        extent: FixedTableSpanExtent(moreButtonHeight),
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
        LongPressGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
          () => LongPressGestureRecognizer(),
          (LongPressGestureRecognizer t) => t.onLongPress = row.onLongPress,
        ),
      },
    );
  }

  TableViewCell _buildCell(BuildContext context, TableVicinity v) {
    if (v.row == 0) return TableViewCell(child: columns[v.column]);

    if (status.type.isQuerying) {
      return const TableViewCell(child: LaamsLoadingCell());
    }

    if (v.row == rows.length + 1 && totalsBuilder != null) {
      final data = LaamsCellData<String?>(
        row: rows.length + 1,
        column: v.column,
        height: 40,
        width: columns[v.column].width,
        isSelected: false,
        entity: null,
      );
      return TableViewCell(child: totalsBuilder!(context, data));
    }

    if (v.row == rows.length + 1 && totalsBuilder == null) {
      return TableViewCell(
        columnMergeStart: 0,
        columnMergeSpan: columns.length,
        child: moreButton!,
      );
    }

    if (v.row == rows.length + 2) {
      return TableViewCell(
        columnMergeStart: 0,
        columnMergeSpan: columns.length,
        child: moreButton!,
      );
    }

    final data = LaamsCellData<Entity>(
      row: v.row - 1,
      column: v.column,
      height: rows[v.row - 1].height,
      width: columns[v.column].width,
      isSelected: rows[v.row - 1].isSelected,
      entity: rows[v.row - 1].entity,
    );

    return TableViewCell(child: cellBuilder(context, data));
  }
}

class _LaamsTableMoible extends StatelessWidget {
  final int itemCount;
  final LaamsTableMore? moreButton;
  final Widget? Function(BuildContext, int)? itemBuilder;

  const _LaamsTableMoible({
    required this.itemCount,
    required this.moreButton,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 350),
      physics: const BouncingScrollPhysics(),
      itemCount: moreButton == null ? itemCount : itemCount + 1,
      itemBuilder: buildItems,
    );
  }

  Widget? buildItems(BuildContext context, int index) {
    if (moreButton != null && index == itemCount) return moreButton;
    if (itemBuilder != null) return itemBuilder!(context, index);
    return null;
  }
}
