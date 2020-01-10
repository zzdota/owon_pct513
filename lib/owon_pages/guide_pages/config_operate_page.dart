import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import '../../generated/i18n.dart';
import 'package:app_settings/app_settings.dart';

class ConfigOperatePage extends StatefulWidget {
  @override
  _ConfigOperatePageState createState() {
    return _ConfigOperatePageState();
  }
}

class _ConfigOperatePageState extends State<ConfigOperatePage> {
  String _ssid = 'WiFi-SSID';
  String _bssid = "";
  String imagestatename = OwonPic.mConfigTipnumberBG;
  String wifistatedes = "";
  bool isbtnenable = true;
  TextEditingController ssidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(S.of(context).configoperatepage_title),
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
                  flex: 1,
                ),
                Expanded(
                  flex: 3,
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
                                  image: AssetImage(imagestatename),
                                ),
                              ),
                              Text(
                                "2",
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
                              wifistatedes,
                              style: TextStyle(color: Colors.white),
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
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: TextField(
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.white),
                                controller: ssidController,
                                decoration: InputDecoration(
                                  hintText: 'WiFi-SSID',
                                  hintStyle: TextStyle(color: Colors.white),
                                  icon: Icon(Icons.signal_wifi_4_bar,
                                      color: Colors.orange),
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2)),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: FlatButton(
                                child: Text(
                                  S.of(context).configoperatepage_setting,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12.0),
                                ),
                                textColor: Colors.white,
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                onPressed: () => AppSettings.openWIFISettings(),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 10,
                        ),
                        TextField(
                          style: TextStyle(fontSize: 15.0, color: Colors.white),
                          controller: passwordController,
                          decoration: InputDecoration(
                              hintText: S.of(context).global_hint_password,
                              hintStyle: TextStyle(color: Colors.white),
                              icon: Icon(Icons.lock, color: Colors.orange)),
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                      width: double.infinity,
                      child: FlatButton(
                        child: Text(S.of(context).general_next),
                        textColor: Colors.white,
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        onPressed: isbtnenable
                            ? () => Navigator.pushNamed(
                                    context, "configwaitingpage",
                                    arguments: {
                                      "ssid": ssidController.text,
                                      "bssid": _bssid,
                                      "password": passwordController.text
                                    })
                            : null,
                        disabledColor: Color.fromRGBO(89, 87, 87, 1),
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

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        String wifiName, wifiBSSID, wifiIP;

        try {
          if (Platform.isIOS) {
            LocationAuthorizationStatus status =
                await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status =
                  await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              wifiName = await _connectivity.getWifiName();
            } else {
              wifiName = await _connectivity.getWifiName();
            }
          } else {
            wifiName = await _connectivity.getWifiName();
          }
        } on PlatformException catch (e) {
          print(e.toString());
          wifiName = "Failed to get Wifi Name";
        }

        try {
          if (Platform.isIOS) {
            LocationAuthorizationStatus status =
                await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status =
                  await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              wifiBSSID = await _connectivity.getWifiBSSID();
            } else {
              wifiBSSID = await _connectivity.getWifiBSSID();
            }
          } else {
            wifiBSSID = await _connectivity.getWifiBSSID();
          }
        } on PlatformException catch (e) {
          print(e.toString());
          wifiBSSID = "Failed to get Wifi BSSID";
        }
        _bssid = wifiBSSID;
        try {
          wifiIP = await _connectivity.getWifiIP();
        } on PlatformException catch (e) {
          print(e.toString());
          wifiIP = "Failed to get Wifi IP";
        }

        setState(() {
          _ssid = '$wifiName';
          if (_ssid.contains("5G")) {
            imagestatename = OwonPic.mConfigTips5G;
            wifistatedes =
                wifistatedes = S.of(context).configoperatepage_tips_5g;
            isbtnenable = false;
          } else {
            imagestatename = OwonPic.mConfigTipnumberBG;
            wifistatedes = S.of(context).configoperatepage_tips;
            isbtnenable = true;
          }
          ssidController.text = _ssid;
        });
        break;
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        //setState(() => _connectionStatus = result.toString());
        setState(() {
          _ssid = "Wi-Fi SSID";
          imagestatename = OwonPic.mConfigTipsNonetwork;
          wifistatedes = S.of(context).configoperatepage_tips_nonetwork;
          isbtnenable = false;
          ssidController.text = _ssid;
        });
        break;
      default:
        //setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }
}
