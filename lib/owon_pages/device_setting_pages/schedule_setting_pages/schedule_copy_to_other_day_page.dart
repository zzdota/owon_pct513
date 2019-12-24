import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:owon_pct513/component/owon_header.dart';
import 'package:owon_pct513/generated/i18n.dart';
import 'package:owon_pct513/owon_api/model/address_model_entity.dart';
import 'package:owon_pct513/owon_providers/owon_evenBus/list_evenbus.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';

class ScheduleCopySCH extends StatefulWidget {
  AddressModelAddrsDevlist devModel;
  Map<String, dynamic> mScheduleListModel;
  int mWeek;

  ScheduleCopySCH(this.devModel, this.mScheduleListModel, this.mWeek);

  @override
  _ScheduleCopySCHState createState() => _ScheduleCopySCHState();
}

class _ScheduleCopySCHState extends State<ScheduleCopySCH> {
  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;
  bool firstCheckBoxState = false,
      secondCheckBoxState = false,
      thirdCheckBoxState = false;
  bool fourthCheckBoxState = false,
      fifthCheckBoxState = false,
      sixCheckBoxState = false;

  String selectWeekStr;
  List<String> mWeekStr;

  @override
  void initState() {
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
        if (!topic.contains("WeeklySchedule")) {
          return;
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
//              if (mScheduleListModel != null) {
//                mScheduleListModel.clear();
//                mScheduleListModel = scheduleMode;
//              }
        });
      }
    });
    Future.delayed(Duration(seconds: 0), () {
      setState(() {
        mWeekStr = [
          S.of(context).global_sun,
          S.of(context).global_mon,
          S.of(context).global_tues,
          S.of(context).global_wed,
          S.of(context).global_thur,
          S.of(context).global_fri,
          S.of(context).global_sat
        ];
        selectWeekStr = mWeekStr[widget.mWeek];
        mWeekStr.removeAt(widget.mWeek);
        OwonLog.e("======>>>>$selectWeekStr");
        OwonLog.e("======>>>>$mWeekStr");
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _listEvenBusSubscription.cancel();
  }

  void copyScheduleValue(int des, int res) {
    for (int i = 0; i < 5; i++) {
      widget.mScheduleListModel["week${des}timeId$i"] =
          widget.mScheduleListModel["week${res}timeId$i"];

      widget.mScheduleListModel["week${des}startTime$i"] =
          widget.mScheduleListModel["week${res}startTime$i"];

      widget.mScheduleListModel["week${des}heatTemp$i"] =
          widget.mScheduleListModel["week${res}heatTemp$i"];

      widget.mScheduleListModel["week${des}coolTemp$i"] =
          widget.mScheduleListModel["week${res}coolTemp$i"];
    }
  }

  void _save() {
    if (firstCheckBoxState) {
      if (widget.mWeek == 0) {
        copyScheduleValue(1, widget.mWeek);
      } else {
        copyScheduleValue(0, widget.mWeek);
      }
    }
    if (secondCheckBoxState) {
      if (widget.mWeek == 1) {
        copyScheduleValue(2, widget.mWeek);
      } else {
        copyScheduleValue(1, widget.mWeek);
      }
    }
    if (thirdCheckBoxState) {
      if (widget.mWeek == 2) {
        copyScheduleValue(3, widget.mWeek);
      } else {
        copyScheduleValue(2, widget.mWeek);
      }
    }
    if (fourthCheckBoxState) {
      if (widget.mWeek == 3) {
        copyScheduleValue(4, widget.mWeek);
      } else {
        copyScheduleValue(3, widget.mWeek);
      }
    }
    if (fifthCheckBoxState) {
      if (widget.mWeek == 4) {
        copyScheduleValue(5, widget.mWeek);
      } else {
        copyScheduleValue(4, widget.mWeek);
      }
    }
    if (sixCheckBoxState) {
      if (widget.mWeek == 5) {
        copyScheduleValue(6, widget.mWeek);
      } else {
        copyScheduleValue(5, widget.mWeek);
      }
    }
    OwonLog.e("=====>schedule${widget.mScheduleListModel}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).schedule_title),
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
            SizedBox(
              height: 20,
            ),
            OwonHeader.header(
                context, OwonPic.scheduleSettingCopy, "To which days",
                subTitle: "would you like to",
                thirdTitle: "apply $selectWeekStr's schedule?",
                fontSize: 20.0,
                width: 200),
            SizedBox(
              height: 80.0,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              firstCheckBoxState = !firstCheckBoxState;
                            });
                          },
                          child: checkBox(firstCheckBoxState, mWeekStr[0]),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              fourthCheckBoxState = !fourthCheckBoxState;
                            });
                          },
                          child: checkBox(fourthCheckBoxState, mWeekStr[3]),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              secondCheckBoxState = !secondCheckBoxState;
                            });
                          },
                          child: checkBox(secondCheckBoxState, mWeekStr[1]),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              fifthCheckBoxState = !fifthCheckBoxState;
                            });
                          },
                          child: checkBox(fifthCheckBoxState, mWeekStr[4]),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              thirdCheckBoxState = !thirdCheckBoxState;
                            });
                          },
                          child: checkBox(thirdCheckBoxState, mWeekStr[2]),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              sixCheckBoxState = !sixCheckBoxState;
                            });
                          },
                          child: checkBox(sixCheckBoxState, mWeekStr[5]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget checkBox(bool value, String week) {
    return Container(
      child: Row(
        children: <Widget>[
          value
              ? SvgPicture.asset(
                  OwonPic.scheduleCopySelect,
                  height: 45,
                  width: 30,
                  color: OwonColor().getCurrent(context, "blue"),
                )
              : SvgPicture.asset(
                  OwonPic.scheduleCopyNoSelect,
                  height: 45,
                  width: 35,
                  color: OwonColor().getCurrent(context, "textColor"),
                ),
          SizedBox(
            width: 10,
          ),
          Text(
            week == null ? "" : week,
            style: TextStyle(
                color: OwonColor().getCurrent(context, "textColor"),
                fontSize: 16),
          ),
        ],
      ),
    );
  }
}
