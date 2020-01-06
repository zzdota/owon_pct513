import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:owon_pct513/component/owon_header.dart';
import 'package:owon_pct513/owon_api/model/get_geofence_mode_entity.dart';
import 'package:owon_pct513/owon_pages/device_setting_pages/device_about_progress_dialog_page.dart';
import 'package:owon_pct513/owon_utils/owon_loading.dart';
import 'package:owon_pct513/owon_utils/owon_mqtt.dart';
import 'package:owon_pct513/owon_utils/owon_toast.dart';
import 'package:owon_pct513/res/owon_sequence.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../owon_providers/owon_evenBus/list_evenbus.dart';
import '../../res/owon_constant.dart';
import '../../res/owon_picture.dart';
import '../../owon_utils/owon_log.dart';
import '../../res/owon_themeColor.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../generated/i18n.dart';

class GeofencePage extends StatefulWidget {
  @override
  _GeofencePageState createState() => _GeofencePageState();
}

class _GeofencePageState extends State<GeofencePage> {
  EasyRefreshController refreshController = EasyRefreshController();
  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;
  bool hadData = false;

  GetGeofenceModeEntity mGetGeofenceModeEntity;
  List<GetGeofenceModeResponseDevice> mGetGeofenceModeEntityBuf =
      List<GetGeofenceModeResponseDevice>();

  String mPativipationDevice = "", mEnteringMode, mLeavingMode;

  @override
  void initState() {
    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
      String topic = msg["topic"];

      if (msg["type"] == "json") {
        Map<String, dynamic> payload = msg["payload"];
        if (payload.containsValue("account.geo.fencing.get")) {
          OwonLoading(context).dismiss();
          setState(() {
            mGetGeofenceModeEntity = GetGeofenceModeEntity().fromJson(payload);

            hadData = mGetGeofenceModeEntity.response.geoFencingEnable == 1
                ? true
                : false;
            update();
          });
        } else if (payload.containsValue("account.geo.fencing.set")) {
          OwonLoading(context).hide().then((e) {
            OwonToast.show(S.of(context).global_save_success);
          });
        }
      } else if (msg["type"] == "string") {
        String payload = msg["payload"];
      } else if (msg["type"] == "raw") {}
    });
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      getGeofence();
    });
  }

  void getGeofence() async {
    OwonLoading(context).show();
    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic = "api/cloud/$clientID";
    Map p = Map();
    p["command"] = "account.geo.fencing.get";
    p["sequence"] = OwonSequence.getGeofence;
    var msg = JsonEncoder.withIndent("  ").convert(p);
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }

  String geofenceModeToString(int val) {
    String mode;
    switch (val) {
      case 0:
        mode = S.of(context).schedule_mode_wake;
        break;
      case 1:
        mode = S.of(context).schedule_mode_away;
        break;
      case 2:
        mode = S.of(context).schedule_mode_home;
        break;
      case 3:
        mode = S.of(context).schedule_mode_sleep;
        break;
      case 4:
        mode = S.of(context).geofence_follow_schedule;
        break;
      case 5:
        mode = S.of(context).geofence_no_action;
        break;
    }
    return mode;
  }

  void _save() async {
    OwonLoading(context).show();
    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic = "api/cloud/$clientID";
    Map buf = Map();
    buf["geoFencingEnable"] = mGetGeofenceModeEntity.response.geoFencingEnable;
    buf["enterGeofenceAction"] =
        mGetGeofenceModeEntity.response.enterGeofenceAction;
    buf["leaveGeofenceAction"] =
        mGetGeofenceModeEntity.response.leaveGeofenceAction;
    buf["devices"] = mGetGeofenceModeEntity.response.devices;

    Map p = Map();
    p["command"] = "account.geo.fencing.set";
    p["sequence"] = OwonSequence.setGeofence;
    p["params"] = buf;
    var msg = JsonEncoder.withIndent("  ").convert(p);
    OwonMqtt.getInstance().publishMessage(topic, msg);
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
        title: Text("Geofence"),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              _save();
            },
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
      body: EasyRefresh(
        controller: refreshController,
        header: ClassicalHeader(
          textColor: OwonColor().getCurrent(context, "textColor"),
        ),
        footer: ClassicalFooter(
            textColor: OwonColor().getCurrent(context, "textColor"),
            enableInfiniteLoad: false),
        onRefresh: () async {
          OwonLog.e("refresh");
        },
        child: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20, left: 20, top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  S.of(context).geofence_title,
                  style: TextStyle(
                      color: OwonColor().getCurrent(context, "textColor")),
                ),
                CupertinoSwitch(
                    value: hadData,
                    activeColor: OwonColor().getCurrent(context, "blue"),
                    onChanged: (bool value) {
                      setState(() {
                        hadData = value;
                        mGetGeofenceModeEntity.response.geoFencingEnable =
                            value ? 1 : 0;
                      });
                    })
              ],
            ),
          ),
          hadData
              ? Container(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Column(
                    children: <Widget>[
                      getCard(S.of(context).geofence_paticipation_decice,
                          mPativipationDevice, 0),
                      getCard(S.of(context).geofence_entering_geofence,
                          mEnteringMode, 1),
                      getCard(S.of(context).geofence_leaving_geofence,
                          mLeavingMode, 2),
                    ],
                  ),
                )
              : getNoDataWidget(),
        ]),
      ),
    );
  }

  Widget getNoDataWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 200, 0, 0),
      child: Column(
        children: <Widget>[
          Image.asset(
            OwonPic.geofenceIcon,
            width: 50,
          ),
          SizedBox(
            height: 70,
          ),
          Container(
            margin: EdgeInsets.only(left: 50, right: 30),
            child: OwonHeader.baseHeader(
                context, S.of(context).geofence_disable_geofence),
          )
        ],
      ),
    );
  }

  Widget getCard(String title, String str, int index) {
    return Container(
        height: OwonConstant.cHeight,
        padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
        child: InkWell(
          onTap: () {
            switch (index) {
              case 0:
                selectParticipatingDevice();
                break;
              case 1:
                selectEnterMode();
                break;
              case 2:
                selectLeaveMode();
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
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                          color: OwonColor().getCurrent(context, "textColor")),
                    ),
                    Expanded(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerRight,
                              width: 150,
                              child: Text(
                                str,
                                style: TextStyle(
                                  color: OwonColor()
                                      .getCurrent(context, "textColor"),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
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

  StateSetter mStateSetter;
  void selectParticipatingDevice() {
    if (mGetGeofenceModeEntityBuf != null) {
      mGetGeofenceModeEntityBuf.clear();
      mGetGeofenceModeEntityBuf = List<GetGeofenceModeResponseDevice>();
    }
    for (int i = 0; i < mGetGeofenceModeEntity.response.devices.length; i++) {
      GetGeofenceModeResponseDevice buf = GetGeofenceModeResponseDevice();
      buf.deviceid = mGetGeofenceModeEntity.response.devices[i].deviceid;
      buf.devname = mGetGeofenceModeEntity.response.devices[i].devname;
      buf.geoSelect = mGetGeofenceModeEntity.response.devices[i].geoSelect;
      mGetGeofenceModeEntityBuf.add(buf);
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return StatefulBuilder(builder: (ctx, state) {
            mStateSetter = state;
            return ShowCommonAlert(
                negativeText: S.of(ctx).global_cancel,
                positiveText: S.of(ctx).global_ok,
                isShowTitleDivide: false,
                isShowBottomDivide: true,
                onCloseEvent: () {
                  Navigator.pop(ctx);
                  if (mGetGeofenceModeEntity.response.devices != null) {
                    mGetGeofenceModeEntity.response.devices.clear();
                    mGetGeofenceModeEntity.response.devices =
                        List<GetGeofenceModeResponseDevice>();
                  }
                  for (int i = 0; i < mGetGeofenceModeEntityBuf.length; i++) {
                    GetGeofenceModeResponseDevice buf =
                        GetGeofenceModeResponseDevice();
                    buf.deviceid = mGetGeofenceModeEntityBuf[i].deviceid;
                    buf.devname = mGetGeofenceModeEntityBuf[i].devname;
                    buf.geoSelect = mGetGeofenceModeEntityBuf[i].geoSelect;
                    mGetGeofenceModeEntity.response.devices.add(buf);
                  }
                  update();
                },
                onPositivePressEvent: () {
                  Navigator.pop(ctx);
                  update();
                },
                title: S.of(context).geofence_dialog_participating_device_title,
                childWidget: Container(
                  height: 250,
                  child: ListView.builder(
                    itemCount: mGetGeofenceModeEntity.response.devices.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          height: OwonConstant.systemHeight,
                          margin: EdgeInsets.only(left: 30, right: 30),
                          child: InkWell(
                            onTap: () {
                              mStateSetter(() {
                                mGetGeofenceModeEntity.response.devices[index]
                                    .geoSelect = (mGetGeofenceModeEntity
                                            .response
                                            .devices[index]
                                            .geoSelect ==
                                        1
                                    ? 0
                                    : 1);
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SvgPicture.asset(
                                  mGetGeofenceModeEntity.response.devices[index]
                                              .geoSelect ==
                                          1
                                      ? OwonPic.scheduleCopySelect
                                      : OwonPic.scheduleCopyNoSelect,
                                  width: 20,
                                  color:
                                      OwonColor().getCurrent(context, "blue"),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width: 200,
                                  child: Text(
                                    mGetGeofenceModeEntity
                                        .response.devices[index].devname,
                                    style: TextStyle(
                                      color: OwonColor()
                                          .getCurrent(context, "blue"),
                                      fontSize: 20,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                  ),
                ));
          });
        });
  }

  void update() {
    setState(() {
      mPativipationDevice = "";
      int y = 0;
      for (int i = 0; i < mGetGeofenceModeEntity.response.devices.length; i++) {
        if (mGetGeofenceModeEntity.response.devices[i].geoSelect == 1) {
          if (y == 0) {
            mPativipationDevice = mPativipationDevice +
                mGetGeofenceModeEntity.response.devices[i].devname;
            y++;
          } else {
            mPativipationDevice =
                mPativipationDevice + S.of(context).geofence_and_more;
            break;
          }
        }
      }
      mEnteringMode = geofenceModeToString(
          mGetGeofenceModeEntity.response.enterGeofenceAction);
      mLeavingMode = geofenceModeToString(
          mGetGeofenceModeEntity.response.leaveGeofenceAction);
    });
  }

  void selectEnterMode() {
    mSelectModeNumBuf =
        mSelectModeNum = mGetGeofenceModeEntity.response.enterGeofenceAction;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return StatefulBuilder(builder: (ctx, state) {
            mStateSetter = state;
            return ShowCommonAlert(
                negativeText: S.of(ctx).global_cancel,
                positiveText: S.of(ctx).global_ok,
                isShowTitleDivide: false,
                isShowBottomDivide: true,
                onPositivePressEvent: () {
                  Navigator.pop(ctx);
                  mGetGeofenceModeEntity.response.enterGeofenceAction =
                      mSelectModeNum;
                  update();
                },
                onCloseEvent: () {
                  Navigator.pop(ctx);
                  mGetGeofenceModeEntity.response.enterGeofenceAction =
                      mSelectModeNum = mSelectModeNumBuf;
                  update();
                },
                title: S.of(context).geofence_entering_geofence,
                childWidget: Column(
                  children: <Widget>[
                    getModeLayout(OwonPic.scheduleModeWake,
                        S.of(context).schedule_mode_wake, 0),
                    getModeLayout(OwonPic.scheduleModeAway,
                        S.of(context).schedule_mode_away, 1),
                    getModeLayout(OwonPic.scheduleModeHome,
                        S.of(context).schedule_mode_home, 2),
                    getModeLayout(OwonPic.scheduleModeSleep,
                        S.of(context).schedule_mode_sleep, 3),
                    getModeLayout(OwonPic.mHoldSchedule,
                        S.of(context).geofence_follow_schedule, 4),
                    getModeLayout(
                        OwonPic.mSysOff, S.of(context).geofence_no_action, 5),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ));
          });
        });
  }

  void selectLeaveMode() {
    mSelectModeNumBuf =
        mSelectModeNum = mGetGeofenceModeEntity.response.leaveGeofenceAction;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return StatefulBuilder(builder: (ctx, state) {
            mStateSetter = state;
            return ShowCommonAlert(
                negativeText: S.of(ctx).global_cancel,
                positiveText: S.of(ctx).global_ok,
                isShowTitleDivide: false,
                isShowBottomDivide: true,
                onPositivePressEvent: () {
                  Navigator.pop(ctx);
                  mGetGeofenceModeEntity.response.leaveGeofenceAction =
                      mSelectModeNum;
                  update();
                },
                onCloseEvent: () {
                  Navigator.pop(ctx);
                  mGetGeofenceModeEntity.response.leaveGeofenceAction =
                      mSelectModeNum = mSelectModeNumBuf;
                  update();
                },
                title: S.of(context).geofence_leaving_geofence,
                childWidget: Column(
                  children: <Widget>[
                    getModeLayout(OwonPic.scheduleModeWake,
                        S.of(context).schedule_mode_wake, 0),
                    getModeLayout(OwonPic.scheduleModeAway,
                        S.of(context).schedule_mode_away, 1),
                    getModeLayout(OwonPic.scheduleModeHome,
                        S.of(context).schedule_mode_home, 2),
                    getModeLayout(OwonPic.scheduleModeSleep,
                        S.of(context).schedule_mode_sleep, 3),
                    getModeLayout(OwonPic.mHoldSchedule,
                        S.of(context).geofence_follow_schedule, 4),
                    getModeLayout(
                        OwonPic.mSysOff, S.of(context).geofence_no_action, 5),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ));
          });
        });
  }

  int mSelectModeNum = 0, mSelectModeNumBuf = 0;
  Widget getModeLayout(String imageUrl, String modeStr, int modeNum) {
    return Container(
      height: OwonConstant.systemHeight,
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  imageUrl,
                  color: OwonColor().getCurrent(context, "blue"),
                  width: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(modeStr,
                    style: TextStyle(
                        color: OwonColor().getCurrent(context, "blue"),
                        fontSize: 20)),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              mStateSetter(() {
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
    );
  }
}
