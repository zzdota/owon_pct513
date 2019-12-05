import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../owon_providers/theme_provider.dart';
class OwonColor {

  /* 主题列表 */
  static const Map _themeColor = {
    0: {
      //black
      "primaryColor": Color(0xff000000), //背景色
      "itemColor": Color(0xff1c1c1c), //item背景色
      "textColor": Color(0xffffffff), //所有文字色
      "borderNormal": Color(0xff5a5a5a), //item边框色
      "borderDisconnect": Color(0xffed1c24), //离线边框色
      "tabBarUnselected": Color(0xff757575), //底部tabBar未选中颜色
      "blue": Color(0xff009fe9), // 登录界面登录按钮色
      "orange": Color(0xfff7ad18), //用户名图标色
    },
    1: {
      //white
      "primaryColor": Color(0xfff3f3f3),
      "itemColor": Color(0xffffffff),
      "textColor": Color(0xff5a5a5a),
      "borderNormal": Color(0xffc3c3c3),
      "borderDisconnect": Color(0xffed1c24),
      "tabBarUnselected": Color(0xff757575),
      "blue": Color(0xff009fe9),
      "orange": Color(0xfff7ad18),
    }
  };

  Color getCurrent(BuildContext context,String key) {
    int index = Provider.of<ThemeProvider>(context).themeIndex;
    print("------>$index");
    return _themeColor[index][key];
  }


}
