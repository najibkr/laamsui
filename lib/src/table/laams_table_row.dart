class LaamsTableRow<Entity> {
  final void Function()? onTap;
  final void Function()? onLongPress;
  final double height;
  final bool isPinned;
  final bool isSelected;
  final Entity entity;

  const LaamsTableRow({
    this.onTap,
    this.onLongPress,
    this.height = 40,
    this.isPinned = false,
    this.isSelected = false,
    required this.entity,
  });
}
