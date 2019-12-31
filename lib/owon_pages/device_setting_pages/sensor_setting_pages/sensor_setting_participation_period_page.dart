import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../generated/i18n.dart';
import '../../../owon_api/model/address_model_entity.dart';
import '../../../owon_api/model/sensor_list_model_entity.dart';
import '../../../owon_providers/owon_evenBus/list_evenbus.dart';
import '../../../owon_utils/owon_loading.dart';
import '../../../owon_utils/owon_mqtt.dart';
import '../../../owon_utils/owon_toast.dart';
import '../../../res/owon_picture.dart';
import '../../../res/owon_themeColor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../owon_utils/owon_text_icon_button.dart';
import '../../../res/owon_constant.dart';

class SensorParticipationPeriodPage extends StatefulWidget {
  AddressModelAddrsDevlist devModel;
  SensorListModelEntity sensorListModelEntity;
  int index;
  SensorParticipationPeriodPage(
      this.devModel, this.sensorListModelEntity, this.index);

  @override
  _SensorParticipationPeriodPageState createState() =>
      _SensorParticipationPeriodPageState();
}

class _SensorParticipationPeriodPageState
    extends State<SensorParticipationPeriodPage> {
  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;
  int mSelectModeNum;

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

    setState(() {
      mSelectModeNum = widget.sensorListModelEntity.para[widget.index].scheduleId;
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
    widget.sensorListModelEntity.para[widget.index].scheduleId = mSelectModeNum;
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
        title: Text(S.of(context).sensor_setting_participation_period),
      ),
      body: Container(
//        color: Colors.red,
        padding: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                getCard(
                    OwonPic.scheduleModeWake, S.of(context).schedule_mode_wake,0),
                getCard(
                    OwonPic.scheduleModeAway, S.of(context).schedule_mode_away,1),
                getCard(
                    OwonPic.scheduleModeHome, S.of(context).schedule_mode_home,2),
                getCard(OwonPic.scheduleModeSleep,
                    S.of(context).schedule_mode_sleep,3),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: OwonConstant.systemHeight,
                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: OwonTextIconButton.icon(
                      onPressed: () {
                        save();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(OwonConstant.cRadius)),
                      icon: Icon(
                        Icons.save_alt,
                        color: Colors.white,
                      ),
                      label: Text(
                        S.of(context).global_save,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      iconTextAlignment: TextIconAlignment.iconRightTextLeft),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getCard(String imageUrl, String modeStr,int modeNum) {
    return Container(
        height: OwonConstant.cHeight,
        padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
        child: Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: OwonColor().getCurrent(context, "borderNormal"),
                  width: 1.0,
                ),
                borderRadius:
                    BorderRadius.all(Radius.circular(OwonConstant.cRadius))),
            child: Container(
              padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          imageUrl,
                          color: OwonColor().getCurrent(context, "textColor"),
                          width: 40,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(modeStr,
                            style: TextStyle(
                                color: OwonColor()
                                    .getCurrent(context, "textColor"),
                                fontSize: 20)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        mSelectModeNum = modeNum;
                      });
                    },
                    child: modeNum == mSelectModeNum
                        ? Icon(
                            Icons.check_circle,
                            color: OwonColor().getCurrent(context, "blue"),
                            size: 35,
                          )
                        : Icon(
                            Icons.radio_button_unchecked,
                            color: OwonColor().getCurrent(context, "blue"),
                            size: 35,
                          ),
                  )
                ],
              ),
            )));
  }
}
