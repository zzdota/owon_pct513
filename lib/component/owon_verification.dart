import 'package:flutter/material.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';

class OwonVerify {
  static Widget button(BuildContext context, String content,
      {@required VoidCallback onPressed,
      double fontSize = 14.0,
      Color color,
      double height = 60.0,
      double width = 130.0}) {
    return Container(
      height: height,
      width: width,
      child: RaisedButton(
        onPressed: onPressed,
        color: color == null ? OwonColor().getCurrent(context, "blue") : color,
        child: Text(
          content,
          style: TextStyle(color: Colors.white, fontSize: fontSize),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
      ),
    );
  }
}
