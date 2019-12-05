import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  int _themeIndex = 0;

  int get themeIndex => _themeIndex;


  void setTheme(int index) async {
    _themeIndex = index;
    notifyListeners();
  }

}
