import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../generated/i18n.dart';
import '../../owon_api/model/address_model_entity.dart';
import '../../owon_providers/owon_evenBus/list_evenbus.dart';
import '../../owon_utils/owon_loading.dart';
import '../../owon_utils/owon_log.dart';
import '../../owon_utils/owon_mqtt.dart';
import '../../owon_utils/owon_text_icon_button.dart';
import '../../owon_utils/owon_toast.dart';
import '../../res/owon_constant.dart';
import '../../res/owon_sequence.dart';
import '../../res/owon_themeColor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceSettingTempUtilPage extends StatefulWidget {
  AddressModelAddrsDevlist devModel;
  DeviceSettingTempUtilPage(this.devModel);

  @override
  _DeviceSettingTempUtilPageState createState() =>
      _DeviceSettingTempUtilPageState();
}

class _DeviceSettingTempUtilPageState extends State<DeviceSettingTempUtilPage> {
  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;
  bool mSelectValue = false;

  @override
  void initState() {
    super.initState();

    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
      String topic = msg["topic"];

      if (msg["type"] == "json") {
        Map<String, dynamic> payload = msg["payload"];
        OwonLoading(context).dismiss();
        if (payload["attributeName"].contains("TemperatureUnit")) {
          String value = payload["attributeValue"];
          OwonLog.e("=====>>>>value$value");
          setState(() {
            if (value == "0") {
              mSelectValue = true;
            } else if (value == "1") {
              mSelectValue = false;
            }
          });
        }
      } else if (msg["type"] == "string") {
        String payload = msg["payload"];
        if (topic.contains("TemperatureUnit")) {
          if (topic.startsWith("reply")) {
            OwonLoading(context).dismiss();
            OwonToast.show(S.of(context).global_save_success);
            Navigator.pop(context);
          }
        }
      }
    });
    Future.delayed(Duration(seconds: 0), () {
      toGetTempUnit();
    });
  }

  void toGetTempUnit() async {
    OwonLoading(context).show();
    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic = "api/cloud/$clientID";
    Map p = Map();
    p["command"] = "device.attr.str";
    p["sequence"] = OwonSequence.settingTempUnit;
    p["deviceid"] = widget.devModel.deviceid;
    p["attributeName"] = "TemperatureUnit";
    var msg = JsonEncoder.withIndent("  ").convert(p);
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }

  void _save() async {
    OwonLoading(context).show();
    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic =
        "api/device/${widget.devModel.deviceid}/$clientID/attribute/TemperatureUnit";
    var msg;
    if (mSelectValue) {
      msg = "0";
    } else {
      msg = "1";
    }
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }

  @override
  void dispose() {
    super.dispose();
    _listEvenBusSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).dSet_temp_unit),
      ),
      body: Container(
//        color: Colors.red,
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: 150.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          mSelectValue = false;
                        });
                      },
                      child: checkBox(!mSelectValue, S.of(context).global_fahrenheit_unit),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          mSelectValue = true;
                        });
                      },
                      child: checkBox(mSelectValue, S.of(context).global_celsius_unit),
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
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(OwonConstant.cRadius),
                      ),
                      onPressed: () {
                        _save();
                      },
                      icon: Icon(
                        Icons.save_alt,
                        color: Colors.white,
                      ),
                      label: Text(
                        S.of(context).global_save,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      iconTextAlignment: TextIconAlignment.iconRightTextLeft)),
            )
          ],
        ),
      ),
    );
  }

  Widget checkBox(bool value, String week) {
    return Container(
      child: Row(
        children: <Widget>[
          value
              ? Icon(
                  Icons.radio_button_checked,
                  color: OwonColor().getCurrent(context, "blue"),
                  size: 35,
                )
              : Icon(
                  Icons.radio_button_unchecked,
                  color: OwonColor().getCurrent(context, "blue"),
                  size: 35,
                ),
          SizedBox(
            width: 10,
          ),
          Text(
            week == null ? "" : week,
            style: TextStyle(
                color: OwonColor().getCurrent(context, "textColor"),
                fontSize: 30),
          ),
        ],
      ),
    );
  }
}
