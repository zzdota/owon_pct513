import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:owon_pct513/component/owon_pickerView.dart';
import 'package:owon_pct513/component/owon_timeTextfield.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:owon_pct513/owon_utils/owon_text_icon_button.dart';
import 'package:owon_pct513/res/owon_constant.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import '../../../generated/i18n.dart';
import '../../../res/owon_themeColor.dart';
import 'package:flutter_picker/flutter_picker.dart';

class VacationSettingPage extends StatefulWidget {
  @override
  _VacationSettingPageState createState() => _VacationSettingPageState();
}

class _VacationSettingPageState extends State<VacationSettingPage> {
  TextEditingController vc = TextEditingController(text: "hehe");
  int _heatValue = 23, _coolValue = 20;

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
              OwonLog.e("save is tap text=${vc.text}");
              OwonLog.e("heat:====>$_heatValue====cool:=====>$_coolValue");
              setState(() {
                _coolValue = 30;
              });
//              var picker = await showDatePicker(
//                  context: context,
//                  initialDate: new DateTime.now(),
//                  firstDate:
//                      new DateTime.now().subtract(new Duration(days: 30)),
//                  lastDate: new DateTime.now().add(new Duration(days: 30)),
//                  locale: Locale('zh'));
//              setState(() {
//                vc.text = picker.toString();
//              });
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
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  OwonPic.dVacDepartB,
                  width: 20,
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
                  child: OwonTimeTextField(context, vc, () async {
                    var picker = await showDatePicker(
                        context: context,
                        initialDate: new DateTime.now(),
                        firstDate:
                            new DateTime.now().subtract(new Duration(days: 30)),
                        lastDate:
                            new DateTime.now().add(new Duration(days: 30)),
                        locale: Locale('zh'));
                    setState(() {
                      vc.text = picker.toString();
                    });
                  }),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: OwonTimeTextField(context, vc, () async {
                    var picker = await showDatePicker(
                        context: context,
                        initialDate: new DateTime.now(),
                        firstDate:
                            new DateTime.now().subtract(new Duration(days: 30)),
                        lastDate:
                            new DateTime.now().add(new Duration(days: 30)),
                        locale: Locale('zh'));
                    setState(() {
                      vc.text = picker.toString();
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
                Image.asset(
                  OwonPic.dVacReturnB,
                  width: 20,
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
                  child: OwonTimeTextField(context, vc, () async {
                    var picker = await showDatePicker(
                        context: context,
                        initialDate: new DateTime.now(),
                        firstDate:
                            new DateTime.now().subtract(new Duration(days: 30)),
                        lastDate:
                            new DateTime.now().add(new Duration(days: 30)),
                        locale: Locale('zh'));
                    setState(() {
                      vc.text = picker.toString();
                    });
                  }),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: OwonTimeTextField(context, vc, () async {
                    var picker = await showDatePicker(
                        context: context,
                        initialDate: new DateTime.now(),
                        firstDate:
                            new DateTime.now().subtract(new Duration(days: 30)),
                        lastDate:
                            new DateTime.now().add(new Duration(days: 30)),
                        locale: Locale('zh'));
                    setState(() {
                      vc.text = picker.toString();
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
                Image.asset(
                  OwonPic.dVacVacationSetB,
                  width: 20,
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
                  onPressed: () {},
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  label: Text(
                    S.of(context).vacation_delete,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                  ),
                  iconTextAlignment: TextIconAlignment.iconRightTextLeft))
        ],
      ),
    );
  }
}
