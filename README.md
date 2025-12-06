A dropdown that works with all iterables instead of just lists. 
It has multiselect features for selecting multiple items as well.

This dropdown stays performant because it consumes any `Iterable` instead of forcing you to copy the data into `List`s, and it uses `ListView.builder` so only the options currently visible on screen are ever built and kept in memory.

## Screenshots

![Custom Decoration](screenshots/customisations.png)

| Single Select                                                                                                                        | Single Select with Search                                                                                                                               | Multi Select                                                                                                                       | Multi Select with Search                                                                                                                              |
|--------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------|
| ![Single Select](https://raw.githubusercontent.com/simranss/repo-assets/refs/heads/main/flutter-iterable-dropdown/single_select.gif) | ![Single Select with Search](https://raw.githubusercontent.com/simranss/repo-assets/refs/heads/main/flutter-iterable-dropdown/single_search_select.gif) | ![Multi Select](https://raw.githubusercontent.com/simranss/repo-assets/refs/heads/main/flutter-iterable-dropdown/multi_select.gif) | ![Multi Select with Search](https://raw.githubusercontent.com/simranss/repo-assets/refs/heads/main/flutter-iterable-dropdown/multi_search_select.gif) |


## Features

Use this package in your Flutter app to:
 * select multiple items in dropdowns
 * use iterables in a dropdown
 * Have a more beautiful dropdown
 * Keep huge data sources responsive by only building the visible options through `ListView.builder`
 * Provide custom first/last options via `CustomItems` that can act as headers or buttons

## Platform Support

| Platform | Supported |
|----------|-----------|
| Android  | ✅         |
| iOS      | ✅         |
| Web      | ✅         |
| Windows  | ✅         |
| MacOS    | ✅         |
| Linux    | ✅         |

## Getting started

Add the package to your Flutter app

```bash
flutter pub add iterable_dropdown
```

Import the package where you want to use it

```dart
import 'package:iterable_dropdown/iterable_dropdown.dart';
```

## Usage

Directly use the component
```dart
@override
Widget build(BuildContext context) {
  return IterableDropdown<String>.builder(
    controller: _dropdownController,
    items: items,
    itemBuilder: (_, _, item, selected, toggleSelection) {
      return ListTile(
        key: ValueKey(item.key),
        title: Text(item.label),
        trailing: selected ? const Icon(Icons.check_circle_outline) : null,
        selected: selected,
        onTap: toggleSelection,
      );
    },
    selectionMode: SelectionMode.multi,
  );
}
```

You can also open or close the dropdown programmatically by interacting with the controller.

```dart
_dropdownController.open() // show overlay
_dropdownController.close() // hide overlay
```

### Fetch items from a Future

When your data comes from an async source, use the `.future` constructor. The future runs only once per controller lifecycle unless you explicitly refresh it.

```dart
@override
Widget build(BuildContext context) {
  return IterableDropdown<String>.future(
    controller: _dropdownController,
    future: _loadCities, // returns Future<Iterable<IterableDropdownItem<String>>>
    loaderColor: Colors.indigo,
    itemBuilder: (_, __, item, selected, toggleSelection) => ListTile(
      key: ValueKey(item.key),
      title: Text(item.label),
      trailing: selected ? const Icon(Icons.check_circle_outline) : null,
      selected: selected,
      onTap: toggleSelection,
    ),
  );
}

Future<Iterable<IterableDropdownItem<String>>> _loadCities() async {
  final cities = await cityRepository.fetchCities();
  return cities.map((city) => IterableDropdownItem(key: city.id, label: city.name, value: city));
}
```

You can also refresh the dropdown using the `_dropdownController.refresh()` method.

## Custom Items (Pinned Rows)

Use the `customItems` parameter when you need pinned widgets before or after the generated options. These widgets never get filtered or selected, which makes them perfect for headers, dividers, or persistent actions. For instance, a customer selector can expose an `Add new customer` row at the top that launches a creation flow.

```dart
@override
Widget build(BuildContext context) {
  return IterableDropdown<Customer>.builder(
    controller: _customerController,
    items: customers,
    itemBuilder: (context, index, item, selected, toggleSelection) => ListTile(
      key: ValueKey(item.key),
      title: Text(item.label),
      trailing: selected ? const Icon(Icons.check_circle_outline) : null,
      selected: selected,
      onTap: toggleSelection,
    ),
    customItems: CustomItems(
      start: ListTile(
        leading: const Icon(Icons.add),
        title: const Text('Add new customer'),
        onTap: _createCustomer,
      ),
      end: TextButton(
        onPressed: _showAdvancedFilters,
        child: const Text('Show all customers'),
      ),
    ),
  );
}
```

Those boundary widgets stay visible regardless of what the user types into the search box and cannot be selected, so they are ideal for headers or CTA rows.


## Upcoming Features

### Grouping options
Options can be grouped by a certain field or a combination of fields. The same label can appear twice if they are in separate groups.
This will present hierarchy to the options.

## Additional information

You can contribute to this package via the [Github Repo](https://github.com/simranss/flutter_iterable_dropdown). Check out the [Contribution Page](CONTRIBUTING.md) for reference.
