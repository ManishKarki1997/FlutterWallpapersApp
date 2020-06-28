import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wallpapers/models/Wallpaper.dart';

Future<List<Wallpaper>> fetchWallpapers() async {
  final response = await http.get('http://192.168.1.111:3000/api/wallpaper');

  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);

    print(body['payload']['wallpapers']);
    var wallpapers = body['payload']['wallpapers']
        .map((dynamic wall) => Wallpaper.fromJson(wall));

    return wallpapers;
  } else {
    throw Exception("Failed to fetch wallpapers");
  }
}
