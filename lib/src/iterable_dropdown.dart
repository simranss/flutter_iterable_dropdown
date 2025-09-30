import 'dart:math' show min;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
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

enum WrapStyle { wrap, list }

class IterableDropdown<T> extends StatefulWidget {
  const IterableDropdown.builder({
    super.key,
    this.controller,
    required this.items,
    this.searchTextController,
    required this.itemBuilder,
    this.selectedItemBuilder,
    this.selectionMode = SelectionMode.single,
    this.wrapStyle = WrapStyle.wrap,
    this.searchFocusNode,
    this.maxHeight = 350,
    this.itemHeight = 60,
  });

  final SelectionMode selectionMode;
  final WrapStyle wrapStyle;
  final IterableDropdownController<T>? controller;
  final TextEditingController? searchTextController;
  final FocusNode? searchFocusNode;
  final Iterable<IterableDropdownItem<T>> items;
  final IterableDropdownItemBuilder<T> itemBuilder;
  final IterableDropdownSelectedItemBuilder<T>? selectedItemBuilder;
  final double itemHeight;
  final double maxHeight;

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
        widget.searchTextController ?? TextEditingController();
    _searchFocusNode = widget.searchFocusNode ?? FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _hideOverlay();
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.searchTextController == null) {
      _searchTextController.dispose();
    }
    if (widget.searchFocusNode == null) {
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
    final textInputHeight = 60;
    final itemCount = _controller.items.length;
    final listHeight = itemCount * widget.itemHeight;
    final dropdownHeight = min(listHeight, widget.maxHeight - textInputHeight);

    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    final dropdownButtonOffset = renderBox.localToGlobal(Offset.zero);

    final topSpace = dropdownButtonOffset.dy;
    final bottomSpace = screenHeight - topSpace - size.height - 4;

    var overlayHeight = dropdownHeight + textInputHeight;
    var offset = Offset(0.0, size.height + 4.0);

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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8,
                    ),
                    child: TextField(
                      controller: _searchTextController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _searchTextController.clear();
                            _controller.onFilter('');
                          },
                          icon: Icon(Icons.close_rounded),
                        ),
                        hintText: 'Search options',
                      ),
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

          final selectedItemBuilder = widget.selectedItemBuilder;
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

            child = switch (widget.wrapStyle) {
              WrapStyle.wrap => Wrap(
                spacing: 8, // Horizontal space between chips
                runSpacing: 4, // Vertical space between lines of chips
                children: [...chips],
              ),
              WrapStyle.list => SizedBox(
                height: 45,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...chips.expandIndexed((i, ele) {
                      if (i == chips.length - 1) return [ele];

                      return [ele, SizedBox(width: 8)];
                    }),
                  ],
                ),
              ),
            };
          } else {
            final item = _controller.selectedDropdownItems.firstOrNull;
            if (item == null) {
              child = SizedBox();
            } else {
              final index = 0;
              void deleteFunc() => _controller.removeSelection(item.key);
              child =
                  selectedItemBuilder?.call(context, index, item, deleteFunc) ??
                  Text(
                    _controller.selectedDropdownItems.firstOrNull?.label ?? '',
                  );
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
