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

/// Chip Configuration and customisations
class ChipConfig {
  /// background color for the chip
  final Color? backgroundColor;

  /// Whether to show the [deleteIcon]
  final bool showDeleteIcon;

  /// icon for deleting the chip
  final Widget deleteIcon;

  /// color for [deleteIcon]
  final Color? deleteIconColor;

  /// [TextStyle] for the text shown in the chip
  final TextStyle? labelStyle;

  /// padding for the chip
  final EdgeInsetsGeometry? padding;

  /// border for the chip
  final BoxBorder? border;

  /// border radius for the chip
  final BorderRadiusGeometry? borderRadius;

  /// Default constructor for [ChipConfig].
  /// Used for chip customisations
  ///
  /// [backgroundColor] --> background color for the chip
  ///
  /// [showDeleteIcon] --> Whether to show the [deleteIcon]
  ///
  /// [deleteIcon] --> icon for deleting the chip
  ///
  /// [deleteIconColor] --> color for [deleteIcon]
  ///
  /// [labelStyle] --> [TextStyle] for the text shown in the chip
  ///
  /// [padding] --> padding for the chip
  ///
  /// [border] --> border for the chip
  ///
  /// [borderRadius] --> border radius for the chip
  const ChipConfig({
    this.backgroundColor,
    this.showDeleteIcon = true,
    this.deleteIcon = const Icon(Icons.close_rounded),
    this.deleteIconColor,
    this.labelStyle,
    this.padding,
    this.border,
    this.borderRadius,
  });
}
