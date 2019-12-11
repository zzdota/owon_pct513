import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:owon_pct513/owon_api/model/owon_login_model_entity.dart';
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

import 'forgot_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _useController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  String _countryCode = "+86";
  String _userName = "", _password = "";

  @override
  initState() {
    super.initState();
    getPhoneCountryCode();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getPhoneCountryCode() {
    setState(() {});
  }

  _setPhoneCountryCode() {
    OwonBottomSheet.show(context, countryCode,
            maxCount: 10, itemHeight: 50.0, key1: "zh")
        .then((val) {
      setState(() {
        _countryCode = "+" + countryCode[val]["code"].toString();
      });
    });
  }

  _login() {
    OwonHttp.getInstance().post(OwonConstant.foreignServerHttp,
        OwonApiHttp().login(_userName, _password), (value) async {
          LoginModelEntity loginModelEntity = LoginModelEntity.fromJson(value);
          switch(int.parse(loginModelEntity.code)){
            case 100:
              String url = "https://${loginModelEntity.response.mqttserver}:${loginModelEntity.response.mqttsslport}/";
              OwonLog.e("url---------------------$url");
              SharedPreferences pre = await SharedPreferences.getInstance();
              pre.setString(OwonConstant.mQTTUrl, url);
              pre.setString(OwonConstant.userName, _userName);
              pre.setString(OwonConstant.password, _password);
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

  _privacy() {}

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

    _useController.addListener(() {
      _userName = _useController.text;
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
                                      controller: _useController, //绑定controller
                                      maxLines: 1, //最多一行
                                      autofocus: false, //自动获取焦点
                                      textAlign: TextAlign.left, //从左到右对齐
                                      style: TextStyle(
                                          color: OwonColor()
                                              .getCurrent(context, "textColor"),
                                          fontSize: 20.0), //输入内容颜色和字体大小
//                                  cursorColor: Colors.deepPurple,//光标颜色
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        //添加装饰效果
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 25.0),
                                        filled: true, //背景是否填充
                                        fillColor: OwonColor().getCurrent(
                                            context,
                                            "itemColor"), //添加黄色填充色（filled: true必须设置，否则单独设置填充色不会生效）
                                        prefixIcon: Icon(
                                          Icons.account_circle,
                                          color: OwonColor()
                                              .getCurrent(context, "orange"),
                                        ), //左侧图标
//                                        prefixIcon: SvgPicture.asset(
//                                            OwonPic.loginUsernameIcon,
//                                            width: 10,
//                                            fit: BoxFit.fitWidth,
//                                            color: OwonColor()
//                                                .getCurrent(context, "orange")),
                                        hintText: S
                                            .of(context)
                                            .global_hint_user, //hint提示文案
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: OwonColor().getCurrent(
                                                context,
                                                "textColor")), //hint提示文案字体颜色
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
                                    right: 10.0,
                                    top: 15.0,
                                    child: OwonVerify.button(
                                        context, _countryCode,
                                        onPressed: _setPhoneCountryCode,
                                        width: 80.0,
                                        height: 45.0),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20, top: 20, right: 20, bottom: 0),
                              child: TextField(
                                  controller: _pwdController, //绑定controller
                                  maxLines: 1, //最多一行
                                  autofocus: false, //自动获取焦点
                                  textAlign: TextAlign.left, //从左到右对齐
                                  style: TextStyle(
                                      color: OwonColor()
                                          .getCurrent(context, "textColor"),
                                      fontSize: 20.0), //输入内容颜色和字体大小
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                    //添加装饰效果
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 25.0),
                                    filled: true, //背景是否填充
                                    fillColor: OwonColor().getCurrent(context,
                                        "itemColor"), //添加黄色填充色（filled: true必须设置，否则单独设置填充色不会生效）
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: OwonColor()
                                          .getCurrent(context, "orange"),
                                    ), //左侧图标
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
                                    hintText: S
                                        .of(context)
                                        .global_hint_password, //hint提示文案
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: OwonColor().getCurrent(context,
                                            "textColor")), //hint提示文案字体颜色
                                  )),
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
