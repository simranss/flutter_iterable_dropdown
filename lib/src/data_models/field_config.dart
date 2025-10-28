import 'package:flutter/material.dart' show Text;
import 'package:iterable_dropdown/src/iterable_dropdown.dart'
    show IterableDropdownSelectedItemBuilder;
import 'package:iterable_dropdown/src/iterable_dropdown_controller.dart'
    show SelectionMode;

enum WrapStyle { wrap, list }

class FieldConfig {
  /// Wrap style for the selected items
  /// can be [WrapStyle.wrap] or [WrapStyle.list]
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

  const FieldConfig({
    this.selectedItemBuilder,
    this.hint = const Text('Select an option'),
    this.wrapStyle = WrapStyle.wrap,
    this.spacing = 8,
    this.runSpacing = 4,
  });
}
