import 'dart:ui' as ui;
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../owon_api/model/get_verify_code_model_entity.dart';
import '../../owon_api/model/reset_psw_model_entity.dart';
import '../../owon_api/owon_api_http.dart';
import '../../owon_utils/owon_http.dart';
import '../../owon_utils/owon_loading.dart';
import '../../owon_utils/owon_log.dart';
import '../../owon_utils/owon_toast.dart';
import '../../component/owon_header.dart';
import '../../component/owon_textfield.dart';
import '../../component/owon_verification.dart';
import '../../owon_utils/owon_bottomsheet.dart';
import '../../owon_utils/owon_text_icon_button.dart';
import '../../res/owon_constant.dart';
import '../../res/owon_country_code.dart';
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
  FocusNode _useFocusNode = FocusNode();
  FocusNode _verFocusNode = FocusNode();
  FocusNode _nPswFocusNode = FocusNode();
  FocusNode _cPswFocusNode = FocusNode();
  String _userName = "",
      _verifyCode = "",
      _newPassword = "",
      _confirmPassword = "",
      _userNameCountryCode;
  bool _userNameIsEmpty = true,
      _verifyIsEmpty = true,
      _nPswIsEmpty = true,
      _cPswIsEmpty = true;
  String _countryCode = "+86";
  bool _countryCodeIsVisibity = false;

  TimerUtil _countDownTimerUtil;
  String _countDownBtnTxt;
  int _countdownTime = 0;

  _getVerifyCode() {
    if (TextUtil.isEmpty(_userName)) {
      OwonToast.show(S.of(context).login_username_null);
      return;
    }
    //开始倒计时
    if (_countDownTimerUtil != null) {
      return;
    }
    _userName = _useController.text;
    OwonLog.e(_userName);
    if (!RegexUtil.isEmail(_userName) ) {
      if (_userNameCountryCode == null || _userNameCountryCode.isEmpty) {
        String code = _countryCode.substring(1, _countryCode.length);
        _userNameCountryCode = "$code-";
      }
      OwonLog.e(_userNameCountryCode);
      _userName = _userNameCountryCode + _userName;
    }
    startCountdownTimer();
    OwonLoading(context).show();
    OwonHttp.getInstance().post(OwonConstant.foreignServerHttp,
        OwonApiHttp().getVerifyCode(_userName, 1), (value) async {
      OwonLog.e(value);
      GetVerifyCodeModelEntity getVerifyCodeModelEntity =
          GetVerifyCodeModelEntity.fromJson(value);
      switch (int.parse(getVerifyCodeModelEntity.code)) {
        case 100:
          if (RegexUtil.isEmail(_userName)) {
            OwonToast.show(S.of(context).global_get_verify_code_email_success);
          } else {
            OwonToast.show(S.of(context).global_get_verify_code_phone_success);
          }
          break;
        case 110:
          OwonToast.show(S.of(context).global_unknown);
          break;
        case 302:
          OwonToast.show(S.of(context).global_get_verify_code_phone_num_error);
          break;
        case 303:
          OwonToast.show(S.of(context).global_account_exist);
          break;
        case 301:
        case 304:
        case 305:
          OwonToast.show(S.of(context).global_get_verify_code_often);
          break;
        case 307:
          OwonToast.show(S.of(context).global_get_verify_code_fail);
          break;
        case 308:
          OwonToast.show(S.of(context).global_not_account);
          break;
        case 309:
          OwonToast.show(S.of(context).global_lock_account);
          break;
        case 310:
          OwonToast.show(S.of(context).global_not_agentid);
          break;
      }
      OwonLoading(context).dismiss();
      if (_countDownTimerUtil != null &&
          int.parse(getVerifyCodeModelEntity.code) != 100) {
        setState(() {
          _countDownTimerUtil.cancel();
          _countDownTimerUtil = null;
          _countDownBtnTxt = S.of(context).global_get_verify_code;
        });
      }
    }, (value) {
      OwonToast.show(S.of(context).global_get_verify_code_fail);
      OwonLoading(context).dismiss();
      if (_countDownTimerUtil != null) {
        setState(() {
          _countDownTimerUtil.cancel();
          _countDownTimerUtil = null;
          _countDownBtnTxt = S.of(context).global_get_verify_code;
        });
      }
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

  _register() async {
    _userName = _useController.text;
    if (TextUtil.isEmpty(_userName)) {
      OwonToast.show(S.of(context).login_username_null);
      return;
    }
    if (TextUtil.isEmpty(_verifyCode)) {
      OwonToast.show(S.of(context).global_enter_verify_null);
      return;
    }
    if (TextUtil.isEmpty(_newPassword) ||
        _newPassword.length < OwonConstant.passwordLessLength) {
      OwonToast.show(S.of(context).login_password_less_six_digits);
      return;
    }
    if (TextUtil.isEmpty(_confirmPassword) ||
        _confirmPassword.length < OwonConstant.passwordLessLength) {
      OwonToast.show(S.of(context).login_password_less_six_digits);
      return;
    }
    if (_confirmPassword != _newPassword) {
      OwonToast.show(S.of(context).global_enter_psw_not_match);
      return;
    }
    if (!RegExp(OwonConstant.userNameRegexString).hasMatch(_userName)) {
      OwonToast.show(S.of(context).global_user_name_regex_string);
      return;
    }
    if (!RegExp(OwonConstant.passwordRegexString).hasMatch(_newPassword) ||
        !RegExp(OwonConstant.passwordRegexString).hasMatch(_confirmPassword)) {
      OwonToast.show(S.of(context).global_password_regex_string);
      return;
    }
    OwonLoading(context).show();
    if (!RegexUtil.isEmail(_userName)) {
      if (_userNameCountryCode == null || _userNameCountryCode.isEmpty) {
        String code = _countryCode.substring(1, _countryCode.length);
        _userNameCountryCode = "$code-";
      }
      _userName = _userNameCountryCode + _userName;
    }
    String lang = ui.window.locale.languageCode;
    String timezoneId = await FlutterNativeTimezone.getLocalTimezone();
    OwonHttp.getInstance().post(
        OwonConstant.foreignServerHttp,
        OwonApiHttp().registerAccount(
            _userName, _newPassword, _verifyCode, lang, timezoneId),
        (value) async {
      ResetPswModelEntity resetPswModelEntity =
          ResetPswModelEntity.fromJson(value);
      switch (int.parse(resetPswModelEntity.code)) {
        case 100:
          OwonToast.show(S.of(context).global_register_account_success);
          Navigator.pop(context);
          break;
        case 110:
          OwonToast.show(S.of(context).global_unknown);
          break;
        case 301:
          OwonToast.show(S.of(context).global_not_account);
          break;
        case 304:
          OwonToast.show(S.of(context).global_lock_account);
          break;
        case 304:
          OwonToast.show(S.of(context).global_account_exist);
          break;
        case 306:
          OwonToast.show(S.of(context).global_verify_code_error);
          break;
        case 307:
          OwonToast.show(S.of(context).global_psw_retry_limit);
          break;
      }
      OwonLoading(context).dismiss();
    }, (value) {
      OwonToast.show(S.of(context).global_register_account_fail);
      OwonLoading(context).dismiss();
    });
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
    _verFocusNode.addListener(() {
      setState(() {
        if (TextUtil.isEmpty(_verifyController.text)) {
          if (_verFocusNode.hasFocus) {
            _verifyIsEmpty = true;
          } else {
            _verifyIsEmpty = true;
          }
        } else {
          if (_verFocusNode.hasFocus) {
            _verifyIsEmpty = false;
          } else {
            _verifyIsEmpty = true;
          }
        }
      });
    });
    _nPswFocusNode.addListener(() {
      setState(() {
        if (TextUtil.isEmpty(_newPwdController.text)) {
          if (_nPswFocusNode.hasFocus) {
            _nPswIsEmpty = true;
          } else {
            _nPswIsEmpty = true;
          }
        } else {
          if (_nPswFocusNode.hasFocus) {
            _nPswIsEmpty = false;
          } else {
            _nPswIsEmpty = true;
          }
        }
      });
    });
    _cPswFocusNode.addListener(() {
      setState(() {
        if (TextUtil.isEmpty(_confirmPwdController.text)) {
          if (_cPswFocusNode.hasFocus) {
            _cPswIsEmpty = true;
          } else {
            _cPswIsEmpty = true;
          }
        } else {
          if (_cPswFocusNode.hasFocus) {
            _cPswIsEmpty = false;
          } else {
            _cPswIsEmpty = true;
          }
        }
      });
    });
  }

  @override
  initState() {
    setSuffixIconStatus();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_countDownTimerUtil != null) {
      _countDownTimerUtil.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: OwonColor().getCurrent(context, "primaryColor"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                OwonHeader.header(
                  context,
                  OwonPic.loginRegisterHeader,
                  S.of(context).global_register,
                  width: 250,
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                  child: Row(
                    mainAxisAlignment: _countryCodeIsVisibity
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.start,
                    children: <Widget>[
                      OwonTextField.textField(
                          context,
                          _useController,
                          S.of(context).global_hint_user,
                          OwonPic.loginUsernameIcon,
                          _useFocusNode,
                          _userNameIsEmpty,
                          width: _countryCodeIsVisibity
                              ? ScreenUtil().setWidth(800)
                              : ScreenUtil().setWidth(1100)),
                      _countryCodeIsVisibity
                          ? OwonVerify.button(context, _countryCode,
                              onPressed: _setPhoneCountryCode,
                              width: ScreenUtil().setWidth(300),
                              height: ScreenUtil().setHeight(200))
                          : Container(height: 0.0, width: 0.0),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      OwonTextField.textField(
                          context,
                          _verifyController,
                          S.of(context).global_hint_verify_code,
                          OwonPic.loginVerifyCodeIcon,
                          _verFocusNode,
                          _verifyIsEmpty,
                          width: ScreenUtil().setWidth(650)),
                      OwonVerify.button(
                          context,
                          _countDownBtnTxt == null
                              ? S.of(context).global_get_verify_code
                              : _countDownBtnTxt,
                          onPressed: _getVerifyCode,
                          width: ScreenUtil().setWidth(450),
                          height: ScreenUtil().setHeight(200)),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                  child: OwonTextField.textField(
                    context,
                    _newPwdController,
                    S.of(context).global_hint_new_password,
                    OwonPic.loginNewPswIcon,
                    _nPswFocusNode,
                    _nPswIsEmpty,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                  child: OwonTextField.textField(
                    context,
                    _confirmPwdController,
                    S.of(context).global_hint_confirm_password,
                    OwonPic.loginConfirmPswIcon,
                    _cPswFocusNode,
                    _cPswIsEmpty,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: OwonConstant.systemHeight,
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
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
            ),
          ],
        ),
      ),
    );
  }

  void startCountdownTimer() {
    _countDownTimerUtil = new TimerUtil(mInterval: 1000, mTotalTime: 60 * 1000);
    _countDownTimerUtil.setOnTimerTickCallback((int tick) {
      double _tick = tick / 1000;
      if (_tick.toInt() == 0) {
        _countDownTimerUtil.setTotalTime(60 * 1000);
      }
      setState(() {
        _countdownTime = _tick.toInt();
        if (_tick.toInt() == 0) {
          _countDownBtnTxt = S.of(context).global_get_verify_code;
          _countDownTimerUtil.cancel();
          _countDownTimerUtil = null;
        } else {
          _countDownBtnTxt = S.of(context).global_verify_code_remaining1 +
              '$_countdownTime' +
              S.of(context).global_verify_code_remaining2;
        }
      });
    });
    _countDownTimerUtil.startCountDown();
  }
}
