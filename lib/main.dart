import 'dart:async';

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
      create: (_) => ObjectProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

@immutable
class BaseObject {
  final String id, lastUpdated;

  BaseObject()
      : id = const Uuid().v4(),
        lastUpdated = DateTime.now().toIso8601String();

  @override
  bool operator ==(covariant BaseObject other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class ExpensiveObject extends BaseObject {}

@immutable
class CheapObject extends BaseObject {}

class ObjectProvider extends ChangeNotifier {
  late String id;
  late CheapObject _cheapObject;
  late ExpensiveObject _expensiveObject;
  late StreamSubscription _cheapObjectStreamSubs;
  late StreamSubscription _expensiveObjectStreamSubs;

  ObjectProvider()
      : id = const Uuid().v4(),
        _cheapObject = CheapObject(),
        _expensiveObject = ExpensiveObject();

  @override
  void notifyListeners() {
    id = const Uuid().v4();
    super.notifyListeners();
  }

  CheapObject get cheapObject => _cheapObject;
  ExpensiveObject get expensiveObject => _expensiveObject;

  void start() {
    _cheapObjectStreamSubs =
        Stream.periodic(const Duration(seconds: 1)).listen((_) {
      _cheapObject = CheapObject();
      notifyListeners();
    });

    _expensiveObjectStreamSubs =
        Stream.periodic(const Duration(seconds: 10)).listen((_) {
      _expensiveObject = ExpensiveObject();
      notifyListeners();
    });
  }

  void stop() {
    _cheapObjectStreamSubs.cancel();
    _expensiveObjectStreamSubs.cancel();
  }
}

class ExpensiveWidget extends StatelessWidget {
  const ExpensiveWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('expensive widget build');
    final expensiveObject = context.select<ObjectProvider, ExpensiveObject>(
        (provider) => provider.expensiveObject);
    return Container(
      color: Colors.blue,
      height: 100,
      child: Column(
        children: [
          const Text('Expensive Widget'),
          Text(expensiveObject.id),
          Text(expensiveObject.lastUpdated),
        ],
      ),
    );
  }
}

class CheapWidget extends StatelessWidget {
  const CheapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('cheap widget build');

    final cheapObject = context.select<ObjectProvider, CheapObject>(
        (provider) => provider.cheapObject);
    return Container(
      color: Colors.yellow,
      height: 100,
      child: Column(
        children: [
          const Text('Cheap Widget'),
          Text(cheapObject.id),
          Text(cheapObject.lastUpdated),
        ],
      ),
    );
  }
}

class ObjectProviderWidget extends StatelessWidget {
  const ObjectProviderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('object widget build');

    final provider = context.watch<ObjectProvider>();
    return Container(
      color: Colors.purple,
      height: 100,
      child: Column(
        children: [
          const Text('Object Provider Widget'),
          Text(provider.id),
          // Text(provider.lastUpdated),
        ],
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('homepage widget build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Default value'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: const [
              Expanded(child: ExpensiveWidget()),
              Expanded(child: CheapWidget()),
            ],
          ),
          const ObjectProviderWidget(),
          TextButton(
            onPressed: () {
              context.read<ObjectProvider>().start();
            },
            child: const Text('start'),
          ),
          TextButton(
            onPressed: () {
              context.read<ObjectProvider>().stop();
            },
            child: const Text('stop'),
          )
        ],
      ),
    );
  }
}
