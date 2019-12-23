import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:owon_pct513/owon_api/model/address_model_entity.dart';
import 'package:owon_pct513/owon_providers/owon_evenBus/list_evenbus.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';
import '../../generated/i18n.dart';
import 'package:owon_pct513/owon_utils/owon_text_icon_button.dart';
import 'package:owon_pct513/res/owon_constant.dart';

class DeviceFanTimePage extends StatefulWidget {
  AddressModelAddrsDevlist devModel;
  DeviceFanTimePage(this.devModel);
  @override
  _DeviceFanTimePageState createState() => _DeviceFanTimePageState();
}

class _DeviceFanTimePageState extends State<DeviceFanTimePage> {
  var _tfVC = TextEditingController();
  double progress = 0.5;

  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;

  @override
  void initState() {
    super.initState();

    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
      String topic = msg["topic"];

      if (msg["type"] == "json") {
//        Map<String, dynamic> payload = msg["payload"];
//        OwonLog.e("----m=${payload["response"]}");
//        List tempList = payload["response"];
//        tempList.forEach((item) {
//          String attr = item["attrName"];
//        });
      } else if (msg["type"] == "string") {
//        String payload = msg["payload"];
//
//        OwonLog.e("----上报的payload=$payload");
//        if (topic.contains("LocalTemperature")) {
//
//        }
      }
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
        title: Text(S.of(context).dSet_fan_set),
      ),
      body: Container(
//        color: Colors.red,
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Expanded(
                child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Text(S.of(context).device_fan_time,
                    style: TextStyle(
                        color: OwonColor().getCurrent(context, "textColor"))),
                SizedBox(
                  height: 60,
                ),
                Container(
//                    color: Colors.purple,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: SvgPicture.asset(
                          OwonPic.deviceFan,
                          color: OwonColor().getCurrent(context, "orange"),
                          width: 20,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor:
                                    OwonColor().getCurrent(context, "blue"),
                                inactiveTrackColor: OwonColor()
                                    .getCurrent(context, "textColor"),
                                trackHeight: 5,
//                                overlayColor: Color(0x29EB1555),
//                                thumbColor: Color(0xFFEB1555),
//                                thumbShape: RoundSliderThumbShape(
//                                  enabledThumbRadius: 15.0,
//                                ),
//                                overlayShape: RoundSliderOverlayShape(
//                                  overlayRadius: 30.0,
//                                ),
                              ), // provide a default theme
                              child: Slider(
                                value: this.progress,
                                onChanged: (data) {
                                  print('change:$data');
                                  setState(() {
                                    this.progress = data;
                                  });
                                },
                                onChangeStart: (data) {
                                  print('start:$data');
                                },
                                onChangeEnd: (data) {
                                  print('end:$data');
                                },
                                min: 0.0,
                                max: 100.0,
                                divisions: 100,
                                label: '$progress\n${S.of(context).device_unit}',
                                semanticFormatterCallback: (double newValue) {
                                  return '${newValue.round()} dollars}';
                                },
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  S.of(context).device_min,
                                  style: TextStyle(
                                      color: OwonColor()
                                          .getCurrent(context, "textColor")),
                                ),
                                Expanded(child: Text("")),
                                Text(S.of(context).device_max,
                                    style: TextStyle(
                                        color: OwonColor()
                                            .getCurrent(context, "textColor"))),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  height: OwonConstant.systemHeight,
                  width: double.infinity,
                  child: OwonTextIconButton.icon(
//                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(OwonConstant.cRadius),
                      ),
                      onPressed: () {},
                      icon: Icon(
                        Icons.save_alt,
                        color: Colors.white,
                      ),
                      label: Text(
                        S.of(context).global_save,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      iconTextAlignment: TextIconAlignment.iconRightTextLeft)),
            )
          ],
        ),
      ),
    );
  }
}
