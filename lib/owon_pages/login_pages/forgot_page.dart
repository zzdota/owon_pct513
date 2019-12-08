import 'package:flutter/material.dart';
import '../../res/owon_themeColor.dart';
import '../../generated/i18n.dart';

class ForgotPage extends StatefulWidget {
  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OwonColor().getCurrent(context, "primaryColor"),
      appBar: AppBar(
        title: Text(S.of(context).reset_psw_title),
      ),
    );
  }
}
