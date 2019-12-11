import 'package:flutter/material.dart';
import 'package:owon_pct513/res/owon_constant.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';

class OwonAdjustTemp extends StatefulWidget {

  String title;
  String tempTitle;
  double height;
  double width;
  VoidCallback upBtnPressed;
  VoidCallback downBtnPressed;

  OwonAdjustTemp(
      {this.title = "Set To",
        this.tempTitle,
        this.width = 70.0,
        this.height = 180.0,
        this.upBtnPressed,
        this.downBtnPressed});

  @override
  _OwonAdjustTempState createState() => _OwonAdjustTempState();
}

class _OwonAdjustTempState extends State<OwonAdjustTemp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.width*0.5),
        border: Border.all(color: OwonColor().getCurrent(context, "textColor"))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(icon: Icon(Icons.keyboard_arrow_up,color: OwonColor().getCurrent(context, "textColor"),size: 35,), onPressed: widget.upBtnPressed),
//          InkWell(
//            onTap: widget.upBtnPressed,
//              child: Icon(Icons.keyboard_arrow_up,color: OwonColor().getCurrent(context, "textColor"),size: 35,)),
          Column(
            children: <Widget>[
              Text(widget.title,style: TextStyle(
                color:  OwonColor().getCurrent(context, "textColor")
              ),),
              Text(widget.tempTitle,style: TextStyle(
                  color:  OwonColor().getCurrent(context, "textColor",),fontSize: 14.0
              ),),
            ],
          ),
          IconButton(icon: Icon(Icons.keyboard_arrow_down,color: OwonColor().getCurrent(context, "textColor"),size: 35,), onPressed: widget.upBtnPressed),

//          InkWell(
//            onTap: widget.downBtnPressed,
//              child: Icon(Icons.keyboard_arrow_down,color: OwonColor().getCurrent(context, "textColor"),size: 35,)),

        ],
      ),
    );
  }
}
