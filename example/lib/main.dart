import 'package:flutter/material.dart';
import 'package:iterable_dropdown/iterable_dropdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final IterableDropdownController<String> _dropdownController1;
  late final IterableDropdownController<String> _dropdownController2;
  late final IterableDropdownController<String> _dropdownController3;
  late final IterableDropdownController<String> _dropdownController4;
  late final IterableDropdownController<String> _dropdownController5;

  @override
  void initState() {
    _dropdownController1 = IterableDropdownController();
    _dropdownController2 = IterableDropdownController();
    _dropdownController3 = IterableDropdownController();
    _dropdownController4 = IterableDropdownController();
    _dropdownController5 = IterableDropdownController();
    super.initState();
  }

  @override
  void dispose() {
    _dropdownController1.dispose();
    _dropdownController2.dispose();
    _dropdownController3.dispose();
    _dropdownController4.dispose();
    _dropdownController5.dispose();
    super.dispose();
  }

  final _items = [
    IterableDropdownItem(key: 'abc', label: 'ABC', value: 'abc'),
    IterableDropdownItem(key: 'def', label: 'DEF', value: 'def'),
    IterableDropdownItem(key: 'ghi', label: 'GHI', value: 'ghi'),
    IterableDropdownItem(key: 'jkl', label: 'JKL', value: 'jkl'),
    IterableDropdownItem(key: 'mno', label: 'MNO', value: 'mno'),
    IterableDropdownItem(key: 'pqr', label: 'PQR', value: 'pqr'),
    IterableDropdownItem(key: 'stu', label: 'STU', value: 'stu'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
        // padding: const EdgeInsets.all(0),
        child: Column(
          spacing: 50,
          children: [
            Column(
              spacing: 4,
              children: [
                Text('Selected Items in wrap'),
                IterableDropdown<String>.builder(
                  controller: _dropdownController1,
                  enableSearch: false,
                  fieldConfig: FieldConfig(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  ),
                  selectedItemConfig: SelectedItemConfig(
                    wrapStyle: WrapStyle.wrap,
                  ),
                  items: _items,
                  itemBuilder: itemBuilder,
                  selectionMode: SelectionMode.multi,
                ),
              ],
            ),
            Column(
              spacing: 4,
              children: [
                Text('Selected Items in horizontal scrollable list'),
                IterableDropdown<String>.builder(
                  controller: _dropdownController2,
                  enableSearch: false,
                  selectedItemConfig: SelectedItemConfig(
                    wrapStyle: WrapStyle.list,
                  ),
                  items: _items,
                  itemBuilder: itemBuilder,
                  selectionMode: SelectionMode.multi,
                ),
              ],
            ),
            Column(
              spacing: 4,
              children: [
                Text('Custom hint'),
                IterableDropdown<String>.builder(
                  controller: _dropdownController3,
                  enableSearch: false,
                  fieldConfig: FieldConfig(hint: Text('Custom Hint')),
                  items: _items,
                  itemBuilder: itemBuilder,
                  selectionMode: SelectionMode.multi,
                ),
              ],
            ),
            Column(
              spacing: 4,
              children: [
                Text('Dropdown customisations'),
                IterableDropdown<String>.builder(
                  controller: _dropdownController4,
                  enableSearch: false,
                  fieldConfig: FieldConfig(
                    hint: Text(
                      'Select an option',
                      style: TextStyle(color: Colors.deepPurple.shade400),
                    ),
                    clearAllIcon: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.deepPurple,
                    ),
                  ),
                  items: _items,
                  itemBuilder: itemBuilder,
                  selectionMode: SelectionMode.multi,
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.deepPurple, width: 2),
                    color: Colors.deepPurple.shade50,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withAlpha(0x66),
                        offset: Offset(4, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              spacing: 4,
              children: [
                Text('Future'),
                IterableDropdown<String>.future(
                  controller: _dropdownController5,
                  future: fetchItems,
                  itemBuilder: itemBuilder,
                  selectionMode: SelectionMode.multi,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          FloatingActionButton(
            onPressed: () => _dropdownController5.openDropdown(),
            child: Icon(Icons.open_in_full_rounded),
          ),
          FloatingActionButton(
            onPressed: () => _dropdownController5.closeDropdown(),
            child: Icon(Icons.close_fullscreen_rounded),
          ),
          FloatingActionButton(
            onPressed: () => _dropdownController5.refresh(
              future: () => fetchItems(const Duration(seconds: 10)),
            ),
            child: Icon(Icons.refresh_rounded),
          ),
        ],
      ),
    );
  }

  Future<Iterable<IterableDropdownItem<String>>> fetchItems([
    Duration duration = const Duration(seconds: 3),
  ]) async {
    try {
      // some future
      await Future.delayed(duration);

      return _items;
    } catch (e) {
      print("error: $e");
    }

    return [];
  }

  Widget itemBuilder(
    BuildContext context,
    int index,
    IterableDropdownItem<String> item,
    bool selected,
    void Function() toggleSelection,
  ) {
    return ListTile(
      key: ValueKey(item.key),
      title: Text(item.label),
      onTap: toggleSelection,
      trailing: selected
          ? Icon(Icons.check_circle_outline_rounded)
          : Icon(Icons.circle_outlined),
      selected: selected,
      selectedColor: Colors.black,
      selectedTileColor: Colors.deepPurple.shade100,
    );
  }
}
