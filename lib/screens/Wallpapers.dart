import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpapers/models/Wallpaper.dart';
import 'package:wallpapers/providers/wallpaper_providers.dart';
import 'package:wallpapers/services/fetchWallpapers.dart';

class WallpapersHome extends StatefulWidget {
  @override
  _WallpapersHomeState createState() => _WallpapersHomeState();
}

class _WallpapersHomeState extends State<WallpapersHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var wallpapersProvider = Provider.of<WallpapersProvider>(context);
    wallpapersProvider.fetchWallpapers();
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: wallpapersProvider.wallpapers.length == 0
              ? Text(
                  "Hello",
                  style: TextStyle(
                      color: Colors.black, decoration: TextDecoration.none),
                )
              : Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        wallpapersProvider.wallpapers[0].fullWallpaperUrl,
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
