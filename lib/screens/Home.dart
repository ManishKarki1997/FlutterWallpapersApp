import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpapers/providers/settings_provider.dart';
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
    var settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallpapers App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.wb_sunny,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () => settingsProvider.toggleTheme(),
          )
        ],
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          PageView(
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
          Positioned(
            left: 0,
            right: 0,
            bottom: settingsProvider.preferFloatingNavigationBar ? 30 : 0,
            // bottom: 0,
            // child: bottomNavigationBar,
            child: settingsProvider.preferFloatingNavigationBar
                ? bottomNavigationBar
                : Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Theme.of(context).bottomAppBarColor,
                      primaryColor: Theme.of(context).bottomAppBarColor,
                    ),
                    child: BottomNavigationBar(
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
                  ),
          ),
        ],
      ),
      // bottomNavigationBar: Theme(
      //   data: Theme.of(context).copyWith(
      //     canvasColor: Theme.of(context).bottomAppBarColor,
      //     primaryColor: Theme.of(context).bottomAppBarColor,
      //   ),
      //   child: BottomNavigationBar(
      //     items: const <BottomNavigationBarItem>[
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.category),
      //         title: Text("Categories"),
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.new_releases),
      //         title: Text("Latest"),
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.trending_up),
      //         title: Text("Popular"),
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.settings),
      //         title: Text("Settings"),
      //       ),
      //     ],
      //     currentIndex: _selectedIndex,
      //     showSelectedLabels: false,
      //     showUnselectedLabels: false,
      //     backgroundColor: Theme.of(context).bottomAppBarColor,
      //     selectedItemColor: Theme.of(context).highlightColor,
      //     unselectedItemColor: Theme.of(context).textSelectionColor,
      //     onTap: (int index) {
      //       setState(() {
      //         _selectedIndex = index;
      //       });
      //       _pageController.jumpToPage(
      //         index,
      //       );
      //     },
      //   ),
      // ),
    );
  }

  Widget get bottomNavigationBar {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Theme.of(context).bottomAppBarColor,
            primaryColor: Theme.of(context).bottomAppBarColor,
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), title: Text('Categories')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.new_releases), title: Text('Latest')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.trending_up), title: Text('Popular')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), title: Text('Settings')),
            ],
            currentIndex: _selectedIndex,
            backgroundColor: Theme.of(context).bottomAppBarColor,
            selectedItemColor: Theme.of(context).highlightColor,
            unselectedItemColor: Theme.of(context).textSelectionColor,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
              _pageController.jumpToPage(
                index,
              );
            },
          ),
        ),
      ),
    );
  }
}
