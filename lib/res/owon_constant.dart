import 'package:flutter/material.dart';

class OwonConstant {
  static final String agentID = "owon20181107"; //代理商ID
  static const String foreignServerIp = "https://connect.owon.com"; //国外服务器ip
  static const String domesticServerIp = "https://gn1.owon.com"; //国内服务器ip
  static const int foreignServerPort = 443; //国外服务器端口
  static const int domesticServerPort = 8443; //国内服务器端口

  static const String foreignServerBase =
      "$foreignServerIp:$foreignServerPort/";
  static const String domesticServerBase =
      "$domesticServerIp:$domesticServerPort/";
  static const String foreignServerHttp =
      "$foreignServerBase" + "accsystem/api/json/";
  static const String domesticServerHttp =
      "$domesticServerBase" + "accsystem/api/json/";

  static const double designWidth = 1242;
  static const double designHeight = 2688;

  static const String mQTTUrl = "mqttUrl";
  static const String mQTTPort = "mqttPort";
  static const String mQTTPortS = "mqttPorts";
  static const String userName = "userName";
  static const String password = "password";
  static const String md5Password = "passwordmd5";
  static const String clientID = "clientID";

  static const double cHeight = 90.0; //最常用高度，登录输入框，card控件的高度
  static const double listHeight = 110.0; //设备列表中的list高度
  static const double cRadius = 16.0; //圆角弧度
  static const double systemHeight = 70.0; //控件界面模式的高度
  static const Color toastBg = Color(0xFF616161);

  static const double scheduleWeekFontsizeSelect = 20;
  static const double scheduleWeekFontsizeNoSelect = 15;

  static const int passwordLessLength = 6;
  static const String userNameRegexString =
      "^[a-zA-Z0-9][\\sa-zA-Z0-9_@]{2,13}[a-zA-Z0-9_@]\$";
  static const String passwordRegexString =
      "^[a-zA-Z0-9`~!@#\\\$\\%\\^&\\*\\(\\)_\\+\\-\\=\\{\\}\\|\\[\\]:\';'\\<\\>\\?,.]{6,16}\$";

  static  String mqttServerIp = "192.168.1.90";//配置向导ip
  static  int mqttServerPort = 1883; //配置向导非加密端口
  static  int mqttServerSSLPort = 8883; //配置向导加密端口
}
