import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wallpapers/providers/wallpaper_providers.dart';
import 'package:wallpapers/screens/SingleWallpaper.dart';

class SingleCategory extends StatefulWidget {
  @override
  _SingleCategoryState createState() => _SingleCategoryState();

  final int categoryId;
  SingleCategory(this.categoryId);
}

class _SingleCategoryState extends State<SingleCategory> {
  ScrollController _scrollController;

  var wallpapersProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    Future.delayed(Duration.zero, () {
      Provider.of<WallpapersProvider>(context, listen: false)
          .fetchCategoryWallpapers(widget.categoryId);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Provider.of<WallpapersProvider>(context, listen: false)
            .fetchMoreCategoryWallpapers(widget.categoryId);
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
        child: wallpapersProvider.loadingCategoryWallpapers == true
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ))
            : wallpapersProvider.categoryWallpapers.length == 0 &&
                    wallpapersProvider.loadingCategoryWallpapers == false
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "No wallpapers available right now for this category.",
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 20.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        RaisedButton(
                          color: Theme.of(context).highlightColor,
                          child: Text(
                            "Return",
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 16.0,
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => wallpapersProvider
                        .fetchMoreCategoryWallpapers(widget.categoryId),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                      child: StaggeredGridView.countBuilder(
                        key: PageStorageKey('latestwallpaper'),
                        controller: _scrollController,
                        crossAxisCount: 4,
                        itemCount: wallpapersProvider.categoryWallpapers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleWallpaper(
                                    wallpapersProvider
                                        .categoryWallpapers[index]),
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                // image: DecorationImage(
                                //     image: NetworkImage(wallpapersProvider
                                //         .wallpapers[index].previewWallpaper),
                                //     fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: wallpapersProvider
                                    .categoryWallpapers[index].previewWallpaper,
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
