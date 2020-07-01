import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wallpapers/providers/settings_provider.dart';
import 'package:wallpapers/providers/wallpaper_providers.dart';
import 'package:wallpapers/screens/SingleWallpaper.dart';

class PopularWallpapers extends StatefulWidget {
  @override
  _PopularWallpapersState createState() => _PopularWallpapersState();
}

class _PopularWallpapersState extends State<PopularWallpapers> {
  ScrollController _scrollController;

  var wallpapersProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    Future.delayed(Duration.zero, () {
      Provider.of<WallpapersProvider>(context, listen: false)
          .fetchWallpapers('popular');
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Provider.of<WallpapersProvider>(context, listen: false)
            .fetchMoreWallpapers('popular');
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
    var settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: wallpapersProvider.popularWallpapers.length == 0
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ))
            : RefreshIndicator(
                color: Theme.of(context).bottomAppBarColor,
                onRefresh: () => wallpapersProvider.fetchWallpapers('popular'),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                  child: new StaggeredGridView.countBuilder(
                    key: PageStorageKey('popularwallpaper'),
                    controller: _scrollController,
                    crossAxisCount: 4,
                    itemCount: wallpapersProvider.popularWallpapers.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index ==
                              wallpapersProvider.popularWallpapers.length - 1 &&
                          wallpapersProvider.nextPageAvailablePopular) {
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
                                wallpapersProvider.popularWallpapers[index]),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: settingsProvider.loadHQImages == true
                                ? wallpapersProvider
                                    .popularWallpapers[index].fullWallpaperUrl
                                : wallpapersProvider
                                    .popularWallpapers[index].previewWallpaper,
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
                        ),
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
