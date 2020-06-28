import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpapers/models/Wallpaper.dart';

class WallpapersProvider with ChangeNotifier {
  List<Wallpaper> _wallpapers = [];

  List<Wallpaper> get wallpapers => _wallpapers;

  void fetchWallpapers() async {
    final response = await http.get('http://192.168.1.111:3000/api/wallpaper');

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      var walls = (body['payload']['wallpapers'] as List)
          .map((dynamic wall) => Wallpaper.fromJson(wall))
          .toList();

      setWallpapers(walls);
      notifyListeners();
    } else {
      print("No response");
    }
  }

  void setWallpapers(List<Wallpaper> walls) {
    // print(walls);
    _wallpapers = walls;
    notifyListeners();
  }
}
