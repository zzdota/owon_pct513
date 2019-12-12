import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../owon_api/model/owon_login_model_entity.dart';
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

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _useController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  String _countryCode = "+86", _userNameCountryCode = "86-";
  String _userName = "", _password = "";
  bool _userNameIsEmpty = false, _passwordIsEmpty = false;
  bool _countryCodeIsVisibity = true;

  @override
  initState() {
    super.initState();
    getPhoneCountryCode();
    getExistUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getPhoneCountryCode() {
    setState(() {});
  }

  getExistUserInfo() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    _userName = pre.get(OwonConstant.userName);
    _password = pre.get(OwonConstant.password);
    if (!TextUtil.isEmpty(_userName) && !RegexUtil.isEmail(_userName)) {
      int index = _userName.indexOf("-");
      if (index > 0) {
        _userName = _userName.substring(index + 1, _userName.length);
      }
    }
    _useController.text = _userName;
    _pwdController.text = _password;
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

  _login() {
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
    if (!RegexUtil.isEmail(_userName)) {
      _userName = _userNameCountryCode + _userName;
    }
    OwonHttp.getInstance().post(OwonConstant.foreignServerHttp,
        OwonApiHttp().login(_userName, _password), (value) async {
      LoginModelEntity loginModelEntity = LoginModelEntity.fromJson(value);
      switch (int.parse(loginModelEntity.code)) {
        case 100:
          initMqtt();

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
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return HomePage();
          }));
          break;
        case 110:
          break;
      }
    }, (value) {
      OwonLog.e("error-------$value");
    });
//  OwonHttp.getInstance().get("http://www.baidu.com", (v){}, (v){});
  }

  initMqtt() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    var userName = pre.get(OwonConstant.userName);
    var password = pre.get(OwonConstant.md5Password);
    var server = pre.get(OwonConstant.mQTTUrl);
    var port = pre.getInt(OwonConstant.mQTTPortS);
    var clientId =OwonClientId.createClientID(userName);

    OwonLog.e("---port=$port  username=$userName pass=$password server=$server client=$clientId");

   OwonMqtt.getInstance().connect(server, port, clientId, userName, password).then((v){
     OwonLog.e("res=$v");
     if(v.returnCode == MqttConnectReturnCode.connectionAccepted){
       OwonLog.e("恭喜你~ ====mqtt连接成功");
     }

   });
  }

  _privacy() {}

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

    _useController.addListener(() {
      _userName = _useController.text;
      setState(() {
        if (!TextUtil.isEmpty(_useController.text)) {
          _userNameIsEmpty = false;
          try {
            if (int.parse(_userName) is num && _userName.length < 12) {
              _countryCodeIsVisibity = true;
            } else {
              _countryCodeIsVisibity = false;
            }
          } catch (e){
            _countryCodeIsVisibity = false;
          }
        } else {
          _userNameIsEmpty = true;
          _countryCodeIsVisibity = false;
        }
      });
    });

    _pwdController.addListener(() {
      _password = _pwdController.text;
      setState(() {
        if (!TextUtil.isEmpty(_pwdController.text)) {
          _passwordIsEmpty = false;
        } else {
          _passwordIsEmpty = true;
        }
      });
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
                                                vertical: 25.0),
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
                                    top: 15.0,
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
                                      vertical: 25.0),
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
                              padding: EdgeInsets.only(
                                  left: 20, top: 20, right: 20, bottom: 0),
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
                              height: 60.0,
                              margin: EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 20.0),
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
