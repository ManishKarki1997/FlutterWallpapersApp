import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _darkThemePreferred = true;
  bool _loadHQImages = false;
  bool _preferFloatingNavigationBar = false;

  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    primaryColor: Colors.grey.shade100,
    accentColor: Colors.black,
    bottomAppBarColor: Colors.black,
    highlightColor: Color(0xff4182ff),
    textSelectionColor: Color(0xff6A7198),
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    primaryColor: Color(0xff010c1c),
    accentColor: Colors.white,
    bottomAppBarColor: Color(0xff14182b),
    highlightColor: Color(0xff4182ff),
    textSelectionColor: Color(0xff6A7198),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  ThemeData activeTheme = darkTheme;

  bool get darkThemePreferred => _darkThemePreferred;
  bool get loadHQImages => _loadHQImages;
  bool get preferFloatingNavigationBar => _preferFloatingNavigationBar;
  ThemeData get currentTheme => activeTheme;

  void setDarkThemePreferred(bool value) {
    _darkThemePreferred = value;
    notifyListeners();
  }

  void setLoadHQImages(bool value) {
    _loadHQImages = value;
    notifyListeners();
  }

  void setPreferFloatingNavigationBar(bool value) {
    _preferFloatingNavigationBar = value;
    notifyListeners();
  }

  void toggleTheme() {
    activeTheme = currentTheme == darkTheme ? lightTheme : darkTheme;
    _darkThemePreferred = currentTheme == darkTheme ? true : false;
    notifyListeners();
  }
}
