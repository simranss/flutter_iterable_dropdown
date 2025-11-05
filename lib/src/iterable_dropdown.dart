import 'dart:math' show min;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:iterable_dropdown/src/data_models/field_config.dart'
    show FieldConfig, WrapStyle;
import 'package:iterable_dropdown/src/data_models/search_field_config.dart';
import 'package:iterable_dropdown/src/iterable_dropdown_controller.dart';
import 'package:iterable_dropdown/src/iterable_dropdown_item.dart';

typedef IterableDropdownItemBuilder<T> =
    Widget Function(
      BuildContext context,
      int index,
      IterableDropdownItem<T> item,
      bool selected,
      void Function() select,
    );

typedef IterableDropdownSelectedItemBuilder<T> =
    Widget Function(
      BuildContext context,
      int index,
      IterableDropdownItem<T> item,
      void Function() delete,
    );

class IterableDropdown<T> extends StatefulWidget {
  const IterableDropdown.builder({
    super.key,
    this.controller,
    required this.items,
    required this.itemBuilder,
    this.selectionMode = SelectionMode.single,
    this.maxHeight = 350,
    this.itemHeight = 60,
    this.fieldConfig = const FieldConfig(),
    this.enableSearch = true,
    this.searchFieldConfig = const SearchFieldConfig(),
  });

  /// Selection mode for your dropdown.
  ///
  /// Can be [SelectionMode.single] or [SelectionMode.multi].
  ///
  /// [SelectionMode.single] gives you a dropdown where only one item can be selected at a time.
  ///
  /// [SelectionMode.multi] gives you a dropdown where multiple items can be selected at a time.
  final SelectionMode selectionMode;

  /// Dropdown controller.
  ///
  /// This can be and should be used to control your dropdown
  final IterableDropdownController<T>? controller;

  /// The list of items.
  ///
  /// Can be an [Iterable] which means it supports [List] and other types
  final Iterable<IterableDropdownItem<T>> items;

  /// The item builder for your dropdown list
  final IterableDropdownItemBuilder<T> itemBuilder;

  /// Each dropdown item height
  ///
  /// This is important to calculate the dropdown height to make it responsive
  ///
  /// It defaults to 60.0
  final double itemHeight;

  /// The maximum height for your dropdown
  /// This defaults to 350.0
  final double maxHeight;

  /// The field level configuration
  ///
  /// This contains all the selected item configuration
  ///
  /// You can configure the [FieldConfig.wrapStyle], [FieldConfig.spacing], ...
  final FieldConfig fieldConfig;

  /// Whether to enable the search field
  ///
  /// Will filter the items based on each dropdown key
  ///
  /// Each dropdown needs to have a unique key for uniqueness and search
  ///
  /// This defaults to true
  final bool enableSearch;

  /// The search field configuration
  /// This contains all the search field configuration such as [SearchFieldConfig.inputDecorationTheme] and [SearchFieldConfig.hint]
  final SearchFieldConfig searchFieldConfig;

  @override
  State<IterableDropdown<T>> createState() => _IterableDropdownState();
}

class _IterableDropdownState<T> extends State<IterableDropdown<T>> {
  late IterableDropdownController<T> _controller;
  late TextEditingController _searchTextController;
  late FocusNode _searchFocusNode;

  final GlobalKey _dropdownKey = GlobalKey();
  final GlobalKey _overlayKey = GlobalKey();

  @override
  void initState() {
    _controller = widget.controller ?? IterableDropdownController();

    if (!_controller.initialised) {
      _controller.initialise(widget.items, widget.selectionMode);
    }
    _searchTextController =
        widget.searchFieldConfig.controller ?? TextEditingController();
    _searchFocusNode = widget.searchFieldConfig.focusNode ?? FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _hideOverlay();
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.searchFieldConfig.controller == null) {
      _searchTextController.dispose();
    }
    if (widget.searchFieldConfig.focusNode == null) {
      _searchFocusNode.dispose();
    }
    super.dispose();
  }

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void _toggleOverlay() {
    if (_overlayEntry == null) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    // Get the size and position of the dropdown button
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    // Calculate the dynamic height
    final textInputHeight = widget.enableSearch ? 60 : 0;
    final itemCount = _controller.items.length;
    final listHeight = itemCount * widget.itemHeight;
    final dropdownHeight = min(listHeight, widget.maxHeight - textInputHeight);

    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    final dropdownButtonOffset = renderBox.localToGlobal(Offset.zero);

    final topSpace = dropdownButtonOffset.dy;
    final bottomSpace = screenHeight - topSpace - size.height - 4;

    var overlayHeight = dropdownHeight + textInputHeight;
    var offset = Offset(0, size.height + 4);

    if (overlayHeight >= bottomSpace) {
      if (topSpace > bottomSpace) {
        overlayHeight = min(overlayHeight, topSpace);

        if (overlayHeight == topSpace) {
          overlayHeight -= 10;
        }

        offset = Offset(0, -overlayHeight - 4);
      } else {
        overlayHeight = bottomSpace - 10;
      }
    }

    var searchDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      suffixIcon: IconButton(
        onPressed: () {
          _searchTextController.clear();
          _controller.onFilter('');
        },
        icon: Icon(Icons.close_rounded),
      ),
      hint: widget.searchFieldConfig.hint,
    );
    if (widget.enableSearch &&
        widget.searchFieldConfig.inputDecorationTheme != null) {
      searchDecoration = searchDecoration.applyDefaults(
        widget.searchFieldConfig.inputDecorationTheme!,
      );
    }

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          height: overlayHeight,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: offset,
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                key: _overlayKey,
                children: [
                  if (widget.enableSearch)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: TextField(
                        controller: _searchTextController,
                        focusNode: _searchFocusNode,
                        decoration: searchDecoration,
                        onChanged: _controller.onFilter,
                      ),
                    ),
                  Expanded(
                    child: ListenableBuilder(
                      listenable: _controller,
                      builder: (context, _) {
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: _controller.filteredItems.length,
                          itemExtent: widget.itemHeight,
                          itemBuilder: (context, index) {
                            final item = _controller.filteredItems.elementAt(
                              index,
                            );
                            final selected = _controller.isSelected(item);

                            void select() =>
                                _controller.toggleSelection(item.key);

                            final child = widget.itemBuilder(
                              context,
                              index,
                              item,
                              selected,
                              select,
                            );

                            return child;
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (e) {
        if (_overlayEntry != null) {
          // overlay is visible

          // hide only if the click hasn't happened on the overlay
          final renderBox =
              _overlayKey.currentContext?.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            final Offset offset = renderBox.localToGlobal(Offset.zero);

            final dropdownSize = renderBox.size;

            final clickPosition = e.position;
            final dropdownBounds = Rect.fromLTWH(
              offset.dx,
              offset.dy,
              dropdownSize.width,
              dropdownSize.height,
            );
            if (!dropdownBounds.contains(clickPosition)) {
              _searchTextController.clear();
              _searchFocusNode.unfocus();
              _hideOverlay();
            }
          } else {
            _searchTextController.clear();
            _searchFocusNode.unfocus();
            _hideOverlay();
          }
        }
      },
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final Widget child;

          final fieldConfig = widget.fieldConfig;
          if (_controller.selectedDropdownItems.isEmpty) {
            child = fieldConfig.hint;
          } else {
            final selectedItemBuilder = fieldConfig.selectedItemBuilder;
            if (widget.selectionMode == SelectionMode.multi) {
              // Create a list of Chip widgets from the selected items
              final chips = _controller.selectedDropdownItems.mapIndexed((
                index,
                item,
              ) {
                void deleteFunc() => _controller.removeSelection(item.key);
                if (selectedItemBuilder != null) {
                  return selectedItemBuilder(context, index, item, deleteFunc);
                }
                return Chip(
                  deleteButtonTooltipMessage: '',
                  label: Text(item.label),
                  onDeleted: deleteFunc,
                );
              });

              child = switch (fieldConfig.wrapStyle) {
                WrapStyle.wrap => Wrap(
                  spacing:
                      fieldConfig.spacing, // Horizontal space between chips
                  runSpacing: fieldConfig
                      .runSpacing, // Vertical space between lines of chips
                  children: [...chips],
                ),
                WrapStyle.list => SizedBox(
                  height: 45,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...chips.expandIndexed((i, ele) {
                        if (i == chips.length - 1) return [ele];

                        return [ele, SizedBox(width: fieldConfig.spacing)];
                      }),
                    ],
                  ),
                ),
              };
            } else {
              final item = _controller.selectedDropdownItems.firstOrNull;
              if (item == null) {
                child = fieldConfig.hint;
              } else {
                final index = 0;
                void deleteFunc() => _controller.removeSelection(item.key);
                child =
                    selectedItemBuilder?.call(
                      context,
                      index,
                      item,
                      deleteFunc,
                    ) ??
                    Text(
                      _controller.selectedDropdownItems.firstOrNull?.label ??
                          '',
                    );
              }
            }
          }

          return CompositedTransformTarget(
            key: _dropdownKey,
            link: _layerLink,
            child: GestureDetector(
              onTap: () {
                // toggle the overlay
                _toggleOverlay();
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
                child: Row(
                  children: [
                    Expanded(child: child),
                    IconButton(
                      onPressed: _controller.clearSelections,
                      tooltip: 'Clear All',
                      icon: Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
