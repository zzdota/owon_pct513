import 'package:flutter/material.dart';
import 'package:owon_pct513/owon_pages/setting_pages/about_page.dart';
import 'package:owon_pct513/owon_utils/owon_mqtt.dart';
import 'package:provider/provider.dart';
import '../../owon_providers/theme_provider.dart';
import '../../res/owon_themeColor.dart';
import '../../res/owon_settingData.dart';
import 'appearance_page.dart';
import '../../generated/i18n.dart';
class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List dataList;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dataList = loadSettingData(context);

    return Scaffold(
        appBar: AppBar(
          leading: Text(""),
          title: Text(S.of(context).tab_set),
          centerTitle: true,
        ),
        body: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              return Container(
                height: 90,
                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: InkWell(
                  onTap: (){
                    switch(index){
                      case 0:{}
                      break;
                      case 1:{
                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return AppearancePage();
                        }));
                      }
                      break;
                      case 2:{}
                      break;
                      case 3:{
                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return AboutPage();
                        }));
                      }
                      break;
                      case 4:{}
                      break;
                      default:
                        break;
                    }
                  },
                  child: Card(
                      shape:  RoundedRectangleBorder(
                          side: BorderSide(
                            color:
                            OwonColor().getCurrent(context, "borderNormal"),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(16.0))
                      ),
                      child: createWidget(index)),
                ),
              );
            }));
  }

  Widget createWidget(int index) {
    int myIndex = Provider.of<ThemeProvider>(context).themeIndex;

    var name = dataList[index]["name"];
    var imageUrl = myIndex==0?dataList[index]["imageUrl"]:dataList[index]["imageUrlW"];
    return GestureDetector(
      onTap: (){
        OwonMqtt.getInstance().disconnect();
        Navigator.of(context).pop();
      },
      child: index == dataList.length-1
          ? Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), color: Colors.red),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(color: Colors.white,fontSize: 16.0),
                  ),

                  SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    imageUrl,
                    width: 20,
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
                        width: 20,
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
            ),
    );
  }
}
