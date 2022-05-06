import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BreadCrumbProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
        routes: {
          '/new': (context) => const AddNewBreadCrumbScreen(),
        },
      ),
    );
  }
}

class BreadCrumb {
  bool isActive;
  final String name;
  final String uuid;

  BreadCrumb({
    required this.isActive,
    required this.name,
  }) : uuid = const Uuid().v4();

  void activate() {
    isActive = true;
  }

  @override
  bool operator ==(covariant BreadCrumb other) => other.uuid == uuid;

  @override
  int get hashCode => uuid.hashCode;

  String get title => name + (isActive ? ' > ' : '');
}

class BreadCrumbProvider extends ChangeNotifier {
  final List<BreadCrumb> _items = [];

  UnmodifiableListView<BreadCrumb> get items => UnmodifiableListView(_items);

  void add(BreadCrumb breadCrumb) {
    for (final item in _items) {
      item.activate();
    }
    _items.add(breadCrumb);
    notifyListeners();
  }

  void reset() {
    _items.clear();
    notifyListeners();
  }
}

class BreadCrumbsWidget extends StatelessWidget {
  final UnmodifiableListView<BreadCrumb> breadCrumbs;

  const BreadCrumbsWidget({Key? key, required this.breadCrumbs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: breadCrumbs.map((breadCrumb) {
        return Text(
          breadCrumb.title,
          style: TextStyle(
            color: breadCrumb.isActive ? Colors.blue : Colors.black,
          ),
        );
      }).toList(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Default value'),
      ),
      body: Column(
        children: [
          Consumer<BreadCrumbProvider>(
            builder: (context, value, child) {
              return BreadCrumbsWidget(
                breadCrumbs: value.items,
              );
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNewBreadCrumbScreen(),
                ),
              );
            },
            child: const Text('Add new bread crumb'),
          ),
          TextButton(
            onPressed: () {
              final provider = context.read<BreadCrumbProvider>().reset();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class AddNewBreadCrumbScreen extends StatefulWidget {
  const AddNewBreadCrumbScreen({Key? key}) : super(key: key);

  @override
  State<AddNewBreadCrumbScreen> createState() => _AddNewBreadCrumbScreenState();
}

class _AddNewBreadCrumbScreenState extends State<AddNewBreadCrumbScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new bread crumb'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Bread crumb name',
              ),
              controller: _controller,
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Add'),
            )
          ],
        ),
      ),
    );
  }
}
