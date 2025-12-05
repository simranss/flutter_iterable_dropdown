import 'package:iterable_dropdown/iterable_dropdown.dart'
    show IterableDropdownSelectedItemBuilder;
import 'package:iterable_dropdown/src/data_models/chip_config.dart';

/// [chip] --> selected item will be displayed as the default chip
///
/// [custom] --> selected item will be displayed as a custom item provided by the user
enum ItemBuilderType { chip, custom }

/// [list] --> a horizontally scrolling list of selected options.
///
/// [wrap] --> a wrapped list. It will move on the next line if there isn't enough space left
enum WrapStyle { wrap, list }

/// Selected Item level configuration
class SelectedItemConfig {
  /// Wrap style for the selected items
  /// can be [WrapStyle.wrap] or [WrapStyle.list]
  ///
  /// [WrapStyle.list] --> a horizontally scrolling list of selected options.
  ///
  /// [WrapStyle.wrap] --> a wrapped list. It will move on the next line if there isn't enough space left
  ///
  /// The default value is [WrapStyle.list]
  final WrapStyle wrapStyle;

  /// How do you want to display the selected items
  ///
  /// [ItemBuilderType.chip] --> selected item will be displayed as the default chip. Can be configured through the [chipConfig]
  ///
  /// [ItemBuilderType.custom] --> selected item will be displayed as a custom item provided by the user using [selectedItemBuilder]
  ///
  /// The default value is [ItemBuilderType.chip]
  final ItemBuilderType selectedItemBuilderType;

  /// An item builder for the selected items.
  /// The maximum height cannot exceed 45.0 for [WrapStyle.list] when the selection mode is [SelectionMode.multi].
  final IterableDropdownSelectedItemBuilder? selectedItemBuilder;

  /// Spacing between the selected items
  /// [spacing] represents the horizontal spacing between the selected items. The default value is 8.0.
  /// [runSpacing] represents the vertical spacing between the selected items. The default value is 4.0.
  final double spacing, runSpacing;

  /// Used when the [selectedItemBuilderType] is [ItemBuilderType.chip]
  ///
  /// It provides all the configurations and customisations regarding the selected item chip
  final ChipConfig chipConfig;

  /// Default constructor for [SelectedItemConfig].
  /// Used for customising and configuring the selected items
  ///
  /// Use [wrapStyle] for customising the [WrapStyle] of the selected options.
  /// It has two options: [WrapStyle.wrap] and [WrapStyle.list].
  ///
  /// [selectedItemBuilder] is lets you customize how the selected option looks. To use this, make sure to set [selectedItemBuilderType] to [ItemBuilderType.custom]
  ///
  /// [spacing] represents the horizontal spacing between the selected items. The default value is 8.0.
  /// [runSpacing] represents the vertical spacing between the selected items. The default value is 4.0.
  ///
  /// [chipConfig] is used when the [selectedItemBuilderType] is [ItemBuilderType.chip], and is used the look and feel for the selected item chips
  const SelectedItemConfig({
    this.selectedItemBuilderType = ItemBuilderType.chip,
    this.wrapStyle = WrapStyle.list,
    this.spacing = 8,
    this.runSpacing = 4,
    this.selectedItemBuilder,
    this.chipConfig = const ChipConfig(),
  });
}
