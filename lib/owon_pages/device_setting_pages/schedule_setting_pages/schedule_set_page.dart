import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:owon_pct513/owon_providers/owon_evenBus/list_evenbus.dart';
import 'package:owon_pct513/owon_utils/owon_loading.dart';
import 'package:owon_pct513/owon_utils/owon_mqtt.dart';
import 'package:owon_pct513/owon_utils/owon_temperature.dart';
import 'package:owon_pct513/owon_utils/owon_toast.dart';
import 'package:owon_pct513/res/owon_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../component/owon_header.dart';
import '../../../component/owon_pickerView.dart';
import '../../../component/owon_timeTextfield.dart';
import '../../../owon_api/model/address_model_entity.dart';
import '../../../owon_utils/owon_log.dart';
import '../../../res/owon_picture.dart';
import '../../../generated/i18n.dart';
import '../../../res/owon_themeColor.dart';

class ScheduleSettingPage extends StatefulWidget {
  AddressModelAddrsDevlist devModel;
  Map<String, dynamic> mScheduleListModel;
  String mImageUrl;
  int mMode;
  int mWeek;
  bool mTempUnit;

  ScheduleSettingPage(this.devModel, this.mScheduleListModel, this.mImageUrl,
      this.mMode, this.mWeek, this.mTempUnit);

  @override
  _ScheduleSettingPageState createState() => _ScheduleSettingPageState();
}

class _ScheduleSettingPageState extends State<ScheduleSettingPage> {
  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;
  TextEditingController vc = TextEditingController();
  int _heatFValue = 26, _coolFValue = 26;
  double _heatCValue = 26.0, _coolCValue = 26.0;

  @override
  void initState() {
    vc.text = getStartTime();
    _heatCValue = widget
            .mScheduleListModel["week${widget.mWeek}heatTemp${widget.mMode}"] /
        100.0;
    _coolCValue = widget
            .mScheduleListModel["week${widget.mWeek}coolTemp${widget.mMode}"] /
        100.0;
    _heatFValue = OwonTemperature().cToF(widget
            .mScheduleListModel["week${widget.mWeek}heatTemp${widget.mMode}"] /
        100.0);
    _coolFValue = OwonTemperature().cToF(widget
            .mScheduleListModel["week${widget.mWeek}coolTemp${widget.mMode}"] /
        100.0);
    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
      String topic = msg["topic"];

      if (msg["type"] == "json") {
        Map<String, dynamic> payload = msg["payload"];
        OwonLog.e("----m=$payload");
      } else if (msg["type"] == "string") {
        String payload = msg["payload"];
        OwonLog.e("----上报的payload=$payload");

        if (topic.contains("TemperatureUnit")) {
          setState(() {
            if (payload == "0") {
              widget.mTempUnit = false;
            } else {
              widget.mTempUnit = true;
            }
          });
        }
      } else if (msg["type"] == "raw") {
        if (topic.contains("WeeklySchedule")) {
          if (topic.startsWith("reply")) {
            OwonLoading(context).dismiss();
            OwonToast.show(S.of(context).global_save_success);
            Navigator.pop(context);
          }
          List payload = msg["payload"];
          OwonLog.e("======>payload$payload");
          Map<String, dynamic> scheduleMode = Map();
          for (int i = 0; i < 7; i++) {
            List buf = payload.sublist(i * 35, 35 * i + 35);
            for (int m = 0; m < 5; m++) {
              List mode = buf.sublist(m * 7, 7 * m + 7);
              scheduleMode["week${i}timeId$m"] = mode[0];
              scheduleMode["week${i}startTime$m"] = (mode[1] << 8) + mode[2];
              scheduleMode["week${i}heatTemp$m"] = (mode[3] << 8) + mode[4];
              scheduleMode["week${i}coolTemp$m"] = (mode[5] << 8) + mode[6];
            }
          }
          setState(() {
            if (widget.mScheduleListModel != null) {
              widget.mScheduleListModel.clear();
              widget.mScheduleListModel = scheduleMode;
            }
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _listEvenBusSubscription.cancel();
  }

  List<int> mapScheduleToList() {
    List<int> buf = List();
    for (int i = 0; i < 7; i++) {
      for (int n = 0; n < 5; n++) {
        buf.add(widget.mScheduleListModel["week${i}timeId$n"]);
        buf.add(widget.mScheduleListModel["week${i}startTime$n"] >> 8);
        buf.add(widget.mScheduleListModel["week${i}startTime$n"] -
            ((widget.mScheduleListModel["week${i}startTime$n"] >> 8) << 8));
        buf.add(widget.mScheduleListModel["week${i}heatTemp$n"] >> 8);
        buf.add(widget.mScheduleListModel["week${i}heatTemp$n"] -
            ((widget.mScheduleListModel["week${i}heatTemp$n"] >> 8) << 8));
        buf.add(widget.mScheduleListModel["week${i}coolTemp$n"] >> 8);
        buf.add(widget.mScheduleListModel["week${i}coolTemp$n"] -
            ((widget.mScheduleListModel["week${i}coolTemp$n"] >> 8) << 8));
      }
    }
    return buf;
  }

  void _save() async {
    List timeStr = vc.text.split(" : ");
    int time = int.parse(timeStr[0]) * 60 + int.parse(timeStr[1]);
    double heatTemp, coolTemp;
    if (widget.mTempUnit) {
      heatTemp = OwonTemperature().fToC(_heatFValue) * 100;
      coolTemp = OwonTemperature().fToC(_coolFValue) * 100;
    } else {
      heatTemp = _heatCValue * 100;
      coolTemp = _coolCValue * 100;
    }
    widget.mScheduleListModel["week${widget.mWeek}startTime${widget.mMode}"] =
        time;
    widget.mScheduleListModel["week${widget.mWeek}heatTemp${widget.mMode}"] =
        heatTemp.toInt();
    widget.mScheduleListModel["week${widget.mWeek}coolTemp${widget.mMode}"] =
        coolTemp.toInt();
    OwonLog.e("------>>>>schedule${widget.mScheduleListModel}");

    List<int> data = mapScheduleToList();
//    OwonLog.e("=====>set schedule${widget.mScheduleListModel}");
//    OwonLog.e("=====>set schedule data$data");

    OwonLoading(context).show();
    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic =
        "api/device/${widget.devModel.deviceid}/$clientID/attribute/WeeklySchedule";
//    var msg;
//    msg = data.toString();
    OwonMqtt.getInstance().publishRawMessage(topic, data);
    OwonLog.e("=====>set schedule$data");
//    OwonLog.e("=====>copy schedule data string===>>$msg");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(S.of(context).schedule_setting_title),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              onPressed: _save,
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
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    OwonHeader.header(
                        context, widget.mImageUrl, getTitleStr(widget.mWeek),
                        width: 200),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(50, 80, 100, 0),
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              OwonPic.scheduleTimeIcon,
                              width: 25,
                              color:
                                  OwonColor().getCurrent(context, "textColor"),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: OwonTimeTextField(context, vc, () async {
                                var picker = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now());
                                setState(() {
                                  vc.text =
                                      "${picker.hour.toString().padLeft(2, '0')} : ${picker.minute.toString().padLeft(2, '0')}";
                                  OwonLog.e(vc.text);
                                });
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                margin: EdgeInsets.only(left: 50, right: 50),
                color: OwonColor().getCurrent(context, "textfieldColor"),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(50, 0, 50, 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              OwonPic.mSysHeat,
                              color: OwonColor()
                                  .getCurrent(context, "borderDisconnect"),
                              width: 20,
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                              width: 100,
                              child: widget.mTempUnit
                                  ? OwonNumberPicker.integer(
                                      initialValue: _heatFValue,
                                      minValue: 41,
                                      maxValue: 86,
                                      selectItemFontColor: OwonColor()
                                          .getCurrent(context, "textColor"),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: OwonColor().getCurrent(
                                                      context, "blue")),
                                              top: BorderSide(
                                                  width: 1,
                                                  color: OwonColor().getCurrent(
                                                      context, "blue")))),
                                      onChanged: (newValue) {
                                        setState(() {
                                          _heatFValue = newValue;
                                        });
                                      })
                                  : OwonNumberPicker.decimal(
                                      initialValue: _heatCValue,
                                      minValue: 5,
                                      maxValue: 30,
                                      listViewWidth: 50,
                                      selectItemFontColor: OwonColor()
                                          .getCurrent(context, "textColor"),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: OwonColor().getCurrent(context, "blue")),
                                              top: BorderSide(width: 1, color: OwonColor().getCurrent(context, "blue")))),
                                      onChanged: (newValue) {
                                        setState(() {
                                          _heatCValue = newValue;
                                        });
                                      }),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              OwonPic.mSysCool,
                              color: OwonColor().getCurrent(context, "blue"),
                              width: 20,
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                              width: 100,
                              child: widget.mTempUnit
                                  ? OwonNumberPicker.integer(
                                      initialValue: _coolFValue,
                                      minValue: 45,
                                      maxValue: 88,
                                      selectItemFontColor: OwonColor()
                                          .getCurrent(context, "textColor"),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: OwonColor().getCurrent(
                                                      context, "blue")),
                                              top: BorderSide(
                                                  width: 1,
                                                  color: OwonColor().getCurrent(
                                                      context, "blue")))),
                                      onChanged: (newValue) {
                                        setState(() {
                                          _coolFValue = newValue;
                                        });
                                      })
                                  : OwonNumberPicker.decimal(
                                      initialValue: _coolCValue,
                                      minValue: 7,
                                      maxValue: 32,
                                      listViewWidth: 50,
                                      selectItemFontColor: OwonColor()
                                          .getCurrent(context, "textColor"),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: OwonColor().getCurrent(context, "blue")),
                                              top: BorderSide(width: 1, color: OwonColor().getCurrent(context, "blue")))),
                                      onChanged: (newValue) {
                                        setState(() {
                                          _coolFValue = newValue;
                                        });
                                      }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  String getTitleStr(int week) {
    String value;
    switch (week) {
      case 0:
        value = "${S.of(context).global_sun} ${S.of(context).tab_set}";
        break;
      case 1:
        value = "${S.of(context).global_mon} ${S.of(context).tab_set}";
        break;
      case 2:
        value = "${S.of(context).global_tues} ${S.of(context).tab_set}";
        break;
      case 3:
        value = "${S.of(context).global_wed} ${S.of(context).tab_set}";
        break;
      case 4:
        value = "${S.of(context).global_thur} ${S.of(context).tab_set}";
        break;
      case 5:
        value = "${S.of(context).global_fri} ${S.of(context).tab_set}";
        break;
      case 6:
        value = "${S.of(context).global_sat} ${S.of(context).tab_set}";
        break;
    }
    return value;
  }

  String getStartTime() {
    int mode = widget.mMode;
    if (widget.mScheduleListModel.length == 0) {
      return "-- : --";
    } else {
      int hour =
          (widget.mScheduleListModel["week${widget.mWeek}startTime$mode"] / 60)
              .toInt();
      int min =
          widget.mScheduleListModel["week${widget.mWeek}startTime$mode"] % 60;
      return "${hour.toString().padLeft(2, '0')} : ${min.toString().padLeft(2, '0')}";
    }
  }
}
