import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpapers/providers/wallpaper_providers.dart';
import 'package:wallpapers/screens/Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WallpapersProvider>(
      create: (BuildContext context) => WallpapersProvider(),
      child: MaterialApp(
        title: 'Wallpapers App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          primaryColor: Color(0xff010c1c),
          accentColor: Colors.white,
          bottomAppBarColor: Color(0xff14182b),
          highlightColor: Color(0xff4182ff),
          // 4182ff
          textSelectionColor: Color(0xff6A7198),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Home(),
      ),
    );
  }
}
