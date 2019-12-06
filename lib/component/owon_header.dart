import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../res/owon_themeColor.dart';

class OwonHeader {
  static Widget header(BuildContext context, String imageUrl, String title,
      [String subTitle]) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
//            margin: EdgeInsets.only(left: 20.0, bottom: 20.0),
            child: Image.asset(
              imageUrl,
              width: ScreenUtil.getInstance().setWidth(123.0),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              left: 20.0,
            ),
            child: SizedBox(
              width: 2.0,
              height: 80.0,
              child: VerticalDivider(
                color: OwonColor().getCurrent(context, "textColor"),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 20.0),
            child: SizedBox(
              height: 80.0,
              child: subTitle == null
                  ? Row(
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 32.0,
                            color: OwonColor().getCurrent(context, "textColor"),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 32.0,
                            color: OwonColor().getCurrent(context, "textColor"),
                          ),
                        ),
                        Text(
                          subTitle,
                          style: TextStyle(
                            fontSize: 32.0,
                            color: OwonColor().getCurrent(context, "textColor"),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
