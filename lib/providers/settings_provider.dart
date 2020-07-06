import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    activeTheme = _darkThemePreferred ? darkTheme : lightTheme;
    notifyListeners();
    savePreferences();
  }

  void setLoadHQImages(bool value) {
    _loadHQImages = value;
    notifyListeners();
    savePreferences();
  }

  void setPreferFloatingNavigationBar(bool value) {
    _preferFloatingNavigationBar = value;
    notifyListeners();
    savePreferences();
  }

  void toggleTheme() {
    activeTheme = currentTheme == darkTheme ? lightTheme : darkTheme;
    _darkThemePreferred = currentTheme == darkTheme ? true : false;
    savePreferences();
    notifyListeners();
  }

  void savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('wallpaperDarkThemePreferred', _darkThemePreferred);
    await prefs.setBool('wallpaperLoadHQImages', _loadHQImages);
    await prefs.setBool(
        'wallpaperFloatingNavigation', _preferFloatingNavigationBar);
  }

  void loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool darkThemeValue = prefs.getBool('wallpaperDarkThemePreferred');
    bool loadHQImagesValue = prefs.getBool('wallpaperLoadHQImages');
    bool wallpaperFloatNavigationValue =
        prefs.getBool('wallpaperFloatingNavigation');
    if (darkThemeValue != null) setDarkThemePreferred(darkThemeValue);
    if (loadHQImagesValue != null) setLoadHQImages(loadHQImagesValue);
    if (wallpaperFloatNavigationValue != null)
      setPreferFloatingNavigationBar(wallpaperFloatNavigationValue);
    notifyListeners();
  }

  clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
