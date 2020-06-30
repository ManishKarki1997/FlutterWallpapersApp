import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wallpapers/providers/wallpaper_providers.dart';
import 'package:wallpapers/screens/Categories.dart';
import 'package:wallpapers/screens/LatestWallpapers.dart';
import 'package:wallpapers/screens/PopularWallpapers.dart';
import 'package:wallpapers/screens/Settings.dart';

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
            icon: Icon(
              Icons.wb_sunny,
              color: Theme.of(context).accentColor,
            ),
            onPressed: null,
          )
        ],
        elevation: 0,
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          Categories(),
          LatestWallpapers(),
          PopularWallpapers(),
          Settings(),
        ],
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
            icon: Icon(Icons.category),
            title: Text("Categories"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases),
            title: Text("Latest"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            title: Text("Popular"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text("Settings"),
          ),
        ],
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Theme.of(context).bottomAppBarColor,
        selectedItemColor: Theme.of(context).highlightColor,
        unselectedItemColor: Theme.of(context).textSelectionColor,
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
