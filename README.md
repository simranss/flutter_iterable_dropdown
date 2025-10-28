A dropdown that works with all iterables instead of just lists. 
It has multiselect features for selecting multiple items as well.

<p>
  <img src="https://raw.githubusercontent.com/simranss/flutter_iterable_dropdown/refs/heads/main/doc/screen_shot.png"
    alt="An image of the dropdown UI" height="400" style="height:400px;" />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://raw.githubusercontent.com/simranss/flutter_iterable_dropdown/refs/heads/main/doc/screen_recording.gif"
    alt="An animated image of the dropdown UI" height="400" style="height:400px;" />
</p>

## Features

Use this package in your Flutter app to:
 * select multiple items in dropdowns
 * use iterables in a dropdown

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
    items: items,
    itemBuilder: (context, index, item, selected, select) {
      return ListTile(
        key: ValueKey(item.key),
        title: Text(item.label),
        onTap: select,
        trailing: Icon(
          selected
            ? Icons.check_box_rounded
            : Icons.check_box_outline_blank_rounded,
        ),
      );
    },
    hintText: 'Select an option',
    selectionMode: SelectionMode.multi,
  );
}
```

## Upcoming Features

#### Custom first and last options
These custom options won't be selectable and won't be filtered by search but can be used as clickable options or custom options in UI
They will be optional so it will not affect the current UI if you don't use it
They will have the same height as the rest of dropdown items

## Additional information

You can contribute to this package via the [github repo](https://github.com/simranss/flutter_iterable_dropdown)