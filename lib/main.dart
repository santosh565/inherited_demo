import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ApiProvider(api: Api(), child: const MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dateTime = 'No Date';
  @override
  Widget build(BuildContext context) {
    final api = ApiProvider.of(context).api;
    return Scaffold(
      appBar: AppBar(
        title: Text(api.dateTime ?? 'Default value'),
      ),
      body: GestureDetector(
        onTap: () async {
          dateTime = await api.getDateAndTime();
          debugPrint(dateTime);
          setState(() {});
        },
        child: Center(
          child: Container(
            color: Colors.white,
            child: DateTimeWidget(key: Key(dateTime)),
          ),
        ),
      ),
    );
  }
}

class Api {
  String? dateTime;

  Future<String> getDateAndTime() {
    return Future.delayed(
            const Duration(seconds: 1), () => DateTime.now().toIso8601String())
        .then((value) {
      dateTime = value;
      return value;
    });
  }
}

class ApiProvider extends InheritedWidget {
  final Api api;
  final String uuid;

  ApiProvider({Key? key, required this.api, required Widget child})
      : uuid = const Uuid().v4(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant ApiProvider oldWidget) {
    return uuid != oldWidget.uuid;
  }

  static ApiProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ApiProvider>()!;
  }
}

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final api = ApiProvider.of(context).api;
    return Text(api.dateTime ?? 'Default value');
  }
}
