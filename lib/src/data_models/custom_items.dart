import 'package:flutter/material.dart' show Widget;

/// Class for defining custom first and last options
///
/// These options are not selectable
///
/// These options won't get filtered using search
///
/// Consider them pinned rows that can be used as headers or actions
class CustomItems {
  /// [start] defines the first option. This option will come before all dropdown options
  /// [end] defines the last option. This option will come after all dropdown options
  final Widget? start, end;

  /// Default constructor for [CustomItems]
  ///
  /// [start] --> [Widget] to be displayed as the first option
  ///
  /// [end] --> [Widget] to be displayed as the last option
  const CustomItems({this.start, this.end});
}
