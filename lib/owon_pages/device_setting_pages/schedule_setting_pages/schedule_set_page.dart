import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  ScheduleSettingPage(this.devModel,this.mScheduleListModel,this.mImageUrl,this.mMode,this.mWeek);

  @override
  _ScheduleSettingPageState createState() => _ScheduleSettingPageState();
}

class _ScheduleSettingPageState extends State<ScheduleSettingPage> {
  TextEditingController vc = TextEditingController(text: "hehe");
  int _heatValue = 26, _coolValue = 26;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(S.of(context).schedule_setting_title),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                OwonLog.e("save is tap text=${vc.text}");
                OwonLog.e("heat:====>$_heatValue====cool:=====>$_coolValue");
                setState(() {
                  _coolValue = 30;
                });
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
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    OwonHeader.header(context, widget.mImageUrl,
                        getTitleStr(widget.mWeek),
                        width: 200),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(50, 80, 100, 0),
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              OwonPic.scheduleTimeIcon,
                              width: 25,
                              color: OwonColor().getCurrent(context, "textColor"),
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
                                  vc.text = "${picker.hour.toString()} : ${picker.minute.toString()}";
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
                              width: 60,
                              child: OwonNumberPicker.integer(
                                  initialValue: _heatValue,
                                  minValue: 0,
                                  maxValue: 100,
                                  selectItemFontColor: OwonColor()
                                      .getCurrent(context, "textColor"),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1,
                                              color: OwonColor()
                                                  .getCurrent(context, "blue")),
                                          top: BorderSide(
                                              width: 1,
                                              color: OwonColor().getCurrent(
                                                  context, "blue")))),
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
                                  selectItemFontColor: OwonColor()
                                      .getCurrent(context, "textColor"),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1,
                                              color: OwonColor()
                                                  .getCurrent(context, "blue")),
                                          top: BorderSide(
                                              width: 1,
                                              color: OwonColor().getCurrent(
                                                  context, "blue")))),
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
}
