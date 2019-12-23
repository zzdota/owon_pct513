import 'dart:async';
import 'package:flutter/material.dart';
import 'package:owon_pct513/generated/i18n.dart';
import 'package:owon_pct513/owon_api/model/address_model_entity.dart';
import 'package:owon_pct513/owon_providers/owon_evenBus/list_evenbus.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:owon_pct513/owon_utils/owon_text_icon_button.dart';
import 'package:owon_pct513/res/owon_constant.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';

class DeviceSettingTempUtilPage extends StatefulWidget {
  AddressModelAddrsDevlist devModel;
  DeviceSettingTempUtilPage(this.devModel);

  @override
  _DeviceSettingTempUtilPageState createState() =>
      _DeviceSettingTempUtilPageState();
}

class _DeviceSettingTempUtilPageState extends State<DeviceSettingTempUtilPage> {
  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;
  String _newValue = '℃';

  @override
  void initState() {
    super.initState();

    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
      String topic = msg["topic"];

      if (msg["type"] == "json") {
//        Map<String, dynamic> payload = msg["payload"];
//        OwonLog.e("----m=${payload["response"]}");
//        List tempList = payload["response"];
//        tempList.forEach((item) {
//          String attr = item["attrName"];
//        });
      } else if (msg["type"] == "string") {
//        String payload = msg["payload"];
//
//        OwonLog.e("----上报的payload=$payload");
//        if (topic.contains("LocalTemperature")) {
//
//        }
      }
    });
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
                margin: EdgeInsets.only(top:150.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _radioBox('℉'),
                    _radioBox('℃'),
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
                      onPressed: () {},
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

  _radioBox(String title) {
    return Container(
      height: 60,
      width: 150,
      child: RadioListTile<String>(
        value: title,
        title: Text(
          title,
          style:
          TextStyle(color: OwonColor().getCurrent(context, "textColor"),
              fontSize: 30),
        ),
        activeColor: OwonColor().getCurrent(context, "blue") ?? OwonColor().getCurrent(context, "blue"),
        selected: false,
        groupValue: _newValue,
        onChanged: (value) {
          setState(() {
            _newValue = value;
          });
        },
      ),
    );
  }
}