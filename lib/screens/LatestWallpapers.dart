import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wallpapers/providers/wallpaper_providers.dart';

class LatestWallpapers extends StatefulWidget {
  @override
  _LatestWallpapersState createState() => _LatestWallpapersState();
}

class _LatestWallpapersState extends State<LatestWallpapers> {
  ScrollController _scrollController;

  var wallpapersProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    Future.delayed(Duration.zero, () {
      Provider.of<WallpapersProvider>(context, listen: false)
          .fetchWallpapers('latest');
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Provider.of<WallpapersProvider>(context, listen: false)
            .fetchMoreWallpapers('latest');
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

    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: wallpapersProvider.wallpapers.length == 0
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ))
            : RefreshIndicator(
                onRefresh: () => wallpapersProvider.fetchWallpapers('latest'),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                  child: new StaggeredGridView.countBuilder(
                    controller: _scrollController,
                    crossAxisCount: 4,
                    itemCount: wallpapersProvider.wallpapers.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == wallpapersProvider.wallpapers.length - 1 &&
                          wallpapersProvider.nextPageAvailable) {
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
                      return Container(
                        decoration: BoxDecoration(
                          // image: DecorationImage(
                          //     image: NetworkImage(wallpapersProvider
                          //         .wallpapers[index].previewWallpaper),
                          //     fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: wallpapersProvider
                              .wallpapers[index].previewWallpaper,
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
                        ),
                        // height: 300.0,
                        // width: MediaQuery.of(context).size.width,
                      );
                    },
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.count(2, index.isEven ? 3 : 2),
                    mainAxisSpacing: 6.0,
                    crossAxisSpacing: 6.0,
                  ),
                ),
              ),
      ),
    );
  }
}
