import 'package:flutter/material.dart';
import 'package:learn_flutter_testing/providers/some_provider.dart';
import 'package:provider/provider.dart';

class AppText extends StatefulWidget {
  const AppText();

  @override
  _AppTextState createState() => _AppTextState();
}

class _AppTextState extends State<AppText> {
  @override
  Widget build(BuildContext context) {
    SomeProvider p = Provider.of(context);
    return Text(p.someValue);
  }
}
