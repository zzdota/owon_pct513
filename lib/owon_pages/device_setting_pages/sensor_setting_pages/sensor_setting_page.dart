import 'dart:async';
import 'package:flutter/material.dart';
import 'package:owon_pct513/owon_api/model/address_model_entity.dart';
import 'package:owon_pct513/owon_api/model/sensor_list_model_entity.dart';
import 'package:owon_pct513/owon_providers/owon_evenBus/list_evenbus.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';

class SensorSettingPage extends StatefulWidget {
  AddressModelAddrsDevlist devModel;
  SensorSettingPage(this.devModel);

  @override
  _SensorSettingPageState createState() => _SensorSettingPageState();
}

class _SensorSettingPageState extends State<SensorSettingPage> {
  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;

  @override
  void initState() {
    super.initState();

    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
      String topic = msg["topic"];

      if (msg["type"] == "json") {
        Map<String, dynamic> payload = msg["payload"];
        OwonLog.e("----m=$payload");
      } else if (msg["type"] == "string") {
        String payload = msg["payload"];
        OwonLog.e("----上报的payload=$payload");
      } else if (msg["type"] == "raw") {
        if (!topic.contains("SensorList")) {
          return;
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
//              OwonLog.e("sensorParaToJson====>> ${buf.toString()}");
//              OwonLog.e("bufsensorToJson====>> ${buf.toString()}");
//
//              OwonLog.e("第${e+1}个sensor ID======> ${byteToInt(sensor[e].sublist(0,4))}");
//              OwonLog.e("第${e+1}个sensor name======> ${String.fromCharCodes(sensor[e].sublist(4,34))}");
//              OwonLog.e("第${e+1}个sensor enable/disable======> ${sensor[e][34]}");
//              OwonLog.e("第${e+1}个sensor occupy/unoccupy======> ${sensor[e][35]}");
//              OwonLog.e("第${e+1}个sensor Temperature======> ${byteToInt(sensor[e].sublist(36,38))}");
//              OwonLog.e("第${e+1}个sensor connect/disconnect======> ${sensor[e][38]}");
//              OwonLog.e("第${e+1}个sensor schedule======> ${sensor[e][39]}");
//              OwonLog.e("第${e+1}个sensor power======> ${sensor[e][40]}");
//              OwonLog.e("第${e+1}个sensor reserve======> ${String.fromCharCodes(sensor[e].sublist(41,51))}");
        }
        sensorMode["para"] = buf;
//            OwonLog.e("sensorToJson====>> ${sensorMode.toString()}");
        SensorListModelEntity sensorListModelEntity =
            SensorListModelEntity.fromJson(sensorMode);
//            OwonLog.e(sensorListModelEntity);
      }
    });
  }

  int byteToInt(List list) {
    int value = 0;
    for (int i = 0; i < list.length; i++) {
      value = value + (list[i] << ((list.length - i - 1) * 8));
    }
    return value;
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
        title: Text("Sensor"),
      ),
      body: FlatButton(
        onPressed: () {},
        child: Text("get"),
      ),
    );
  }
}
