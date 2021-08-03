import 'package:flutter/cupertino.dart';

class SomeProvider with ChangeNotifier {
  String someValue = 'thing';
  SomeProvider(String _someValue) {
    someValue = _someValue;
    notifyListeners();
    return;
  }
}
