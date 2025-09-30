import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:iterable_dropdown/src/iterable_dropdown_item.dart'
    show IterableDropdownItem;

enum SelectionMode { single, multi }

class IterableDropdownController<T> extends ChangeNotifier {
  bool _initialised = false;

  bool get initialised => _initialised;

  List<String> _selectedKeys = [];
  Iterable<IterableDropdownItem<T>> _items = [];
  Iterable<IterableDropdownItem<T>> _filteredItems = [];
  SelectionMode _selectionMode = SelectionMode.single;

  Iterable<IterableDropdownItem<T>> get items => _items.where((ele) => true);

  UnmodifiableListView<String> get selectedKeys =>
      UnmodifiableListView(_selectedKeys);

  Iterable<IterableDropdownItem<T>> get selectedDropdownItems =>
      _items.where((ele) => _selectedKeys.contains(ele.key));

  Iterable<T> get selectedItems => _items.map((ele) {
    final selected = _selectedKeys.contains(ele.key);

    return selected ? ele.value : null;
  }).whereType<T>();

  Iterable<IterableDropdownItem<T>> get filteredItems => _filteredItems;

  void updateSelectionMode(SelectionMode mode) {
    _selectionMode = mode;

    if (mode == SelectionMode.single && _selectedKeys.length > 1) {
      _selectedKeys = [_selectedKeys.first];
    }

    notifyListeners();
  }

  void setItems(Iterable<IterableDropdownItem<T>> items) {
    if (items.isEmpty) {
      throw Exception('Items cannot be empty');
    }
    _items = items;
    _filteredItems = items;
    _selectedKeys = [];
    notifyListeners();
  }

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

  void addSelection(String key) {
    if (_selectionMode == SelectionMode.single) {
      _selectedKeys = [];
    }
    _selectedKeys = {..._selectedKeys, key}.toList();
    notifyListeners();
  }

  void removeSelection(String key) {
    _selectedKeys = {..._selectedKeys}.toList()..remove(key);
    notifyListeners();
  }

  void setSelection(String key) {
    _selectedKeys = [key];
    notifyListeners();
  }

  void addSelections(List<String> keys) {
    if (_selectionMode == SelectionMode.single) {
      _selectedKeys = [keys.first];
    } else {
      _selectedKeys = {..._selectedKeys, ...keys}.toList();
    }
    notifyListeners();
  }

  void removeSelections(List<String> keys) {
    _selectedKeys = [..._selectedKeys]
      ..removeWhere((key) => keys.contains(key));
    notifyListeners();
  }

  void setSelections(List<String> keys) {
    if (_selectionMode == SelectionMode.single) {
      _selectedKeys = [keys.first];
    } else {
      _selectedKeys = keys.toSet().toList();
    }
    notifyListeners();
  }

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

  void clearSelections() {
    _selectedKeys = [];
    notifyListeners();
  }

  void selectWhere(bool Function(IterableDropdownItem<T> item) predicate) {
    final keys = _items.map((ele) {
      final shouldSelect = predicate(ele);

      return shouldSelect ? ele.key : null;
    }).nonNulls;

    if (keys.isEmpty) return;

    if (_selectionMode == SelectionMode.single) {
      _selectedKeys = [keys.first];
    } else {
      _selectedKeys = {..._selectedKeys, ...keys}.toList();
    }
  }

  bool isKeySelected(String key) => _selectedKeys.contains(key);

  bool isSelected(IterableDropdownItem<T> item) => isKeySelected(item.key);

  void initialise(Iterable<IterableDropdownItem<T>> items, SelectionMode mode) {
    _items = items;
    _filteredItems = items;
    _selectionMode = mode;
    _selectedKeys = [];
    _initialised = true;
  }
}
