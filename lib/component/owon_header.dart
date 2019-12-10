import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../res/owon_themeColor.dart';

class OwonHeader {
  static Widget header(BuildContext context, String imageUrl, String title,
      {String subTitle,
      double fontSize = 30.0,
        double width = 250.0,
//        double height = 100.0,
      MainAxisAlignment alignment = MainAxisAlignment.center}) {
    return Container(
      child: Row(
        mainAxisAlignment: alignment,
        children: <Widget>[
          Image.asset(
            imageUrl,
            width: ScreenUtil.getInstance().setWidth(width),
//            height: ScreenUtil.getInstance().setHeight(height),
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 2,
            height: 60,
            child: Container(
              color: OwonColor().getCurrent(context, "textColor"),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          subTitle == null
              ? Text(
                  title,
                  style: TextStyle(
                      color: OwonColor().getCurrent(context, "textColor"),
                      fontSize: fontSize),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                          color: OwonColor().getCurrent(context, "textColor"),
                          fontSize: fontSize),
                    ),
                    Text(
                      subTitle,
                      style: TextStyle(
                          color: OwonColor().getCurrent(context, "textColor"),
                          fontSize: fontSize),
                    )
                  ],
                )
        ],
      ),
    );
  }
}
