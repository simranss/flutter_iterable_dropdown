import 'dart:math' show min;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:iterable_dropdown/src/data_models/custom_items.dart';
import 'package:iterable_dropdown/src/data_models/field_config.dart';
import 'package:iterable_dropdown/src/data_models/search_field_config.dart';
import 'package:iterable_dropdown/src/data_models/selected_item_config.dart';
import 'package:iterable_dropdown/src/iterable_dropdown_controller.dart';
import 'package:iterable_dropdown/src/iterable_dropdown_item.dart';

/// A custom widget builder for selected options.
/// Provides with [context], [index], [item], [selected], [toggleSelection]
///
/// [index] --> index of the option in the dropdown
///
/// [item] --> option.
/// It gives the item data in [IterableDropdownItem] format
///
/// [selected] --> whether the option is selected or not
///
/// [toggleSelection] --> function to select / unselect the option
typedef IterableDropdownItemBuilder<T> =
    Widget Function(
      BuildContext context,
      int index,
      IterableDropdownItem<T> item,
      bool selected,
      void Function() toggleSelection,
    );

/// A custom widget builder for selected options.
/// Provides with [context], [index], [item], [delete]
///
/// [index] --> index of the option in list of the selected options
///
/// [item] --> selected option.
/// It gives the item data in [IterableDropdownItem] format
///
/// [delete] --> function to delete the selected option
typedef IterableDropdownSelectedItemBuilder<T> =
    Widget Function(
      BuildContext context,
      int index,
      IterableDropdownItem<T> item,
      void Function() delete,
    );

/// Iterable Dropdown
///
/// You can create a dropdown out of not just [List]s but any [Iterable]s.
///
/// Check individual constructors to build this dropdown
class IterableDropdown<T> extends StatefulWidget {
  /// Pass [items] and [itemBuilder], and you'll have a basic dropdown ready.
  /// [items] are the Iterable of items you want to iterate over, while [itemBuilder] builds what user sees in the dropdown option.
  /// Make sure to have unique [IterableDropdownItem.key] for all options.
  ///
  /// It is highly recommended to use the [IterableDropdownController] using the [controller] field for controlling any and all aspects of the dropdown.
  ///
  /// If you enable search, make sure to pass the string you want to search against in the [IterableDropdownItem.key] of [items].
  ///
  /// When space is not available at bottom, it will try to open in top.
  /// If both don't have enough space to show all [items] or the [maxHeight], then it'll choose the side which has more space and adjust the height according to available space
  ///
  /// You can customise how the selected items appear using the [fieldConfig].
  /// You can choose the wrapStyle using [FieldConfig.wrapStyle] or the spacing using [FieldConfig.spacing].
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
    this.decoration,
    this.margin,
    this.customItems = const CustomItems(),
    this.selectedItemConfig = const SelectedItemConfig(),
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
  ///
  /// [IterableDropdownItem.key] must be unique if you want the dropdown to work properly.
  /// Options with same key will behave abnormally (eg: both items getting selected when user only selects one)
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
  /// Make sure to pass the key as the String you want to search against
  ///
  /// Each dropdown needs to have a unique key for uniqueness and search
  ///
  /// This defaults to true
  final bool enableSearch;

  /// The search field configuration
  /// This contains all the search field configuration such as [SearchFieldConfig.inputDecorationTheme] and [SearchFieldConfig.hint]
  final SearchFieldConfig searchFieldConfig;

  final SelectedItemConfig selectedItemConfig;

  /// Custom decoration for the dropdown
  final Decoration? decoration;

  /// Margin for the dropdown
  final EdgeInsetsGeometry? margin;

  /// Custom first and last options in the dropdown
  /// These options cannot be filtered or selected
  final CustomItems customItems;

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

    _controller.attachDropdownVisibilityHandlers(
      openDropdown: _openOverlay,
      closeDropdown: _closeOverlay,
    );

    super.initState();
  }

  @override
  void dispose() {
    _closeOverlay();
    _controller.detachDropdownVisibilityHandlers();

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
      _openOverlay();
    } else {
      _closeOverlay();
    }
  }

  void _openOverlay() {
    if (_overlayEntry != null) return;

    _showOverlay();
  }

  void _closeOverlay() {
    if (_overlayEntry == null) return;

    _hideOverlay();
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    // Get the size and position of the dropdown button
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size =
        renderBox.size +
        Offset(
          -(widget.margin?.horizontal ?? 0),
          -(widget.margin?.vertical ?? 0),
        );

    // Calculate the dynamic height
    final textInputHeight = widget.enableSearch ? 60 : 0;
    final itemCount = _controller.items.length;
    final listHeight = itemCount * widget.itemHeight;
    final dropdownHeight = min(listHeight, widget.maxHeight - textInputHeight);

    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    final dropdownButtonOffset = renderBox.localToGlobal(Offset.zero);

    final margin = widget.margin;
    final double leftMargin, topMargin;
    if (margin is EdgeInsets) {
      leftMargin = margin.left;
      topMargin = margin.top;
    } else if (margin is EdgeInsetsDirectional) {
      leftMargin = margin.start;
      topMargin = margin.top;
    } else {
      leftMargin = 0;
      topMargin = 0;
    }

    final topSpace = dropdownButtonOffset.dy + topMargin;
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
    offset = offset + Offset(leftMargin, topMargin);

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
    );
    if (widget.enableSearch &&
        widget.searchFieldConfig.inputDecorationTheme != null) {
      searchDecoration = InputDecoration().applyDefaults(
        widget.searchFieldConfig.inputDecorationTheme!,
      );
    }
    if (widget.searchFieldConfig.showClearAllIcon) {
      searchDecoration = searchDecoration.copyWith(
        suffixIcon: IconButton(
          onPressed: () {
            _searchTextController.clear();
            _controller.onFilter('');
          },
          icon: widget.searchFieldConfig.clearIcon,
          iconSize: widget.searchFieldConfig.clearIconSize,
          color: widget.searchFieldConfig.clearIconColor,
        ),
      );
    }

    searchDecoration = searchDecoration.copyWith(
      hint: widget.searchFieldConfig.hint,
    );

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
                        final itemCount =
                            _controller.filteredItems.length +
                            (widget.customItems.start != null ? 1 : 0) +
                            (widget.customItems.end != null ? 1 : 0);

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: itemCount,
                          itemExtent: widget.itemHeight,
                          itemBuilder: (context, index) {
                            if (index == 0 &&
                                widget.customItems.start != null) {
                              return widget.customItems.start!;
                            }

                            if (index == itemCount - 1 &&
                                widget.customItems.end != null) {
                              return widget.customItems.end!;
                            }

                            final tempIndex =
                                index -
                                (widget.customItems.start != null ? 1 : 0);

                            final item = _controller.filteredItems.elementAt(
                              tempIndex,
                            );
                            final selected = _controller.isSelected(item);

                            void toggleSelection() =>
                                _controller.toggleSelection(item.key);

                            final child = widget.itemBuilder(
                              context,
                              tempIndex,
                              item,
                              selected,
                              toggleSelection,
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
              _closeOverlay();
            }
          } else {
            _searchTextController.clear();
            _searchFocusNode.unfocus();
            _closeOverlay();
          }
        }
      },
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final Widget child;

          final fieldConfig = widget.fieldConfig;
          final selectedItemConfig = widget.selectedItemConfig;

          if (_controller.selectedDropdownItems.isEmpty) {
            child = fieldConfig.hint;
          } else {
            final selectedItemBuilder = selectedItemConfig.selectedItemBuilder;
            final chipConfig = selectedItemConfig.chipConfig;

            assert(
              (selectedItemConfig.selectedItemBuilderType ==
                          ItemBuilderType.custom &&
                      selectedItemBuilder != null) ||
                  selectedItemConfig.selectedItemBuilderType ==
                      ItemBuilderType.chip,
            );

            if (widget.selectionMode == SelectionMode.multi) {
              // Create a list of Chip widgets from the selected items
              final chips = _controller.selectedDropdownItems.mapIndexed((
                index,
                item,
              ) {
                void deleteFunc() => _controller.removeSelection(item.key);
                if (selectedItemBuilder != null &&
                    selectedItemConfig.selectedItemBuilderType ==
                        ItemBuilderType.custom) {
                  return selectedItemBuilder(context, index, item, deleteFunc);
                }

                return Chip(
                  deleteButtonTooltipMessage: '',
                  label: Text(item.label, style: chipConfig.labelStyle),
                  onDeleted: chipConfig.showDeleteButton ? deleteFunc : null,
                  backgroundColor: chipConfig.backgroundColor,
                  deleteIcon: chipConfig.showDeleteButton
                      ? chipConfig.deleteIcon
                      : null,
                  deleteIconColor: chipConfig.showDeleteButton
                      ? chipConfig.deleteIconColor
                      : null,
                );
              });

              child = switch (selectedItemConfig.wrapStyle) {
                WrapStyle.wrap => Wrap(
                  spacing: selectedItemConfig.spacing,
                  runSpacing: selectedItemConfig.runSpacing,
                  children: [...chips],
                ),
                WrapStyle.list => SizedBox(
                  height: 45,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...chips.expandIndexed((i, ele) {
                        if (i == chips.length - 1) return [ele];

                        return [
                          ele,
                          SizedBox(width: selectedItemConfig.spacing),
                        ];
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

          Decoration dropdownDecoration = BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          );
          if (widget.decoration != null) {
            dropdownDecoration = widget.decoration!;
          }

          return CompositedTransformTarget(
            key: _dropdownKey,
            link: _layerLink,
            child: GestureDetector(
              onTap: () {
                // toggle the overlay
                _toggleOverlay();
              },
              child: Container(
                decoration: dropdownDecoration,
                padding: fieldConfig.padding,
                margin: widget.margin,
                child: Row(
                  children: [
                    Expanded(child: child),
                    if (fieldConfig.showClearAllIcon)
                      IconButton(
                        onPressed: _controller.clearSelections,
                        tooltip: 'Clear All',
                        icon: fieldConfig.clearAllIcon,
                        iconSize: fieldConfig.clearAllIconSize,
                        color: fieldConfig.clearAllIconColor,
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
