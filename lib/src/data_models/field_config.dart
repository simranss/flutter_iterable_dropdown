import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show Text, EdgeInsets, EdgeInsetsGeometry, Widget, Icons;

/// Selected field level customisation
class FieldConfig {
  /// The text that is shown when no item is selected
  /// The default text will be "Select an option"
  final Text hint;

  /// padding for the dropdown field
  final EdgeInsetsGeometry? padding;

  final bool showClearAllIcon;

  /// Icon for clearing all selections
  final Widget clearAllIcon;

  /// iconSize for [clearAllIcon]
  final double? clearAllIconSize;

  final Color? clearAllIconColor;

  /// Default constructor
  ///
  /// [hint] is the text that is shown when no item is selected
  const FieldConfig({
    this.hint = const Text('Select an option'),
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    this.showClearAllIcon = true,
    this.clearAllIcon = const Icon(Icons.close_rounded),
    this.clearAllIconSize = 24,
    this.clearAllIconColor,
  });
}
