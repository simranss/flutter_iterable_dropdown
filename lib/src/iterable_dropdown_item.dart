import 'package:equatable/equatable.dart' show Equatable;
import 'package:iterable_dropdown/iterable_dropdown.dart' show IterableDropdown;

/// The data model for each dropdown option
///
/// The [IterableDropdown] takes an [Iterable] of this data model
class IterableDropdownItem<T> extends Equatable {
  /// Default constructor
  ///
  /// [key] --> A unique key for the dropdown option.
  /// This is what will be used as a search string as well when you enable search.
  ///
  /// [label] --> This is what will be displayed in the dropdown option.
  ///
  /// [value] --> This is the internal value for the option.
  const IterableDropdownItem({
    required this.key,
    required this.label,
    required this.value,
  });

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

  @override
  List<Object?> get props => [key];
}
