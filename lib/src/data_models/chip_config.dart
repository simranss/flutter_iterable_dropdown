import 'package:flutter/material.dart'
    show
        Widget,
        Color,
        Icon,
        Icons,
        TextStyle,
        EdgeInsetsGeometry,
        BoxBorder,
        BorderRadiusGeometry;

class ChipConfig {
  final Color? backgroundColor;

  final bool showDeleteButton;
  final Widget deleteIcon;

  final Color? deleteIconColor;

  final TextStyle? labelStyle;

  final EdgeInsetsGeometry? padding;

  final BoxBorder? border;

  final BorderRadiusGeometry? borderRadius;

  const ChipConfig({
    this.backgroundColor,
    this.showDeleteButton = true,
    this.deleteIcon = const Icon(Icons.close_rounded),
    this.deleteIconColor,
    this.labelStyle,
    this.padding,
    this.border,
    this.borderRadius,
  });
}
