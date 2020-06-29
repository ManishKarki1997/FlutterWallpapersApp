import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpapers/models/Wallpaper.dart';

class WallpapersProvider with ChangeNotifier {
  List<Wallpaper> _wallpapers = [];
  int pageIndex = 1;
  bool nextPageExists;

  List<Wallpaper> get wallpapers => _wallpapers;
  bool get nextPageAvailable => nextPageExists;

  Future<void> fetchWallpapers() async {
    final response = await http.get('http://192.168.1.111:3000/api/wallpaper');
    // final response = await http.get(
    // 'http://192.168.1.111:3000/api/wallpaper?page=$pageIndex&count=10&sortByDate=latest');

    if (response.statusCode == 200) {
      print('refreshing');
      var body = jsonDecode(response.body);

      var walls = (body['payload']['wallpapers'] as List)
          .map((dynamic wall) => Wallpaper.fromJson(wall))
          .toList();

      nextPageExists = body['payload']['next'];

      setWallpapers(walls);
      notifyListeners();
    } else {
      // throw Exception('no response');
      print("No response");
    }
  }

  void fetchMoreWallpapers() async {
    if (!nextPageExists) {
      print('next page does not exist. returning...');
      return;
    }
    final response = await http.get(
        'http://192.168.1.111:3000/api/wallpaper?page=${pageIndex + 1}&count=10&sortByDate=latest');

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      pageIndex++;

      var walls = (body['payload']['wallpapers'] as List)
          .map((dynamic wall) => Wallpaper.fromJson(wall))
          .toList();

      nextPageExists = body['payload']['next'];

      _wallpapers.addAll(walls);
      setWallpapers(_wallpapers);
      notifyListeners();
    } else {
      print("No response");
    }
  }

  void setWallpapers(List<Wallpaper> walls) {
    _wallpapers = walls;
    notifyListeners();
  }
}
