import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show Text, EdgeInsets, EdgeInsetsGeometry, Widget, Icons;
import 'package:iterable_dropdown/src/iterable_dropdown.dart'
    show IterableDropdownSelectedItemBuilder;
import 'package:iterable_dropdown/src/iterable_dropdown_controller.dart'
    show SelectionMode;

/// [list] --> a horizontally scrolling list of selected options.
///
/// [wrap] --> a wrapped list. It will move on the next line if there isn't enough space left
enum WrapStyle { wrap, list }

/// Selected field level customisation
class FieldConfig {
  /// Wrap style for the selected items
  /// can be [WrapStyle.wrap] or [WrapStyle.list]
  ///
  /// [WrapStyle.list] --> a horizontally scrolling list of selected options.
  ///
  /// [WrapStyle.wrap] --> a wrapped list. It will move on the next line if there isn't enough space left
  final WrapStyle wrapStyle;

  /// An item builder for the selected items.
  /// The maximum height cannot exceed 45.0 for [WrapStyle.list] when the selection mode is [SelectionMode.multi].
  final IterableDropdownSelectedItemBuilder? selectedItemBuilder;

  /// The text that is shown when no item is selected
  /// The default text will be "Select an option"
  final Text hint;

  /// Spacing between the selected items
  /// [spacing] represents the horizontal spacing between the selected items. The default value is 8.0.
  /// [runSpacing] represents the vertical spacing between the selected items. The default value is 4.0.
  final double spacing, runSpacing;

  /// Padding and margin for the dropdown
  final EdgeInsetsGeometry? padding, margin;

  final Widget clearAllIcon;

  /// Default constructor
  ///
  /// Use [wrapStyle] for customising the [WrapStyle] of the selected options.
  /// It has two options: [WrapStyle.wrap] and [WrapStyle.list].
  ///
  /// [selectedItemBuilder] is lets you customize how the selected option looks.
  ///
  /// [hint] is the text that is shown when no item is selected
  ///
  /// [spacing] represents the horizontal spacing between the selected items. The default value is 8.0.
  /// [runSpacing] represents the vertical spacing between the selected items. The default value is 4.0.
  const FieldConfig({
    this.selectedItemBuilder,
    this.hint = const Text('Select an option'),
    this.wrapStyle = WrapStyle.wrap,
    this.spacing = 8,
    this.runSpacing = 4,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    this.margin,
    this.clearAllIcon = const Icon(Icons.close_rounded),
  });
}
