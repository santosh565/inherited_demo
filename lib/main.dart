import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

String currentDateTime() => DateTime.now().toIso8601String();

@immutable
class Seconds {
  final String value;
  Seconds() : value = currentDateTime();
}

@immutable
class Minutes {
  final String value;
  Minutes() : value = currentDateTime();
}



class SecondsWidget extends StatelessWidget {
  const SecondsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final seconds = context.watch<Seconds>();
    return Expanded(
        child: Container(
      height: 100,
      color: Colors.yellow,
      child: Text(seconds.value),
    ));
  }
}

class MinutesWidget extends StatelessWidget {
  const MinutesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minutes = context.watch<Minutes>();
    return Expanded(
        child: Container(
      height: 100,
      color: Colors.blue,
      child: Text(minutes.value),
    ));
  }
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
      home: const MyHomePage(),
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
      body: MultiProvider(
        providers: [
          StreamProvider.value(
            value: Stream<Seconds>.periodic(
                const Duration(seconds: 1), (_) => Seconds()),
            initialData: Seconds(),
          ),
          StreamProvider.value(
            value: Stream<Minutes>.periodic(
                const Duration(seconds: 5), (_) => Minutes()),
            initialData: Minutes(),
          ),
        ],
        child: Column(
          children: [
            Row(
              children: const [
                SecondsWidget(),
                MinutesWidget(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
