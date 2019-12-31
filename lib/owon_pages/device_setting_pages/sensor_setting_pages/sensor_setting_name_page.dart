import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../generated/i18n.dart';
import '../../../owon_api/model/address_model_entity.dart';
import '../../../owon_api/model/sensor_list_model_entity.dart';
import '../../../owon_providers/owon_evenBus/list_evenbus.dart';
import '../../../owon_utils/owon_loading.dart';
import '../../../owon_utils/owon_mqtt.dart';
import '../../../owon_utils/owon_toast.dart';
import '../../../res/owon_themeColor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../owon_utils/owon_text_icon_button.dart';
import '../../../res/owon_constant.dart';

class SensorRenamePage extends StatefulWidget {
  AddressModelAddrsDevlist devModel;
  SensorListModelEntity sensorListModelEntity;
  int index;
  SensorRenamePage(this.devModel, this.sensorListModelEntity, this.index);

  @override
  _SensorRenamePageState createState() => _SensorRenamePageState();
}

class _SensorRenamePageState extends State<SensorRenamePage> {
  var _tfVC = TextEditingController();

  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;

  @override
  void initState() {
    super.initState();

    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
      String topic = msg["topic"];

      if (msg["type"] == "json") {
        Map<String, dynamic> payload = msg["payload"];
      } else if (msg["type"] == "string") {
        String payload = msg["payload"];
      } else if (msg["type"] == "raw") {
        if (topic.contains("SensorList")) {
          if (topic.startsWith("reply")) {
            OwonLoading(context).hide().then((e) {
              OwonToast.show(S.of(context).global_save_success);
            });
          }
          List payload = msg["payload"];
          int count = payload[0];
          payload = payload.sublist(1, payload.length);
          List sensor = List();
          Map<String, dynamic> sensorMode = Map();
          for (int i = 0; i < count; i++) {
            sensor.add(payload.sublist(i * 51, 51 * i + 51));
          }
          List buf = List();
          for (int e = 0; e < sensor.length; e++) {
            Map<String, dynamic> sensorPara = Map();
            sensorPara["id"] = byteToInt(sensor[e].sublist(0, 4));
            sensorPara["name"] = String.fromCharCodes(sensor[e].sublist(4, 34));
            sensorPara["enable"] = sensor[e][34];
            sensorPara["occupy"] = sensor[e][35];
            sensorPara["temp"] = byteToInt(sensor[e].sublist(36, 38));
            sensorPara["connect"] = sensor[e][38];
            sensorPara["scheduleId"] = sensor[e][39];
            sensorPara["batteryStatus"] = sensor[e][40];
            sensorPara["reserve"] =
                String.fromCharCodes(sensor[e].sublist(41, 51));
            buf.add(sensorPara);
          }
          sensorMode["para"] = buf;
          widget.sensorListModelEntity =
              SensorListModelEntity.fromJson(sensorMode);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _listEvenBusSubscription.cancel();
  }

  int byteToInt(List list) {
    int value = 0;
    for (int i = 0; i < list.length; i++) {
      value = value + (list[i] << ((list.length - i - 1) * 8));
    }
    return value;
  }

  List<int> intToByte(int value, int byte) {
    List<int> buf = List();
    for (int i = 0; i < byte; i++) {
      int valueBuf = value >> ((byte - 1 - i) * 8);
      value = value - (valueBuf << ((byte - 1 - i) * 8));
      buf.add(valueBuf);
    }
    return buf;
  }

  List<int> mapSensorToList() {
    List<int> buf = List();
    buf.add(widget.sensorListModelEntity.para.length);
    for (int i = 0; i < widget.sensorListModelEntity.para.length; i++) {
      SensorListModelParam sensorPara = widget.sensorListModelEntity.para[i];

      List<int> name = List();
      name.addAll(utf8.encode(sensorPara.name));
      for (int i = name.length; i < 30; i++) {
        name.add(0);
      }

      List<int> reserve = List();
      for (int i = 0; i < 10; i++) {
        reserve.add(0);
      }

      buf.addAll(intToByte(sensorPara.id, 4));
      buf.addAll(name);
      buf.add(sensorPara.enable);
      buf.add(sensorPara.occupy);
      buf.addAll(intToByte(sensorPara.temp, 2));
      buf.add(sensorPara.connect);
      buf.add(sensorPara.scheduleId);
      buf.add(sensorPara.batteryStatus);
      buf.addAll(reserve);
    }
    return buf;
  }

  save() async {
    OwonLoading(context).show();
    widget.sensorListModelEntity.para[widget.index].name = _tfVC.text;
    List<int> data = mapSensorToList();
    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic =
        "api/device/${widget.devModel.deviceid}/$clientID/attribute/SensorList";
    OwonMqtt.getInstance().publishRawMessage(topic, data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).dSet_rename),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Expanded(
              child: TextField(
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
                  )),
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
                        save();
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
