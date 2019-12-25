import 'dart:async';
import 'package:flutter/material.dart';
import 'package:owon_pct513/generated/i18n.dart';
import 'package:owon_pct513/owon_api/model/address_model_entity.dart';
import 'package:owon_pct513/owon_api/model/sensor_list_model_entity.dart';
import 'package:owon_pct513/owon_providers/owon_evenBus/list_evenbus.dart';
import 'package:owon_pct513/owon_utils/owon_loading.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:owon_pct513/owon_utils/owon_mqtt.dart';
import 'package:owon_pct513/owon_utils/owon_temperature.dart';
import 'package:owon_pct513/owon_utils/owon_toast.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:owon_pct513/res/owon_constant.dart';

class SensorAboutPage extends StatefulWidget {
  AddressModelAddrsDevlist devModel;
  SensorListModelEntity sensorListModelEntity;
  int index;
  SensorAboutPage(this.devModel, this.sensorListModelEntity, this.index);

  @override
  _SensorAboutPageState createState() => _SensorAboutPageState();
}

class _SensorAboutPageState extends State<SensorAboutPage> {
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
        title: Text(S.of(context).sensor_setting_sensor_about),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "${S.of(context).sensor_about_id}${widget.sensorListModelEntity.para[widget.index].id}",
              style: TextStyle(
                  fontSize: 20,
                  color: OwonColor().getCurrent(context, "textColor")),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
                "${S.of(context).sensor_about_battery}${widget.sensorListModelEntity.para[widget.index].batteryStatus}%",
                style: TextStyle(
                    fontSize: 20,
                    color: OwonColor().getCurrent(context, "textColor"))),
            SizedBox(
              height: 15,
            ),
            Text(
                "${S.of(context).sensor_about_temp}${widget.devModel.tempUnit ? "${OwonTemperature().cToF(widget.sensorListModelEntity.para[widget.index].temp / 100)}${S.of(context).global_fahrenheit_unit}" : "${(widget.sensorListModelEntity.para[widget.index].temp / 100)}${S.of(context).global_celsius_unit}"}",
                style: TextStyle(
                    fontSize: 20,
                    color: OwonColor().getCurrent(context, "textColor"))),
            SizedBox(
              height: 15,
            ),
            Text(
                "${S.of(context).sensor_about_occupied_or}${widget.sensorListModelEntity.para[widget.index].occupy == 0 ? "${S.of(context).sensor_about_occupied}" : "${S.of(context).sensor_about_unoccupied}"}",
                style: TextStyle(
                    fontSize: 20,
                    color: OwonColor().getCurrent(context, "textColor"))),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
