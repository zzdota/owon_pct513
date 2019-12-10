import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:owon_pct513/component/owon_textfield.dart';
import 'package:owon_pct513/component/owon_verification.dart';
import 'package:owon_pct513/owon_utils/owon_text_icon_button.dart';
import 'package:owon_pct513/res/owon_constant.dart';
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

  _getVerifyCode() {
    setState(() {});
  }

  _register(){

  }

  @override
  Widget build(BuildContext context) {
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
                  margin: EdgeInsets.only(left: 20.0, right: 20.0,top: 20),
                  child: OwonTextField.textField(context, _useController,
                      S.of(context).global_hint_user, OwonPic.loginUsernameIcon),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20,right: 20,top: 30),
                  child: Row(
                    children: <Widget>[
                      OwonTextField.textField(context, _verifyController,
                          S.of(context).global_hint_verify_code, OwonPic.loginVerifyCodeIcon,width: 230),
                      SizedBox(
                        width: 10.0,
                      ),
                      OwonVerify.button(context, S.of(context).global_get_verify_code, onPressed: _getVerifyCode)
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0,top: 30),
                  child: OwonTextField.textField(context, _newPwdController,
                      S.of(context).global_hint_new_password, OwonPic.loginNewPswIcon),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0,top: 30),
                  child: OwonTextField.textField(context, _confirmPwdController,
                      S.of(context).global_hint_confirm_password, OwonPic.loginConfirmPswIcon),
                ),
                Container(
                  width: double.infinity,
                  height: 60.0,
                  margin: EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 30.0),
                  child: OwonTextIconButton.icon(
                      onPressed: _register,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              OwonConstant.cRadius)),
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
                      iconTextAlignment:
                      TextIconAlignment.iconRightTextLeft),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
