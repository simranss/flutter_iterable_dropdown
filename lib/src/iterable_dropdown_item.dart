import 'package:iterable_dropdown/iterable_dropdown.dart' show IterableDropdown;

/// The data model for each dropdown option
///
/// The [IterableDropdown] takes an [Iterable] of this data model
class IterableDropdownItem<T> {
  /// Default constructor
  ///
  /// [key] --> A unique key for the dropdown option.
  /// This is what will be used as a search string as well when you enable search.
  ///
  /// [label] --> This is what will be displayed in the dropdown option.
  ///
  /// [value] --> This is the internal value for the option.
  ///
  /// [selectedItemLabel] --> This is the what will show when the item is selected. If null, then labell will be used
  ///
  /// [secondaryLabel] --> An optional string that can be used to display a subtitle or description
  const IterableDropdownItem({
    required this.key,
    required this.label,
    required this.value,
    String? selectedItemLabel,
    this.secondaryLabel,
  }) : selectedItemLabel = selectedItemLabel ?? label;

  /// A unique key for the dropdown option.
  /// This is what will be used as a search string as well when you enable search.
  ///
  /// Make sure all options have unique keys, as this will determine the selection as well.
  /// If two options are with the same key and one of them gets selected, then they will both appear selected.
  /// The dropdown will consider them equal when equality check happens.
  final String key;

  /// the internal value for the option.
  final T value;

  /// The string that will get displayed to the user in the dropdown.
  final String label;

  /// A secondary string in case you want to show a subtitle text in the dropdown
  final String? secondaryLabel;

  /// The string that will get displayed to the user when it is selected
  final String selectedItemLabel;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IterableDropdownItem && other.key == key;
  }

  @override
  int get hashCode => key.hashCode;
}
