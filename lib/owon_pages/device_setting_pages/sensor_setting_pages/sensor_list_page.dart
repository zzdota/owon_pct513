import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:owon_pct513/generated/i18n.dart';
import 'package:owon_pct513/owon_api/model/address_model_entity.dart';
import 'package:owon_pct513/owon_api/model/sensor_list_model_entity.dart';
import 'package:owon_pct513/owon_pages/device_setting_pages/sensor_setting_pages/sensor_setting_page.dart';
import 'package:owon_pct513/owon_providers/owon_evenBus/list_evenbus.dart';
import 'package:owon_pct513/owon_utils/owon_loading.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:owon_pct513/owon_utils/owon_mqtt.dart';
import 'package:owon_pct513/owon_utils/owon_temperature.dart';
import 'package:owon_pct513/owon_utils/owon_toast.dart';
import 'package:owon_pct513/res/owon_constant.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import 'package:owon_pct513/res/owon_sequence.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SensorListPage extends StatefulWidget {
  AddressModelAddrsDevlist devModel;
  SensorListPage(this.devModel);

  @override
  _SensorListPageState createState() => _SensorListPageState();
}

class _SensorListPageState extends State<SensorListPage> {
  final SlidableController slidableController = SlidableController();
  EasyRefreshController refreshController = EasyRefreshController();

  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;
  SensorListModelEntity mSensorListModelEntity;
  int mSensorListCount = 0;
  bool _switchValue = true;

  @override
  void initState() {
    super.initState();
    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
      String topic = msg["topic"];

      if (msg["type"] == "json") {
        Map<String, dynamic> payload = msg["payload"];
        OwonLog.e("----sensor list page===>>>$payload");
        if (payload["attributeName"].contains("SensorList")) {
          OwonLoading(context).dismiss();
          List value = base64Decode(payload["attributeValue"]).toList();
          int count = value[0];
          value = value.sublist(1, value.length);
          List sensor = List();
          Map<String, dynamic> sensorMode = Map();
          for (int i = 0; i < count; i++) {
            sensor.add(value.sublist(i * 51, 51 * i + 51));
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
          mSensorListModelEntity = SensorListModelEntity.fromJson(sensorMode);
          setState(() {
            mSensorListCount = mSensorListModelEntity.para.length;
          });
        }
      } else if (msg["type"] == "string") {
        String payload = msg["payload"];
        OwonLog.e("----上报的payload=$payload");
      } else if (msg["type"] == "raw") {
        if (topic.contains("SensorList")) {
          if(topic.startsWith("reply")){
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
          mSensorListModelEntity = SensorListModelEntity.fromJson(sensorMode);
          setState(() {
            mSensorListCount = mSensorListModelEntity.para.length;
          });
        }
      }
    });

    Future.delayed(Duration(seconds: 0), () {
      toGetSensorList();
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

  toGetSensorList() async {
    OwonLoading(context).show();
    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic = "api/cloud/$clientID";
    Map p = Map();
    p["command"] = "device.attr.raw";
    p["sequence"] = OwonSequence.getSensorList;
    p["deviceid"] = widget.devModel.deviceid;
    p["attributeName"] = "SensorList";
    var msg = JsonEncoder.withIndent("  ").convert(p);
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }

  List<int> mapSensorToList() {
    List<int> buf = List();
    buf.add(mSensorListModelEntity.para.length);
    for (int i = 0; i < mSensorListModelEntity.para.length; i++) {
      SensorListModelParam sensorPara = mSensorListModelEntity.para[i];

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

  void save() async {
//    OwonLoading(context).show();
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
        appBar: AppBar(title: Text(S.of(context).sensor_list_title)),
        body: EasyRefresh(
          controller: refreshController,
          header: ClassicalHeader(
            textColor: OwonColor().getCurrent(context, "textColor"),
          ),
          footer: ClassicalFooter(
              textColor: OwonColor().getCurrent(context, "textColor"),
              enableInfiniteLoad: false),
          onRefresh: () async {
//          toGetList();
            OwonLog.e("refresh");
          },
          child: ListView.builder(
              itemCount: mSensorListCount,
              itemBuilder: (context, index) {
                return index == 0
                    ? setCard(index)
                    : Slidable(
                        key: Key(index.toString()),
                        controller: slidableController,
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        enabled: true,
                        dismissal: SlidableDismissal(
                          dismissThresholds: {SlideActionType.secondary: 0.6},
                          child: SlidableDrawerDismissal(),
                          onDismissed: (actionType) {
                            OwonLog.e("什么时候调用 啊");
                          },
                          onWillDismiss: (actionType) {
                            return _slideDelete(index);
                          },
                        ),
                        child: setCard(index),
                        secondaryActions: <Widget>[
                          Container(
                            padding: EdgeInsets.all(5),
                            child: IconSlideAction(
                                caption: S.of(context).global_delete,
                                color: Colors.red,
                                icon: Icons.delete,
                                closeOnTap: true,
                                onTap: () {
                                  _tapDelete(index);
                                }),
                          ),
                        ],
                      );
              }),
        ));
  }

  Widget setCard(int index) {
    return Container(
      height: OwonConstant.listHeight,
      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SensorSettingPage(
                  widget.devModel, mSensorListModelEntity, index)));
        },
        child: Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: OwonColor().getCurrent(context, "borderNormal"),
                  width: 1.0,
                ),
                borderRadius:
                    BorderRadius.all(Radius.circular(OwonConstant.cRadius))),
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoSwitch(
                      value: mSensorListModelEntity.para[index].enable == 0
                          ? false
                          : true,
                      activeColor: OwonColor().getCurrent(context, "blue"),
                      onChanged: (bool value) {
                        ///点击切换开关的状态
                        setState(() {
                          mSensorListModelEntity.para[index].enable =
                              value ? 1 : 0;
                          save();
                        });
                      }),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    mSensorListModelEntity.para[index].name,
                    style: TextStyle(
                        color: OwonColor().getCurrent(context, "textColor"),
                        fontSize: 16),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    widget.devModel.tempUnit
                        ? "${OwonTemperature().cToF(mSensorListModelEntity.para[index].temp / 100)}${S.of(context).global_fahrenheit_unit} / ${mSensorListModelEntity.para[index].occupy == 0 ? S.of(context).sensor_list_occupied : S.of(context).sensor_list_unoccupied}"
                        : "${(mSensorListModelEntity.para[index].temp / 100)}${S.of(context).global_celsius_unit} / ${mSensorListModelEntity.para[index].occupy == 0 ? S.of(context).sensor_list_occupied : S.of(context).sensor_list_unoccupied}",
                    style: TextStyle(
                        color: OwonColor().getCurrent(context, "blue"),
                        fontSize: 16),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: OwonColor().getCurrent(context, "textColor"),
                  )
                ],
              ),
            )),
      ),
    );
  }

  FutureOr<bool> _slideDelete(int index) {
    OwonLog.e("====$index");
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete'),
          content: Text('Item will be deleted'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  _tapDelete(int index) {
    OwonLog.e("点击了删除index=$index");
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete'),
          content: Text('Item will be deleted'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }
}
