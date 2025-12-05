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

  /// Whether to show the [clearIcon]
  final bool showClearAllIcon;

  /// Suffix icon to clear all text entered
  final Widget clearIcon;

  /// iconSize for [clearIcon]
  final double? clearIconSize;

  /// color for [clearIcon]
  final Color? clearIconColor;

  /// Default constructor for [SearchFieldConfig].
  /// Used for customising and configuring the search box when you open the dropdown
  ///
  /// [controller] --> [TextEditingController] to control the text in the field
  ///
  /// [focusNode] --> [FocusNode] to control the focus state of the field
  ///
  /// [hint] --> [Text] to display as hint text
  ///
  /// [inputDecorationTheme] --> [InputDecorationTheme] to customize the appearance of the field
  ///
  /// [showClearAllIcon] --> Whether to show the [clearIcon]
  ///
  /// [clearIcon] --> Suffix icon to clear all text entered
  ///
  /// [clearIconSize] --> iconSize for [clearIcon]
  ///
  /// [clearIconColor] --> color for [clearIcon]
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
