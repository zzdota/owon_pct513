import 'package:flutter/material.dart';
import '../../owon_providers/theme_provider.dart';
import '../../res/owon_themeColor.dart';
import '../../res/owon_settingData.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List dataList = loadSettingData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Text(""),
          title: Text("Setting"),
          centerTitle: true,
        ),
        body: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              return Container(
                height: 90,
                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    child: createWidget(index)),
              );
            }));
  }

  Widget createWidget(int index) {
    var name = dataList[index]["name"];
    var imageUrl = dataList[index]["imageUrl"];
    return index == 5
        ? Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16), color: Colors.red),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  imageUrl,
                  width: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  name,
                  style: TextStyle(color: Colors.white,fontSize: 16.0),
                ),
              ],
            ))
        : Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      imageUrl,
                      width: 30,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                          color: OwonColor().getCurrent(context, "textColor"),fontSize: 16.0),
                    ),
                  ],
                ),
                Icon(Icons.keyboard_arrow_right,
                    color: OwonColor().getCurrent(context, "textColor"))
              ],
            ),
          );
  }
}
