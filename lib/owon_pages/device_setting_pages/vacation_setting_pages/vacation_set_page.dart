import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:owon_pct513/component/owon_pickerView.dart';
import 'package:owon_pct513/component/owon_timeTextfield.dart';
import 'package:owon_pct513/owon_api/model/address_model_entity.dart';
import 'package:owon_pct513/owon_api/model/vaction_model_entity.dart';
import 'package:owon_pct513/owon_providers/owon_evenBus/list_evenbus.dart';
import 'package:owon_pct513/owon_utils/owon_loading.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:owon_pct513/owon_utils/owon_mqtt.dart';
import 'package:owon_pct513/owon_utils/owon_text_icon_button.dart';
import 'package:owon_pct513/owon_utils/owon_toast.dart';
import 'package:owon_pct513/res/owon_constant.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../generated/i18n.dart';
import '../../../res/owon_themeColor.dart';
import 'package:flutter_picker/flutter_picker.dart';
import '../../../owon_utils/owon_convert.dart';

class VacationSettingPage extends StatefulWidget {
  VactionModelEntity sensorListModelEntity;
  VactionModelPara paraModel;
  AddressModelAddrsDevlist devModel;
  List originList;
  int index;
  bool isFromAdd;

  VacationSettingPage(
      {this.devModel,
      this.sensorListModelEntity,
      this.index,
      this.originList,
      this.isFromAdd});
  @override
  _VacationSettingPageState createState() => _VacationSettingPageState();
}

class _VacationSettingPageState extends State<VacationSettingPage> {
  TextEditingController _departYearVc = TextEditingController(text: "hehe");
  TextEditingController _departDayVc = TextEditingController(text: "hehe");
  TextEditingController _returnYearVc = TextEditingController(text: "hehe");
  TextEditingController _returnDayVc = TextEditingController(text: "hehe");
  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;

  int _heatValue, _coolValue;
  @override
  void initState() {
    if (!widget.isFromAdd) {
      widget.paraModel = widget.sensorListModelEntity.para[widget.index];
      _departYearVc.text = createYearTimeString(widget.paraModel.sYear,
          widget.paraModel.sMonth, widget.paraModel.sDay);
      _departDayVc.text =
          createTimeString(widget.paraModel.sHour, widget.paraModel.sMin);
      _returnYearVc.text = createYearTimeString(widget.paraModel.eYear,
          widget.paraModel.eMonth, widget.paraModel.eDay);
      _returnDayVc.text =
          createTimeString(widget.paraModel.eHour, widget.paraModel.eMin);
      _heatValue = (widget.devModel.tempUnit)
          ? double.parse(
                  OwonConvert.reduce100CToF(widget.paraModel.heat.toString()))
              .floor()
          : double.parse(
                  OwonConvert.reduce100(widget.paraModel.heat.toString()))
              .floor();
      _coolValue = (widget.devModel.tempUnit)
          ? double.parse(
                  OwonConvert.reduce100CToF(widget.paraModel.cool.toString()))
              .floor()
          : double.parse(
                  OwonConvert.reduce100(widget.paraModel.cool.toString()))
              .floor();
    } else {
      DateTime now = DateTime.now();
      widget.paraModel = VactionModelPara();
      widget.paraModel.sYear = (now.year - 2000);
      widget.paraModel.sMonth = now.month;
      widget.paraModel.sDay = now.day;
      widget.paraModel.sHour = now.hour;
      widget.paraModel.sMin = now.minute;

      DateTime tomorrow =
          DateTime(now.year, now.month, now.day + 1, now.hour, now.minute);

      widget.paraModel.eYear = (tomorrow.year - 2000);
      widget.paraModel.eMonth = tomorrow.month;
      widget.paraModel.eDay = tomorrow.day;
      widget.paraModel.eHour = tomorrow.hour;
      widget.paraModel.eMin = tomorrow.minute;
      widget.paraModel.heat = 2800;
      widget.paraModel.cool = 2600;

      _departYearVc.text = createYearTimeString(widget.paraModel.sYear,
          widget.paraModel.sMonth, widget.paraModel.sDay);
      _departDayVc.text =
          createTimeString(widget.paraModel.sHour, widget.paraModel.sMin);
      _returnYearVc.text = createYearTimeString(widget.paraModel.eYear,
          widget.paraModel.eMonth, widget.paraModel.eDay);
      _returnDayVc.text =
          createTimeString(widget.paraModel.eHour, widget.paraModel.eMin);
      _heatValue = (widget.devModel.tempUnit)
          ? double.parse(
                  OwonConvert.reduce100CToF(widget.paraModel.heat.toString()))
              .floor()
          : double.parse(
                  OwonConvert.reduce100(widget.paraModel.heat.toString()))
              .floor();
      _coolValue = (widget.devModel.tempUnit)
          ? double.parse(
                  OwonConvert.reduce100CToF(widget.paraModel.cool.toString()))
              .floor()
          : double.parse(
                  OwonConvert.reduce100(widget.paraModel.cool.toString()))
              .floor();
    }
    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
      String topic = msg["topic"];
      if (msg["type"] == "string") {
        if (topic.startsWith("reply") && topic.contains("VactionSchedule")) {
          OwonLoading(context).hide().then((e) {
            OwonToast.show(S.of(context).global_save_success);
            Navigator.of(context).pop();
          });
        }
      }else if(msg["type"] == "raw") {
        print("222222222222=====>");
      }
    });
    super.initState();
  }
  void dispose() {
    super.dispose();
    _listEvenBusSubscription.cancel();
  }

  setProperty({String attribute, List<int> value}) async {
    OwonLoading(context).show();
    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic =
        "api/device/${widget.devModel.deviceid}/$clientID/attribute/$attribute";
//    var msg = value;

    OwonLog.e("value========>$value");
//    OwonMqtt.getInstance().publishMessage(topic, msg);
    OwonMqtt.getInstance().publishRawMessage(topic, value);
  }

  List<int> createYearList(String year) {
    List tem = year.split(" ");
    var monthString = tem.first;
    var dayString = tem[1];
    var yearString = tem.last;
    int y = int.parse(yearString) - 2000;
    int m = createMonth(monthString);
    int d = int.parse(dayString);
    return [y, m, d];
  }

  List<int> createTimeList(String time) {
    List tem = time.split(": ");
    var hString = tem.first;
    var mString = tem.last;
    int h = int.parse(hString);
    int m = int.parse(mString);
    return [h, m];
  }

  List<int> createParameter() {
    List<int> totalList = [];
    List<int> syearList = createYearList(_departYearVc.text);
    List<int> sdayList = createTimeList(_departDayVc.text);
    List<int> eyearList = createYearList(_returnYearVc.text);
    List<int> edayList = createTimeList(_returnDayVc.text);
    int heat1 = (_heatValue * 100) >> 8;
    int heat2 = _heatValue * 100 - (heat1 << 8);
    int cool1 = (_coolValue * 100) >> 8;
    int cool2 = _coolValue * 100 - (cool1 << 8);
    totalList.addAll(syearList);
    totalList.addAll(sdayList);
    totalList.addAll(eyearList);
    totalList.addAll(edayList);
    totalList.add(heat1);
    totalList.add(heat2);
    totalList.add(cool1);
    totalList.add(cool2);

    return totalList;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).dSet_vacation),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
//            splashColor: Colors.red,
            onPressed: () {
              if (widget.isFromAdd) {
                int firstNum = widget.originList[0];
                int desNum = firstNum + 1;
                widget.originList[0] = desNum;

                int start = 1 + 14 * firstNum;
                int end = start + 14;
                List<int> newList = createParameter();

                widget.originList.addAll(newList);
                print("增加${widget.originList}");


                int endIndex = desNum*14 +1;
                List desList = widget.originList.sublist(0,endIndex);
                print("增加desList$desList");

                setProperty(
                    attribute: "VactionSchedule", value: desList);
              } else {
                List<int> newList = createParameter();
                int start = 1 + 14 * widget.index;
                int end = start + 14;
                widget.originList.replaceRange(start, end, newList);

                print("修改${widget.originList}");
                int endIndex = widget.originList[0]*14 +1;
                List desList = widget.originList.sublist(0,endIndex);
                print("修改desList$desList");

                setProperty(
                    attribute: "VactionSchedule", value: desList);
              }
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SvgPicture.asset(
                    OwonPic.dVacDepart,
                    width: 20,
                    color: OwonColor().getCurrent(context, "textColor"),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    S.of(context).vacation_depart,
                    style: TextStyle(
                        color: OwonColor().getCurrent(context, "textColor")),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: OwonTimeTextField(context, _departYearVc, () async {
                      var picker = await showDatePicker(
                          context: context,
                          initialDate: new DateTime.now(),
                          firstDate: new DateTime.now()
                              .subtract(new Duration(days: 365)),
                          lastDate:
                              new DateTime.now().add(new Duration(days: 365)),
                          locale: Locale('zh'));
                      setState(() {
                        _departYearVc.text = createYearTimeString(
                            picker.year, picker.month, picker.day,
                            addYear: false);
                      });
                    }),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: OwonTimeTextField(context, _departDayVc, () async {
                      var picker = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      setState(() {
                        _departDayVc.text =
                            createTimeString(picker.hour, picker.minute);
                      });
                    }),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SvgPicture.asset(
                    OwonPic.dVacReturn,
                    width: 20,
                    color: OwonColor().getCurrent(context, "textColor"),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    S.of(context).vacation_return,
                    style: TextStyle(
                        color: OwonColor().getCurrent(context, "textColor")),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: OwonTimeTextField(context, _returnYearVc, () async {
                      var picker = await showDatePicker(
                          context: context,
                          initialDate: new DateTime.now(),
                          firstDate: new DateTime.now()
                              .subtract(new Duration(days: 365)),
                          lastDate:
                              new DateTime.now().add(new Duration(days: 365)),
                          locale: Locale('zh'));
                      setState(() {
                        _returnYearVc.text = createYearTimeString(
                            picker.year, picker.month, picker.day,
                            addYear: false);
                      });
                    }),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: OwonTimeTextField(context, _returnDayVc, () async {
                      var picker = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      setState(() {
                        _returnDayVc.text =
                            createTimeString(picker.hour, picker.minute);
                      });
                    }),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SvgPicture.asset(
                    OwonPic.dVacVacationSetB,
                    width: 20,
                    color: OwonColor().getCurrent(context, "textColor"),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    S.of(context).dSet_vacation,
                    style: TextStyle(
                        color: OwonColor().getCurrent(context, "textColor")),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        OwonPic.mSysHeat,
                        color:
                            OwonColor().getCurrent(context, "borderDisconnect"),
                        width: 20,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        width: 60,
                        child: OwonNumberPicker.integer(
                            initialValue: _heatValue,
                            minValue: 0,
                            maxValue: 100,
                            selectItemFontColor:
                                OwonColor().getCurrent(context, "textColor"),
                            decoration: BoxDecoration(
//                        color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: OwonColor()
                                            .getCurrent(context, "blue")),
                                    top: BorderSide(
                                        width: 1,
                                        color: OwonColor()
                                            .getCurrent(context, "blue")))),
                            onChanged: (newValue) {
                              setState(() {
                                _heatValue = newValue;
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
                        width: 60,
                        child: OwonNumberPicker.integer(
                            initialValue: _coolValue,
                            minValue: 0,
                            maxValue: 100,
                            selectItemFontColor:
                                OwonColor().getCurrent(context, "textColor"),
                            decoration: BoxDecoration(
//                        color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: OwonColor()
                                            .getCurrent(context, "blue")),
                                    top: BorderSide(
                                        width: 1,
                                        color: OwonColor()
                                            .getCurrent(context, "blue")))),
                            onChanged: (newValue) {
                              setState(() {
                                _coolValue = newValue;
                              });
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                height: OwonConstant.systemHeight,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: OwonTextIconButton.icon(
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(OwonConstant.cRadius),
                    ),
                    onPressed: () {

                      print("${widget.originList}");
                      int start = 1 + 14 * widget.index;
                      int end = start + 14;
                      widget.originList.removeRange(start, end);

                      print("删除${widget.originList}");
                      int endIndex = (widget.originList[0]-1)*14 +1;
                      List desList = widget.originList.sublist(0,endIndex);
                      int firstNum = desList[0];
                      int desNum = firstNum - 1;
                      desList[0] = desNum;
                      print("删除desList$desList");

                      setProperty(
                          attribute: "VactionSchedule", value: desList);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    label: Text(
                      S.of(context).vacation_delete,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    iconTextAlignment: TextIconAlignment.iconRightTextLeft))
          ],
        ),
      ),
    );
  }


  String createTimeString(int hourNum, int minNum) {
    String desString = "7: 00";

    int sHour = hourNum;
    int sMin = minNum;

    String hour = sHour.toString().padLeft(2, '0');
    String min = sMin.toString().padLeft(2, '0');

    desString = "$hour: $min";
    return desString;
  }

  String createYearTimeString(int yearNum, int monthNum, int dayNum,
      {bool addYear = true}) {
    String desString = "Oct 17 2019";
    int sYear = yearNum;
    int sMonth = monthNum;
    int sDay = dayNum;

    String month = convertMonth(sMonth);
    String day = sDay.toString();
    String year = sYear.toString();

    if (addYear) {
      year = (sYear + 2000).toString();
    }

    desString = "$month $day $year";
    return desString;
  }

  String convertMonth(int sMonth) {
    if (sMonth == 1) {
      return "Jan";
    } else if (sMonth == 2) {
      return "Feb";
    } else if (sMonth == 3) {
      return "Mar";
    } else if (sMonth == 4) {
      return "Apr";
    } else if (sMonth == 5) {
      return "May";
    } else if (sMonth == 6) {
      return "Jun";
    } else if (sMonth == 7) {
      return "Jul";
    } else if (sMonth == 8) {
      return "Aug";
    } else if (sMonth == 9) {
      return "Sep";
    } else if (sMonth == 10) {
      return "Oct";
    } else if (sMonth == 11) {
      return "Nov";
    } else {
      return "Dec";
    }
  }

  int createMonth(String mon) {
    if (mon == "Jan") {
      return 1;
    } else if (mon == "Feb") {
      return 2;
    } else if (mon == "Mar") {
      return 3;
    } else if (mon == "Apr") {
      return 4;
    } else if (mon == "May") {
      return 5;
    } else if (mon == "Jun") {
      return 6;
    } else if (mon == "Jul") {
      return 7;
    } else if (mon == "Aug") {
      return 8;
    } else if (mon == "Sep") {
      return 9;
    } else if (mon == "Oct") {
      return 10;
    } else if (mon == "Nov") {
      return 11;
    } else if (mon == "Dec") {
      return 12;
    }
  }
}
