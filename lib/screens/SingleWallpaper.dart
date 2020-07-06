import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:provider/provider.dart';
import 'package:wallpapers/models/Wallpaper.dart';
import 'package:wallpapers/providers/settings_provider.dart';
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
    var settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GestureDetector(
            onDoubleTap: () => showAlertDialog(context),
            child: Hero(
              tag: widget.wallpaper.fullWallpaperUrl,
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
          ),
          DraggableScrollableSheet(
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).bottomAppBarColor,
                  borderRadius: BorderRadius.circular(32.0),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 60.0,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 40.0,
                                height: 40.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.wallpaper.uploaderAvatar !=
                                            null
                                        ? widget.wallpaper.uploaderAvatar
                                        : "https://w.wallhaven.cc/full/dg/wallhaven-dgrx2l.jpg",
                                    fit: BoxFit.cover,
                                    width: 40.0,
                                    height: 40.0,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                      child: Container(
                                        height: 20.0,
                                        width: 20.0,
                                        child: CircularProgressIndicator(
                                            backgroundColor:
                                                Theme.of(context).accentColor,
                                            value: downloadProgress.progress),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.wallpaper.uploaderName != null
                                        ? widget.wallpaper.uploaderName
                                        : "Unknown",
                                    style: TextStyle(
                                        color: settingsProvider
                                                .darkThemePreferred
                                            ? Theme.of(context).accentColor
                                            : Theme.of(context).primaryColor,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1),
                                  ),
                                  Text(
                                    "${widget.wallpaper.views.toString()} views",
                                    style: TextStyle(
                                        color:
                                            settingsProvider.darkThemePreferred
                                                ? Theme.of(context).accentColor
                                                : Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.7),
                                        fontSize: 14.0),
                                  )
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.file_download),
                            onPressed: _downloadImage,
                            color: settingsProvider.darkThemePreferred
                                ? Theme.of(context).accentColor
                                : Theme.of(context).primaryColor,
                          )
                        ],
                      ),
                    ),
                    if (wallpapersProvider.loadingSimilarWallpapers)
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    if (!wallpapersProvider.loadingSimilarWallpapers &&
                        wallpapersProvider.similarWallpapers.length == 0)
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            "No similar wallpapers found",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: settingsProvider.darkThemePreferred
                                  ? Theme.of(context).accentColor
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    if (!wallpapersProvider.loadingSimilarWallpapers &&
                        wallpapersProvider.similarWallpapers.length > 0)
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Similar Wallpapers",
                              style: TextStyle(
                                  color: settingsProvider.darkThemePreferred
                                      ? Theme.of(context).accentColor
                                      : Theme.of(context).primaryColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              flex: 1,
                              child: new StaggeredGridView.countBuilder(
                                shrinkWrap: true,
                                key: PageStorageKey('latestwallpaper'),
                                controller: scrollController,
                                crossAxisCount: 4,
                                itemCount:
                                    wallpapersProvider.similarWallpapers.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SingleWallpaper(
                                            wallpapersProvider
                                                .similarWallpapers[index]),
                                      ),
                                    ),
                                    child: Container(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: CachedNetworkImage(
                                          imageUrl: wallpapersProvider
                                              .similarWallpapers[index]
                                              .previewWallpaper,
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                            child: Container(
                                              height: 20.0,
                                              width: 20.0,
                                              child: CircularProgressIndicator(
                                                  value: downloadProgress
                                                      .progress),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                            Icons.error,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          fadeOutDuration:
                                              const Duration(seconds: 1),
                                          fadeInDuration:
                                              const Duration(seconds: 2),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                staggeredTileBuilder: (int index) =>
                                    new StaggeredTile.count(
                                        2, index.isEven ? 2.4 : 1.8),
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
            maxChildSize: 0.9,
            minChildSize: 0.2,
            initialChildSize: 0.25,
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
        child: Text("Cancel"), onPressed: () => Navigator.pop(context));
    Widget continueButton = FlatButton(
        child: Text("Download"),
        onPressed: () {
          _downloadImage();
          Navigator.pop(context);
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Download Wallpaper"),
      content: Text("Do you want to download the wallpaper?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
