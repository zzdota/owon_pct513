import 'package:flutter/material.dart';
import 'package:owon_pct513/owon_providers/theme_provider.dart';
import 'package:owon_pct513/res/owon_picture.dart';
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
      return TextStyle(color: OwonColor().getCurrent(context, "tabBarSelected"));
    } else {
      return TextStyle(
          color: OwonColor().getCurrent(context, "tabBarUnselected"));
    }
  }
  int myIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    myIndex = Provider.of<ThemeProvider>(context).themeIndex;

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
              icon:Image.asset(myIndex==0?(_currentIndex==0?OwonPic.theSelBlack:OwonPic.theUnSelBlack):(_currentIndex==0?OwonPic.theSelWhite:OwonPic.theUnSelWhite),
                  width:_currentIndex == 0 ? 35.0 : 30.0),
          ),
          BottomNavigationBarItem(
              title: Text(
                "Setting",
                style: getStyleWithIndex(1),
              ),
            icon:Image.asset(myIndex==0?(_currentIndex==1?OwonPic.settingSelBlack:OwonPic.settingUnSelBlack):(_currentIndex==1?OwonPic.settingSelWhite:OwonPic.settingUnSelWhite),
                width:_currentIndex == 1 ? 35.0 : 30.0),
          ),
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
