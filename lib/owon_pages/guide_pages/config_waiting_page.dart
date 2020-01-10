import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:esptouch_plug/esptouch_plug.dart';
import '../../generated/i18n.dart';
import 'package:owon_pct513/res/owon_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../owon_providers/owon_evenBus/list_evenbus.dart';
import '../../owon_utils/owon_toast.dart';

class ConfigWaitingPage extends StatefulWidget {
  @override
  _ConfigWaitingPageState createState() {
    return _ConfigWaitingPageState();
  }
}

class _ConfigWaitingPageState extends State<ConfigWaitingPage> {
  var progressvalue = 0;
  String ssid = "";
  String bssid = "";
  String password = "";
  String statestr = "";
  String username = "";
  String deviceid = "";
  int addrid = 1;
  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;
  Timer _timer;
  static const EventChannel _eventChannel =
      EventChannel("esptouch_plugin_event");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getExistUserInfo();
    registerevent();
    _eventChannel.receiveBroadcastStream().listen((data) {
      //streamController.sink.add(data);
      String datastr = data;
      if (datastr.contains("connect success")) {
        setState(() {
          statestr = "\ue834  " +
              S.of(context).configwaitingpage_step1 +
              "\n\n\ue835  " +
              S.of(context).configwaitingpage_step2 +
              "\n\n\ue835  " +
              S.of(context).configwaitingpage_step3;
        });
        var jsondata = {
          "type": "wizardConfig",
          "command": "serverCfg",
          "argument": {
            "host": OwonConstant.mqttServerIp,
            "sslport": OwonConstant.mqttServerSSLPort,
            "port": OwonConstant.mqttServerPort
          },
          "sequence": 1000
        };
        String jsonString = convert.jsonEncode(jsondata);
        EsptouchPlug.writeData(jsonString);
      } else {
        print("errordata=" + datastr);
        Map<String, dynamic> json = convert.jsonDecode(datastr);
        String command = json["command"];
        Map response = json["response"];
        if (deviceid == "") {
          deviceid = response["deviceid"];
        }
        if (command == "serverCfg") {
          var jsondata = {
            "type": "wizardConfig",
            "command": "DevOwnerCfg",
            "argument": {
              "Owner": username,
              "agentid": OwonConstant.agentID,
            },
            "sequence": 1001
          };
          String jsonString = convert.jsonEncode(jsondata);
          EsptouchPlug.writeData(jsonString);
        } else if (command == "DevOwnerCfg") {
          var jsondata = {
            "type": "wizardConfig",
            "command": "DevLocationCfg",
            "argument": {
              "Addrid": addrid.toString(),
              "Area": "Asia/Shanghai",
            },
            "sequence": 1002
          };
          String jsonString = convert.jsonEncode(jsondata);
          EsptouchPlug.writeData(jsonString);
        } else if (command == "DevLocationCfg") {
          setState(() {
            statestr = "\ue834  " +
                S.of(context).configwaitingpage_step1 +
                "\n\n\ue834  " +
                S.of(context).configwaitingpage_step2 +
                "\n\n\ue835  " +
                S.of(context).configwaitingpage_step3;
          });
          var jsondata = {
            "type": "wizardConfig",
            "command": "startRegister",
            "sequence": 1003
          };
          String jsonString = convert.jsonEncode(jsondata);
          EsptouchPlug.writeData(jsonString);
          EsptouchPlug.closeLocalServer();
        }
      }
    });
    startTimer();
    startLocalServer();
  }

  registerevent() {
    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
      String topic = msg["topic"];
      String payload = msg["payload"];
      if (payload.contains("devlist") && payload.contains(deviceid)) {
        cancelTimer();
        setState(() {
          statestr = "\ue834  " +
              S.of(context).configwaitingpage_step1 +
              "\n\n\ue834  " +
              S.of(context).configwaitingpage_step2 +
              "\n\n\ue834  " +
              S.of(context).configwaitingpage_step3;
          progressvalue = 100;
        });
        EsptouchPlug.closeLocalServer();
        Navigator.pushNamed(context, "configsuccesspage",
            arguments: {"deviceid": deviceid});
      }
    });
  }

  getExistUserInfo() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    username = pre.get(OwonConstant.userName);
    addrid = pre.get("addrid");
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    cancelTimer();
  }

  void startTimer() {
    //设置 1 秒回调一次
    const period = const Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      //更新界面
      setState(() {
        //秒数减一，因为一秒回调一次
        progressvalue++;
      });
      if (progressvalue == 100) {
        //倒计时秒数为0，取消定时器
        cancelTimer();
        EsptouchPlug.closeLocalServer();
        Navigator.pushNamed(context, "configfailedpage");
      }
    });
  }

  void cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void startLocalServer() async {
    String result = await EsptouchPlug.openLocalServer();
  }

  void espTouchConfig() async {
    print("bssid= " + bssid);
    String result = await EsptouchPlug.espTouchConfig(ssid, bssid, password);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (statestr == "") {
      statestr = "\ue835  " +
          S.of(context).configwaitingpage_step1 +
          "\n\n\ue835  " +
          S.of(context).configwaitingpage_step2 +
          "\n\n\ue835  " +
          S.of(context).configwaitingpage_step3;
    }

    if (ssid == "") {
      Map args = ModalRoute.of(context).settings.arguments;
      ssid = args['ssid'];
      bssid = args['bssid'];
      password = args['password'];
      espTouchConfig();
    }

    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(S.of(context).configwaitingpage_title),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Image.asset(
              OwonPic.mDivideLineHori,
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Spacer(
                  flex: 2,
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Image(
                                  image: AssetImage(OwonPic.mConfigTipnumberBG),
                                ),
                              ),
                              Text(
                                "3",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 35.0),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          color: Colors.white,
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                            child: Text(
                              S.of(context).configwaitingpage_tip,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(
                  flex: 2,
                ),
                Expanded(
                  flex: 6,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                          value: progressvalue / 100.0,
                        ),
                      ),
                      Text(
                        '$progressvalue' + "%",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ],
                  ),
                ),
                Spacer(
                  flex: 2,
                ),
                Expanded(
                    flex: 5,
                    child: Center(
                      child: Text(
                        statestr,
                        style: TextStyle(
                            fontFamily: "MaterialIcons",
                            fontSize: 12.0,
                            color: Colors.white),
                      ),
                    )),
                Spacer(
                  flex: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
