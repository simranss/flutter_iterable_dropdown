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
  late final IterableDropdownController<String> _dropdownController;

  @override
  void initState() {
    _dropdownController = IterableDropdownController();
    super.initState();
  }

  @override
  void dispose() {
    _dropdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IterableDropdown<String>.builder(
              controller: _dropdownController,
              wrapStyle: WrapStyle.list,
              items: [
                IterableDropdownItem(key: 'abc', label: 'ABC', value: 'abc'),
                IterableDropdownItem(key: 'def', label: 'DEF', value: 'def'),
                IterableDropdownItem(key: 'ghi', label: 'GHI', value: 'ghi'),
                IterableDropdownItem(key: 'jkl', label: 'JKL', value: 'jkl'),
                IterableDropdownItem(key: 'mno', label: 'MNO', value: 'mno'),
                IterableDropdownItem(key: 'pqr', label: 'PQR', value: 'pqr'),
                IterableDropdownItem(key: 'stu', label: 'STU', value: 'stu'),
              ],
              itemBuilder: (_, _, item, selected, select) {
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
            ),
          ],
        ),
      ),
    );
  }
}
