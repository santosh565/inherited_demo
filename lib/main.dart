import 'dart:math' show Random;

import 'package:flutter/material.dart';

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
      home: const MyHomePage(),
    );
  }
}

enum AvailableColors { one, two }

class AvailableColorsModel extends InheritedModel<AvailableColors> {
  final MaterialColor color1, color2;

  const AvailableColorsModel(
      {Key? key,
      required this.color1,
      required this.color2,
      required Widget child})
      : super(
          key: key,
          child: child,
        );

  static AvailableColorsModel of(BuildContext context, AvailableColors aspect) {
    return InheritedModel.inheritFrom<AvailableColorsModel>(context,
        aspect: aspect)!;
  }

  @override
  bool updateShouldNotify(covariant AvailableColorsModel oldWidget) {
    return color1 != oldWidget.color1 || color2 != oldWidget.color2;
  }

  @override
  bool updateShouldNotifyDependent(covariant AvailableColorsModel oldWidget,
      Set<AvailableColors> dependencies) {
    if (dependencies.contains(AvailableColors.one) &&
        color1 != oldWidget.color1) {
      return true;
    }
    if (dependencies.contains(AvailableColors.two) &&
        color2 != oldWidget.color2) {
      return true;
    }
    return false;
  }
}

class ColorWidget extends StatelessWidget {
  final AvailableColors color;
  const ColorWidget({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = AvailableColorsModel.of(context, color);
    return Container(
      height: 100,
      color: color == AvailableColors.one ? provider.color1 : provider.color2,
    );
  }
}

final colors = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.pink,
  Colors.cyan,
  Colors.teal,
  Colors.indigo,
  Colors.lime,
  Colors.lightGreen,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
];

extension RandomElememnt<T> on Iterable<T> {
  T randomElement() => elementAt(Random().nextInt(length));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var color1 = Colors.red;
  var color2 = Colors.green;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Default value'),
      ),
      body: AvailableColorsModel(
        color1: color1,
        color2: color2,
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        color1 = colors.randomElement();
                      });
                    },
                    child: const Text('Change color1')),
                TextButton(
                  onPressed: () {
                    setState(() {
                      color2 = colors.randomElement();
                    });
                  },
                  child: const Text('Change color2'),
                ),
              ],
            ),
            const ColorWidget(color: AvailableColors.one),
            const ColorWidget(color: AvailableColors.two),
          ],
        ),
      ),
      // AvailableColorsModel(
    );
  }
}
