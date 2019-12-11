import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../res/owon_constant.dart';
import '../res/owon_themeColor.dart';

class OwonBottomSheet {
  static Future show(context, List dataList,
      {int maxCount = 5,
      double itemHeight = OwonConstant.systemHeight,
      String key = "code",
      String key1 = "name"}) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        side: BorderSide(
            width: 1.0, color: OwonColor().getCurrent(context, "itemColor")),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(OwonConstant.cRadius),
            topRight: Radius.circular(OwonConstant.cRadius)),
      ),
      context: context,
      builder: (BuildContext context) {
        return new Container(
            height: maxCount * itemHeight > 400
                ? 400
                : dataList.length * itemHeight,
            decoration: BoxDecoration(
                color: OwonColor().getCurrent(context, "itemColor"),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(OwonConstant.cRadius),
                    topRight: Radius.circular(OwonConstant.cRadius)),
                border: Border.all(
                    color: OwonColor().getCurrent(context, "textColor"))),
            child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context, index);
                    },
                    child: Container(
                      height: itemHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: 120,
                                ),
                                dataList[index]["imageUrl"] == null
                                    ? Text("")
                                    : SvgPicture.asset(
                                        dataList[index]["imageUrl"],
                                        width: 15,
                                        color: dataList[index]["color"] == null
                                            ? OwonColor().getCurrent(
                                                context, "textColor")
                                            : dataList[index]["color"],
                                      ),
                                SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "+" + dataList[index][key].toString(),
                                      style: TextStyle(
                                          color: OwonColor().getCurrent(
                                              context, "textColor")),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      dataList[index][key1],
                                      style: TextStyle(
                                          color: OwonColor().getCurrent(
                                              context, "textColor")),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Divider(
                              height: 1,
                            ),
                            color:
                                OwonColor().getCurrent(context, "borderNormal"),
                          )
                        ],
                      ),
                    ),
                  );
                }));
      },
    );
  }
}
