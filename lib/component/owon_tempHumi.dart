import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import '../res/owon_themeColor.dart';

class OwonTempHumi extends StatefulWidget {
  String localTemp;
  String localHumi;
  bool showFan;
  OwonTempHumi({this.localHumi="55",this.localTemp="30",this.showFan});

  @override
  _OwonTempHumiState createState() => _OwonTempHumiState();
}

class _OwonTempHumiState extends State<OwonTempHumi> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              widget.showFan?SvgPicture.asset(OwonPic.mFanShow,width: 18,color: OwonColor().getCurrent(context, "textColor"),):Text(""),
//              Icon(Icons.invert_colors_off,color: OwonColor().getCurrent(context, "textColor",),size: 16,),
              SizedBox(width: 8,),
              Container(
                color: OwonColor().getCurrent(context, "textColor"),
                child: VerticalDivider(
                  indent: 10.0,
                  endIndent: 10.0,
                  width: 1,
                  thickness: 1,
                ),
              ),
              SizedBox(width: 8,),
              SvgPicture.asset(OwonPic.mHumidityWater,color:  OwonColor().getCurrent(context, "textColor",),width: 15,),
//              Icon(Icons.watch,color: OwonColor().getCurrent(context, "textColor",),size: 16,),
              SizedBox(width: 2,),
              Text("${widget.localHumi}%",style: TextStyle(
                  color:  OwonColor().getCurrent(context, "textColor",),fontSize: 17.0
              ),),


            ],
          ),
          SizedBox(height: 5,),
          Text(widget.localTemp,style: TextStyle(
              color:  OwonColor().getCurrent(context, "textColor",),fontSize: 75.0
          ),),
        ],
      ),
    );
  }
}
