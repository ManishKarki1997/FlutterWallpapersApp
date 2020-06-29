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
          primaryColor: Color(0xff1E1E1E),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Home(),
      ),
    );
  }
}
