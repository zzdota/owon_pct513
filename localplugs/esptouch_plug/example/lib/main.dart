import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:flutter/services.dart';
import 'package:esptouch_plug/esptouch_plug.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  static const EventChannel _eventChannel = EventChannel("esptouch_plugin_event");
  @override
  void initState() {
    super.initState();
    startListener();
    EsptouchPlug.openLocalServer();
    initPlatformState();
  }

  void startListener() async {
    _eventChannel.receiveBroadcastStream().listen((data) {
      //streamController.sink.add(data);
      print(data+"xxxxxxxxxxxx");

      print("xxx="+data);
      String datastr = data;
      if (datastr.contains("connect success")){
        var jsondata = {
          "type": "wizardConfig",
          "command": "serverCfg",
          "argument": {
            "host":"192.168.1.90",
            "sslport":8883,
            "port":1883
          },
          "sequence":1000};
        String jsonString = convert.jsonEncode(jsondata);
        EsptouchPlug.writeData(jsonString);
        print("xxxwritedata");
      }
      else if (datastr.contains("serverCfg")){
        var jsondata = {
          "type": "wizardConfig",
          "command": "DevOwnerCfg",
          "argument": {
            "Owner":"steven",
            "agentid":"owon20181107",
          },
          "sequence":1001};
        String jsonString = convert.jsonEncode(jsondata);
        writeData(jsonString);
      }else if (datastr.contains("DevOwnerCfg")){
        var jsondata = {
          "type": "wizardConfig",
          "command": "DevLocationCfg",
          "argument": {
            "Addrid":"1",
            "Area":"Asia/Shanghai",
          },
          "sequence":1002};
        String jsonString = convert.jsonEncode(jsondata);
        writeData(jsonString);
      }else if (datastr.contains("DevLocationCfg")){
        var jsondata = {
          "type": "wizardConfig",
          "command": "startRegister",
          "sequence":1003};
        String jsonString = convert.jsonEncode(jsondata);
        writeData(jsonString);
        EsptouchPlug.closeLocalServer();
      }


    });
  }

  Future<void> writeData(String data) async {
    String result = await EsptouchPlug.writeData(data);
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await EsptouchPlug.espTouchConfig("", "", "");

      print("result= "+platformVersion+" xxxxxxx");
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
