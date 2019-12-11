import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:owon_pct513/owon_utils/owon_http.dart';
import '../../component/owon_textfield.dart';
import '../../component/owon_verification.dart';
import '../../owon_utils/owon_bottomsheet.dart';
import '../../owon_utils/owon_text_icon_button.dart';
import '../../res/owon_constant.dart';
import '../../res/owon_country_code.dart';
import '../../component/owon_header.dart';
import '../../res/owon_picture.dart';
import '../../res/owon_themeColor.dart';
import '../../generated/i18n.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _useController = TextEditingController();
  final TextEditingController _verifyController = TextEditingController();
  final TextEditingController _newPwdController = TextEditingController();
  final TextEditingController _confirmPwdController = TextEditingController();
  String _userName = "",
      _verifyCode = "",
      _newPassword = "",
      _confirmPassword = "";
  String _countryCode = "+86";
  bool _isShowCodeBtn = true;

  Timer _timer;
  int _countdownTime;

  _getVerifyCode() {
    if(_countdownTime == 0 && validateMobileOrEmail()){
//      OwonHttp.getInstance().post(url, params, successCallBack, errorCallBack)
      startCountdownTimer();
    }
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

  _register() {}

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    _useController.addListener(() {
      _userName = _useController.text;
    });

    _verifyController.addListener(() {
      _verifyCode = _verifyController.text;
    });

    _newPwdController.addListener(() {
      _newPassword = _newPwdController.text;
    });

    _confirmPwdController.addListener(() {
      _confirmPassword = _confirmPwdController.text;
    });
    return Scaffold(
      backgroundColor: OwonColor().getCurrent(context, "primaryColor"),
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.of(context).global_register),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                OwonHeader.header(context, OwonPic.loginRegisterHeader,
                    S.of(context).global_register,
                    width: 180),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                  child: Stack(
                    children: <Widget>[
                      OwonTextField.textField(
                          context,
                          _useController,
                          S.of(context).global_hint_user,
                          OwonPic.loginUsernameIcon),
                      _isShowCodeBtn == true
                          ? Positioned(
                              right: 0,
                              child: OwonVerify.button(context, _countryCode,
                                  onPressed: _setPhoneCountryCode,
                                  width: 80.0,
                                  height: 45.0),
                            )
                          : Container(height: 0.0, width: 0.0),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      OwonTextField.textField(
                          context,
                          _verifyController,
                          S.of(context).global_hint_verify_code,
                          OwonPic.loginVerifyCodeIcon,
                          width: 220),
                      OwonVerify.button(
                          context,
                          _countdownTime > 0
                              ? S.of(context).global_verify_code_remaining1 +
                                  '$_countdownTime' +
                                  S.of(context).global_verify_code_remaining2
                              : S.of(context).global_get_verify_code,
                          onPressed: _getVerifyCode),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30),
                  child: OwonTextField.textField(
                      context,
                      _newPwdController,
                      S.of(context).global_hint_new_password,
                      OwonPic.loginNewPswIcon),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30),
                  child: OwonTextField.textField(
                      context,
                      _confirmPwdController,
                      S.of(context).global_hint_confirm_password,
                      OwonPic.loginConfirmPswIcon),
                ),
                Container(
                  width: double.infinity,
                  height: 60.0,
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
                  child: OwonTextIconButton.icon(
                      onPressed: _register,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(OwonConstant.cRadius)),
                      icon: SvgPicture.asset(
                        OwonPic.loginRegisterIcon,
                        color: Colors.white,
                        width: 20,
                      ),
                      label: Text(
                        S.of(context).global_register,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      iconTextAlignment: TextIconAlignment.iconRightTextLeft),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void startCountdownTimer() {
    _countdownTime = 60;
    const oneSec = const Duration(seconds: 1);

    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }

    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_countdownTime < 1) {
          _timer.cancel();
          _timer = null;
        } else {
          _countdownTime = _countdownTime - 1;
        }
      });
    });
  }

  bool validateMobileOrEmail(){
    if(RegexUtil.isMobileExact(_userName) || RegexUtil.isEmail(_userName)){
      return true;
    }
    return false;
  }
}
