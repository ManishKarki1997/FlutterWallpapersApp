import 'package:flutter/cupertino.dart';
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
  ScrollController _scrollController;

  var wallpapersProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    Future.delayed(Duration.zero, () {
      Provider.of<WallpapersProvider>(context, listen: false).fetchWallpapers();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Provider.of<WallpapersProvider>(context, listen: false)
            .fetchMoreWallpapers();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var wallpapersProvider = Provider.of<WallpapersProvider>(context);
    // wallpapersProvider.fetchWallpapers();

    return Scaffold(
      appBar: AppBar(
        title: Text('Wallpapers App'),
      ),
      body: Container(
        child: wallpapersProvider.wallpapers.length == 0
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ))
            : ListView.builder(
                controller: _scrollController,
                itemBuilder: (BuildContext context, int index) {
                  if (index == wallpapersProvider.wallpapers.length - 1 &&
                      wallpapersProvider.nextPageAvailable) {
                    return CupertinoActivityIndicator();
                  }
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(wallpapersProvider
                              .wallpapers[index].previewWallpaper),
                          fit: BoxFit.cover),
                    ),
                    height: 300.0,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                  );
                },
                itemCount: wallpapersProvider.wallpapers.length,
              ),
      ),
    );
  }
}
