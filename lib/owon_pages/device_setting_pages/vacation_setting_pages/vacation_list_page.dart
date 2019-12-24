import 'dart:async';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:owon_pct513/owon_api/model/address_model_entity.dart';
import 'package:owon_pct513/owon_api/model/sensor_list_model_entity.dart';
import 'package:owon_pct513/owon_pages/device_setting_pages/vacation_setting_pages/vacation_set_page.dart';
import 'package:owon_pct513/res/owon_sequence.dart';
import '../../../owon_utils/owon_mqtt.dart';
import '../../../res/owon_constant.dart';
import '../../../res/owon_picture.dart';
import '../../../owon_utils/owon_log.dart';
import '../../../res/owon_themeColor.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../../generated/i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../owon_providers/owon_evenBus/list_evenbus.dart';

class VacationListPage extends StatefulWidget {
  AddressModelAddrsDevlist devModel;
  VacationListPage(this.devModel);
  @override
  _VacationListPageState createState() => _VacationListPageState();
}

class _VacationListPageState extends State<VacationListPage> {
  final SlidableController slidableController = SlidableController();
  EasyRefreshController refreshController = EasyRefreshController();
  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;
  bool hadData = true;

  @override
  void initState() {
    super.initState();

    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
      String topic = msg["topic"];

      if (msg["type"] == "json") {
        Map<String, dynamic> payload = msg["payload"];
        if (payload["attributeName"] == "VactionSchedule") {
          OwonLog.e("======");
          String value = payload["attributeValue"];
          List listPayload = convert.base64Decode(value).toList();
          OwonLog.e("des=$listPayload");

          int count = listPayload[0];
          listPayload = listPayload.sublist(1, listPayload.length);
          List sensor = List();
          Map<String, dynamic> sensorMode = Map();
          for (int i = 0; i < count; i++) {
            sensor.add(listPayload.sublist(i * 14, 14 * i + 14));
          }
          List buf = List();
          for (int e = 0; e < sensor.length; e++) {
            Map<String, dynamic> sensorPara = Map();
            sensorPara["sYear"] = sensor[e][0];
            sensorPara["sMonth"] = sensor[e][1];
            sensorPara["sDay"] = sensor[e][2];
            sensorPara["sHour"] = sensor[e][3];
            sensorPara["sMin"] = sensor[e][4];

            sensorPara["eYear"] = sensor[e][5];
            sensorPara["eMonth"] = sensor[e][6];
            sensorPara["eDay"] = sensor[e][7];
            sensorPara["eHour"] = sensor[e][8];
            sensorPara["eMin"] = sensor[e][9];

            sensorPara["heat"] = byteToInt(sensor[e].sublist(10, 12));

            sensorPara["cool"] = byteToInt(sensor[e].sublist(12, 14));
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


        }
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

    Future.delayed(Duration(seconds: 1), () {
      toGetList();
    });
  }

  int byteToInt(List list) {
    int value = 0;
    for (int i = 0; i < list.length; i++) {
      value = value + (list[i] << ((list.length - i - 1) * 8));
    }
    return value;
  }

  setProperty({String attribute, List<int> value}) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic =
        "api/device/${widget.devModel.deviceid}/$clientID/attribute/$attribute";
//    var msg = value;

    OwonLog.e("value========>$value");
//    OwonMqtt.getInstance().publishMessage(topic, msg);
  OwonMqtt.getInstance().publishRawMessage(topic, value);
  }

 List<int> createList(){
    List<int> fisrt = [1,19,12,24,14,32,19,12,25,23,59,10,40,10,0];
    List<int> tem =  List.generate(141-fisrt.length, (index){
      return 255;
    });

     List<int> desList =[];
    desList.addAll(fisrt);
    desList.addAll(tem);
    return desList;
  }

  toGetList() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic = "api/cloud/$clientID";
    Map p = Map();
    p["command"] = "device.attr.raw";
    p["sequence"] = OwonSequence.temp;
    p["deviceid"] = widget.devModel.deviceid;
    p["attributeName"] = "VactionSchedule";
    var msg = convert.JsonEncoder.withIndent("  ").convert(p);
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).vacation_title),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  setProperty(attribute: "VactionSchedule",value: createList());
                },
                icon: Icon(
                  Icons.add,
                  color: OwonColor().getCurrent(context, "textColor"),
                  size: 30,
                ))
          ],
        ),
        body: hadData
            ? EasyRefresh(
                controller: refreshController,
                header: ClassicalHeader(
                  textColor: OwonColor().getCurrent(context, "textColor"),
                ),
                footer: ClassicalFooter(
                    textColor: OwonColor().getCurrent(context, "textColor"),
                    enableInfiniteLoad: false),
                onRefresh: () async {
                  toGetList();
                  OwonLog.e("refresh");
                },
                onLoad: () async {
                  OwonLog.e("load");
                },
                child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Slidable(
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
                        child: Container(
                          height: OwonConstant.cHeight,
                          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => VacationSettingPage()));
                            },
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: OwonColor()
                                          .getCurrent(context, "borderNormal"),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(OwonConstant.cRadius))),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(30, 0, 15, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "PCT513",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: OwonColor().getCurrent(
                                                context, "textColor")),
                                      ),
                                      Text(
                                        "PCT513",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: OwonColor().getCurrent(
                                                context, "textColor")),
                                      ),
                                      getRightWidget(true)
                                    ],
                                  ),
                                )),
                          ),
                        ),
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
                    }))
            : getNoDataWidget());
  }

  Widget getNoDataWidget() {
    return Container(
//      color: Colors.red,
//      width: ScreenUtil.screenWidth - 40,
      padding: EdgeInsets.fromLTRB(0, 90, 0, 0),
      child: Column(
        children: <Widget>[
          Image.asset(
            OwonPic.dVacNoSetB,
            width: 110,
          ),
          SizedBox(
            height: 70,
          ),
          Container(
//              color: Colors.purple,
              padding: EdgeInsets.fromLTRB(80, 0, 80, 0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    color: OwonColor().getCurrent(context, "textColor"),
                    width: 2,
                    height: 60,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      S.of(context).vacation_noEvent,
                      style: TextStyle(
                          fontSize: 22,
                          color: OwonColor().getCurrent(
                            context,
                            "textColor",
                          )),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget getRightWidget(bool normal) {
    if (normal) {
      return Icon(
        Icons.keyboard_arrow_right,
        color: OwonColor().getCurrent(context, "textColor"),
      );
    } else {
      return Row(
        children: <Widget>[
          Image.asset(
            "assets/images/launch_icon.png",
            fit: BoxFit.contain,
            height: 20,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            S.of(context).list_disconnect,
            style: TextStyle(
                color: OwonColor().getCurrent(context, "borderDisconnect")),
          )
        ],
      );
    }
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
