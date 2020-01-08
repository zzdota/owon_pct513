import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../owon_api/model/change_password_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../owon_api/owon_api_http.dart';
import '../../owon_utils/owon_http.dart';
import '../../owon_utils/owon_loading.dart';
import '../../owon_utils/owon_toast.dart';
import '../../component/owon_header.dart';
import '../../component/owon_textfield.dart';
import '../../owon_utils/owon_text_icon_button.dart';
import '../../res/owon_constant.dart';
import '../../res/owon_picture.dart';
import '../../res/owon_themeColor.dart';
import '../../generated/i18n.dart';

class ChangePage extends StatefulWidget {
  @override
  _ChangePageState createState() => _ChangePageState();
}

class _ChangePageState extends State<ChangePage> {
  final TextEditingController _oldPwdController = TextEditingController();
  final TextEditingController _newPwdController = TextEditingController();
  final TextEditingController _confirmPwdController = TextEditingController();
  FocusNode _oPswFocusNode = FocusNode();
  FocusNode _nPswFocusNode = FocusNode();
  FocusNode _cPswFocusNode = FocusNode();
  String _oldPassword = "", _newPassword = "", _confirmPassword = "";
  bool _oPswIsEmpty = true, _nPswIsEmpty = true, _cPswIsEmpty = true;

  _confirm() async {
    if (TextUtil.isEmpty(_oldPassword)) {
      OwonToast.show(S.of(context).change_psw_enter_old_psw_null);
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
    if (!RegExp(OwonConstant.passwordRegexString).hasMatch(_newPassword) ||
        !RegExp(OwonConstant.passwordRegexString).hasMatch(_confirmPassword)) {
      OwonToast.show(S.of(context).global_password_regex_string);
      return;
    }
    SharedPreferences pre = await SharedPreferences.getInstance();
    String userName = pre.getString(OwonConstant.userName);
    OwonLoading(context).show();
    OwonHttp.getInstance().post(OwonConstant.foreignServerHttp,
        OwonApiHttp().changePassword(userName, _oldPassword, _newPassword),
        (value) {
      OwonLoading(context).hide().then((v) {
        ChangePasswordEntity changePswModelEntity =
            ChangePasswordEntity.fromJson(value);
        switch (int.parse(changePswModelEntity.code)) {
          case 100:
            OwonToast.show(S.of(context).change_psw_success);
            Navigator.pop(context);
            break;
          case 110:
            OwonToast.show(S.of(context).global_unknown);
            break;
          case 301:
            OwonToast.show(S.of(context).global_not_account);
            break;
          case 303:
            OwonToast.show(S.of(context).change_psw_old_psw_error);
            break;
          case 304:
            OwonToast.show(S.of(context).global_lock_account);
            break;
        }
      });
    }, (value) {
      OwonLoading(context).hide().then((v){
        OwonToast.show(S.of(context).change_psw_fail);
      });
    });
  }

  setSuffixIconStatus() {
    _oPswFocusNode.addListener(() {
      setState(() {
        if (TextUtil.isEmpty(_oldPwdController.text)) {
          if (_oPswFocusNode.hasFocus) {
            _oPswIsEmpty = true;
          } else {
            _oPswIsEmpty = true;
          }
        } else {
          if (_oPswFocusNode.hasFocus) {
            _oPswIsEmpty = false;
          } else {
            _oPswIsEmpty = true;
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
  }

  @override
  Widget build(BuildContext context) {
    _oldPwdController.addListener(() {
      _oldPassword = _oldPwdController.text;
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
                  OwonPic.loginResetPswHeader,
                  S.of(context).change_psw_change,
                  subTitle: S.of(context).reset_psw_password,
                  width: 250,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 80),
                  child: OwonTextField.textField(
                    context,
                    _oldPwdController,
                    S.of(context).change_psw_old_psw,
                    OwonPic.loginPasswordIcon,
                    _oPswFocusNode,
                    _oPswIsEmpty,
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
                      onPressed: _confirm,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(OwonConstant.cRadius)),
                      icon: SvgPicture.asset(
                        OwonPic.loginConfirmResetPswIcon,
                        color: Colors.white,
                        width: 20,
                      ),
                      label: Text(
                        S.of(context).reset_psw_confirm,
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
}
