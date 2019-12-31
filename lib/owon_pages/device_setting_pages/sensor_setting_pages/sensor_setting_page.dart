import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../generated/i18n.dart';
import '../../../owon_api/model/address_model_entity.dart';
import '../../../owon_api/model/sensor_list_model_entity.dart';
import '../../../owon_pages/device_setting_pages/sensor_setting_pages/sensor_setting_about_page.dart';
import '../../../owon_pages/device_setting_pages/sensor_setting_pages/sensor_setting_name_page.dart';
import '../../../owon_pages/device_setting_pages/sensor_setting_pages/sensor_setting_participation_period_page.dart';
import '../../../owon_providers/owon_evenBus/list_evenbus.dart';
import '../../../owon_providers/theme_provider.dart';
import '../../../owon_utils/owon_loading.dart';
import '../../../owon_utils/owon_log.dart';
import '../../../owon_utils/owon_mqtt.dart';
import '../../../owon_utils/owon_text_icon_button.dart';
import '../../../owon_utils/owon_toast.dart';
import '../../../res/owon_constant.dart';
import '../../../res/owon_picture.dart';
import '../../../res/owon_themeColor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SensorSettingPage extends StatefulWidget {
  AddressModelAddrsDevlist devModel;
  SensorListModelEntity sensorListModelEntity;
  int index;
  SensorSettingPage(this.devModel, this.sensorListModelEntity, this.index);

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
        if (topic.contains("SensorList")) {
          if (topic.startsWith("reply")) {
            OwonLoading(context).dismiss();
            OwonToast.show(S.of(context).global_save_success);
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
          setState(() {
            widget.sensorListModelEntity =
                SensorListModelEntity.fromJson(sensorMode);
          });
        }
      }
    });
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

  int byteToInt(List list) {
    int value = 0;
    for (int i = 0; i < list.length; i++) {
      value = value + (list[i] << ((list.length - i - 1) * 8));
    }
    return value;
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

  void delete(int index) async {
    OwonLoading(context).show();
    widget.sensorListModelEntity.para.remove(index);
    List<int> data = mapSensorToList();
    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic =
        "api/device/${widget.devModel.deviceid}/$clientID/attribute/SensorList";
    OwonMqtt.getInstance().publishRawMessage(topic, data);
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
        body: Column(
          children: <Widget>[
            Container(
                height: OwonConstant.cHeight,
                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SensorRenamePage(widget.devModel,
                            widget.sensorListModelEntity, widget.index)));
                  },
                  child: createCard(
                      Provider.of<ThemeProvider>(context).themeIndex == 0
                          ? OwonPic.dSetRenameB
                          : OwonPic.dSetRenameW,
                      S.of(context).sensor_setting_sensor_name),
                )),
            Container(
                height: OwonConstant.cHeight,
                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SensorParticipationPeriodPage(
                            widget.devModel,
                            widget.sensorListModelEntity,
                            widget.index)));
                  },
                  child: createCard(
                      Provider.of<ThemeProvider>(context).themeIndex == 0
                          ? OwonPic.sensorSettingParticipationPeriodB
                          : OwonPic.sensorSettingParticipationPeriodW,
                      S.of(context).sensor_setting_participation_period),
                )),
            Container(
                height: OwonConstant.cHeight,
                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SensorAboutPage(widget.devModel,
                            widget.sensorListModelEntity, widget.index)));
                  },
                  child: createCard(
                      Provider.of<ThemeProvider>(context).themeIndex == 0
                          ? OwonPic.dSetDeviceInfoB
                          : OwonPic.dSetDeviceInfoW,
                      S.of(context).sensor_setting_sensor_about),
                )),
            widget.index == 0
                ? Container()
                : Container(
                    height: OwonConstant.systemHeight,
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(10, 4, 10, 0),
                    child: InkWell(
                      onTap: () {
                        delete(widget.index);
                      },
                      child: OwonTextIconButton.icon(
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(OwonConstant.cRadius),
                          ),
                          onPressed: () {},
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          label: Text(
                            S.of(context).sensor_setting_delete_sensor,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          iconTextAlignment:
                              TextIconAlignment.iconRightTextLeft),
                    ))
          ],
        ));
  }

  Widget createCard(String imageUrl, String title) {
    return Card(
      shape: RoundedRectangleBorder(
          side: BorderSide(
            color: OwonColor().getCurrent(context, "borderNormal"),
            width: 1.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  imageUrl,
                  width: 20,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: OwonColor().getCurrent(context, "textColor"),
                      fontSize: 16.0),
                ),
              ],
            ),
            Icon(Icons.keyboard_arrow_right,
                color: OwonColor().getCurrent(context, "textColor"))
          ],
        ),
      ),
    );
  }
}
