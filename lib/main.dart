import 'package:flutter/material.dart';
import 'package:learn_flutter_testing/pages/tabs.dart';
import 'package:learn_flutter_testing/providers/some_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => SomeProvider('given value string'),
          )
        ],
        child: Tabs(
          title: 'Flutter Demo Home Page',
        ),
      ),
    );
  }
}
