import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../owon_utils/owon_loading.dart';
import '../../../owon_utils/owon_toast.dart';
import '../../../res/owon_sequence.dart';
import '../../../owon_utils/owon_temperature.dart';
import '../../../owon_api/model/address_model_entity.dart';
import '../../../owon_pages/device_setting_pages/schedule_setting_pages/schedule_copy_to_other_day_page.dart';
import '../../../owon_pages/device_setting_pages/schedule_setting_pages/schedule_set_page.dart';
import '../../../owon_utils/owon_mqtt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../owon_utils/owon_text_icon_button.dart';
import '../../../res/owon_constant.dart';
import '../../../res/owon_picture.dart';
import '../../../owon_utils/owon_log.dart';
import '../../../res/owon_themeColor.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../../generated/i18n.dart';
import '../../../owon_providers/owon_evenBus/list_evenbus.dart';

class ScheduleListPage extends StatefulWidget {
  AddressModelAddrsDevlist devModel;
  ScheduleListPage(this.devModel);

  @override
  _ScheduleListPageState createState() => _ScheduleListPageState();
}

class _ScheduleListPageState extends State<ScheduleListPage> {
  EasyRefreshController refreshController = EasyRefreshController();
  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;
  bool hadData = true;
  Map<String, dynamic> mScheduleListModel = Map();
  bool tempUnit = false;
  bool _switchValue = true;
  int _selectTab = 0;

  @override
  void initState() {
    tempUnit = widget.devModel.tempUnit;
    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
      String topic = msg["topic"];

      if (msg["type"] == "json") {
        Map<String, dynamic> payload = msg["payload"];
        OwonLog.e("----m=$payload");
        if (payload["attributeName"].contains("WeeklySchedule")) {
          OwonLoading(context).dismiss();
          List value = base64Decode(payload["attributeValue"]).toList();
          OwonLog.e("=====>>>>value$value");
          Map<String, dynamic> scheduleMode = Map();
          for (int i = 0; i < 7; i++) {
            List buf = value.sublist(i * 35, 35 * i + 35);
            for (int m = 0; m < 5; m++) {
              List mode = buf.sublist(m * 7, 7 * m + 7);
              scheduleMode["week${i}timeId$m"] = mode[0];
              scheduleMode["week${i}startTime$m"] = (mode[1] << 8) + mode[2];
              scheduleMode["week${i}heatTemp$m"] = (mode[3] << 8) + mode[4];
              scheduleMode["week${i}coolTemp$m"] = (mode[5] << 8) + mode[6];
            }
          }
          setState(() {
            if (mScheduleListModel != null) {
              mScheduleListModel.clear();
              mScheduleListModel = scheduleMode;
            }
          });
        } else if (payload["attributeName"].contains("ProgramOperationMode")) {
          String value = payload["attributeValue"];
          OwonLog.e("=====>>>>value$value");
          setState(() {
            if (value == "0") {
              _switchValue = false;
              hadData = false;
              OwonLoading(context).dismiss();
            } else {
              _switchValue = true;
              hadData = true;
              toGetScheduleList();
            }
          });
        }
      } else if (msg["type"] == "string") {
        String payload = msg["payload"];
        OwonLog.e("----上报的payload=$payload");
        if (topic.contains("TemperatureUnit")) {
          setState(() {
            if (payload == "0") {
              tempUnit = false;
            } else {
              tempUnit = true;
            }
          });
        } else if (topic.contains("ProgramOperationMode")) {
          if (topic.startsWith("reply")) {
            OwonLoading(context).hide().then((e) {
              OwonToast.show(S.of(context).global_save_success);
            });
            setState(() {
              if (payload == "0") {
                _switchValue = false;
                hadData = false;
              } else {
                _switchValue = true;
                hadData = true;
                toGetScheduleList();
              }
            });
          }
        }
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
          if (mScheduleListModel != null) {
            mScheduleListModel.clear();
            mScheduleListModel = scheduleMode;
          }
        });
      }
    });
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      toGetScheduleEnable();
      toGetCurrentWeek();
    });
  }

  toGetCurrentWeek() {
    setState(() {
      _selectTab = DateTime.now().weekday;
    });
  }

  toGetScheduleList() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic = "api/cloud/$clientID";
    Map p = Map();
    p["command"] = "device.attr.raw";
    p["sequence"] = OwonSequence.schedule;
    p["deviceid"] = widget.devModel.deviceid;
    p["attributeName"] = "WeeklySchedule";
    var msg = JsonEncoder.withIndent("  ").convert(p);
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }

  toGetScheduleEnable() async {
    OwonLoading(context).show();
    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic = "api/cloud/$clientID";
    Map p = Map();
    p["command"] = "device.attr.str";
    p["sequence"] = OwonSequence.getScheduleEnable;
    p["deviceid"] = widget.devModel.deviceid;
    p["attributeName"] = "ProgramOperationMode";
    var msg = JsonEncoder.withIndent("  ").convert(p);
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }

  void setScheduleEnable() async {
    OwonLoading(context).show();
    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic =
        "api/device/${widget.devModel.deviceid}/$clientID/attribute/ProgramOperationMode";
    var msg;
    if (_switchValue) {
      msg = "1";
    } else {
      msg = "0";
    }
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }

  @override
  void dispose() {
    super.dispose();
    _listEvenBusSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 7,
        initialIndex: DateTime.now().weekday,
        child: Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).schedule_title),
              centerTitle: true,
              elevation: 0,
              actions: <Widget>[
                CupertinoSwitch(
                    value: _switchValue,
                    activeColor: OwonColor().getCurrent(context, "blue"),
                    onChanged: (bool value) {
                      ///点击切换开关的状态
                      setState(() {
                        _switchValue = value;
                        setScheduleEnable();
                      });
                    })
              ],
              bottom: hadData
                  ? PreferredSize(
                      preferredSize: Size(200.0, 80.0),
                      child: Container(
                        color: OwonColor().getCurrent(context, "primaryColor"),
                        width: double.infinity,
                        height: 80,
                        child: TabBar(
                            isScrollable: false,
                            unselectedLabelColor:
                                OwonColor().getCurrent(context, "textColor"),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                                shape: BoxShape.circle,
                                color: OwonColor().getCurrent(context, "blue")),
                            labelPadding: EdgeInsets.all(1),
                            onTap: (v) {
                              setState(() {
                                _selectTab = v;
                              });
                            },
                            tabs: [
                              Tab(
                                child: Text(
                                  S.of(context).global_sun,
                                  style: TextStyle(
                                      color: _selectTab == 0
                                          ? Colors.white
                                          : OwonColor()
                                              .getCurrent(context, "textColor"),
                                      fontSize: _selectTab == 0
                                          ? OwonConstant
                                              .scheduleWeekFontsizeSelect
                                          : OwonConstant
                                              .scheduleWeekFontsizeNoSelect),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  S.of(context).global_mon,
                                  style: TextStyle(
                                      color: _selectTab == 1
                                          ? Colors.white
                                          : OwonColor()
                                              .getCurrent(context, "textColor"),
                                      fontSize: _selectTab == 1
                                          ? OwonConstant
                                              .scheduleWeekFontsizeSelect
                                          : OwonConstant
                                              .scheduleWeekFontsizeNoSelect),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  S.of(context).global_tues,
                                  style: TextStyle(
                                      color: _selectTab == 2
                                          ? Colors.white
                                          : OwonColor()
                                              .getCurrent(context, "textColor"),
                                      fontSize: _selectTab == 2
                                          ? OwonConstant
                                              .scheduleWeekFontsizeSelect
                                          : OwonConstant
                                              .scheduleWeekFontsizeNoSelect),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  S.of(context).global_wed,
                                  style: TextStyle(
                                      color: _selectTab == 3
                                          ? Colors.white
                                          : OwonColor()
                                              .getCurrent(context, "textColor"),
                                      fontSize: _selectTab == 3
                                          ? OwonConstant
                                              .scheduleWeekFontsizeSelect
                                          : OwonConstant
                                              .scheduleWeekFontsizeNoSelect),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  S.of(context).global_thur,
                                  style: TextStyle(
                                      color: _selectTab == 4
                                          ? Colors.white
                                          : OwonColor()
                                              .getCurrent(context, "textColor"),
                                      fontSize: _selectTab == 4
                                          ? OwonConstant
                                              .scheduleWeekFontsizeSelect
                                          : OwonConstant
                                              .scheduleWeekFontsizeNoSelect),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  S.of(context).global_fri,
                                  style: TextStyle(
                                      color: _selectTab == 5
                                          ? Colors.white
                                          : OwonColor()
                                              .getCurrent(context, "textColor"),
                                      fontSize: _selectTab == 5
                                          ? OwonConstant
                                              .scheduleWeekFontsizeSelect
                                          : OwonConstant
                                              .scheduleWeekFontsizeNoSelect),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  S.of(context).global_sat,
                                  style: TextStyle(
                                      color: _selectTab == 6
                                          ? Colors.white
                                          : OwonColor()
                                              .getCurrent(context, "textColor"),
                                      fontSize: _selectTab == 6
                                          ? OwonConstant
                                              .scheduleWeekFontsizeSelect
                                          : OwonConstant
                                              .scheduleWeekFontsizeNoSelect),
                                ),
                              ),
                            ]),
                      ),
                    )
                  : null,
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
                      toGetScheduleList();
                      OwonLog.e("refresh");
                    },
//                    onLoad: () async {
//                      OwonLog.e("load");
//                    },
                    child: Column(
                      children: <Widget>[
                        getCard(
                            OwonPic.scheduleModeWake,
                            S.of(context).schedule_mode_wake,
                            0,
                            getStartTime(0),
                            getHeatTemp(0),
                            getCoolTemp(0)),
                        getCard(
                            OwonPic.scheduleModeAway,
                            S.of(context).schedule_mode_away,
                            1,
                            getStartTime(1),
                            getHeatTemp(1),
                            getCoolTemp(1)),
                        getCard(
                            OwonPic.scheduleModeHome,
                            S.of(context).schedule_mode_home,
                            2,
                            getStartTime(2),
                            getHeatTemp(2),
                            getCoolTemp(2)),
                        getCard(
                            OwonPic.scheduleModeSleep,
                            S.of(context).schedule_mode_sleep,
                            3,
                            getStartTime(3),
                            getHeatTemp(3),
                            getCoolTemp(3)),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          height: OwonConstant.systemHeight,
                          margin: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: OwonTextIconButton.icon(
                              onPressed: () {
                                if (mScheduleListModel.length != 0) {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return ScheduleCopySCH(widget.devModel,
                                        mScheduleListModel, _selectTab);
                                  }));
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      OwonConstant.cRadius)),
                              icon: SvgPicture.asset(
                                OwonPic.scheduleCopy,
                                color: Colors.white,
                                height: 22.0,
                              ),
                              label: Text(
                                S.of(context).schedule_copy_sch,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                              iconTextAlignment:
                                  TextIconAlignment.iconRightTextLeft),
                        ),
                      ],
                    ),
                  )
                : getNoDataWidget()));
  }

  Widget getNoDataWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 90, 0, 0),
      child: Column(
        children: <Widget>[
          Image.asset(
            OwonPic.scheduleDisabled,
            width: 110,
          ),
          SizedBox(
            height: 70,
          ),
          Container(
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
                      S.of(context).schedule_disabled_tip,
                      style: TextStyle(
                          fontSize: 22,
                          color: OwonColor().getCurrent(
                            context,
                            "textColor",
                          )),
                      maxLines: 2,
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

  Widget getCard(String imageUrl, String modeStr, int modeNum, String timeStr,
      String heatStr, String coolStr) {
    return Container(
        height: OwonConstant.cHeight,
        padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
        child: InkWell(
          onTap: () {
            switch (modeNum) {
              case 0:
                if (mScheduleListModel.length != 0) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ScheduleSettingPage(
                        widget.devModel,
                        mScheduleListModel,
                        OwonPic.scheduleSettingModeWake,
                        0,
                        _selectTab,
                        tempUnit);
                  }));
                }
                break;
              case 1:
                if (mScheduleListModel.length != 0) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ScheduleSettingPage(
                        widget.devModel,
                        mScheduleListModel,
                        OwonPic.scheduleSettingModeAway,
                        1,
                        _selectTab,
                        tempUnit);
                  }));
                }
                break;
              case 2:
                if (mScheduleListModel.length != 0) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ScheduleSettingPage(
                        widget.devModel,
                        mScheduleListModel,
                        OwonPic.scheduleSettingModeHome,
                        2,
                        _selectTab,
                        tempUnit);
                  }));
                }
                break;
              case 3:
                if (mScheduleListModel.length != 0) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ScheduleSettingPage(
                        widget.devModel,
                        mScheduleListModel,
                        OwonPic.scheduleSettingModeSleep,
                        3,
                        _selectTab,
                        tempUnit);
                  }));
                }
                break;
            }
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
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 100.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                            imageUrl,
                            color: OwonColor().getCurrent(context, "textColor"),
                            width: 40,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            modeStr,
                            style: TextStyle(
                                color: OwonColor()
                                    .getCurrent(context, "textColor")),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 30.0),
                        height: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                SvgPicture.asset(
                                  OwonPic.scheduleTimeIcon,
                                  color: OwonColor()
                                      .getCurrent(context, "textColor"),
                                  width: 15,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  timeStr,
                                  style: TextStyle(
                                      color: OwonColor()
                                          .getCurrent(context, "textColor")),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                SvgPicture.asset(
                                  OwonPic.mSysHeat,
                                  color: OwonColor()
                                      .getCurrent(context, "borderDisconnect"),
                                  width: 15,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  heatStr,
                                  style: TextStyle(
                                      color: OwonColor().getCurrent(
                                          context, "borderDisconnect")),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                SvgPicture.asset(
                                  OwonPic.mSysCool,
                                  color:
                                      OwonColor().getCurrent(context, "blue"),
                                  width: 15,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  coolStr,
                                  style: TextStyle(
                                      color: OwonColor()
                                          .getCurrent(context, "blue")),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color:
                                  OwonColor().getCurrent(context, "textColor"),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ));
  }

  String getStartTime(int mode) {
    if (mScheduleListModel.length == 0) {
      return "-- : --";
    } else {
      int hour =
          (mScheduleListModel["week${_selectTab}startTime$mode"] / 60).toInt();
      int min = mScheduleListModel["week${_selectTab}startTime$mode"] % 60;
      return "${hour.toString().padLeft(2, '0')} : ${min.toString().padLeft(2, '0')}";
    }
  }

  String getHeatTemp(int mode) {
    if (mScheduleListModel.length == 0) {
      return "-.-";
    } else {
      return tempUnit == false
          ? "${mScheduleListModel["week${_selectTab}heatTemp$mode"] / 100} ${S.of(context).global_celsius_unit}"
          : "${OwonTemperature().cToF(mScheduleListModel["week${_selectTab}heatTemp$mode"] / 100)} ${S.of(context).global_fahrenheit_unit}";
    }
  }

  String getCoolTemp(int mode) {
    if (mScheduleListModel.length == 0) {
      return "-.-";
    } else {
      return tempUnit == false
          ? "${mScheduleListModel["week${_selectTab}coolTemp$mode"] / 100} ${S.of(context).global_celsius_unit}"
          : "${OwonTemperature().cToF(mScheduleListModel["week${_selectTab}coolTemp$mode"] / 100)} ${S.of(context).global_fahrenheit_unit}";
    }
  }
}
