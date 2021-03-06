import 'dart:math';

import 'package:flutter/material.dart';
import 'package:owon_pct513/owon_api/model/address_model_entity.dart';
import 'package:owon_pct513/owon_pages/device_setting_pages/device_about_page.dart';
import 'package:owon_pct513/owon_pages/device_setting_pages/device_fanTime_page.dart';
import 'package:owon_pct513/owon_pages/device_setting_pages/device_rename_page.dart';
import 'package:owon_pct513/owon_pages/device_setting_pages/sensor_setting_pages/sensor_list_page.dart';
import 'package:owon_pct513/owon_pages/device_setting_pages/sensor_setting_pages/sensor_setting_page.dart';
import 'package:owon_pct513/owon_pages/device_setting_pages/vacation_setting_pages/vacation_list_page.dart';
import 'package:owon_pct513/owon_pages/setting_pages/about_page.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:owon_pct513/owon_utils/owon_mqtt.dart';
import 'package:provider/provider.dart';
import '../../owon_providers/theme_provider.dart';
import '../../res/owon_themeColor.dart';
import '../../res/owon_settingData.dart';
import '../../generated/i18n.dart';
import 'device_temp_util_page.dart';

class DeviceSettingPage extends StatefulWidget {
  AddressModelAddrsDevlist devModel;
  DeviceSettingPage(this.devModel);

  @override
  _DeviceSettingPageState createState() => _DeviceSettingPageState();
}

class _DeviceSettingPageState extends State<DeviceSettingPage> {
  List dataList;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dataList = loadDeviceSettingData(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).dSet_device_setting),
          centerTitle: true,
        ),
        body: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              return Container(
                height: 90,
                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: InkWell(
                  onTap: () {
                    switch (index) {
                      case 0:
                        {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return DeviceRenamePage(widget.devModel);
                          }));
                        }
                        break;
                      case 1:
                        {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return VacationListPage(widget.devModel);
                          }));
                        }
                        break;
                      case 2:
                        {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return DeviceFanTimePage(widget.devModel);
                          }));
                        }
                        break;
                      case 3:
                        {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return SensorListPage(widget.devModel);
                          }));
                        }
                        break;
                      case 4:
                        {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return DeviceSettingTempUtilPage(widget.devModel);
                          }));
                        }
                        break;
                      case 5:
                        {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return DeviceAboutPage(widget.devModel);
                          }));
                        }
                        break;
                      default:
                        break;
                    }
                  },
                  child: Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color:
                                OwonColor().getCurrent(context, "borderNormal"),
                            width: 1.0,
                          ),
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      child: createWidget(index)),
                ),
              );
            }));
  }

  Widget createWidget(int index) {
    int myIndex = Provider.of<ThemeProvider>(context).themeIndex;

    var name = dataList[index]["name"];
    var imageUrl = myIndex == 0
        ? dataList[index]["imageUrl"]
        : dataList[index]["imageUrlW"];
    if(index == dataList.length-1){
      return GestureDetector(
          onTap: () {
            OwonLog.e("delet===>");
          },
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), color: Colors.red),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                 Icon(Icons.delete,color: Colors.white,)
                ],
              )));
    }else{
      return GestureDetector(
//      onTap: (){
//        OwonMqtt.getInstance().disconnect();
//        Navigator.of(context).pop();
//      },
        child: Container(
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
                        color: OwonColor().getCurrent(context, "textColor"),
                        fontSize: 16.0),
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
}
