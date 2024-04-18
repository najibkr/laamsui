enum CellType {
  text,
  editable,
  autocomplete,
  options,
}

extension CellTypeExt on CellType {
  bool get isText => this == CellType.text;
  bool get isEditable => this == CellType.editable;
  bool get isAutocomplete => this == CellType.autocomplete;
  bool get isOptions => this == CellType.options;
}

class LaamsCellData<Entity> {
  final int row;
  final int column;
  final bool isSelected;
  final double height;
  final double width;
  final Entity entity;

  const LaamsCellData({
    required this.row,
    required this.column,
    required this.isSelected,
    required this.height,
    required this.width,
    required this.entity,
  });
}
