import 'package:flutter/material.dart' show Widget;

/// class for defining custom first and last options
/// These options are not selectable
/// These options won't get filtered using search
class CustomItems {
  /// [start] defines the first option. This option will come before all dropdown options
  /// [end] defines the last option. This option will come after all dropdown options
  final Widget? start, end;

  /// default constructor
  const CustomItems({this.start, this.end});
}
