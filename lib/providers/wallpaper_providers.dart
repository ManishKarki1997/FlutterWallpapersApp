import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpapers/models/Wallpaper.dart';

class WallpapersProvider with ChangeNotifier {
  List<Wallpaper> _wallpapers = [];
  List<Wallpaper> _popularWallpapers = [];
  List<Wallpaper> _similarWallpapers = [];

  int popularPageIndex = 1;
  int latestPageIndex = 1;
  bool nextPageExists;
  bool nextPageExistsPopular;
  bool similarWallpapersLoading;

// ------------ Getters ------------
  List<Wallpaper> get wallpapers => _wallpapers;
  List<Wallpaper> get popularWallpapers => _popularWallpapers;
  List<Wallpaper> get similarWallpapers => _similarWallpapers;

  bool get nextPageAvailable => nextPageExists;
  bool get nextPageAvailablePopular => nextPageExistsPopular;
  bool get loadingSimilarWallpapers => similarWallpapersLoading;

// ------------ End Getters ------------

  Future<void> fetchWallpapers(String filter) async {
    String url =
        "http://192.168.1.111:3000/api/wallpaper?page=0&count=20&sortByDate=latest&filter=$filter";

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      var walls = (body['payload']['wallpapers'] as List)
          .map((dynamic wall) => Wallpaper.fromJson(wall))
          .toList();

      if (filter == 'popular') {
        nextPageExistsPopular = body['payload']['next'];
      } else {
        nextPageExists = body['payload']['next'];
      }

      setWallpapers(walls, filter);
      notifyListeners();
    } else {
      // throw Exception('no response');
      print("No response");
    }
  }

  void fetchMoreWallpapers(String filter) async {
    if (filter == 'popular' && !nextPageExistsPopular) {
      print('next page does not exist. returning...');
      return;
    } else if (filter == 'latest' && !nextPageExists) {
      print('next page does not exist. returning...');
      return;
    }

    String url;
    url = filter == 'popular'
        ? "http://192.168.1.111:3000/api/wallpaper?page=$popularPageIndex&count=10&sortByDate=latest&filter=$filter"
        : "http://192.168.1.111:3000/api/wallpaper?page=$latestPageIndex&count=10&sortByDate=latest&filter=$filter";

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      filter == 'popular' ? popularPageIndex++ : latestPageIndex++;

      var walls = (body['payload']['wallpapers'] as List)
          .map((dynamic wall) => Wallpaper.fromJson(wall))
          .toList();

      filter == 'popular'
          ? nextPageExistsPopular = body['payload']['next']
          : nextPageExists = body['payload']['next'];

      _wallpapers.addAll(walls);
      setWallpapers(_wallpapers, filter);
      notifyListeners();
    } else {
      print("No response");
    }
  }

  Future<void> fetchSimilarWallpapers(String wallpaperId) async {
    String url = "http://192.168.1.111:3000/api/wallpaper/similar/$wallpaperId";

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      var walls = (body['payload']['similarWallpapers'] as List)
          .map((dynamic wall) => Wallpaper.fromJson(wall))
          .toList();

      similarWallpapersLoading = false;
      setSimilarWallpapers(walls);
      notifyListeners();
    } else {
      // throw Exception('no response');
      print("No response");
    }
  }

  void setWallpapers(List<Wallpaper> walls, String filter) {
    if (filter == 'popular') {
      _popularWallpapers = walls;
    } else {
      _wallpapers = walls;
    }
    // _wallpapers = walls;
    notifyListeners();
  }

  void setSimilarWallpapers(List<Wallpaper> walls) {
    _similarWallpapers = walls;

    notifyListeners();
  }
}
