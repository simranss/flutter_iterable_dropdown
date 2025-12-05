import 'package:flutter/material.dart'
    show
        InputDecorationThemeData,
        Icons,
        TextEditingController,
        FocusNode,
        Text,
        Widget,
        Color,
        Icon;

/// Search Field Configuration
class SearchFieldConfig {
  /// Search field TextEditingController
  final TextEditingController? controller;

  /// Search field FocusNode
  final FocusNode? focusNode;

  /// Hint Text for the search field
  ///
  /// Defaults to 'Search options'
  final Text hint;

  /// InputDecorationTheme for the search field
  final InputDecorationThemeData? inputDecorationTheme;

  final bool showClearAllIcon;
  final Widget clearIcon;

  final double? clearIconSize;

  final Color? clearIconColor;

  /// Default constructor
  ///
  /// [controller] --> [TextEditingController] to control the text in the field
  ///
  /// [focusNode] --> [FocusNode] to control the focus state of the field
  ///
  /// [hint] --> [Text] to display as hint text
  ///
  /// [inputDecorationTheme] --> [InputDecorationTheme] to customize the appearance of the field
  const SearchFieldConfig({
    this.controller,
    this.focusNode,
    this.hint = const Text('Search options'),
    this.inputDecorationTheme,
    this.showClearAllIcon = true,
    this.clearIcon = const Icon(Icons.close_rounded),
    this.clearIconSize,
    this.clearIconColor,
  });
}
