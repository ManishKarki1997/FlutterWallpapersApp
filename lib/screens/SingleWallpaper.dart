import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:provider/provider.dart';
import 'package:wallpapers/models/Wallpaper.dart';
import 'package:wallpapers/providers/wallpaper_providers.dart';

class SingleWallpaper extends StatefulWidget {
  @override
  _SingleWallpaperState createState() => _SingleWallpaperState();
  final Wallpaper wallpaper;
  SingleWallpaper(this.wallpaper);
}

class _SingleWallpaperState extends State<SingleWallpaper> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1000), () {
      var wallpapersProvider =
          Provider.of<WallpapersProvider>(context, listen: false);
      wallpapersProvider.fetchSimilarWallpapers(widget.wallpaper.wallpaperId);
    });
  }

  void _downloadImage() async {
    await ImageDownloader.downloadImage(widget.wallpaper.fullWallpaperUrl);
  }

  @override
  Widget build(BuildContext context) {
    var wallpapersProvider = Provider.of<WallpapersProvider>(context);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GestureDetector(
            onDoubleTap: _downloadImage,
            child: CachedNetworkImage(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              imageUrl: widget.wallpaper.fullWallpaperUrl,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Container(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          DraggableScrollableSheet(
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).bottomAppBarColor,
                  borderRadius: BorderRadius.circular(32.0),
                ),
                child: new StaggeredGridView.countBuilder(
                  key: PageStorageKey('latestwallpaper'),
                  controller: scrollController,
                  crossAxisCount: 4,
                  itemCount: wallpapersProvider.similarWallpapers.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (wallpapersProvider.loadingSimilarWallpapers) {
                      return Center(
                        child: Container(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      );
                    }

                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SingleWallpaper(
                              wallpapersProvider.similarWallpapers[index]),
                        ),
                      ),
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            imageUrl: wallpapersProvider
                                .similarWallpapers[index].previewWallpaper,
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
                            errorWidget: (context, url, error) => Icon(
                              Icons.error,
                              color: Theme.of(context).accentColor,
                            ),
                            fadeOutDuration: const Duration(seconds: 1),
                            fadeInDuration: const Duration(seconds: 2),
                          ),
                        ),
                      ),
                    );
                  },
                  staggeredTileBuilder: (int index) =>
                      new StaggeredTile.count(2, index.isEven ? 2.4 : 1.8),
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
              );
            },
            maxChildSize: 0.9,
            minChildSize: 0.1,
            initialChildSize: 0.1,
          ),
        ],
      ),
    );
  }
}
