import 'dart:async';

import 'package:flutter/material.dart';
import 'package:owon_pct513/owon_api/model/address_model_entity.dart';
import 'package:owon_pct513/owon_providers/owon_evenBus/list_evenbus.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';
import '../../generated/i18n.dart';

class DeviceRenamePage extends StatefulWidget {
  AddressModelAddrsDevlist devModel;
  DeviceRenamePage(this.devModel);

  @override
  _DeviceRenamePageState createState() => _DeviceRenamePageState();
}

class _DeviceRenamePageState extends State<DeviceRenamePage> {
  var _tfVC = TextEditingController();

  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;

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
        title: Text(S.of(context).dSet_rename),
        actions: <Widget>[
          FlatButton(
//            splashColor: Colors.red,
            onPressed: () {
              OwonLog.e("save is tap text${_tfVC.text}");
            },
            child: Text(
              S.of(context).global_save,
              style: TextStyle(
                  color: OwonColor().getCurrent(
                    context,
                    "textColor",
                  ),
                  fontSize: 22),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: TextField(
//          autofocus: true,
            style: TextStyle(
                color: OwonColor().getCurrent(
                  context,
                  "textColor",
                ),
                fontSize: 24.0),
            controller: _tfVC,
            decoration: InputDecoration(
              labelText: S.of(context).dSet_rename_tip,
              labelStyle: TextStyle(
                  fontSize: 17, color: OwonColor().getCurrent(context, "blue")),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              filled: false,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: OwonColor().getCurrent(context, "textfieldColor")),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: OwonColor().getCurrent(context, "textfieldColor")),
              ),
//              hintText: S.of(context).dSet_rename_tip,
//              hintStyle: TextStyle(
//                  fontSize: 14,
//                  color: OwonColor().getCurrent(context, "textColor")),
            )),
      ),
    );
  }
}
