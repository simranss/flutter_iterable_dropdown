# 2.0.6
**06-12-2025**

* `IterableDropdown.future()` added
* `IterableDropdownController` now has a `refresh()`
* Earlier, when you set custom items using `IterableDropdownController`, it reset the selection as well, now user can choose if they want to reset the selection or not
* The controller can now be instantiated with pre-selected values
* Dropdown now won't open unless it is initialised and is not in a loading state
* Updated Example
* Updated Screenshot

# 2.0.5
**05-12-2025**

* Icons to have a corresponding iconSize and iconColor outside the icon definition.
* Fields related to selected items have now been grouped and moved to `selectedItemConfig`
* More customisations for the selected item chip. 
* Control given if you want to show the suffix icon or not for chips, search and the dropdown itself
* Added `deselectWhere()` to the controller
* The controller can programmatically open or close the dropdown
* Improved documentation

# 2.0.4+1

* Assets and screenshots

# 2.0.4

* `margin` will no longer be in `fieldConfig`. It will be outside with the rest of the dropdown fields
* Default `wrapStyle` for the dropdown is not `WrapStyle.list`
* Custom widgets for first and last options of the dropdown. These options won't get filtered by search. These options are also not selectable

# 2.0.3+1

* More dart docs

# 2.0.3

* More UI customisations

# 2.0.2

* Updated `README.md`
* `FieldConfig` is no longer a required field
* Added more dart documentations

# 2.0.1

* Updated examples in `README.md` and the example project

## 2.0.0

* Breaking changes in this version
1. Search Field configuration is now clubbed in a field called `searchFieldConfig`
2. Field level configuration are clubbed in a field called `fieldConfig`
3. Search is now optional
4. More control over the UI
5. Dart version upgraded to 3.9.0
6. Updated Example
7. Added documentation

## 1.0.1

* Updated the screen recording.


## 1.0.0

* Initial release.
