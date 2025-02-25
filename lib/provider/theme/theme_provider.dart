import 'package:flutter/material.dart';
import 'package:restauran_submission_1/services/shared_preferences_service.dart';

class ThemeProvider extends ChangeNotifier {
  final SharedPreferencesService _service;
  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider(this._service) {
    _themeMode = _service.getTheme() == ThemeMode.dark.name
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    _service.setTheme(_themeMode.name);
    notifyListeners();
  }
}
