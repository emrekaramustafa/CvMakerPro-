import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  static const _boxName = 'settings';
  static const _key = 'isDarkMode';

  bool _isDarkMode;

  ThemeProvider() : _isDarkMode = _loadInitial();

  static bool _loadInitial() {
    final box = Hive.box(_boxName);
    // Default to light mode (false = light)
    return box.get(_key, defaultValue: false) as bool;
  }

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final box = Hive.box(_boxName);
    await box.put(_key, _isDarkMode);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    final box = Hive.box(_boxName);
    await box.put(_key, value);
    notifyListeners();
  }
}
