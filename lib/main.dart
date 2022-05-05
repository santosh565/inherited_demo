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

final sliderData = SliderData();

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
      body: SliderNotifier(
        sliderData: sliderData,
        child: Builder(builder: (context) {
          return Column(
            children: [
              Slider(
                  value: SliderNotifier.of(context),
                  onChanged: (value) {
                    sliderData.value = value;
                  }),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Opacity(
                      opacity: SliderNotifier.of(context),
                      child: Container(
                        height: 150,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Opacity(
                      opacity: SliderNotifier.of(context),
                      child: Container(
                        height: 150,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        }),
      ),
    );
  }
}

class SliderData extends ChangeNotifier {
  double _value = 0;
  double get value => _value;

  set value(double value) {
    if (_value != value) {
      _value = value;
      notifyListeners();
    }
  }
}

class SliderNotifier extends InheritedNotifier<SliderData> {
  const SliderNotifier({
    Key? key,
    required SliderData sliderData,
    required Widget child,
  }) : super(
          key: key,
          child: child,
          notifier: sliderData,
        );

  static double of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<SliderNotifier>()
          ?.notifier
          ?.value ??
      0.0;
}
