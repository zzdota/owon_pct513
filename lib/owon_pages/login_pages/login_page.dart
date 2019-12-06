import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../owon_pages/home_page.dart';
import '../../owon_utils/owon_text_icon_button.dart';
import '../../owon_utils/owon_toast.dart';
import '../../res/owon_constant.dart';
import '../../generated/i18n.dart';
import '../../res/owon_themeColor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
//  @override
//  initState() {
//    SystemChrome.setEnabledSystemUIOverlays([]);
//    super.initState();
//  }
//
//  @override
//  void dispose() {
//    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
//    super.dispose();
//  }
  final TextEditingController _useController = new TextEditingController();
  final TextEditingController _pwdController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

    _useController.addListener(() {
      OwonToast.show('您输入的内容为：${_useController.text}');
    });

    _pwdController.addListener(() {
      OwonToast.show('您输入的内容为：${_pwdController.text}');
    });

    return Scaffold(
      backgroundColor: OwonColor().getCurrent(context, "primaryColor"),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Image.asset(
                        "assets/images/login/login_bg_smail_icon.png",
                        width: ScreenUtil.getInstance().setWidth(123.0),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(
                        left: 20.0,
                      ),
                      child: SizedBox(
                        width: 2.0,
                        height: 80.0,
                        child: VerticalDivider(
                          color: OwonColor().getCurrent(context, "textColor"),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(left: 20.0),
                      child: SizedBox(
                        height: 80.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              S.of(context).login_hi,
                              style: TextStyle(
                                fontSize: 32.0,
                                color: OwonColor()
                                    .getCurrent(context, "textColor"),
                              ),
                            ),
                            Text(
                              S.of(context).login_welcome,
                              style: TextStyle(
                                fontSize: 32.0,
                                color: OwonColor()
                                    .getCurrent(context, "textColor"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            right: -50.0,
                            top: -50.0,
                            child: Image.asset(
                              "assets/images/login/login_bg_right_top.png",
                              width: ScreenUtil.getInstance().setWidth(450.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.only(top: 50.0),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: -60.0,
                      top: 40,
                      child: Image.asset(
                          "assets/images/login/login_bg_center_left_bottom.png",
                          width: ScreenUtil.getInstance().setWidth(450.0)),
                    ),
                    Positioned(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20, top: 0, right: 20, bottom: 0),
                              child: TextField(
                                  controller: _useController, //绑定controller
                                  maxLines: 1, //最多一行
                                  autofocus: true, //自动获取焦点
                                  textAlign: TextAlign.left, //从左到右对齐
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0), //输入内容颜色和字体大小
//                                  cursorColor: Colors.deepPurple,//光标颜色
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    //添加装饰效果
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 25.0),
                                    filled: true, //背景是否填充
                                    fillColor: OwonColor().getCurrent(context,
                                        "itemColor"), //添加黄色填充色（filled: true必须设置，否则单独设置填充色不会生效）
                                    prefixIcon: Icon(
                                      Icons.account_circle,
                                      color: OwonColor()
                                          .getCurrent(context, "orange"),
                                    ), //左侧图标
                                    hintText: S
                                        .of(context)
                                        .login_hint_user, //hint提示文案
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: OwonColor().getCurrent(context,
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
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20, top: 30, right: 20, bottom: 0),
                              child: TextField(
                                  controller: _pwdController, //绑定controller
                                  maxLines: 1, //最多一行
                                  autofocus: true, //自动获取焦点
                                  textAlign: TextAlign.left, //从左到右对齐
                                  style: TextStyle(
                                      color: Colors.white,
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
                                    hintText:
                                        S.of(context).login_hint_psw, //hint提示文案
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: OwonColor().getCurrent(context,
                                            "textColor")), //hint提示文案字体颜色
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20, top: 30, right: 20, bottom: 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  FlatButton.icon(
                                    onPressed: () {},
                                    icon: SvgPicture.asset(
                                      "assets/images/login/login_register_icon.svg",
                                      color: OwonColor()
                                          .getCurrent(context, "blue"),
                                      width: 28.0,
                                    ),
                                    label: Text(S.of(context).login_register),
                                    textColor:
                                        OwonColor().getCurrent(context, "blue"),
                                  ),
                                  FlatButton.icon(
                                    onPressed: () {

                                    },
                                    icon: SvgPicture.asset(
                                      "assets/images/login/login_forgot_psw_icon.svg",
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
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: double.infinity,
                              height: 60.0,
                              padding: EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 0.0),
                              child: OwonTextIconButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                          return HomePage();
                                        }));
                                  },
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
                    left: -50.0,
                    bottom: -50.0,
                    child: Image.asset(
                        "assets/images/login/login_bg_center_left_bottom.png",
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
