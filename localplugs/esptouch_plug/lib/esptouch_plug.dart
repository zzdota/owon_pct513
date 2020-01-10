import 'dart:async';

import 'package:flutter/services.dart';

class EsptouchPlug {
  static const MethodChannel _channel =
      const MethodChannel('esptouch_plug');

  static Future<String> espTouchConfig(String ssid,String bssid,String password) async {
    final String result = await _channel.invokeMethod('espTouchConfig',{
      "ssid":ssid,
      "password":password,
      "bssid":bssid
    });
    return result;
  }

  static Future<String> openLocalServer() async {
    final String result = await _channel.invokeMethod('openLocalServer');
    return result;
  }

  static Future<String> closeLocalServer() async {
    final String result = await _channel.invokeMethod('closeLocalServer');
    return result;
  }

  static Future<String> writeData(String data) async {
    final String result = await _channel.invokeMethod('writeData',{"data":data});
    return result;
  }
}
