part of 'iterable_dropdown.dart';

/// Selection Mode for the [IterableDropdown] widget.
///
/// [single] --> Only one item can be selected at a time
///
/// [multi] --> Multiple items can be selected at a time
enum SelectionMode { single, multi }

/// Controller for an [IterableDropdown] widget.
///
/// It is recommended to use the controller along with the Widget.
/// Provides full control over the [IterableDropdown] widget programmatically
class IterableDropdownController<T> extends ChangeNotifier {
  bool _initialised;
  bool _isLoading;
  OverlayEntry? _overlayEntry;
  Future<Iterable<IterableDropdownItem<T>>> Function()? _itemsFuture;

  /// Is the controller initialised
  bool get initialised => _initialised;

  /// Whether the dropdown items are currently being fetched
  bool get isLoading => _isLoading;

  /// Whether the dropdown overlay is currently visible
  bool get isOpen => !isClose;

  /// Whether the dropdown overlay is currently hidden
  bool get isClose => _overlayEntry == null;

  List<String> _selectedKeys;
  Iterable<IterableDropdownItem<T>> _items;
  Iterable<IterableDropdownItem<T>> _filteredItems;
  SelectionMode _selectionMode;
  VoidCallback? _showOverlayCallback;

  /// A getter for the dropdown options
  Iterable<IterableDropdownItem<T>> get items => _items.where((ele) => true);

  /// A getter for all the selected keys.
  UnmodifiableListView<String> get selectedKeys =>
      UnmodifiableListView(_selectedKeys);

  /// A getter for all selected options
  Iterable<IterableDropdownItem<T>> get selectedDropdownItems =>
      _items.where((ele) => _selectedKeys.contains(ele.key));

  /// A getter for all selected values
  Iterable<T> get selectedItems => _items.map((ele) {
    final selected = _selectedKeys.contains(ele.key);

    return selected ? ele.value : null;
  }).whereType<T>();

  /// A getter for all filtered items.
  ///
  /// This is what the user sees in the dropdown list.
  /// Filtered options are filtered on the basis of the search query.
  Iterable<IterableDropdownItem<T>> get filteredItems => _filteredItems;

  /// Updates the selection mode
  ///
  /// [SelectionMode.single] --> Only one option can be selected at a time
  ///
  /// [SelectionMode.multi] --> Multiple options can be selected at a time
  void updateSelectionMode(SelectionMode mode) {
    _selectionMode = mode;

    if (mode == SelectionMode.single && _selectedKeys.length > 1) {
      _selectedKeys = [_selectedKeys.first];
    }

    notifyListeners();
  }

  /// Sets the Iterable as the new dropdown options
  ///
  /// This removes all the previous selections and items
  void setItems(
    Iterable<IterableDropdownItem<T>> items, {
    bool resetSelection = true,
  }) {
    _items = items;
    _filteredItems = items;
    if (resetSelection) _selectedKeys = [];

    notifyListeners();
  }

  /// filter dropdown options based on the query
  void onFilter(String query) {
    if (query.isEmpty) {
      _filteredItems = _items;
      notifyListeners();
      return;
    }

    _filteredItems = _items.where(
      (ele) => ele.key.toLowerCase().contains(query.toLowerCase()),
    );
    notifyListeners();
  }

  /// Selects the option with matching key.
  /// This adds the new selection without affecting the previous selections.
  ///
  /// [SelectionMode.single] --> Since only 1 option can be selected at a time, it removes the previous selection.
  ///
  /// [SelectionMode.multi] --> adds a new selection
  void addSelection(String key) {
    if (_selectionMode == SelectionMode.single) {
      _selectedKeys = [];
    }
    _selectedKeys = {..._selectedKeys, key}.toList();
    notifyListeners();
  }

  /// De-selects the option with matching key.
  void removeSelection(String key) {
    _selectedKeys = {..._selectedKeys}.toList()..remove(key);
    notifyListeners();
  }

  /// Selects the option with matching key.
  /// This removes all the previous selections.
  void setSelection(String key) {
    _selectedKeys = [key];
    notifyListeners();
  }

  /// Selects all the options with matching keys from iterable.
  /// This adds the new selections without affecting the previous ones.
  ///
  /// [SelectionMode.single] --> only the 1st one is selected and the rest of the items are ignored.
  /// Since only 1 option can be selected at a time, it removes the previous selection.
  ///
  /// [SelectionMode.multi] --> all items are selected
  ///
  /// If the keys are empty, nothing happens
  void addSelections(Iterable<String> keys) {
    if (keys.isEmpty) return;
    if (_selectionMode == SelectionMode.single) {
      _selectedKeys = [keys.first];
    } else {
      _selectedKeys = {..._selectedKeys, ...keys}.toList();
    }
    notifyListeners();
  }

  /// De-selects all the options with matching keys from iterable
  ///
  /// If the keys are empty, nothing happens
  void removeSelections(Iterable<String> keys) {
    if (keys.isEmpty) return;

    _selectedKeys = [..._selectedKeys]
      ..removeWhere((selectedKey) => keys.contains(selectedKey));

    notifyListeners();
  }

  /// Selects all the options with matching keys from iterable.
  /// This removes all the previous selections.
  ///
  /// [SelectionMode.single] --> only the 1st one is selected and the rest of the keys are ignored
  ///
  /// [SelectionMode.multi] --> all keys are selected
  ///
  /// If the keys are empty, nothing happens
  void setSelections(Iterable<String> keys) {
    if (keys.isEmpty) return;

    if (_selectionMode == SelectionMode.single) {
      _selectedKeys = [keys.first];
    } else {
      _selectedKeys = keys.toSet().toList();
    }

    notifyListeners();
  }

  /// Toggles the selection of a key
  ///
  /// if the key is already selected, it will be removed.
  /// Whereas if the key wasn't selected, it will get selected
  void toggleSelection(String key) {
    if (_selectedKeys.contains(key)) {
      _selectedKeys = [..._selectedKeys]..remove(key);
    } else {
      if (_selectionMode == SelectionMode.single) {
        _selectedKeys = [];
      }
      _selectedKeys = [..._selectedKeys, key];
    }
    notifyListeners();
  }

  /// Clear all selections
  void clearSelections() {
    _selectedKeys = [];
    notifyListeners();
  }

  /// select all items which fulfill the predicate
  void selectWhere(bool Function(IterableDropdownItem<T> item) predicate) {
    final keys = _items.map((ele) {
      final shouldSelect = predicate(ele);

      return shouldSelect ? ele.key : null;
    }).nonNulls;

    setSelections(keys);
  }

  /// de-select all items which fulfill the predicate
  void deselectWhere(bool Function(IterableDropdownItem<T> item) predicate) {
    final keys = _items.map((ele) {
      final shouldDeselect = predicate(ele);

      return shouldDeselect ? ele.key : null;
    }).nonNulls;

    removeSelections(keys);
  }

  /// Returns if the key is selected
  bool isKeySelected(String key) => _selectedKeys.contains(key);

  /// Returns if the item is selected
  bool isSelected(IterableDropdownItem<T> item) => isKeySelected(item.key);

  /// Initialise the dropdown
  ///
  /// This is by default called once when building the dropdown component for the first tine
  void initialise(
    SelectionMode mode, {
    Iterable<IterableDropdownItem<T>>? items,
    Future<Iterable<IterableDropdownItem<T>>> Function()? future,
    bool resetSelection = true,
  }) {
    if (_initialised || _isLoading) return;

    if (items == null && future == null) {
      throw ArgumentError(
        'Either items or future must be provided for initialisation.',
      );
    }

    if (items != null && future != null) {
      throw ArgumentError(
        'Both items and future cannot be provided together for initialisation.',
      );
    }

    _selectionMode = mode;

    if (items != null) {
      _items = items;
      _filteredItems = items;
      if (resetSelection) _selectedKeys = [];
      _initialised = true;
      _isLoading = false;
      return;
    }

    if (future != null) {
      _itemsFuture = future;

      refresh(resetSelection: resetSelection).then((_) {
        _initialised = true;
      });
    }
  }

  /// Opens the dropdown overlay if it is currently hidden
  void openDropdown() {
    if (isLoading || !initialised) {
      return;
    }

    if (isOpen) return;

    _showOverlayCallback?.call();
  }

  /// Closes the dropdown overlay if it is currently visible
  void closeDropdown() {
    if (isClose) return;

    _hideOverlayEntry();

    onFilter('');
  }

  /// Toggles the dropdown overlay
  ///
  /// if it is currently visible, then closes it
  ///
  /// if it is currently hidden, then opens it
  void toggleDropdown() {
    if (isLoading || !initialised) {
      return;
    }

    if (isClose) {
      openDropdown();
    } else {
      closeDropdown();
    }
  }

  void _setOverlayEntry(OverlayEntry? entry) {
    _overlayEntry = entry;
  }

  void _hideOverlayEntry() {
    _overlayEntry?.remove();
    _setOverlayEntry(null);
  }

  Future<void> _fetchItems(
    Future<Iterable<IterableDropdownItem<T>>> Function()? future,
    bool resetSelection,
  ) async {
    if (future != null) {
      _itemsFuture = future;
    }

    if (_itemsFuture == null) {
      throw StateError('No future configured for fetching items.');
    }
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final items = await _itemsFuture!();
      _items = items;
      _filteredItems = items;
      if (resetSelection) _selectedKeys = [];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Fetch items again using the provided future.
  Future<void> refresh({
    Future<Iterable<IterableDropdownItem<T>>> Function()? future,
    bool resetSelection = true,
  }) {
    try {
      return _fetchItems(future, resetSelection);
    } catch (_) {
      rethrow;
    }
  }

  /// Default constructor for [IterableDropdownController]
  IterableDropdownController([Iterable<String>? selectedKeys])
    : _initialised = false,
      _isLoading = false,
      _overlayEntry = null,
      _selectedKeys = [...?selectedKeys],
      _filteredItems = [],
      _items = [],
      _selectionMode = SelectionMode.single,
      _showOverlayCallback = null;
}
