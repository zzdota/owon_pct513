import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:owon_pct513/generated/i18n.dart';
import 'package:owon_pct513/owon_api/model/address_model_entity.dart';
import 'package:owon_pct513/owon_api/model/sensor_list_model_entity.dart';
import 'package:owon_pct513/owon_providers/owon_evenBus/list_evenbus.dart';
import 'package:owon_pct513/owon_utils/owon_loading.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:owon_pct513/owon_utils/owon_mqtt.dart';
import 'package:owon_pct513/owon_utils/owon_toast.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:owon_pct513/owon_utils/owon_text_icon_button.dart';
import 'package:owon_pct513/res/owon_constant.dart';

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
//        Map<String, dynamic> payload = msg["payload"];
//        OwonLog.e("----m=${payload["response"]}");
      } else if (msg["type"] == "string") {
        String payload = msg["payload"];
        OwonLog.e("----上报的payload=$payload");
        if (topic.contains("DeviceName")) {
//          OwonLoading(context).dismiss();
          OwonLoading(context).hide().then((e) {
            OwonToast.show(S.of(context).global_save_success);
          });
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
                      onPressed: () {},
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
