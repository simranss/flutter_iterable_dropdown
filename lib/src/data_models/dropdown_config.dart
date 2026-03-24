import 'package:flutter/widgets.dart'
    show BorderRadiusGeometry, Color, BoxBorder, Gradient, BoxShadow;

/// Dropdown overlay customisations
class DropdownConfig {
  /// border radius for your dropdown
  final BorderRadiusGeometry? borderRadius;

  /// border for your dropdown
  final BoxBorder? border;

  /// background color for your dropdown
  final Color? backgroundColor;

  /// background gradient for your dropdown
  final Gradient? backgroundGradient;

  /// The maximum height for your dropdown
  /// This defaults to 350.0
  final double maxHeight;

  /// shadow effects for your dropdown
  final List<BoxShadow>? boxShadow;

  /// Default constructor for [DropdownConfig].
  /// Used for dropdown overlay customisations
  ///
  /// [borderRadius] --> border radius for your dropdown
  ///
  /// [border] --> border for your dropdown
  ///
  /// [backgroundColor] --> background color for your dropdown
  ///
  /// [backgroundGradient] --> background gradient for your dropdown
  ///
  /// [boxShadow] --> shadow effects for your dropdown
  ///
  /// [maxHeight] --> The maximum height for your dropdown
  const DropdownConfig({
    this.borderRadius,
    this.border,
    this.backgroundColor,
    this.backgroundGradient,
    this.boxShadow,
    this.maxHeight = 350,
  });
}
