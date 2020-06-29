import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wallpapers/providers/wallpaper_providers.dart';
import 'package:wallpapers/screens/LatestWallpapers.dart';
import 'package:wallpapers/screens/PopularWallpapers.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallpapers App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.wb_sunny),
            onPressed: null,
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[LatestWallpapers(), PopularWallpapers()],
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });

          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.new_releases), title: Text("Latest")),
          BottomNavigationBarItem(
              icon: Icon(Icons.trending_up), title: Text("Popular")),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          _pageController.jumpToPage(
            index,
          );
        },
      ),
    );
  }
}