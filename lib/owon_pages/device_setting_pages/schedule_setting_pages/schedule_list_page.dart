import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:owon_pct513/owon_utils/owon_text_icon_button.dart';
import 'package:owon_pct513/res/owon_constant.dart';
import '../../../res/owon_picture.dart';
import '../../../owon_utils/owon_log.dart';
import '../../../res/owon_themeColor.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../../generated/i18n.dart';
import '../../../owon_providers/owon_evenBus/list_evenbus.dart';

class ScheduleListPage extends StatefulWidget {
  @override
  _ScheduleListPageState createState() => _ScheduleListPageState();
}

class _ScheduleListPageState extends State<ScheduleListPage> {
  EasyRefreshController refreshController = EasyRefreshController();
  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;
  bool hadData = true;

  bool _switchValue = false;
  int _selectTab;

  @override
  void initState() {
    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
      OwonLog.e("canvas =>>>>topic=${msg["topic"]}");
      OwonLog.e("canvas =>>>>payload=${msg["payload"]}");
      Map<String, dynamic> payload = msg["payload"];
      OwonLog.e("canvas =>>>>cmd=${payload["command"]}");
      OwonLog.e("canvas =>>>>addrs=${payload["addrs"]}");
    });
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      toGetScheduleList();
    });
  }

  toGetScheduleList() async {
//    SharedPreferences pre = await SharedPreferences.getInstance();
//    var clientID = pre.get(OwonConstant.clientID);
//    String topic = "api/cloud/$clientID";
//    Map p = Map();
//    p["command"] = "addr.dev.list";
//    var msg = JsonEncoder.withIndent("  ").convert(p);
//    OwonMqtt.getInstance().publishMessage(topic, msg);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 7,
        child: Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).schedule_title),
              centerTitle: true,
              elevation: 0,
              actions: <Widget>[
                CupertinoSwitch(
                    value: _switchValue,
                    activeColor: OwonColor().getCurrent(context, "blue"),
                    trackColor: OwonColor().getCurrent(context, "textColor"),
                    onChanged: (bool value) {
                      ///点击切换开关的状态
                      setState(() {
                        _switchValue = value;
                        OwonLog.e(_switchValue);
                      });
                    })
              ],
              bottom: PreferredSize(
                preferredSize: Size(200.0, 120.0),
                child: Container(
                  color: OwonColor().getCurrent(context, "primaryColor"),
                  width: double.infinity,
                  height: 120,
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
                            S.of(context).global_mon,
                            style: TextStyle(
                                color: _selectTab == 0
                                    ? Colors.white
                                    : OwonColor()
                                        .getCurrent(context, "textColor"),
                                fontSize: _selectTab == 0
                                    ? OwonConstant.scheduleWeekFontsizeSelect
                                    : OwonConstant
                                        .scheduleWeekFontsizeNoSelect),
                          ),
                        ),
                        Tab(
                          child: Text(
                            S.of(context).global_tues,
                            style: TextStyle(
                                color: _selectTab == 1
                                    ? Colors.white
                                    : OwonColor()
                                        .getCurrent(context, "textColor"),
                                fontSize: _selectTab == 1
                                    ? OwonConstant.scheduleWeekFontsizeSelect
                                    : OwonConstant
                                        .scheduleWeekFontsizeNoSelect),
                          ),
                        ),
                        Tab(
                          child: Text(
                            S.of(context).global_wed,
                            style: TextStyle(
                                color: _selectTab == 2
                                    ? Colors.white
                                    : OwonColor()
                                        .getCurrent(context, "textColor"),
                                fontSize: _selectTab == 2
                                    ? OwonConstant.scheduleWeekFontsizeSelect
                                    : OwonConstant
                                        .scheduleWeekFontsizeNoSelect),
                          ),
                        ),
                        Tab(
                          child: Text(
                            S.of(context).global_thur,
                            style: TextStyle(
                                color: _selectTab == 3
                                    ? Colors.white
                                    : OwonColor()
                                        .getCurrent(context, "textColor"),
                                fontSize: _selectTab == 3
                                    ? OwonConstant.scheduleWeekFontsizeSelect
                                    : OwonConstant
                                        .scheduleWeekFontsizeNoSelect),
                          ),
                        ),
                        Tab(
                          child: Text(
                            S.of(context).global_fri,
                            style: TextStyle(
                                color: _selectTab == 4
                                    ? Colors.white
                                    : OwonColor()
                                        .getCurrent(context, "textColor"),
                                fontSize: _selectTab == 4
                                    ? OwonConstant.scheduleWeekFontsizeSelect
                                    : OwonConstant
                                        .scheduleWeekFontsizeNoSelect),
                          ),
                        ),
                        Tab(
                          child: Text(
                            S.of(context).global_sat,
                            style: TextStyle(
                                color: _selectTab == 5
                                    ? Colors.white
                                    : OwonColor()
                                        .getCurrent(context, "textColor"),
                                fontSize: _selectTab == 5
                                    ? OwonConstant.scheduleWeekFontsizeSelect
                                    : OwonConstant
                                        .scheduleWeekFontsizeNoSelect),
                          ),
                        ),
                        Tab(
                          child: Text(
                            S.of(context).global_sun,
                            style: TextStyle(
                                color: _selectTab == 6
                                    ? Colors.white
                                    : OwonColor()
                                        .getCurrent(context, "textColor"),
                                fontSize: _selectTab == 6
                                    ? OwonConstant.scheduleWeekFontsizeSelect
                                    : OwonConstant
                                        .scheduleWeekFontsizeNoSelect),
                          ),
                        ),
                      ]),
                ),
              ),
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
                    onLoad: () async {
                      OwonLog.e("load");
                    },
                    child: Column(
                      children: <Widget>[
                        getCard(
                            OwonPic.scheduleModeWake,
                            S.of(context).schedule_mode_wake,
                            "6:00 AM",
                            "21.0",
                            "21.0"),
                        SizedBox(
                          height: 15,
                        ),
                        getCard(
                            OwonPic.scheduleModeAway,
                            S.of(context).schedule_mode_away,
                            "6:00 AM",
                            "21.0",
                            "21.0"),
                        SizedBox(
                          height: 15,
                        ),
                        getCard(
                            OwonPic.scheduleModeHome,
                            S.of(context).schedule_mode_home,
                            "6:00 AM",
                            "21.0",
                            "21.0"),
                        SizedBox(
                          height: 15,
                        ),
                        getCard(
                            OwonPic.scheduleModeSleep,
                            S.of(context).schedule_mode_sleep,
                            "6:00 AM",
                            "21.0",
                            "21.0"),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: double.infinity,
                          height: 60.0,
                          margin:
                              EdgeInsets.only(left: 10.0, right: 10.0),
                          child: OwonTextIconButton.icon(
                              onPressed: () {},
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

  Widget getCard(String imageUrl, String modeStr, String heatStr,
      String timeStr, String coolStr) {
    return Container(
        height: OwonConstant.listHeight,
        padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
        child: InkWell(
          onTap: () {},
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
}
