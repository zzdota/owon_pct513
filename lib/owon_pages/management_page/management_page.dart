import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:owon_pct513/owon_api/model/address_model_entity.dart';
import 'package:owon_pct513/owon_pages/device_setting_pages/device_setting_page.dart';
import 'package:owon_pct513/owon_pages/device_setting_pages/schedule_setting_pages/schedule_list_page.dart';
import 'package:owon_pct513/owon_utils/owon_bottomsheet.dart';
import 'package:owon_pct513/owon_utils/owon_loading.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:owon_pct513/res/owon_constant.dart';
import 'package:owon_pct513/res/owon_sequence.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../res/owon_themeColor.dart';
import '../../component/owon_twoBtn.dart';
import '../../component/owon_tempHumi.dart';
import '../../component/owon_adjustTemp.dart';
import '../../component/owon_mode.dart';
import '../../res/owon_settingData.dart';
import 'package:owon_pct513/owon_utils/owon_mqtt.dart';
import '../../owon_providers/owon_evenBus/list_evenbus.dart';

class ManagementPage extends StatefulWidget {
  AddressModelAddrsDevlist devModel;
  ManagementPage(this.devModel);

  @override
  _ManagementPageState createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  String _localTemp = "30";
  String _localHumi = "55";
  String _systemMode;
  String _fanMode;
  String _homeMode;
  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;

  @override
  void initState() {
    getProperty();
    super.initState();

    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
      String topic = msg["topic"];

      if (msg["type"] == "json") {
        Map<String, dynamic> payload = msg["payload"];
        OwonLoading(context).dismiss();
        OwonLog.e("----m=${payload["response"]}");
        List tempList = payload["response"];
        tempList.forEach((item) {
          String attr = item["attrName"];
          if (attr == "LocalTemperature") {
            _localTemp = item["attrValue"];
          } else if (attr == "LocalRelativeHumidity") {
            _localHumi = item["attrValue"];
          } else if (attr == "SystemMode") {
            _systemMode = item["attrValue"];
          } else if (attr == "FanMode") {
            _fanMode = item["attrValue"];
          } else if (attr == "HomeMode") {
            _homeMode = item["attrValue"];
          }
        });
      } else if (msg["type"] == "string") {
        String payload = msg["payload"];

        OwonLog.e("----上报的payload=$payload");
        if (topic.contains("LocalTemperature")) {
          setState(() {
            _localTemp = payload;
          });
        } else if (topic.contains("LocalRelativeHumidity")) {
          setState(() {
            _localHumi = payload;
          });
        } else if (topic == "SystemMode") {
          setState(() {
            _systemMode = payload;
          });
        } else if (topic == "FanMode") {
          setState(() {
            _fanMode = payload;
          });
        } else if (topic == "HomeMode") {
          setState(() {
            _homeMode = payload;
          });
        } else if (topic == "ThermostaRunningMode") {}
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _listEvenBusSubscription.cancel();
  }

  getProperty() async {
    List attrsList = [
      "LocalTemperature",
      "LocalRelativeHumidity",
      "SystemMode",
      "FanMode",
      "HomeMode",
      "ThermostatRunningMode",
      "OccupiedCoolingSetpoint",
      "OccupiedHeatingSetpoint",
      "UnoccupiedCoolingSetpoint",
      "SetpointHold",
      "SetpointHoldDuration",
      "TemperatureUnit"
    ];
    List paramList = [];
    for (int i = 0; i < attrsList.length; i++) {
      String p = attrsList[i];
      Map paramMap = Map();
      paramMap["attrName"] = p;
      paramList.add(paramMap);
    }

    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic = "api/cloud/$clientID";
    Map p = Map();
    p["command"] = "device.attr.str.batch";
    p["sequence"] = OwonSequence.temp;
    p["deviceid"] = widget.devModel.deviceid;
    p["param"] = paramList;

    var msg = JsonEncoder.withIndent("  ").convert(p);
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }
  setProperty({String attribute,String value}) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic =
        "api/device/${widget.devModel.deviceid}/$clientID/attribute/$attribute";
    var msg = value;
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }

//  setProperty() async {
//    SharedPreferences pre = await SharedPreferences.getInstance();
//    var clientID = pre.get(OwonConstant.clientID);
//    String topic = "api/device/${widget.devModel.deviceid}/$clientID/attribute/SystemMode";
//    var msg = "3";

//    String topic = "api/device/${widget.devModel.deviceid}/$clientID/attribute/FanMode";
//    var msg = "4";

//        String topic = "api/device/${widget.devModel.deviceid}/$clientID/attribute/HomeMode";
//    var msg = "2";

//    String topic = "api/device/${widget.devModel.deviceid}/$clientID/attribute/OccupiedCoolingSetpoint";
//    var msg = "2600";

//    String topic = "api/device/${widget.devModel.deviceid}/$clientID/attribute/OccupiedHeatingSetpoint";
//    var msg = "2600";

//    String topic = "api/device/${widget.devModel.deviceid}/$clientID/attribute/UnoccupiedCoolingSetpoint";
//    var msg = "2200";

//    String topic = "api/device/${widget.devModel.deviceid}/$clientID/attribute/SetpointHold";
//    var msg = "1";

//    String topic = "api/device/${widget.devModel.deviceid}/$clientID/attribute/SetpointHoldDuration";
////    var msg = "65535";
//    var msg = "65530";

//    String topic =
//        "api/device/${widget.devModel.deviceid}/$clientID/attribute/TemperatureUnit";
//    var msg = "0";
//    OwonMqtt.getInstance().publishMessage(topic, msg);
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("PCT513"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return DeviceSettingPage(widget.devModel);
              }));
            },
            color: OwonColor().getCurrent(context, "textColor"),
          )
        ],
      ),
      body: Container(child: getWidget()),
    );
  }

  Widget getWidget() {
    var dataList = loadSystemData;

    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
//          color: Colors.red,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 0, 20),
                  child: OwonAdjustTemp(
                    title: "Heat To",
                    tempTitle: "30.0",
                    upBtnPressed: () {
                      OwonLog.e("up");
                    },
                    downBtnPressed: () {
                      OwonLog.e("down");
                    },
                  ),
                ),
                Expanded(
                    child: OwonTempHumi(
                  localTemp: _localTemp,
                  localHumi: _localHumi,
                )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 8, 20),
                  child: OwonAdjustTemp(
                    title: "Heat To",
                    tempTitle: "30.0",
                    upBtnPressed: () {
                      OwonLog.e("up");
                    },
                    downBtnPressed: () {
                      OwonLog.e("down");
                    },
                  ),
                ),
              ],
            ),
          ),
          flex: 5,
        ),
        Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                OwonMode(
                  leftTitle: "系统模式",
                  rightTitle: "Cool",
                ),
                OwonMode(
                  leftTitle: "风扇",
                  rightTitle: "Follow Schedule",
                ),
                OwonMode(
                  leftTitle: "System",
                  rightTitle: "Emergency Heat",
                  onPressed: () {
                    OwonLog.e("----");
                    OwonBottomSheet.show(context, dataList).then((val) {
                      print("--消失后的回调-->$val");
                    });

//                  .then((val) {
//                    print("--消失后的回调-->$val");
//                  });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: getBottomWidget(),
                )
              ],
            ))
      ],
    );
  }

  Widget getBottomWidget() {
    return OwonTwoBtn(
      leftTitle: "Temp Hold",
      rightTitle: "Schedule",
      leftBtnPressed: () {
        OwonLog.e("left");
      },
      rightBtnPressed: () {
        OwonLog.e("right");
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ScheduleListPage();
        }));
      },
    );
  }
}
