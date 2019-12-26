import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:owon_pct513/owon_api/model/address_model_entity.dart';
import 'package:owon_pct513/owon_providers/owon_evenBus/list_evenbus.dart';
import 'package:owon_pct513/owon_utils/owon_loading.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:owon_pct513/owon_utils/owon_mqtt.dart';
import 'package:owon_pct513/owon_utils/owon_toast.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../generated/i18n.dart';
import 'package:owon_pct513/owon_utils/owon_text_icon_button.dart';
import 'package:owon_pct513/res/owon_constant.dart';
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
        String payload = msg["payload"];

        OwonLog.e("----上报的payload=$payload");
        if (topic.startsWith("reply") && topic.contains("DeviceName")) {

//          OwonLoading(context).dismiss();
          OwonLoading(context).hide().then((e){
            OwonToast.show(S.of(context).global_save_success);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _listEvenBusSubscription.cancel();
  }

  setProperty({String attribute, String value}) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic =
        "api/device/${widget.devModel.deviceid}/$clientID/attribute/$attribute";
    var msg = value;
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).dSet_rename),
      ),
      body: Container(
//        color: Colors.red,
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Expanded(
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
                    prefixIcon: Icon(
                      Icons.edit,
                      color: OwonColor().getCurrent(context, "orange"),
                    ),
                    labelText: S.of(context).dSet_rename_tip,
                    labelStyle: TextStyle(
                        fontSize: 17,
                        color: OwonColor().getCurrent(context, "textColor")),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15.0),
                    filled: false,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: OwonColor()
                              .getCurrent(context, "textfieldColor")),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: OwonColor()
                              .getCurrent(context, "textfieldColor")),
                    ),
//              hintText: S.of(context).dSet_rename_tip,
//              hintStyle: TextStyle(
//                  fontSize: 14,
//                  color: OwonColor().getCurrent(context, "textColor")),
                  )),
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
                        setProperty(attribute: "DeviceName",value:_tfVC.text);
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
}
