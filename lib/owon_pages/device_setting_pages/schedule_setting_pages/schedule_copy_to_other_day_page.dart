import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:owon_pct513/component/owon_header.dart';
import 'package:owon_pct513/generated/i18n.dart';
import 'package:owon_pct513/owon_api/model/address_model_entity.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).schedule_title),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              setState(() {});
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
                          child: checkBox(
                              firstCheckBoxState, mWeekStr[0]),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              secondCheckBoxState = !secondCheckBoxState;
                            });
                          },
                          child: checkBox(
                              secondCheckBoxState, mWeekStr[3]),
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
                          child: checkBox(
                              thirdCheckBoxState, mWeekStr[1]),
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
                          child: checkBox(
                              fourthCheckBoxState, mWeekStr[4]),
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
                              fifthCheckBoxState = !fifthCheckBoxState;
                            });
                          },
                          child: checkBox(
                              fifthCheckBoxState, mWeekStr[2]),
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
                          child: checkBox(
                              sixCheckBoxState, mWeekStr[5]),
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
            week == null ?"" : week,
            style: TextStyle(
                color: OwonColor().getCurrent(context, "textColor"),
                fontSize: 16),
          ),
        ],
      ),
    );
  }
}
