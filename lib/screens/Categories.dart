import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpapers/screens/SingleCategory.dart';
import 'package:wallpapers/screens/SingleWallpaper.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<dynamic> categoriesList = [
    {
      "name": "Minimalism",
      "tagId": "227",
      "wallpaperUrl": "https://w.wallhaven.cc/full/w8/wallhaven-w8jdkr.jpg"
    },
    {
      "name": "Sci-fi",
      "tagId": "14",
      "wallpaperUrl": "https://w.wallhaven.cc/full/48/wallhaven-48zjo2.jpg",
    },
    {
      "name": "Anime",
      "tagId": "5",
      "wallpaperUrl": "https://w.wallhaven.cc/full/lm/wallhaven-lm8xjp.png"
    },
    {
      "name": "Landscape",
      "tagId": "711",
      "wallpaperUrl": "https://w.wallhaven.cc/full/mp/wallhaven-mpjpvm.jpg",
    },
    {
      "name": "Fantasy",
      "tagId": "853",
      "wallpaperUrl": "https://w.wallhaven.cc/full/43/wallhaven-432vlv.jpg",
    },
    {
      "name": "Video Games",
      "tagId": "55",
      "wallpaperUrl": "https://w.wallhaven.cc/full/01/wallhaven-01egg3.jpg",
    },
    {
      "name": "Space",
      "tagId": "32",
      "wallpaperUrl": "https://w.wallhaven.cc/full/nm/wallhaven-nm3ddy.jpg",
    },
    {
      "name": "Dark",
      "tagId": "369",
      "wallpaperUrl": "https://w.wallhaven.cc/full/95/wallhaven-95jq7d.jpg",
    },
    {
      "name": "Drawing",
      "tagId": "1540",
      "wallpaperUrl": "https://w.wallhaven.cc/full/kw/wallhaven-kwz6r6.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: ListView.separated(
          key: PageStorageKey('categories'),
          // crossAxisCount: 4,
          itemCount: categoriesList.length,
          separatorBuilder: (_, i) => Divider(),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SingleCategory(int.parse(categoriesList[index]['tagId'])),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      height: 300.0,
                      width: MediaQuery.of(context).size.width,
                      child: Opacity(
                        opacity: 0.4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            imageUrl: categoriesList[index]['wallpaperUrl'],
                            colorBlendMode: BlendMode.darken,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                              child: Container(
                                height: 20.0,
                                width: 20.0,
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fadeOutDuration: const Duration(seconds: 1),
                            fadeInDuration: const Duration(seconds: 3),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 140,
                      child: Text(
                        categoriesList[index]['name'],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 36.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                // height: 300.0,
                // width: MediaQuery.of(context).size.width,
              ),
            );
          },
          // staggeredTileBuilder: (int index) => new StaggeredTile.count(3, 2),
          // mainAxisSpacing: 6.0,
          // crossAxisSpacing: 0.0,
        ),
      ),
    );
  }
}
