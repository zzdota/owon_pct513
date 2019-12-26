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
import 'package:owon_pct513/owon_utils/owon_toast.dart';
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

class ManagementPage extends StatefulWidget {
  AddressModelAddrsDevlist devModel;
  ManagementPage(this.devModel);

  @override
  _ManagementPageState createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  var systemList = loadSystemData;
  var fanList = loadFanData;
  var holdList = loadHoldData;

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
  String _ThermostatRunningMode = "0";
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
//                _tempUnit = false;
              } else {
                _tempUnit = true;
              }
              widget.devModel.tempUnit = _tempUnit;
              OwonLog.e("======>>>tempUnit====${widget.devModel.tempUnit}");
            });
          }
        });
      } else if (msg["type"] == "string") {
        String payload = msg["payload"];

        OwonLog.e("----上报的payload=$payload");
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
      "RelayState"
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
                    localHumi: OwonConvert.reduce100(_localHumi),
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
                    rightIcon: OwonConvert.createSystemIcon(_systemMode),
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

    Color getAutoBackgroundColor(String systemMode,String runningMode) {
      Color desColor = Colors.transparent;

        if(runningMode == "3") {
          desColor = Colors.blue;
        }else if(runningMode == "4") {
          desColor = Colors.red;

        }

        return desColor;
    }

    Color getCoolBackgroundColor(String runningMode) {
      Color desColor = Colors.transparent;

      if(runningMode == "3") {
        desColor = Colors.blue;
      }

      return desColor;
    }
    Color getHeatBackgroundColor(String runningMode) {
      Color desColor = Colors.transparent;

      if(runningMode == "4" || runningMode == "5") {
        desColor = Colors.red;

      }

      return desColor;
    }

    Widget getAutoWidget(String systemMode,String runningMode) {
      return Column(
        children: <Widget>[
          Expanded(
            child: Container(
          color: getAutoBackgroundColor(systemMode, runningMode),
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
                        _timer = Timer(Duration(seconds: 2), () {
                          setProperty(
                              attribute: "OccupiedCoolingSetpoint",
                              value: _OccupiedCoolingSetpoint);
                        });

                        OwonLog.e("up");
                        _OccupiedCoolingSetpoint =
                            (int.parse(_OccupiedCoolingSetpoint) + 50)
                                .toString();
                        setState(() {});
                      },
                      downBtnPressed: () {
                        if (_timer != null) {
                          _timer.cancel();
                          _timer = null;
                        }
                        _timer = Timer(Duration(seconds: 2), () {
                          setProperty(
                              attribute: "OccupiedCoolingSetpoint",
                              value: _OccupiedCoolingSetpoint);
                        });

                        OwonLog.e("down");
                        _OccupiedCoolingSetpoint =
                            (int.parse(_OccupiedCoolingSetpoint) - 50)
                                .toString();
                        setState(() {});
                      },
                    ),
                  ),
                  Expanded(
                      child: OwonTempHumi(
                    localTemp: _tempUnit?OwonConvert.reduce100CToF(_localTemp) :OwonConvert.reduce100(_localTemp),
                    localHumi: OwonConvert.reduce100(_localHumi),
                  )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 8, 20),
                    child: OwonAdjustTemp(
                      title: "Heat To",
                      tempTitle:
                      _tempUnit?OwonConvert.reduce100CToF(_OccupiedHeatingSetpoint) :OwonConvert.reduce100(_OccupiedHeatingSetpoint),
                      upBtnPressed: () {
                        if (_timer != null) {
                          _timer.cancel();
                          _timer = null;
                        }
                        _timer = Timer(Duration(seconds: 2), () {
                          setProperty(
                              attribute: "OccupiedHeatingSetpoint",
                              value: _OccupiedHeatingSetpoint);
                        });

                        OwonLog.e("up");
                        _OccupiedHeatingSetpoint =
                            (int.parse(_OccupiedHeatingSetpoint) + 50)
                                .toString();
                        setState(() {});
                      },
                      downBtnPressed: () {
                        if (_timer != null) {
                          _timer.cancel();
                          _timer = null;
                        }
                        _timer = Timer(Duration(seconds: 2), () {
                          setProperty(
                              attribute: "OccupiedHeatingSetpoint",
                              value: _OccupiedHeatingSetpoint);
                        });

                        OwonLog.e("down");
                        _OccupiedHeatingSetpoint =
                            (int.parse(_OccupiedHeatingSetpoint) - 50)
                                .toString();
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
                    rightIcon: OwonConvert.createSystemIcon(_systemMode),
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
                    rightIcon: OwonConvert.createFanIcon(_fanMode),
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
                        setPointHoldDuration: _setPointHoldDuration),
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

    Widget getCoolWidget(String runningMode) {
      return Column(
        children: <Widget>[
          Expanded(
            child: Container(
          color: getCoolBackgroundColor(runningMode),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: OwonTempHumi(
                    localTemp:_tempUnit?OwonConvert.reduce100CToF(_localTemp) :OwonConvert.reduce100(_localTemp),
                    localHumi: OwonConvert.reduce100(_localHumi),
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
                        _timer = Timer(Duration(seconds: 2), () {
                          setProperty(
                              attribute: "OccupiedCoolingSetpoint",
                              value: _OccupiedCoolingSetpoint);
                        });

                        OwonLog.e("up");
                        _OccupiedCoolingSetpoint =
                            (int.parse(_OccupiedCoolingSetpoint) + 50)
                                .toString();
                        setState(() {});
                      },
                      downBtnPressed: () {
                        if (_timer != null) {
                          _timer.cancel();
                          _timer = null;
                        }
                        _timer = Timer(Duration(seconds: 2), () {
                          setProperty(
                              attribute: "OccupiedCoolingSetpoint",
                              value: _OccupiedCoolingSetpoint);
                        });

                        OwonLog.e("down");
                        _OccupiedCoolingSetpoint =
                            (int.parse(_OccupiedCoolingSetpoint) - 50)
                                .toString();
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
                    rightIcon: OwonConvert.createSystemIcon(_systemMode),
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
                    rightIcon: OwonConvert.createFanIcon(_fanMode),
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
                        setPointHoldDuration: _setPointHoldDuration),
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

    Widget getHeatWidget(String runningMode) {
      return Column(
        children: <Widget>[
          Expanded(
            child: Container(
          color: getHeatBackgroundColor(runningMode),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: OwonTempHumi(
                    localTemp: _tempUnit?OwonConvert.reduce100CToF(_localTemp) :OwonConvert.reduce100(_localTemp),
                    localHumi: OwonConvert.reduce100(_localHumi),
                  )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 8, 20),
                    child: OwonAdjustTemp(
                      title: "Heat To",
                      tempTitle:
                      _tempUnit?OwonConvert.reduce100CToF(_OccupiedHeatingSetpoint) :OwonConvert.reduce100(_OccupiedHeatingSetpoint),
                      upBtnPressed: () {
                        if (_timer != null) {
                          _timer.cancel();
                          _timer = null;
                        }
                        _timer = Timer(Duration(seconds: 2), () {
                          setProperty(
                              attribute: "OccupiedHeatingSetpoint",
                              value: _OccupiedHeatingSetpoint);
                        });

                        OwonLog.e("up");
                        _OccupiedHeatingSetpoint =
                            (int.parse(_OccupiedHeatingSetpoint) + 50)
                                .toString();
                        setState(() {});
                      },
                      downBtnPressed: () {
                        if (_timer != null) {
                          _timer.cancel();
                          _timer = null;
                        }
                        _timer = Timer(Duration(seconds: 2), () {
                          setProperty(
                              attribute: "OccupiedHeatingSetpoint",
                              value: _OccupiedHeatingSetpoint);
                        });

                        OwonLog.e("down");
                        _OccupiedHeatingSetpoint =
                            (int.parse(_OccupiedHeatingSetpoint) - 50)
                                .toString();
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
                    rightIcon: OwonConvert.createSystemIcon(_systemMode),
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
                    rightIcon: OwonConvert.createFanIcon(_fanMode),
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
                        setPointHoldDuration: _setPointHoldDuration),
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

    Widget getEHeatWidget(String runningMode) {
      return Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: getHeatBackgroundColor(runningMode),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: OwonTempHumi(
                    localTemp: _tempUnit?OwonConvert.reduce100CToF(_localTemp) :OwonConvert.reduce100(_localTemp),
                    localHumi: OwonConvert.reduce100(_localHumi),
                  )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 8, 20),
                    child: OwonAdjustTemp(
                      title: "Heat To",
                      tempTitle:
                      _tempUnit?OwonConvert.reduce100CToF(_OccupiedHeatingSetpoint) :OwonConvert.reduce100(_OccupiedHeatingSetpoint),
                      upBtnPressed: () {
                        if (_timer != null) {
                          _timer.cancel();
                          _timer = null;
                        }
                        _timer = Timer(Duration(seconds: 2), () {
                          setProperty(
                              attribute: "OccupiedHeatingSetpoint",
                              value: _OccupiedHeatingSetpoint);
                        });

                        OwonLog.e("up");
                        _OccupiedHeatingSetpoint =
                            (int.parse(_OccupiedHeatingSetpoint) + 50)
                                .toString();
                        setState(() {});
                      },
                      downBtnPressed: () {
                        if (_timer != null) {
                          _timer.cancel();
                          _timer = null;
                        }
                        _timer = Timer(Duration(seconds: 2), () {
                          setProperty(
                              attribute: "OccupiedHeatingSetpoint",
                              value: _OccupiedHeatingSetpoint);
                        });

                        OwonLog.e("down");
                        _OccupiedHeatingSetpoint =
                            (int.parse(_OccupiedHeatingSetpoint) - 50)
                                .toString();
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
                    rightIcon: OwonConvert.createSystemIcon(_systemMode),
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
                    rightIcon: OwonConvert.createFanIcon(_fanMode),
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
                        setPointHoldDuration: _setPointHoldDuration),
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

    Widget getWidget({String systemMode, String runningMode}) {

      Widget desWidget = getAutoWidget(systemMode,runningMode);

      if(systemMode == "0"){
        desWidget = getOffWidget();
      }else if(systemMode == "3") {
        desWidget = getCoolWidget(runningMode);
      }else if(systemMode == "4") {
        desWidget = getHeatWidget(runningMode);
      }else if(systemMode == "5") {
        desWidget = getEHeatWidget(runningMode);
      }else if(systemMode == "1") {
        desWidget = getAutoWidget(systemMode,runningMode);
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
              systemMode: _systemMode, runningMode: _ThermostatRunningMode)),
    );
  }
}
