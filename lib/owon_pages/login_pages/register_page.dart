import 'package:flutter/material.dart';
import '../../res/owon_themeColor.dart';
import '../../generated/i18n.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: OwonColor().getCurrent(context, "primaryColor"),
        appBar: AppBar(
        title: Text(S.of(context).reset_psw_title),
    )
    );
  }
}
