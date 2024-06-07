
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorThemeData with ChangeNotifier {
  static late SharedPreferences _sharedPreferences;
  bool isGreen = true;

  final ThemeData blueAccentTheme = _buildThemeData(Color(0xff121212));
  final ThemeData amberAccentTheme = _buildThemeData(Color(0xff00BFFF));

  static ThemeData _buildThemeData(Color color) {
    return ThemeData.from(
      useMaterial3: true,
      textTheme: const TextTheme(
        titleMedium: TextStyle(color: Colors.white),
        displaySmall: TextStyle(color: Colors.white),
      ),
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: color,
        onPrimary: Colors.white,
        secondary: Colors.white,
        onSecondary: Colors.white,
        error: Colors.white,
        onError: color,
        background: color,
        onBackground: Colors.white,
        surface: color,
        onSurface: Colors.white,
      ),
    );
  }

  ThemeData get selectedThemeData {
    return isGreen ? blueAccentTheme : amberAccentTheme;
  }

  Future<void> createSharedPref() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void switchTheme(bool selected) {
    isGreen = selected;
    saveTheme(selected);
    notifyListeners();
  }

  void saveTheme(bool value) {
    _sharedPreferences.setBool('themeData', value);
  }

  Future<void> loadTheme() async {
    await createSharedPref();
    isGreen = _sharedPreferences.getBool('themeData') ?? true;
  }
}
