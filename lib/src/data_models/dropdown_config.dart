import 'package:flutter/widgets.dart'
    show BorderRadiusGeometry, Color, BoxBorder, Gradient, BoxShadow;

class DropdownConfig {
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;

  final Color? backgroundColor;
  final Gradient? backgroundGradient;

  /// The maximum height for your dropdown
  /// This defaults to 350.0
  final double maxHeight;

  final List<BoxShadow>? boxShadow;

  const DropdownConfig({
    this.borderRadius,
    this.border,
    this.backgroundColor,
    this.backgroundGradient,
    this.maxHeight = 350,
    this.boxShadow,
  });
}
