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

  @override
  Widget build(BuildContext context) {
    final items = [
      IterableDropdownItem(key: 'abc', label: 'ABC', value: 'abc'),
      IterableDropdownItem(key: 'def', label: 'DEF', value: 'def'),
      IterableDropdownItem(key: 'ghi', label: 'GHI', value: 'ghi'),
      IterableDropdownItem(key: 'jkl', label: 'JKL', value: 'jkl'),
      IterableDropdownItem(key: 'mno', label: 'MNO', value: 'mno'),
      IterableDropdownItem(key: 'pqr', label: 'PQR', value: 'pqr'),
      IterableDropdownItem(key: 'stu', label: 'STU', value: 'stu'),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 100),
        // padding: const EdgeInsets.all(0),
        child: Column(
          spacing: 70,
          children: [
            IterableDropdown<String>.builder(
              controller: _dropdownController1,
              enableSearch: false,
              items: items,
              itemBuilder: itemBuilder,
              selectionMode: SelectionMode.multi,
            ),
            IterableDropdown<String>.builder(
              controller: _dropdownController2,
              enableSearch: false,
              fieldConfig: FieldConfig(wrapStyle: WrapStyle.list),
              items: items,
              itemBuilder: itemBuilder,
              selectionMode: SelectionMode.multi,
            ),
            IterableDropdown<String>.builder(
              controller: _dropdownController3,
              enableSearch: false,
              fieldConfig: FieldConfig(hint: Text('Custom Hint')),
              items: items,
              itemBuilder: itemBuilder,
              selectionMode: SelectionMode.multi,
            ),
            IterableDropdown<String>.builder(
              controller: _dropdownController4,
              enableSearch: false,
              fieldConfig: FieldConfig(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              ),
              items: items,
              itemBuilder: itemBuilder,
              selectionMode: SelectionMode.multi,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.deepPurple, width: 2),
              ),
            ),
          ],
        ),
      ),
    );
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
