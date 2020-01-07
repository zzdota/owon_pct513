import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:owon_pct513/owon_api/model/address_model_entity.dart';
import 'package:owon_pct513/owon_pages/device_setting_pages/device_setting_page.dart';
import 'package:owon_pct513/owon_pages/device_setting_pages/schedule_setting_pages/schedule_list_page.dart';
import 'package:owon_pct513/owon_utils/owon_bottomsheet.dart';
import 'package:owon_pct513/owon_utils/owon_loading.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:owon_pct513/owon_utils/owon_temperature.dart';
import 'package:owon_pct513/res/owon_constant.dart';
import 'package:owon_pct513/res/owon_sequence.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../res/owon_themeColor.dart';
import '../../component/owon_twoBtn.dart';
import '../../component/owon_tempHumi.dart';
import '../../component/owon_adjustTemp.dart';
import '../../component/owon_mode.dart';
import '../../res/owon_settingData.dart';
import 'package:owon_pct513/owon_utils/owon_mqtt.dart';
import '../../owon_providers/owon_evenBus/list_evenbus.dart';
import '../../owon_utils/owon_convert.dart';
import '../../owon_utils/owon_temperature.dart';
import '../../generated/i18n.dart';

class ManagementPage extends StatefulWidget {
  AddressModelAddrsDevlist devModel;
  ManagementPage(this.devModel);

  @override
  _ManagementPageState createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {


  String _localTemp = "3000";
  String _localHumi = "5500";
  String _systemMode = "3";
  String _fanMode = "6";
  String _setPointHold = "1";
  String _setPointHoldDuration = "65535";
  String _OccupiedCoolingSetpoint = "2000";
  String _OccupiedHeatingSetpoint = "2600";
  bool _tempUnit = false;

  String _justSetValue;
  String _justSetPointHoldDurationValue;
//  String _ThermostatRunningMode = "0";
  String _relayState = "0";

  int _heat_c = 3000;
  int _cool_c = 2400;
  int _heat_f = 8900;
  int _cool_f = 8600;


  String _SetpointDeadBand = "150";
  String _MaxHeatSetpointLimit = "3000";
  String _MinHeatSetpointLimit = "500";
  String _MaxCoolSetpointLimit = "3200";
  String _MinCoolSetpointLimit = "700";

  String _homeMode;
  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;
  Timer _timer;
  @override
  void initState() {
    getProperty();
    super.initState();
    Future.delayed(Duration(seconds: 0),(){
      OwonLoading(context).show();
    });
    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
      String topic = msg["topic"];

      if (msg["type"] == "json") {
        Map<String, dynamic> payload = msg["payload"];
        OwonLoading(context).dismiss();
        if(!payload.containsValue("device.attr.str.batch")) {
            return;
          }
        OwonLoading(context).dismiss();
        OwonLog.e("----m=${payload["response"]}");
        List tempList = payload["response"];
        tempList.forEach((item) {
          String attr = item["attrName"];
          if (attr == "LocalTemperature") {
            setState(() {});
            _localTemp = item["attrValue"]==null?"3000":item["attrValue"];
          } else if (attr == "LocalRelativeHumidity") {
            _localHumi = item["attrValue"];
          } else if (attr == "SystemMode") {
            setState(() {});
            _systemMode = item["attrValue"];
          } else if (attr == "FanMode") {
            setState(() {});
            _fanMode = item["attrValue"];
          } else if (attr == "HomeMode") {
            _homeMode = item["attrValue"];
          } else if (attr == "SetpointHold") {
            _setPointHold = item["attrValue"]==null?"3":item["attrValue"];
            if (_setPointHold == "0") {
              setState(() {});
            }
          } else if (attr == "SetpointHoldDuration") {
            _setPointHoldDuration = item["attrValue"];
            setState(() {});
          } else if (attr == "OccupiedCoolingSetpoint") {
            _OccupiedCoolingSetpoint = item["attrValue"];
            setState(() {});
          } else if (attr == "OccupiedHeatingSetpoint") {
            _OccupiedHeatingSetpoint = item["attrValue"];
            setState(() {});
          } else if (attr == "TemperatureUnit") {
            setState(() {
              if(item["attrValue"] == "0"){
                _tempUnit = false;
                _heat_c = int.parse(_OccupiedHeatingSetpoint);
                _cool_c = int.parse(_OccupiedCoolingSetpoint);
              } else {
                _tempUnit = true;
                _heat_f = OwonTemperature().c100ToF100(int.parse(_OccupiedHeatingSetpoint));
//                    int.parse(OwonConvert.zoom100(OwonConvert.reduce100CToF(_OccupiedHeatingSetpoint)));
                _cool_f = OwonTemperature().c100ToF100(int.parse(_OccupiedCoolingSetpoint));
//                    int.parse(OwonConvert.zoom100(OwonConvert.reduce100CToF(_OccupiedCoolingSetpoint)));
              }
              widget.devModel.tempUnit = _tempUnit;
              OwonLog.e("======>>>tempUnit====${widget.devModel.tempUnit}");
            });
          }else if (attr == "RelayState") {
            _relayState = item["attrValue"];
            setState(() {});
          } else if (attr == "SetpointDeadBand") {
            String temString = item["attrValue"];
            if(temString.isEmpty) {
              print("空字符串");
              return;
            }
            _SetpointDeadBand = item["attrValue"];
            setState(() {});
          } else if (attr == "MaxHeatSetpointLimit") {
            String temString = item["attrValue"];
            if(temString.isEmpty) {
              print("空字符串");
              return;
            }
            _MaxHeatSetpointLimit = item["attrValue"];
            setState(() {});
          } else if (attr == "MinHeatSetpointLimit") {
            String temString = item["attrValue"];
            if(temString.isEmpty) {
              print("空字符串");
              return;
            }
            _MinHeatSetpointLimit = item["attrValue"];
            setState(() {});
          } else if (attr == "MaxCoolSetpointLimit") {
            String temString = item["attrValue"];
            if(temString.isEmpty) {
              print("空字符串");
              return;
            }
            _MaxCoolSetpointLimit = item["attrValue"];
            setState(() {});
          } else if (attr == "MinCoolSetpointLimit") {
            String temString = item["attrValue"];
            if(temString.isEmpty) {
              print("空字符串");
              return;
            }
            _MinCoolSetpointLimit = item["attrValue"];
            setState(() {});
          }
        });
      } else if (msg["type"] == "string") {
        String payload = msg["payload"];

//        OwonLog.e("----上报的payload=$payload");
        if (topic.contains("LocalTemperature")) {
          setState(() {
            _localTemp = payload;
          });
        } else if (topic.contains("LocalRelativeHumidity")) {
          setState(() {
            _localHumi = payload;
          });
        } else if (topic.contains("SystemMode")) {
          if (topic.startsWith("reply")) {
            setState(() {
              _systemMode = _justSetValue;
            });
            return;
          }
          setState(() {
            _systemMode = payload;
          });
        } else if (topic.contains("FanMode")) {
          if (topic.startsWith("reply")) {
            setState(() {
              _fanMode = _justSetValue;
            });
            return;
          }
          setState(() {
            _fanMode = payload;
          });
        } else if (topic.contains("HomeMode")) {
          if (topic.startsWith("reply")) {
            setState(() {
              _homeMode = _justSetValue;
            });
            return;
          }
          setState(() {
            _homeMode = payload;
          });
        } else if (topic.endsWith("SetpointHold")) {
          if (topic.startsWith("reply")) {
            if (_justSetValue == "0") {
              setState(() {
                _setPointHold = "0";
              });
            }
          }
        } else if (topic.contains("SetpointHoldDuration")) {
          if (topic.startsWith("reply")) {
            setState(() {
              _setPointHold = _justSetValue;
              _setPointHoldDuration = _justSetPointHoldDurationValue;

              OwonLog.e(
                  ('=========>setpoint=$_setPointHold  duration=$_setPointHoldDuration just=$_justSetValue, us=$_justSetPointHoldDurationValue'));
            });
            return;
          }
          setState(() {
            _setPointHoldDuration = payload;
          });
        } else if (topic.contains("TemperatureUnit")) {
          setState(() {
            if(payload == "0"){
              _tempUnit = false;
            } else {
              _tempUnit = true;
            }
            widget.devModel.tempUnit = _tempUnit;
            OwonLog.e("======>>>tempUnit====${widget.devModel.tempUnit}");
          });
        } else if (topic.contains("RelayState")) {
          setState(() {
            _relayState = payload;
          });
        }else if (topic.contains("OccupiedCoolingSetpoint")) {
          if (topic.startsWith("reply")) {
            setState(() {
              if(_tempUnit){
                _OccupiedCoolingSetpoint = OwonConvert.zoom100FToC(OwonConvert.reduce100(_cool_f.toString()));
              }else{
                _OccupiedCoolingSetpoint = _cool_c.toString();

              }
            });
            return;
          }
          setState(() {
            _OccupiedCoolingSetpoint = payload;

            if(_tempUnit){
//              _heat_f = OwonTemperature().c100ToF100(int.parse(_OccupiedHeatingSetpoint));
              _cool_f = OwonTemperature().c100ToF100(int.parse(_OccupiedCoolingSetpoint));
              OwonLog.e("-coolf _OccupiedCoolingSetpoint=$_OccupiedCoolingSetpoint");

              OwonLog.e("-coolf=$_cool_f");
            } else {

//              _heat_c = int.parse(_OccupiedHeatingSetpoint);
              _cool_c = int.parse(_OccupiedCoolingSetpoint);
              OwonLog.e("-coolc=$_cool_c");
            }
          });
        }else if (topic.contains("OccupiedHeatingSetpoint")) {
          if (topic.startsWith("reply")) {
            setState(() {
              if(_tempUnit){
                _OccupiedHeatingSetpoint = OwonConvert.zoom100FToC(OwonConvert.reduce100(_heat_f.toString()));
              }else{
                _OccupiedHeatingSetpoint = _heat_c.toString();

              }
            });
            return;
          }
          setState(() {
            _OccupiedHeatingSetpoint = payload;
            if(_tempUnit){
              _heat_f = OwonTemperature().c100ToF100(int.parse(_OccupiedHeatingSetpoint));
//              _cool_f = OwonTemperature().c100ToF100(int.parse(_OccupiedCoolingSetpoint));
            } else {
              _heat_c = int.parse(_OccupiedHeatingSetpoint);
//              _cool_c = int.parse(_OccupiedCoolingSetpoint);
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _listEvenBusSubscription.cancel();
  }

  getProperty() async {
    List attrsList = [
      "LocalTemperature",
      "LocalRelativeHumidity",
      "SystemMode",
      "FanMode",
      "HomeMode",
      "ThermostatRunningMode",
      "OccupiedCoolingSetpoint",
      "OccupiedHeatingSetpoint",
      "UnoccupiedCoolingSetpoint",
      "SetpointHold",
      "SetpointHoldDuration",
      "TemperatureUnit",
      "RelayState",
      "SetpointDeadBand",
      "MaxHeatSetpointLimit",
      "MinHeatSetpointLimit",
      "MaxCoolSetpointLimit",
      "MinCoolSetpointLimit"
    ];
    List paramList = [];
    for (int i = 0; i < attrsList.length; i++) {
      String p = attrsList[i];
      Map paramMap = Map();
      paramMap["attrName"] = p;
      paramList.add(paramMap);
    }

    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic = "api/cloud/$clientID";
    Map p = Map();
    p["command"] = "device.attr.str.batch";
    p["sequence"] = OwonSequence.temp;
    p["deviceid"] = widget.devModel.deviceid;
    p["param"] = paramList;

    var msg = JsonEncoder.withIndent("  ").convert(p);
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }

  setProperty({String attribute, String value}) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic =
        "api/device/${widget.devModel.deviceid}/$clientID/attribute/$attribute";
    var msg = value;
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }



  @override
  Widget build(BuildContext context) {
    var systemList = loadSystemData(context);
    var fanList = loadFanData(context);
    var holdList = loadHoldData(context);
    Widget getBottomWidget() {
      return OwonTwoBtn(
        leftTitle: "Temp Hold",
        rightTitle: "Schedule",
        leftBtnPressed: () {
          OwonLog.e("left");
        },
        rightBtnPressed: () {
          OwonLog.e("right");
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ScheduleListPage(widget.devModel);
          }));
        },
      );
    }
    bool getShowFan(String relayState) {
      bool desFan =false;
      int relayStateNum = int.parse(relayState);
      if((relayStateNum & (0x1<<2))== (0x1<<2) || (relayStateNum & (0x1<<5))== (0x1<<5)|| (relayStateNum & (0x1<<6))== (0x1<<6)) {
        desFan = true;
      }
      return desFan;
    }


    Color getBackgroundColor(String relayState) {
      Color desColor = Colors.transparent;
      int relayStateNum = int.parse(relayState);
      if((relayStateNum & (0x1<<0))== (0x1<<0) || (relayStateNum & (0x1<<3))== (0x1<<3)) {
        desColor = Colors.red;

      }else if((relayStateNum & (0x1<<1))== (0x1<<1) || (relayStateNum & (0x1<<4))== (0x1<<4)) {
        desColor = Colors.blue;
      }

      return desColor;
    }

    Widget getOffWidget() {
      return Column(
        children: <Widget>[
          Expanded(
            child: Container(
//          color: Colors.red,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: OwonTempHumi(
                    localTemp:_tempUnit?OwonConvert.reduce100CToF(_localTemp) :OwonConvert.reduce100(_localTemp),
                    localHumi: OwonConvert.reduce100ForHumidity(_localHumi), showFan: getShowFan(_relayState)
                  )),
                ],
              ),
            ),
            flex: 5,
          ),
          Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  OwonMode(
                    rightIcon: OwonConvert.createSystemIcon(_systemMode, context),
                    leftTitle: "System",
                    rightTitle: OwonConvert.toSystemMode(_systemMode),
                    onPressed: () {
                      OwonLog.e("----");
                      OwonBottomSheet.show(context, systemList, key: null)
                          .then((val) {
                        String desValue;
                        if (val == 0) {
                          desValue = "0";
                        } else if (val == 1) {
                          desValue = "1";
                        } else if (val == 2) {
                          desValue = "3";
                        } else if (val == 3) {
                          desValue = "4";
                        } else if (val == 4) {
                          desValue = "5";
                        }
                        _justSetValue = desValue;
                        print("--消失后的回调-->$val");
                        setProperty(attribute: "SystemMode", value: desValue);
                      });
                    },
                  ),
                ],
              ))
        ],
      );
    }




    Widget getAutoWidget(String systemMode,String relayState) {
      return Column(
        children: <Widget>[
          Expanded(
            child: Container(
          color: getBackgroundColor(relayState),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 20, 0, 20),
                    child: OwonAdjustTemp(
                      title: "Cool To",
                      tempTitle:
                      _tempUnit?OwonConvert.reduce100CToF(_OccupiedCoolingSetpoint) :OwonConvert.reduce100(_OccupiedCoolingSetpoint),
                      upBtnPressed: () {
                        if (_timer != null) {
                          _timer.cancel();
                          _timer = null;
                        }
                        _timer = Timer(Duration(seconds: 1), () {
                          setProperty(
                              attribute: "OccupiedCoolingSetpoint",
                              value: _OccupiedCoolingSetpoint);
                          setProperty(
                              attribute: "OccupiedHeatingSetpoint",
                              value: _OccupiedHeatingSetpoint);
                        });

                        OwonLog.e("up");
                        if(_tempUnit){
                          if(_cool_f >= OwonTemperature().c100ToF100(int.parse(_MaxCoolSetpointLimit)))return;

                          _cool_f = _cool_f + 100;
                          OwonLog.e("heat=$_heat_c   cool=$_cool_c");
//                          if(_heat_f - _cool_f < int.parse(_SetpointDeadBand)*2){
//                            _heat_f = _cool_f + int.parse(_SetpointDeadBand)*2;
//                            _OccupiedHeatingSetpoint = _heat_f.toString();
//                          }
                        }else{
                          if(_cool_c >= int.parse(_MaxCoolSetpointLimit))return;
                          _cool_c = _cool_c + 50;
                          OwonLog.e("heat=$_heat_c   cool=$_cool_c");
//                          if(_heat_c - _cool_c < int.parse(_SetpointDeadBand)){
//                            _heat_c = _cool_c + int.parse(_SetpointDeadBand);
//                            _OccupiedHeatingSetpoint = _heat_c.toString();
//                          }
                        }
                        if(_tempUnit){
                          _OccupiedCoolingSetpoint = OwonConvert.zoom100FToC(OwonConvert.reduce100(_cool_f.toString()));
                        }else{
                          _OccupiedCoolingSetpoint = _cool_c.toString();

                        }
                        OwonLog.e("sheat=$_OccupiedHeatingSetpoint   scool=$_OccupiedCoolingSetpoint");

                        setState(() {});
                      },
                      downBtnPressed: () {
                        if (_timer != null) {
                          _timer.cancel();
                          _timer = null;
                        }
                        _timer = Timer(Duration(seconds: 1), () {
                          setProperty(
                              attribute: "OccupiedCoolingSetpoint",
                              value: _OccupiedCoolingSetpoint);
                          setProperty(
                              attribute: "OccupiedHeatingSetpoint",
                              value: _OccupiedHeatingSetpoint);
                        });

                        OwonLog.e("down");
                        if(_tempUnit){
                          if(_cool_f <= OwonTemperature().c100ToF100(int.parse(_MinCoolSetpointLimit)))return;

                          _cool_f = _cool_f - 100;
                          OwonLog.e("heat=$_heat_c   cool=$_cool_c");
                          if(_cool_f -_heat_f < int.parse(_SetpointDeadBand)*2){
                            _heat_f = _cool_f - int.parse(_SetpointDeadBand)*2;
                            _OccupiedHeatingSetpoint = OwonTemperature().f100ToC100(_heat_f).toString();
                          }
                        }else{
                          if(_cool_c <= int.parse(_MinCoolSetpointLimit))return;
                          _cool_c = _cool_c - 50;
                          OwonLog.e("heat=$_heat_c   cool=$_cool_c");
                          if(_cool_c -_heat_c  < int.parse(_SetpointDeadBand)){
                            _heat_c = _cool_c - int.parse(_SetpointDeadBand);
                            _OccupiedHeatingSetpoint = _heat_c.toString();
                          }
                        }
                        if(_tempUnit){
                          _OccupiedCoolingSetpoint = OwonConvert.zoom100FToC(OwonConvert.reduce100(_cool_f.toString()));
                        }else{
                          _OccupiedCoolingSetpoint = _cool_c.toString();

                        }
                        OwonLog.e("sheat=$_OccupiedHeatingSetpoint   scool=$_OccupiedCoolingSetpoint");
                        setState(() {});
                      },
                    ),
                  ),
                  Expanded(
                      child: OwonTempHumi(
                    localTemp: _tempUnit?OwonConvert.reduce100CToF(_localTemp)
                        :OwonConvert.reduce100(_localTemp),
                    localHumi: OwonConvert.reduce100ForHumidity(_localHumi),
                        showFan: getShowFan(_relayState),
                  )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 8, 20),
                    child: OwonAdjustTemp(
                      title: "Heat To",
                      tempTitle:
                      _tempUnit?OwonConvert.reduce100CToF(_OccupiedHeatingSetpoint)
                          :OwonConvert.reduce100(_OccupiedHeatingSetpoint),

                      upBtnPressed: () {
                        if (_timer != null) {
                          _timer.cancel();
                          _timer = null;
                        }
                        _timer = Timer(Duration(seconds: 1), () {
                          setProperty(
                              attribute: "OccupiedCoolingSetpoint",
                              value: _OccupiedCoolingSetpoint);
                          setProperty(
                              attribute: "OccupiedHeatingSetpoint",
                              value: _OccupiedHeatingSetpoint);
                        });

                        OwonLog.e("up");
                        if(_tempUnit){
                          OwonLog.e("up  heeat f=${OwonTemperature().c100ToF100(int.parse(_MaxHeatSetpointLimit))}");

                          if(_heat_f >= OwonTemperature().c100ToF100(int.parse(_MaxHeatSetpointLimit)))return;

                          _heat_f = _heat_f + 100;
                          OwonLog.e("heat=$_heat_f   cool=$_cool_f");
                          if(_cool_f - _heat_f < int.parse(_SetpointDeadBand)*2){
                            _cool_f =  _heat_f + int.parse(_SetpointDeadBand)*2;
                            OwonLog.e("_heat_f=$_heat_f   _cool_f=$_cool_f");

                            _OccupiedCoolingSetpoint = OwonTemperature().f100ToC100(_cool_f).toString();
                          }
                        }else{
                          if(_heat_c >= int.parse(_MaxHeatSetpointLimit))return;
                          _heat_c = _heat_c + 50;
                          OwonLog.e("heat=$_heat_c   cool=$_cool_c");
                          if(_cool_c -_heat_c < int.parse(_SetpointDeadBand)){
                            _cool_c = _heat_c + int.parse(_SetpointDeadBand);
                            _OccupiedCoolingSetpoint = _cool_c.toString();
                          }
                        }
                        if(_tempUnit){
                          _OccupiedHeatingSetpoint = OwonConvert.zoom100FToC(OwonConvert.reduce100(_heat_f.toString()));
                        }else{
                          _OccupiedHeatingSetpoint = _heat_c.toString();

                        }
                        OwonLog.e("sheat=$_OccupiedHeatingSetpoint   scool=$_OccupiedCoolingSetpoint");

                        setState(() {});
                      },
                      downBtnPressed: () {
                        if (_timer != null) {
                          _timer.cancel();
                          _timer = null;
                        }
                        _timer = Timer(Duration(seconds: 1), () {
                          setProperty(
                              attribute: "OccupiedCoolingSetpoint",
                              value: _OccupiedCoolingSetpoint);
                          setProperty(
                              attribute: "OccupiedHeatingSetpoint",
                              value: _OccupiedHeatingSetpoint);
                        });

                        OwonLog.e("down");
                        if(_tempUnit){
                          if(_heat_f <= OwonTemperature().c100ToF100(int.parse(_MinHeatSetpointLimit)))return;

                          _heat_f = _heat_f - 100;
                          OwonLog.e("heatf=$_heat_f   coolf=$_cool_f");
//                          if(_heat_f - _cool_f < int.parse(_SetpointDeadBand)*2){
//                            _cool_f = _heat_f - int.parse(_SetpointDeadBand)*2;
//                            _OccupiedHeatingSetpoint = _heat_f.toString();
//                          }
                        }else{
                          if(_heat_c <= int.parse(_MinHeatSetpointLimit))return;
                          _heat_c = _heat_c - 50;
                          OwonLog.e("heat=$_heat_c   cool=$_cool_c");
//                          if(_heat_c - _cool_c < int.parse(_SetpointDeadBand)){
//                             _cool_c =_heat_c  - int.parse(_SetpointDeadBand);
//                            _OccupiedCoolingSetpoint = _cool_c.toString();
//                          }
                        }
                        if(_tempUnit){
                          OwonLog.e("====>heatf=$_heat_f   coolf=$_cool_f");

                          OwonLog.e("---->${OwonConvert.reduce100(_heat_f.toString())}");

                          _OccupiedHeatingSetpoint = OwonConvert.zoom100FToC(OwonConvert.reduce100(_heat_f.toString()));
                        }else{
                          _OccupiedHeatingSetpoint = _heat_c.toString();

                        }
                        OwonLog.e("sheat=$_OccupiedHeatingSetpoint   scool=$_OccupiedCoolingSetpoint");
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            flex: 5,
          ),
          Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  OwonMode(
                    rightIcon: OwonConvert.createSystemIcon(_systemMode, context),
                    leftTitle: "System",
                    rightTitle: OwonConvert.toSystemMode(_systemMode),
                    onPressed: () {
                      OwonLog.e("----");
                      OwonBottomSheet.show(context, systemList, key: null)
                          .then((val) {
                        String desValue;
                        if (val == 0) {
                          desValue = "0";
                        } else if (val == 1) {
                          desValue = "1";
                        } else if (val == 2) {
                          desValue = "3";
                        } else if (val == 3) {
                          desValue = "4";
                        } else if (val == 4) {
                          desValue = "5";
                        }
                        _justSetValue = desValue;
                        print("--消失后的回调-->$val");
                        setProperty(attribute: "SystemMode", value: desValue);
                      });
                    },
                  ),
                  OwonMode(
                    leftTitle: "Fan",
                    rightIcon: OwonConvert.createFanIcon(_fanMode,context),
                    rightTitle: OwonConvert.toFanMode(_fanMode),
                    onPressed: () {
                      OwonLog.e("----");
                      OwonBottomSheet.show(context, fanList, key: null)
                          .then((val) {
                        print("--消失后的回调-->$val");
                        String desValue;
                        if (val == 0) {
                          desValue = "4";
                        } else if (val == 1) {
                          desValue = "6";
                        } else if (val == 2) {
                          desValue = "5";
                        }
                        _justSetValue = desValue;
                        setProperty(attribute: "FanMode", value: desValue);
                      });
                    },
                  ),
                  OwonMode(
                    rightIcon: OwonConvert.createHoldIcon(
                        setPointHold: _setPointHold,
                        setPointHoldDuration: _setPointHoldDuration,context: context),
                    leftTitle: "Hold",
                    rightTitle: OwonConvert.toHoldMode(
                        setPointHold: _setPointHold,
                        setPointHoldDuration: _setPointHoldDuration),
                    onPressed: () {
                      OwonLog.e("----");
                      OwonBottomSheet.show(context, holdList, key: null)
                          .then((val) {
                        print("--消失后的回调-->$val");
                        String desValue;
                        if (val == 0) {
                          desValue = "0";
                          _justSetValue = desValue;
                          setProperty(
                              attribute: "SetpointHold", value: desValue);
                        } else if (val == 1) {
                          desValue = "1";
                          _justSetValue = desValue;
                          _justSetPointHoldDurationValue = "65535";
                          setProperty(
                              attribute: "SetpointHold", value: desValue);
                          setProperty(
                              attribute: "SetpointHoldDuration",
                              value: "65535");
                        } else if (val == 2) {
                          desValue = "1";
                          _justSetValue = desValue;
                          _justSetPointHoldDurationValue = "1";
                          setProperty(
                              attribute: "SetpointHold", value: desValue);
                          Future.delayed(Duration(milliseconds: 100), () {
                            setProperty(
                                attribute: "SetpointHoldDuration", value: "1");
                          });
                        }
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: getBottomWidget(),
                  )
                ],
              ))
        ],
      );
    }

    Widget getCoolWidget(String relayState) {
      return Column(
        children: <Widget>[
          Expanded(
            child: Container(
          color: getBackgroundColor(relayState),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: OwonTempHumi(
                    localTemp:_tempUnit?OwonConvert.reduce100CToF(_localTemp) :OwonConvert.reduce100(_localTemp),
                    localHumi: OwonConvert.reduce100ForHumidity(_localHumi),
                        showFan: getShowFan(_relayState),
                  )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 8, 20),
                    child: OwonAdjustTemp(
                      title: "Cool To",
                      tempTitle:
                      _tempUnit?OwonConvert.reduce100CToF(_OccupiedCoolingSetpoint) :OwonConvert.reduce100(_OccupiedCoolingSetpoint),

                      upBtnPressed: () {
                        if (_timer != null) {
                          _timer.cancel();
                          _timer = null;
                        }
                        _timer = Timer(Duration(seconds: 1), () {
                          setProperty(
                              attribute: "OccupiedCoolingSetpoint",
                              value: _OccupiedCoolingSetpoint);
                        });

                        OwonLog.e("up");
                        if(_tempUnit){
                          if(_cool_f >= OwonTemperature().c100ToF100(int.parse(_MaxCoolSetpointLimit)))return;

                          _cool_f = _cool_f + 100;
                          OwonLog.e("heat=$_heat_c   cool=$_cool_c");
//                          if(_heat_f - _cool_f < int.parse(_SetpointDeadBand)*2){
//                            _heat_f = _cool_f + int.parse(_SetpointDeadBand)*2;
//                            _OccupiedHeatingSetpoint = _heat_f.toString();
//                          }
                        }else{
                          if(_cool_c >= int.parse(_MaxCoolSetpointLimit))return;
                          _cool_c = _cool_c + 50;
                          OwonLog.e("heat=$_heat_c   cool=$_cool_c");
//                          if(_heat_c - _cool_c < int.parse(_SetpointDeadBand)){
//                            _heat_c = _cool_c + int.parse(_SetpointDeadBand);
//                            _OccupiedHeatingSetpoint = _heat_c.toString();
//                          }
                        }
                        if(_tempUnit){
                          _OccupiedCoolingSetpoint = OwonConvert.zoom100FToC(OwonConvert.reduce100(_cool_f.toString()));
                        }else{
                          _OccupiedCoolingSetpoint = _cool_c.toString();

                        }
                        OwonLog.e("sheat=$_OccupiedHeatingSetpoint   scool=$_OccupiedCoolingSetpoint");

                        setState(() {});
                      },
                      downBtnPressed: () {
                        if (_timer != null) {
                          _timer.cancel();
                          _timer = null;
                        }
                        _timer = Timer(Duration(seconds: 1), () {
                          setProperty(
                              attribute: "OccupiedCoolingSetpoint",
                              value: _OccupiedCoolingSetpoint);
                        });

                        OwonLog.e("down");
                        if(_tempUnit){
                          if(_cool_f <= OwonTemperature().c100ToF100(int.parse(_MinCoolSetpointLimit)))return;

                          _cool_f = _cool_f - 100;
                          OwonLog.e("heat=$_heat_c   cool=$_cool_c");
                          if(_cool_f -_heat_f < int.parse(_SetpointDeadBand)*2){
                            _heat_f = _cool_f - int.parse(_SetpointDeadBand)*2;
                            _OccupiedHeatingSetpoint = OwonTemperature().f100ToC100(_heat_f).toString();
                          }
                        }else{
                          if(_cool_c <= int.parse(_MinCoolSetpointLimit))return;
                          _cool_c = _cool_c - 50;
                          OwonLog.e("heat=$_heat_c   cool=$_cool_c");
                          if(_cool_c -_heat_c  < int.parse(_SetpointDeadBand)){
                            _heat_c = _cool_c - int.parse(_SetpointDeadBand);
                            _OccupiedHeatingSetpoint = _heat_c.toString();
                          }
                        }
                        if(_tempUnit){
                          _OccupiedCoolingSetpoint = OwonConvert.zoom100FToC(OwonConvert.reduce100(_cool_f.toString()));
                        }else{
                          _OccupiedCoolingSetpoint = _cool_c.toString();

                        }
                        OwonLog.e("sheat=$_OccupiedHeatingSetpoint   scool=$_OccupiedCoolingSetpoint");
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            flex: 5,
          ),
          Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  OwonMode(
                    rightIcon: OwonConvert.createSystemIcon(_systemMode,context),
                    leftTitle: "System",
                    rightTitle: OwonConvert.toSystemMode(_systemMode),
                    onPressed: () {
                      OwonLog.e("----");
                      OwonBottomSheet.show(context, systemList, key: null)
                          .then((val) {
                        String desValue;
                        if (val == 0) {
                          desValue = "0";
                        } else if (val == 1) {
                          desValue = "1";
                        } else if (val == 2) {
                          desValue = "3";
                        } else if (val == 3) {
                          desValue = "4";
                        } else if (val == 4) {
                          desValue = "5";
                        }
                        _justSetValue = desValue;
                        print("--消失后的回调-->$val");
                        setProperty(attribute: "SystemMode", value: desValue);
                      });
                    },
                  ),
                  OwonMode(
                    leftTitle: "Fan",
                    rightIcon: OwonConvert.createFanIcon(_fanMode, context),
                    rightTitle: OwonConvert.toFanMode(_fanMode),
                    onPressed: () {
                      OwonLog.e("----");
                      OwonBottomSheet.show(context, fanList, key: null)
                          .then((val) {
                        print("--消失后的回调-->$val");
                        String desValue;
                        if (val == 0) {
                          desValue = "4";
                        } else if (val == 1) {
                          desValue = "6";
                        } else if (val == 2) {
                          desValue = "5";
                        }
                        _justSetValue = desValue;
                        setProperty(attribute: "FanMode", value: desValue);
                      });
                    },
                  ),
                  OwonMode(
                    rightIcon: OwonConvert.createHoldIcon(
                        setPointHold: _setPointHold,
                        setPointHoldDuration: _setPointHoldDuration,
                    context: context),
                    leftTitle: "Hold",
                    rightTitle: OwonConvert.toHoldMode(
                        setPointHold: _setPointHold,
                        setPointHoldDuration: _setPointHoldDuration),
                    onPressed: () {
                      OwonLog.e("----");
                      OwonBottomSheet.show(context, holdList, key: null)
                          .then((val) {
                        print("--消失后的回调-->$val");
                        String desValue;
                        if (val == 0) {
                          desValue = "0";
                          _justSetValue = desValue;
                          setProperty(
                              attribute: "SetpointHold", value: desValue);
                        } else if (val == 1) {
                          desValue = "1";
                          _justSetValue = desValue;
                          _justSetPointHoldDurationValue = "65535";
                          setProperty(
                              attribute: "SetpointHold", value: desValue);
                          setProperty(
                              attribute: "SetpointHoldDuration",
                              value: "65535");
                        } else if (val == 2) {
                          desValue = "1";
                          _justSetValue = desValue;
                          _justSetPointHoldDurationValue = "1";
                          setProperty(
                              attribute: "SetpointHold", value: desValue);
                          Future.delayed(Duration(milliseconds: 100), () {
                            setProperty(
                                attribute: "SetpointHoldDuration", value: "1");
                          });
                        }
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: getBottomWidget(),
                  )
                ],
              ))
        ],
      );
    }

    Widget getHeatWidget(String relayState) {
      return Column(
        children: <Widget>[
          Expanded(
            child: Container(
          color: getBackgroundColor(relayState),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: OwonTempHumi(
                    localTemp: _tempUnit?OwonConvert.reduce100CToF(_localTemp) :OwonConvert.reduce100(_localTemp),
                    localHumi: OwonConvert.reduce100ForHumidity(_localHumi),
                        showFan: getShowFan(_relayState),
                  )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 8, 20),
                    child: OwonAdjustTemp(
                      title: "Heat To",
                      tempTitle:
                      _tempUnit?OwonConvert.reduce100CToF(_OccupiedHeatingSetpoint)
                          :OwonConvert.reduce100(_OccupiedHeatingSetpoint),

                      upBtnPressed: () {
                        if (_timer != null) {
                          _timer.cancel();
                          _timer = null;
                        }
                        _timer = Timer(Duration(seconds: 1), () {
                          setProperty(
                              attribute: "OccupiedCoolingSetpoint",
                              value: _OccupiedCoolingSetpoint);
                          setProperty(
                              attribute: "OccupiedHeatingSetpoint",
                              value: _OccupiedHeatingSetpoint);
                        });

                        OwonLog.e("up");
                        if(_tempUnit){
                          OwonLog.e("up  heeat f=${OwonTemperature().c100ToF100(int.parse(_MaxHeatSetpointLimit))}");

                          if(_heat_f >= OwonTemperature().c100ToF100(int.parse(_MaxHeatSetpointLimit)))return;

                          _heat_f = _heat_f + 100;
                          OwonLog.e("heat=$_heat_f   cool=$_cool_f");
                          if(_cool_f - _heat_f < int.parse(_SetpointDeadBand)*2){
                            _cool_f =  _heat_f + int.parse(_SetpointDeadBand)*2;
                            OwonLog.e("_heat_f=$_heat_f   _cool_f=$_cool_f");

                            _OccupiedCoolingSetpoint = OwonTemperature().f100ToC100(_cool_f).toString();
                          }
                        }else{
                          if(_heat_c >= int.parse(_MaxHeatSetpointLimit))return;
                          _heat_c = _heat_c + 50;
                          OwonLog.e("heat=$_heat_c   cool=$_cool_c");
                          if(_cool_c -_heat_c < int.parse(_SetpointDeadBand)){
                            _cool_c = _heat_c + int.parse(_SetpointDeadBand);
                            _OccupiedCoolingSetpoint = _cool_c.toString();
                          }
                        }
                        if(_tempUnit){
                          _OccupiedHeatingSetpoint = OwonConvert.zoom100FToC(OwonConvert.reduce100(_heat_f.toString()));
                        }else{
                          _OccupiedHeatingSetpoint = _heat_c.toString();

                        }
                        OwonLog.e("sheat=$_OccupiedHeatingSetpoint   scool=$_OccupiedCoolingSetpoint");

                        setState(() {});
                      },
                      downBtnPressed: () {
                        if (_timer != null) {
                          _timer.cancel();
                          _timer = null;
                        }
                        _timer = Timer(Duration(seconds: 1), () {
                          setProperty(
                              attribute: "OccupiedCoolingSetpoint",
                              value: _OccupiedCoolingSetpoint);
                          setProperty(
                              attribute: "OccupiedHeatingSetpoint",
                              value: _OccupiedHeatingSetpoint);
                        });

                        OwonLog.e("down");
                        if(_tempUnit){
                          if(_heat_f <= OwonTemperature().c100ToF100(int.parse(_MinHeatSetpointLimit)))return;

                          _heat_f = _heat_f - 100;
                          OwonLog.e("heatf=$_heat_f   coolf=$_cool_f");
//                          if(_heat_f - _cool_f < int.parse(_SetpointDeadBand)*2){
//                            _cool_f = _heat_f - int.parse(_SetpointDeadBand)*2;
//                            _OccupiedHeatingSetpoint = _heat_f.toString();
//                          }
                        }else{
                          if(_heat_c <= int.parse(_MinHeatSetpointLimit))return;
                          _heat_c = _heat_c - 50;
                          OwonLog.e("heat=$_heat_c   cool=$_cool_c");
//                          if(_heat_c - _cool_c < int.parse(_SetpointDeadBand)){
//                             _cool_c =_heat_c  - int.parse(_SetpointDeadBand);
//                            _OccupiedCoolingSetpoint = _cool_c.toString();
//                          }
                        }
                        if(_tempUnit){
                          OwonLog.e("====>heatf=$_heat_f   coolf=$_cool_f");

                          OwonLog.e("---->${OwonConvert.reduce100(_heat_f.toString())}");

                          _OccupiedHeatingSetpoint = OwonConvert.zoom100FToC(OwonConvert.reduce100(_heat_f.toString()));
                        }else{
                          _OccupiedHeatingSetpoint = _heat_c.toString();

                        }
                        OwonLog.e("sheat=$_OccupiedHeatingSetpoint   scool=$_OccupiedCoolingSetpoint");
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            flex: 5,
          ),
          Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  OwonMode(
                    rightIcon: OwonConvert.createSystemIcon(_systemMode, context),
                    leftTitle: "System",
                    rightTitle: OwonConvert.toSystemMode(_systemMode),
                    onPressed: () {
                      OwonLog.e("----");
                      OwonBottomSheet.show(context, systemList, key: null)
                          .then((val) {
                        String desValue;
                        if (val == 0) {
                          desValue = "0";
                        } else if (val == 1) {
                          desValue = "1";
                        } else if (val == 2) {
                          desValue = "3";
                        } else if (val == 3) {
                          desValue = "4";
                        } else if (val == 4) {
                          desValue = "5";
                        }
                        _justSetValue = desValue;
                        print("--消失后的回调-->$val");
                        setProperty(attribute: "SystemMode", value: desValue);
                      });
                    },
                  ),
                  OwonMode(
                    leftTitle: "Fan",
                    rightIcon: OwonConvert.createFanIcon(_fanMode, context),
                    rightTitle: OwonConvert.toFanMode(_fanMode),
                    onPressed: () {
                      OwonLog.e("----");
                      OwonBottomSheet.show(context, fanList, key: null)
                          .then((val) {
                        print("--消失后的回调-->$val");
                        String desValue;
                        if (val == 0) {
                          desValue = "4";
                        } else if (val == 1) {
                          desValue = "6";
                        } else if (val == 2) {
                          desValue = "5";
                        }
                        _justSetValue = desValue;
                        setProperty(attribute: "FanMode", value: desValue);
                      });
                    },
                  ),
                  OwonMode(
                    rightIcon: OwonConvert.createHoldIcon(
                        setPointHold: _setPointHold,
                        setPointHoldDuration: _setPointHoldDuration,context: context),
                    leftTitle: "Hold",
                    rightTitle: OwonConvert.toHoldMode(
                        setPointHold: _setPointHold,
                        setPointHoldDuration: _setPointHoldDuration),
                    onPressed: () {
                      OwonLog.e("----");
                      OwonBottomSheet.show(context, holdList, key: null)
                          .then((val) {
                        print("--消失后的回调-->$val");
                        String desValue;
                        if (val == 0) {
                          desValue = "0";
                          _justSetValue = desValue;
                          setProperty(
                              attribute: "SetpointHold", value: desValue);
                        } else if (val == 1) {
                          desValue = "1";
                          _justSetValue = desValue;
                          _justSetPointHoldDurationValue = "65535";
                          setProperty(
                              attribute: "SetpointHold", value: desValue);
                          setProperty(
                              attribute: "SetpointHoldDuration",
                              value: "65535");
                        } else if (val == 2) {
                          desValue = "1";
                          _justSetValue = desValue;
                          _justSetPointHoldDurationValue = "1";
                          setProperty(
                              attribute: "SetpointHold", value: desValue);
                          Future.delayed(Duration(milliseconds: 100), () {
                            setProperty(
                                attribute: "SetpointHoldDuration", value: "1");
                          });
                        }
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: getBottomWidget(),
                  )
                ],
              ))
        ],
      );
    }

    Widget getEHeatWidget(String relayState) {
      return Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: getBackgroundColor(relayState),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: OwonTempHumi(
                    localTemp: _tempUnit?OwonConvert.reduce100CToF(_localTemp)
                        :OwonConvert.reduce100(_localTemp),
                    localHumi: OwonConvert.reduce100ForHumidity(_localHumi),
                        showFan: getShowFan(_relayState),
                  )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 8, 20),
                    child: OwonAdjustTemp(
                      title: "Heat To",
                      tempTitle:
                      _tempUnit?OwonConvert.reduce100CToF(_OccupiedHeatingSetpoint)
                          :OwonConvert.reduce100(_OccupiedHeatingSetpoint),
                      upBtnPressed: () {
                        if (_timer != null) {
                          _timer.cancel();
                          _timer = null;
                        }
                        _timer = Timer(Duration(seconds: 1), () {
                          setProperty(
                              attribute: "OccupiedHeatingSetpoint",
                              value: _OccupiedHeatingSetpoint);
                        });

                        OwonLog.e("up");
                        if(_tempUnit){
                          OwonLog.e("up  heeat f=${OwonTemperature().c100ToF100(int.parse(_MaxHeatSetpointLimit))}");

                          if(_heat_f >= OwonTemperature().c100ToF100(int.parse(_MaxHeatSetpointLimit)))return;

                          _heat_f = _heat_f + 100;
                          OwonLog.e("heat=$_heat_f   cool=$_cool_f");
                          if(_cool_f - _heat_f < int.parse(_SetpointDeadBand)*2){
                            _cool_f =  _heat_f + int.parse(_SetpointDeadBand)*2;
                            OwonLog.e("_heat_f=$_heat_f   _cool_f=$_cool_f");

                            _OccupiedCoolingSetpoint = OwonTemperature().f100ToC100(_cool_f).toString();
                          }
                        }else{
                          if(_heat_c >= int.parse(_MaxHeatSetpointLimit))return;
                          _heat_c = _heat_c + 50;
                          OwonLog.e("heat=$_heat_c   cool=$_cool_c");
                          if(_cool_c -_heat_c < int.parse(_SetpointDeadBand)){
                            _cool_c = _heat_c + int.parse(_SetpointDeadBand);
                            _OccupiedCoolingSetpoint = _cool_c.toString();
                          }
                        }
                        if(_tempUnit){
                          _OccupiedHeatingSetpoint = OwonConvert.zoom100FToC(OwonConvert.reduce100(_heat_f.toString()));
                        }else{
                          _OccupiedHeatingSetpoint = _heat_c.toString();

                        }
                        OwonLog.e("sheat=$_OccupiedHeatingSetpoint   scool=$_OccupiedCoolingSetpoint");

                        setState(() {});
                      },
                      downBtnPressed: () {
                        if (_timer != null) {
                          _timer.cancel();
                          _timer = null;
                        }
                        _timer = Timer(Duration(seconds: 1), () {
                          setProperty(
                              attribute: "OccupiedHeatingSetpoint",
                              value: _OccupiedHeatingSetpoint);
                        });

                        OwonLog.e("down");
                        if(_tempUnit){
                          if(_heat_f <= OwonTemperature().c100ToF100(int.parse(_MinHeatSetpointLimit)))return;

                          _heat_f = _heat_f - 100;
                          OwonLog.e("heatf=$_heat_f   coolf=$_cool_f");
//                          if(_heat_f - _cool_f < int.parse(_SetpointDeadBand)*2){
//                            _cool_f = _heat_f - int.parse(_SetpointDeadBand)*2;
//                            _OccupiedHeatingSetpoint = _heat_f.toString();
//                          }
                        }else{
                          if(_heat_c <= int.parse(_MinHeatSetpointLimit))return;
                          _heat_c = _heat_c - 50;
                          OwonLog.e("heat=$_heat_c   cool=$_cool_c");
//                          if(_heat_c - _cool_c < int.parse(_SetpointDeadBand)){
//                             _cool_c =_heat_c  - int.parse(_SetpointDeadBand);
//                            _OccupiedCoolingSetpoint = _cool_c.toString();
//                          }
                        }
                        if(_tempUnit){
                          OwonLog.e("====>heatf=$_heat_f   coolf=$_cool_f");

                          OwonLog.e("---->${OwonConvert.reduce100(_heat_f.toString())}");

                          _OccupiedHeatingSetpoint = OwonConvert.zoom100FToC(OwonConvert.reduce100(_heat_f.toString()));
                        }else{
                          _OccupiedHeatingSetpoint = _heat_c.toString();

                        }
                        OwonLog.e("sheat=$_OccupiedHeatingSetpoint   scool=$_OccupiedCoolingSetpoint");
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            flex: 5,
          ),
          Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  OwonMode(
                    rightIcon: OwonConvert.createSystemIcon(_systemMode,context),
                    leftTitle: "System",
                    rightTitle: OwonConvert.toSystemMode(_systemMode),
                    onPressed: () {
                      OwonLog.e("----");
                      OwonBottomSheet.show(context, systemList, key: null)
                          .then((val) {
                        String desValue;
                        if (val == 0) {
                          desValue = "0";
                        } else if (val == 1) {
                          desValue = "1";
                        } else if (val == 2) {
                          desValue = "3";
                        } else if (val == 3) {
                          desValue = "4";
                        } else if (val == 4) {
                          desValue = "5";
                        }
                        _justSetValue = desValue;
                        print("--消失后的回调-->$val");
                        setProperty(attribute: "SystemMode", value: desValue);
                      });
                    },
                  ),
                  OwonMode(
                    leftTitle: "Fan",
                    rightIcon: OwonConvert.createFanIcon(_fanMode, context),
                    rightTitle: OwonConvert.toFanMode(_fanMode),
                    onPressed: () {
                      OwonLog.e("----");
                      OwonBottomSheet.show(context, fanList, key: null)
                          .then((val) {
                        print("--消失后的回调-->$val");
                        String desValue;
                        if (val == 0) {
                          desValue = "4";
                        } else if (val == 1) {
                          desValue = "6";
                        } else if (val == 2) {
                          desValue = "5";
                        }
                        _justSetValue = desValue;
                        setProperty(attribute: "FanMode", value: desValue);
                      });
                    },
                  ),
                  OwonMode(
                    rightIcon: OwonConvert.createHoldIcon(
                        setPointHold: _setPointHold,
                        setPointHoldDuration: _setPointHoldDuration,context: context),
                    leftTitle: "Hold",
                    rightTitle: OwonConvert.toHoldMode(
                        setPointHold: _setPointHold,
                        setPointHoldDuration: _setPointHoldDuration),
                    onPressed: () {
                      OwonLog.e("----");
                      OwonBottomSheet.show(context, holdList, key: null)
                          .then((val) {
                        print("--消失后的回调-->$val");
                        String desValue;
                        if (val == 0) {
                          desValue = "0";
                          _justSetValue = desValue;
                          setProperty(
                              attribute: "SetpointHold", value: desValue);
                        } else if (val == 1) {
                          desValue = "1";
                          _justSetValue = desValue;
                          _justSetPointHoldDurationValue = "65535";
                          setProperty(
                              attribute: "SetpointHold", value: desValue);
                          setProperty(
                              attribute: "SetpointHoldDuration",
                              value: "65535");
                        } else if (val == 2) {
                          desValue = "1";
                          _justSetValue = desValue;
                          _justSetPointHoldDurationValue = "1";
                          setProperty(
                              attribute: "SetpointHold", value: desValue);
                          Future.delayed(Duration(milliseconds: 100), () {
                            setProperty(
                                attribute: "SetpointHoldDuration", value: "1");
                          });
                        }
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: getBottomWidget(),
                  )
                ],
              ))
        ],
      );
    }

    Widget getWidget({String systemMode, String relayState}) {

      Widget desWidget = getAutoWidget(systemMode,relayState);

      if(systemMode == "0"){
        desWidget = getOffWidget();
      }else if(systemMode == "3") {
        desWidget = getCoolWidget(relayState);
      }else if(systemMode == "4") {
        desWidget = getHeatWidget(relayState);
      }else if(systemMode == "5") {
        desWidget = getEHeatWidget(relayState);
      }else if(systemMode == "1") {
        desWidget = getAutoWidget(systemMode,relayState);
      }

     return desWidget;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("PCT513"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return DeviceSettingPage(widget.devModel);
              }));
            },
            color: OwonColor().getCurrent(context, "textColor"),
          )
        ],
      ),
      body: Container(
          child: getWidget(
              systemMode: _systemMode, relayState: _relayState)),
    );
  }
}
