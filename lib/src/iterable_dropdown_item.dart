import 'package:equatable/equatable.dart' show Equatable;

class IterableDropdownItem<T> extends Equatable {
  const IterableDropdownItem({
    required this.key,
    required this.label,
    required this.value,
  });

  final String key;
  final T value;
  final String label;

  @override
  List<Object?> get props => [key];
}
