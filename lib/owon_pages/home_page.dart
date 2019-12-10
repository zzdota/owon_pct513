import 'package:flutter/material.dart';
import 'package:owon_pct513/owon_providers/theme_provider.dart';
import 'package:provider/provider.dart';
import '../res/owon_themeColor.dart';
import 'list_pages/list_page.dart';
import 'setting_pages/setting_page.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
//  int index;
  List<Widget> tempList = [
    ListPage(),
    SettingPage(),
  ];
  int _currentIndex = 0;

  TextStyle getStyleWithIndex(int idx) {
    if (idx == _currentIndex) {
      return TextStyle(color: OwonColor().getCurrent(context, "textColor"));
    } else {
      return TextStyle(
          color: OwonColor().getCurrent(context, "tabBarUnselected"));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      body: this.tempList[_currentIndex],
      body: IndexedStack(
        index: _currentIndex,
        children: this.tempList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: OwonColor().getCurrent(context, "itemColor"),
        items: [
          BottomNavigationBarItem(
              title: Text(
                "List",
                style: getStyleWithIndex(0),
              ),
              icon: Icon(
                Icons.home,
                size: _currentIndex == 0 ? 35.0 : 30.0,
                color: _currentIndex == 0
                    ? OwonColor().getCurrent(context, "textColor")
                    : OwonColor().getCurrent(context, "tabBarUnselected"),
              )),
          BottomNavigationBarItem(
              title: Text(
                "Setting",
                style: getStyleWithIndex(1),
              ),
              icon: Icon(Icons.settings,
                  size: _currentIndex == 1 ? 35.0 : 30.0,
                  color: _currentIndex == 1
                      ? OwonColor().getCurrent(context, "textColor")
                      : OwonColor().getCurrent(context, "tabBarUnselected"))),
        ],
        currentIndex: _currentIndex,
        onTap: (idx) {
          print("------$idx");

          setState(() {
            _currentIndex = idx;
          });
        },
        fixedColor: Theme.of(context).primaryColor,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
