import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool darkModePreferred = true;
  bool loadHQImages = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Dark theme preferred",
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
                Switch(
                  value: darkModePreferred,
                  activeTrackColor: Theme.of(context).textSelectionColor,
                  activeColor: Theme.of(context).highlightColor,
                  inactiveTrackColor: Theme.of(context).textSelectionColor,
                  onChanged: (value) {
                    setState(() {
                      darkModePreferred = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Load high quality wallpapers",
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
                Switch(
                  value: loadHQImages,
                  activeTrackColor: Theme.of(context).textSelectionColor,
                  activeColor: Theme.of(context).highlightColor,
                  inactiveTrackColor: Theme.of(context).textSelectionColor,
                  onChanged: (value) {
                    setState(() {
                      loadHQImages = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
