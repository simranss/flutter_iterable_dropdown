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

  /// Whether you want to display the [clearAllIcon]
  final bool showClearAllIcon;

  /// Icon for clearing all selections
  final Widget clearAllIcon;

  /// iconSize for [clearAllIcon]
  final double? clearAllIconSize;

  /// color for [clearAllIcon]
  final Color? clearAllIconColor;

  /// Default constructor for the [FieldConfig].
  /// Used for dropdown field customisations
  ///
  /// [hint] --> The text that is shown when no item is selected
  ///
  /// [padding] --> padding for the dropdown field
  ///
  /// [showClearAllIcon] --> Whether you want to display the [clearAllIcon]
  ///
  /// [clearAllIcon] --> Icon for clearing all selections
  ///
  /// [clearAllIconSize] --> iconSize for [clearAllIcon]
  ///
  /// [clearAllIconColor] --> color for [clearAllIcon]
  const FieldConfig({
    this.hint = const Text('Select an option'),
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    this.showClearAllIcon = true,
    this.clearAllIcon = const Icon(Icons.close_rounded),
    this.clearAllIconSize = 24,
    this.clearAllIconColor,
  });
}
