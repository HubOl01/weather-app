import 'package:flutter/material.dart';

class WeatherTheme extends ChangeNotifier {
  bool _isDark = false;

  ThemeData get currentTheme => _isDark ? WeatherThemeData().createDarkTheme() : WeatherThemeData().createLightTheme();
  switchTheme(){
    _isDark = !_isDark;
    notifyListeners();
  }
}

class WeatherThemeData {
  ThemeData createTheme(Map<String, dynamic> colors) {
    return ThemeData(
        fontFamily: "Arial",
        brightness: colors["brightness"],
        scaffoldBackgroundColor: colors["scaffoldBackground"],
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: colors["fabColor"],
            foregroundColor: Colors.white));
  }

  createLightTheme() {
    return createTheme({
      "brightness": Brightness.light,
      "scaffoldBackground": Colors.white,
      "fabColor": Colors.blue,
    });
  }

  createDarkTheme() {
    return createTheme({
      "brightness": Brightness.dark,
      "scaffoldBackground": Colors.black,
      "fabColor": Colors.green,
    });
  }
}
