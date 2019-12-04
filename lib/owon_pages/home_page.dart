import 'package:flutter/material.dart';
import 'list_pages/list_page.dart';
import 'setting_pages/setting_page.dart';
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List<Widget> tempList = [
    ListPage(),
    SettingPage(),
  ];
  int _currentIndex = 0;

  TextStyle getStyleWithIndex(int idx) {
    if (idx == _currentIndex) {
      return TextStyle(color: Colors.white);
    } else {
      return TextStyle(color: Colors.grey);
    }
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
        backgroundColor: Color.fromARGB(255, 28, 28, 28),
        items: [
          BottomNavigationBarItem(
              title: Text(
                "List",
                style: getStyleWithIndex(0),
              ),
              icon: Icon(Icons.home,size: _currentIndex==0?35.0:30.0,color:_currentIndex==0? Colors.white:Colors.grey,)),
          BottomNavigationBarItem(
              title: Text(
                "Setting",
                style: getStyleWithIndex(1),
              ),
              icon: Icon(Icons.score,size: _currentIndex==1?35.0:30.0,color:_currentIndex==1? Colors.white:Colors.grey,)),
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
