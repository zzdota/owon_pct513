import 'dart:convert';
import 'dart:ui' as ui;
import 'package:common_utils/common_utils.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../owon_utils/owon_loading.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../owon_api/model/login_model_entity.dart';
import '../../owon_providers/owon_evenBus/list_evenbus.dart';
import '../../owon_utils/owon_clientid.dart';
import '../../owon_utils/owon_mqtt.dart';
import '../../owon_utils/owon_toast.dart';
import '../../owon_api/owon_api_http.dart';
import '../../owon_utils/owon_http.dart';
import '../../owon_utils/owon_log.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../owon_utils/owon_bottomsheet.dart';
import '../../res/owon_country_code.dart';
import '../../component/owon_header.dart';
import '../../component/owon_verification.dart';
import '../../owon_pages/login_pages/register_page.dart';
import '../../res/owon_picture.dart';
import '../../owon_pages/home_page.dart';
import '../../owon_utils/owon_text_icon_button.dart';
import '../../res/owon_constant.dart';
import '../../generated/i18n.dart';
import '../../res/owon_themeColor.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'forgot_page.dart';
import 'package:typed_data/typed_buffers.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _useController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  FocusNode _useFocusNode = FocusNode();
  FocusNode _pswFocusNode = FocusNode();

  String _countryCode, _userNameCountryCode;
  String _userName = "", _password = "";
  bool _userNameIsEmpty = true, _passwordIsEmpty = true;
  bool _countryCodeIsVisibity = false;

  Future applyPermission() async {
    bool isSHow = await PermissionHandler()
        .shouldShowRequestPermissionRationale(PermissionGroup.location);
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);

    if (permission != PermissionStatus.granted) {
      if (!isSHow) {
        await PermissionHandler().openAppSettings();
      } else {
        final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.location]);

        PermissionStatus pp = await PermissionHandler()
            .checkPermissionStatus(PermissionGroup.location);
        if (pp == PermissionStatus.granted) {
          OwonToast.show("权限申请通过");
        } else {
          OwonToast.show("请允许camera权限，并重试！");
        }
      }
    } else {
//      getPhoneCountryCode();
    }
//    PermissionStatus permission = await PermissionHandler()
//        .checkPermissionStatus(PermissionGroup.location);
//    if (permission != PermissionStatus.granted) {
//      OwonDialog(cancelPressed: () {
//        print('cancel cancle');
//        OwonToast.show('使肌肤卡拉斯京flasjdfoasjdfio大龄剩女发生内');
//      }).showOK("没有定位权限");
//    } else {
//      getPhoneCountryCode();
//    }
  }

  String getPhoneCountryCode() {
    String code = ui.window.locale.countryCode.toString();
    setState(() {
      for (int i = 0; i < countryCode.length; i++) {
        if (code == countryCode[i]["locale"]) {
          _countryCode = "+${countryCode[i]["code"]}";
          break;
        }
      }
      if (_countryCode == null || _countryCode.isEmpty) {
        _countryCode = "+86";
      }
    });
    return code;
  }

  getExistUserInfo() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    _userName = pre.get(OwonConstant.userName);
    _password = pre.get(OwonConstant.password);
    if (!TextUtil.isEmpty(_userName) && !RegexUtil.isEmail(_userName)) {
      int index = _userName.indexOf("-");
      if (index > 0) {
        _countryCode = "+${_userName.substring(0, index)}";
        _userNameCountryCode = "${_userName.substring(0, index)}-";
        _userName = _userName.substring(index + 1, _userName.length);
      }
    }
    _useController.text = _userName;
    _pwdController.text = _password;
  }

  setSuffixIconStatus() {
    _useFocusNode.addListener(() {
      setState(() {
        if (TextUtil.isEmpty(_useController.text)) {
          if (_useFocusNode.hasFocus) {
            _userNameIsEmpty = true;
          } else {
            _userNameIsEmpty = true;
          }
        } else {
          if (_useFocusNode.hasFocus) {
            _userNameIsEmpty = false;
          } else {
            _userNameIsEmpty = true;
          }
        }
      });
    });
    _pswFocusNode.addListener(() {
      setState(() {
        if (TextUtil.isEmpty(_pwdController.text)) {
          if (_pswFocusNode.hasFocus) {
            _passwordIsEmpty = true;
          } else {
            _passwordIsEmpty = true;
          }
        } else {
          if (_pswFocusNode.hasFocus) {
            _passwordIsEmpty = false;
          } else {
            _passwordIsEmpty = true;
          }
        }
      });
    });
  }

  _setPhoneCountryCode() {
    OwonBottomSheet.show(context, countryCode,
            maxCount: 10, itemHeight: 50.0, key1: "zh")
        .then((val) {
      setState(() {
        _countryCode = "+" + countryCode[val]["code"].toString();
        _userNameCountryCode = countryCode[val]["code"].toString() + "-";
      });
    });
  }

  _login() async {
    _userName = _useController.text;
    if (TextUtil.isEmpty(_userName)) {
      OwonToast.show(S.of(context).login_username_null);
      return;
    }
    if (TextUtil.isEmpty(_password) ||
        _password.length < OwonConstant.passwordLessLength) {
      OwonToast.show(S.of(context).login_password_less_six_digits);
      return;
    }
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      OwonToast.show(S.of(context).login_no_network);
      return;
    }
    if (!RegexUtil.isEmail(_userName)) {
      if (_userNameCountryCode == null || _userNameCountryCode.isEmpty) {
        String code = _countryCode.substring(1, _countryCode.length);
        _userNameCountryCode = "$code-";
      }
      _userName = _userNameCountryCode + _userName;
    }
    OwonLoading(context).show();
    OwonHttp.getInstance().post(OwonConstant.foreignServerHttp,
        OwonApiHttp().login(_userName, _password), (value) async {
      LoginModelEntity loginModelEntity = LoginModelEntity.fromJson(value);
      switch (int.parse(loginModelEntity.code)) {
        case 100:
          SharedPreferences pre = await SharedPreferences.getInstance();
          pre.setString(
              OwonConstant.mQTTUrl, loginModelEntity.response.mqttserver);
          pre.setInt(OwonConstant.mQTTPort, loginModelEntity.response.mqttport);
          pre.setInt(
              OwonConstant.mQTTPortS, loginModelEntity.response.mqttsslport);
          pre.setString(OwonConstant.userName, _userName);
          pre.setString(OwonConstant.password, _password);
          pre.setString(
              OwonConstant.md5Password, EnDecodeUtil.encodeMd5(_password));
          initMqtt(pre);
          break;
        case 110:
          OwonToast.show(S.of(context).login_fail);
          break;
        case 301:
          OwonToast.show(S.of(context).login_no_account);
          break;
        case 302:
          OwonToast.show(
              "${S.of(context).login_retry_limit}${loginModelEntity.response.retryRemainTime} ${S.of(context).login_retry_time}");
          break;
        case 303:
          OwonToast.show(
              "${S.of(context).login_wrong_psw}, ${loginModelEntity.response.retryPswRemainCout} ${S.of(context).login_retry_time_alert}");
          break;
        case 304:
          OwonToast.show(S.of(context).login_lock_account);
          break;
      }
    }, (value) {
      OwonLog.e("error-------$value");
      OwonLoading(context).dismiss();
    });
  }

  initMqtt(SharedPreferences pre) async {
    var userName = pre.get(OwonConstant.userName);
    var password = pre.get(OwonConstant.md5Password);
    var server = pre.get(OwonConstant.mQTTUrl);
    var port = pre.getInt(OwonConstant.mQTTPortS);
    var clientId = OwonClientId.createClientID(userName);

    OwonLog.e(
        "---port=$port  username=$userName pass=$password server=$server client=$clientId");

    OwonMqtt.getInstance()
        .connect(server, port, clientId, userName, password)
        .then((v) {
      OwonLog.e("res=$v");
      if (v.returnCode == MqttConnectReturnCode.connectionAccepted) {
        OwonLoading(context).hide().then((item){
//          OwonLoading(context).dismiss();
          OwonLog.e("恭喜你~ ====mqtt连接成功");
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return HomePage();
          }));
          pre.setString(OwonConstant.clientID, clientId);
          startListen();
          toSubscribe(clientId,userName);
        });

      } else {
        OwonLog.e("有事做了~ ====mqtt连接失败!!!");
        OwonToast.show(S.of(context).login_fail);
      }
    });
  }

  toSubscribe(String clientID,String userName) {
    String topic = "reply/cloud/$clientID";
    OwonMqtt.getInstance().subscribeMessage(topic);

    String replyTopic = "reply/device/+/$clientID/#";
    OwonMqtt.getInstance().subscribeMessage(replyTopic);

    String accountTopic = "account/$userName/attribute/#";
    OwonMqtt.getInstance().subscribeMessage(accountTopic);

  }

  startListen() {
    OwonMqtt.getInstance().updates().listen(_onData);
  }

  _onData(List<MqttReceivedMessage<MqttMessage>> data) {
    final MqttPublishMessage recMess = data[0].payload;
    final String topic = data[0].topic;
    if (topic.contains("reply/cloud")) {
      final String pt =
      MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      String desString = "topic is <$topic>, payload is <-- $pt -->";
      OwonLog.e("json =$desString");
      Map p = Map();
      p["topic"] = topic;
      p["type"] = "json";
      p["payload"] = jsonDecode(pt);
      ListEventBus.getDefault().post(p);
    } else if (topic.contains("raw")) {
      List bu = recMess.payload.message.toList();
      String desString = "topic is <$topic>, payload is <-- $bu -->";
//      OwonLog.e("raw =$desString");
      Map p = Map();
      p["topic"] = topic;
      p["type"] = "raw";
      p["payload"] = bu;
      ListEventBus.getDefault().post(p);
    } else if (topic.contains("attribute")) {
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      String desString = "topic is <$topic>, payload is <-- $pt -->";
      OwonLog.e("string =$desString");
      Map p = Map();
      p["topic"] = topic;
      p["type"] = "string";
      p["payload"] = pt;
      ListEventBus.getDefault().post(p);
    } else {
      OwonLog.e("未知类型");
    }
  }

  _privacy() {}

  @override
  initState() {
    getExistUserInfo();
    setSuffixIconStatus();
//    applyPermission();
//    getPhoneCountryCode();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    applyPermission();
//    getPhoneCountryCode();
    ScreenUtil.instance = ScreenUtil(
        width: OwonConstant.designWidth, height: OwonConstant.designHeight)
      ..init(context);
    _useController.addListener(() {
      _userName = _useController.text;
      setState(() {
        if (!TextUtil.isEmpty(_useController.text)) {
          try {
            if (int.parse(_userName) is num && _userName.length < 12) {
              _countryCodeIsVisibity = true;
              if (_userName.length == 1) {
                getPhoneCountryCode();
              }
            } else {
              _countryCodeIsVisibity = false;
            }
          } catch (e) {
            _countryCodeIsVisibity = false;
          }
        } else {
          _countryCodeIsVisibity = false;
        }
      });
    });

    _pwdController.addListener(() {
      _password = _pwdController.text;
    });

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: OwonColor().getCurrent(context, "primaryColor"),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomLeft,
                    margin: EdgeInsets.only(left: 20.0),
                    child: SizedBox(
                      height: 80,
                      child: OwonHeader.header(
                          context, OwonPic.loginBgSmile, S.of(context).login_hi,
                          width: 140, subTitle: S.of(context).login_welcome),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          right: -40.0,
                          top: -10.0,
                          child: Image.asset(
                            OwonPic.loginBgRightTop,
                            width: ScreenUtil.getInstance().setWidth(450.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.only(top: 30.0),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: -60.0,
                      top: 40,
                      child: Image.asset(OwonPic.loginBgCenterLeftBottom,
                          width: ScreenUtil.getInstance().setWidth(450.0)),
                    ),
                    Positioned(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20, top: 0, right: 20, bottom: 0),
                              child: Stack(
                                children: <Widget>[
                                  TextField(
                                      controller: _useController,
                                      focusNode: _useFocusNode,
                                      maxLines: 1,
                                      maxLength: 20,
                                      autofocus: false,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: OwonColor()
                                              .getCurrent(context, "textColor"),
                                          fontSize: 20.0),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        counterText: "",
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 20.0),
                                        filled: true,
                                        fillColor: OwonColor()
                                            .getCurrent(context, "itemColor"),
                                        prefixIcon: Icon(
                                          Icons.account_circle,
                                          color: OwonColor()
                                              .getCurrent(context, "orange"),
                                        ),
                                        suffixIcon: Offstage(
                                          offstage: _userNameIsEmpty,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color: OwonColor().getCurrent(
                                                  context, "textColor"),
                                            ),
                                            onPressed: () {
                                              _useController.clear();
                                            },
                                          ),
                                        ),
                                        hintText:
                                            S.of(context).global_hint_user,
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: OwonColor().getCurrent(
                                                context, "textColor")),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: OwonColor().getCurrent(
                                                  context, "borderNormal")),
                                          borderRadius: BorderRadius.circular(
                                              OwonConstant.cRadius),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: OwonColor().getCurrent(
                                                  context, "borderNormal")),
                                          borderRadius: BorderRadius.circular(
                                              OwonConstant.cRadius),
                                        ),
                                      )),
                                  Positioned(
                                    right: 40.0,
                                    top: 10.0,
                                    child: _countryCodeIsVisibity
                                        ? OwonVerify.button(
                                            context, _countryCode,
                                            onPressed: _setPhoneCountryCode,
                                            width: 80.0,
                                            height: 45.0)
                                        : Container(
                                            width: 0.0,
                                            height: 0.0,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20, top: 20, right: 20, bottom: 0),
                              child: TextField(
                                controller: _pwdController,
                                focusNode: _pswFocusNode,
                                maxLines: 1,
                                maxLength: 20,
                                autofocus: false,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: OwonColor()
                                        .getCurrent(context, "textColor"),
                                    fontSize: 20.0),
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                  counterText: "",
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  filled: true,
                                  fillColor: OwonColor()
                                      .getCurrent(context, "itemColor"),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: OwonColor()
                                        .getCurrent(context, "orange"),
                                  ),
                                  suffixIcon: Offstage(
                                    offstage: _passwordIsEmpty,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: OwonColor()
                                            .getCurrent(context, "textColor"),
                                      ),
                                      onPressed: () {
                                        _pwdController.clear();
                                      },
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: OwonColor().getCurrent(
                                            context, "borderNormal")),
                                    borderRadius: BorderRadius.circular(
                                        OwonConstant.cRadius),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: OwonColor().getCurrent(
                                            context, "borderNormal")),
                                    borderRadius: BorderRadius.circular(
                                        OwonConstant.cRadius),
                                  ),
                                  hintText: S.of(context).global_hint_password,
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: OwonColor()
                                          .getCurrent(context, "textColor")),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, top: 10, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  FlatButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return RegisterPage();
                                      }));
                                    },
                                    icon: SvgPicture.asset(
                                      OwonPic.loginRegister,
                                      color: OwonColor()
                                          .getCurrent(context, "blue"),
                                      width: 28.0,
                                    ),
                                    label: Text(S.of(context).global_register),
                                    textColor:
                                        OwonColor().getCurrent(context, "blue"),
                                  ),
                                  FlatButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return ForgotPage();
                                      }));
                                    },
                                    icon: SvgPicture.asset(
                                      OwonPic.loginForgotPsw,
                                      color: OwonColor()
                                          .getCurrent(context, "blue"),
                                      height: 22.0,
                                    ),
                                    label: Text(S.of(context).login_forgot),
                                    textColor:
                                        OwonColor().getCurrent(context, "blue"),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: OwonConstant.systemHeight,
                              margin: EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 10),
                              child: OwonTextIconButton.icon(
                                  onPressed: _login,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          OwonConstant.cRadius)),
                                  icon: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    S.of(context).login_button,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  iconTextAlignment:
                                      TextIconAlignment.iconRightTextLeft),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 20.0, left: 20.0, right: 20.0),
                              child: Text.rich(TextSpan(children: [
                                TextSpan(
                                    text: S.of(context).login_privacy1,
                                    style: TextStyle(
                                      color: OwonColor()
                                          .getCurrent(context, "textColor"),
                                    )),
                                TextSpan(
                                    text: S.of(context).login_privacy2,
                                    style: TextStyle(
                                      color: OwonColor()
                                          .getCurrent(context, "blue"),
                                    ),
                                    recognizer: _privacy()),
                              ])),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: -10.0,
                    bottom: -50.0,
                    child: Image.asset(OwonPic.loginBgCenterLeftBottom,
                        width: ScreenUtil.getInstance().setWidth(450.0)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
