import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:owon_pct513/res/owon_constant.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';
typedef VoidCallback = void Function();
class OwonTwoBtn extends StatelessWidget {
  String leftTitle;
  String rightTitle;
  double height;
  double width;
  VoidCallback leftBtnPressed;
  VoidCallback rightBtnPressed;

  OwonTwoBtn(
      {this.leftTitle,
      this.rightTitle,
      this.height = 50.0,
      this.width = 200.0,
      this.leftBtnPressed,
      this.rightBtnPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(this.height * 0.5),
          border: Border.all(
            color: OwonColor().getCurrent(context, "borderNormal"),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: this.leftBtnPressed,
            child: Container(
//              color: Colors.red,
              width: width*0.5-20,
              alignment: Alignment.center,
              height: height,
              child: Text(
                this.leftTitle,
                style:
                    TextStyle(color: OwonColor().getCurrent(context, "textColor")),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          VerticalDivider(
            width: 1,
            color: OwonColor().getCurrent(context, "borderNormal"),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: this.rightBtnPressed,
            child: Container(
//              color: Colors.purple,
              width: width*0.5-20,
              alignment: Alignment.center,
              height: height,
              child: Text(
                this.rightTitle,
                style:
                    TextStyle(color: OwonColor().getCurrent(context, "textColor")),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
