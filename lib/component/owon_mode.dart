import 'package:flutter/material.dart';
import 'package:owon_pct513/res/owon_constant.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';

class OwonMode extends StatefulWidget {
  String leftTitle;
  String rightTitle;
  double height;
  VoidCallback onPressed;
  OwonMode(
      {this.leftTitle,
      this.rightTitle,
      this.height = OwonConstant.systemHeight,
      this.onPressed});
  @override
  _OwonModeState createState() => _OwonModeState();
}

class _OwonModeState extends State<OwonMode> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(OwonConstant.cRadius),
          border: Border.all(
              color: OwonColor().getCurrent(context, "borderNormal"))),
      child: InkWell(
        onTap: widget.onPressed,
        child: Row(
          children: <Widget>[
            getLeft(context),
            Expanded(child: getRight(context)),
          ],
        ),
      ),
    );
  }

  Widget getLeft(context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 100,
      ),
//      color: Colors.purple,

      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
//            width: double.infinity,
//            color: Colors.red,
            child: Row(
              children: <Widget>[
              getDot(context),
              SizedBox(
                width: 5,
              ),
              Text(
                widget.leftTitle,
                style:
                TextStyle(color: OwonColor().getCurrent(context, "textColor")),
              ),
              SizedBox(
                width: 10,
              )
            ],),
          ),
          VerticalDivider(
            indent: 10.0,
            endIndent: 10.0,
            width: 1,
            thickness: 1,
            color: OwonColor().getCurrent(context, "borderNormal"),
          )
        ],
      ),
    );
  }

  Widget getRight(context) {
    return Container(
//        color: Colors.red,
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
                child: Container(
              padding: EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: OwonColor().getCurrent(context, "textColor"),
                  ),
                  Text(
                    widget.rightTitle,
                    style: TextStyle(
                        color: OwonColor().getCurrent(context, "textColor")),
                  ),
                ],
              ),
            )),
            Icon(
              Icons.keyboard_arrow_up,
              color: OwonColor().getCurrent(context, "textColor"),
            )
          ],
        ));
  }
}

Widget getDot(context) {
  const double wh = 8.0;
  return Container(
    width: wh,
    height: wh,
    decoration: BoxDecoration(
      color: OwonColor().getCurrent(context, "textColor"),
      borderRadius: BorderRadius.circular(wh * 0.5),
    ),
  );
}
