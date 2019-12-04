import 'package:flutter/material.dart';
import 'owon_pages/login_pages/login_page.dart';
import 'owon_utils/owon_log.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OwonLog.e("-----");
    jumpToHomePage(context);
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset(
            "assets/images/launch_bg.png",
            fit: BoxFit.cover,
          ),
          Image.asset(
            "assets/images/launch_icon.png",
            fit: BoxFit.contain,
            width: 200,
          ),
        ],
      ),
    );
  }

  jumpToHomePage(context) {
    Future.delayed(Duration(seconds: 2), () {
//      Navigator.of(context).pushAndRemoveUntil(
//          MaterialPageRoute(builder: (context) => LoginPage()),
//          (Route router) => false);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }
}
