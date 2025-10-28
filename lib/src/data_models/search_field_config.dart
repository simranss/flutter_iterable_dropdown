import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show InputDecorationTheme;

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

  const SearchFieldConfig({
    this.controller,
    this.focusNode,
    this.hint = const Text('Search options'),
    this.inputDecorationTheme,
  });
}
