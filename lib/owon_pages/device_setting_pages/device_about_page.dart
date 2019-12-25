import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:owon_pct513/generated/i18n.dart';
import 'package:owon_pct513/owon_api/model/address_model_entity.dart';
import 'package:owon_pct513/owon_api/model/sensor_list_model_entity.dart';
import 'package:owon_pct513/owon_providers/owon_evenBus/list_evenbus.dart';
import 'package:owon_pct513/owon_utils/owon_loading.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:owon_pct513/owon_utils/owon_mqtt.dart';
import 'package:owon_pct513/owon_utils/owon_temperature.dart';
import 'package:owon_pct513/owon_utils/owon_text_icon_button.dart';
import 'package:owon_pct513/owon_utils/owon_toast.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import 'package:owon_pct513/res/owon_sequence.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:owon_pct513/res/owon_constant.dart';

class DeviceAboutPage extends StatefulWidget {
  AddressModelAddrsDevlist devModel;
  DeviceAboutPage(this.devModel);

  @override
  _DeviceAboutPageState createState() => _DeviceAboutPageState();
}

class _DeviceAboutPageState extends State<DeviceAboutPage> {
  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;

  String mCurrentVersion, mUpgradeVersion, mDeviceId, mDeviceNetwork;

  @override
  void initState() {
    super.initState();

    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
      String topic = msg["topic"];

      if (msg["type"] == "json") {
        Map<String, dynamic> payload = msg["payload"];
        if (payload.containsValue("device.attr.str.batch")) {
          List tempList = payload["response"];
          tempList.forEach((item) {
            String attr = item["attrName"];
            if (attr == "deviceid") {
              setState(() {
                mDeviceId = item["attrValue"];
              });
            } else if (attr == "versionname") {
              setState(() {
                mCurrentVersion = item["attrValue"];
              });
            }
          });
          getDeviceUpgradeInfo();
        } else if (payload.containsKey("version.get")) {
          if (topic.startsWith("reply")) {
            OwonLoading(context).dismiss();
            setState(() {
              mUpgradeVersion = payload["version"];
            });
          }
        }
      } else if (msg["type"] == "string") {
        String payload = msg["payload"];
        OwonLog.e("----上报的payload=$payload");
        if (topic.contains("DeviceName")) {
//          OwonLoading(context).dismiss();
          OwonLoading(context).hide().then((e) {
            OwonToast.show(S.of(context).global_save_success);
          });
        }
      }
    });
    Future.delayed(Duration(seconds: 0), () {
      getDeviceInfo();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _listEvenBusSubscription.cancel();
  }

  getDeviceUpgradeInfo() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic = "api/cloud/$clientID";
    Map p = Map();
    p["command"] = "version.get";
    p["type"] = "UAA8BC7Cais7dJGc";
    p["sequence"] = OwonSequence.getDeviceUpgradeInfo;
    p["language"] = "en";
    p["firmwaretype"] = "pct513";
    var msg = JsonEncoder.withIndent("  ").convert(p);
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }

  getDeviceInfo() async {
    OwonLoading(context).show();
    List attrsList = [
      "deviceid",
      "versionname",
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
    p["sequence"] = OwonSequence.getDeviceInfo;
    p["deviceid"] = widget.devModel.deviceid;
    p["param"] = paramList;

    var msg = JsonEncoder.withIndent("  ").convert(p);
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).device_info_title),
      ),
      body: Container(
//        color: Colors.red,
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${S.of(context).device_info_current_version}$mCurrentVersion",
                      style: TextStyle(
                          fontSize: 20,
                          color: OwonColor().getCurrent(context, "textColor")),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                        "${S.of(context).device_info_upgrade_version}$mUpgradeVersion",
                        style: TextStyle(
                            fontSize: 20,
                            color:
                                OwonColor().getCurrent(context, "textColor"))),
                    SizedBox(
                      height: 15,
                    ),
                    Text("${S.of(context).device_info_mac}$mDeviceId",
                        style: TextStyle(
                            fontSize: 20,
                            color:
                                OwonColor().getCurrent(context, "textColor"))),
                    SizedBox(
                      height: 15,
                    ),
                    Text("${S.of(context).device_info_network}$mDeviceNetwork",
                        style: TextStyle(
                            fontSize: 20,
                            color:
                                OwonColor().getCurrent(context, "textColor"))),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  height: OwonConstant.systemHeight,
                  width: double.infinity,
                  child: OwonTextIconButton.icon(
//                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(OwonConstant.cRadius),
                      ),
                      onPressed: () {
                        OwonLoading(context).show();
                      },
                      icon: SvgPicture.asset(
                        OwonPic.dSettingUpgrade,
                        width: 25,
                        color: OwonColor().getCurrent(context, "textColor"),
                      ),
                      label: Text(
                        S.of(context).device_info_upgrade,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      iconTextAlignment: TextIconAlignment.iconRightTextLeft)),
            )
          ],
        ),
      ),
    );
  }
}
