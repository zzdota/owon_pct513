import 'package:flutter/material.dart';
import 'package:owon_pct513/component/owon_header.dart';
import 'package:owon_pct513/res/owon_constant.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../owon_providers/theme_provider.dart';
import '../../component/owon_header.dart';
import '../../res/owon_picture.dart';
class AppearancePage extends StatefulWidget {
  @override
  _AppearancePageState createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appearance"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 40,),

          OwonHeader.header(context,OwonPic.appearI,"Appearance",alignment: MainAxisAlignment.center,width: 120),
          SizedBox(
            height: 30,
          ),
          createMiddle(),
          SizedBox(
            height: 30,
          ),
//          createBottom()
        ],
      ),
    );
  }

  Widget createTop() {
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            OwonPic.appearB,
            width: 60,
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 2,
            height: 60,
            child: Container(
              color: OwonColor().getCurrent(context, "textColor"),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Appearance",
            style: TextStyle(
                color: OwonColor().getCurrent(context, "textColor"),
                fontSize: 45),
          )
        ],
      ),
    );
  }

  Widget createMiddle() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          createMiddleItem(OwonPic.appearB, "Dark",Provider.of<ThemeProvider>(context).themeIndex,()async {
            SharedPreferences pre = await SharedPreferences.getInstance();
            pre.setInt("themeColor", 0);
            Provider.of<ThemeProvider>(context).setTheme(0);
          }),
          createMiddleItem(OwonPic.appearW, "Light",Provider.of<ThemeProvider>(context).themeIndex==0?1:0,()async {
            SharedPreferences pre = await SharedPreferences.getInstance();
            pre.setInt("themeColor", 1);
            Provider.of<ThemeProvider>(context).setTheme(1);
          })
        ],
      ),
    );
  }

  Widget createMiddleItem(String imageUrl, String text, int index,VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              imageUrl,
              width: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              text,
              style: TextStyle(
                  color: OwonColor().getCurrent(context, "textColor"),
                  fontSize: 25),
            ),
            SizedBox(
              height: 15,
            ),
            index == 0?Icon(
              Icons.check_circle,
              color: OwonColor().getCurrent(context, "blue"),
              size: 35,
            ):Icon(
              Icons.radio_button_unchecked,
              color: OwonColor().getCurrent(context, "blue"),
              size: 35,
            )
          ],
        ),
      ),
    );
  }



  Widget createWidget() {
    return Container(
      height: 100,
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                "assets/images/launch_icon.png",
                width: 30,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "Automatic",
                style: TextStyle(
                    color: OwonColor().getCurrent(context, "textColor"),
                    fontSize: 16.0),
              ),
            ],
          ),
          Icon(
            Icons.check_circle,
            color: OwonColor().getCurrent(context, "blue"),
            size: 35,
          )
        ],
      ),
    );
  }



  Widget createBottom() {
    return Card(
        shape:  RoundedRectangleBorder(
            side: BorderSide(
              color:
              OwonColor().getCurrent(context, "borderNormal"),
              width: 1.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(OwonConstant.cRadius))
        ),
        child: createWidget());
  }
}
