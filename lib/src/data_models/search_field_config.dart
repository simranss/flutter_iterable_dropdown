import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show InputDecorationTheme;

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
  final InputDecorationTheme? inputDecorationTheme;

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
  });
}
