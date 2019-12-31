import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../res/owon_themeColor.dart';

class OwonHeader {
  static Widget header(BuildContext context, String imageUrl, String title,
      {String subTitle, String thirdTitle,
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
                    ),
                    thirdTitle != null ? Text(
                      thirdTitle,
                      style: TextStyle(
                          color: OwonColor().getCurrent(context, "textColor"),
                          fontSize: fontSize),
                    ) : Container(),
                  ],
                )
        ],
      ),
    );
  }
















  static Widget normalHeader(BuildContext context, String imageUrl, String title,
      {String subTitle,
        double fontSize = 20.0,
        double width = 250.0,
//        double height = 100.0,
        MainAxisAlignment alignment = MainAxisAlignment.start}) {
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
            height: subTitle==null?45:70,
            child: Container(
              color: OwonColor().getCurrent(context, "textColor"),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          subTitle == null
              ? Container(
            width: 250,
                child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                  color: OwonColor().getCurrent(context, "textColor"),
                  fontSize: fontSize),
          ),
              )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 250,
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: OwonColor().getCurrent(context, "textColor"),
                      fontSize: fontSize),
                ),
              ),
              SizedBox(height: 5,),
              Container(
                width: 250,
                child: Text(
                  subTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: OwonColor().getCurrent(context, "textColor"),
                      fontSize: fontSize-4),
                ),
              ),

            ],
          )
        ],
      ),
    );
  }
}
