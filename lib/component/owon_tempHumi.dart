import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import '../res/owon_themeColor.dart';

class OwonTempHumi extends StatefulWidget {
  String localTemp;
  String localHumi;
  OwonTempHumi({this.localHumi="55",this.localTemp="30"});

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
              Icon(Icons.invert_colors_off,color: OwonColor().getCurrent(context, "textColor",),size: 16,),
              SizedBox(width: 8,),
              Container(
                color: OwonColor().getCurrent(context, "textColor"),
                child: VerticalDivider(
                  indent: 8.0,
                  endIndent: 8.0,
                  width: 1,
                  thickness: 1,
                ),
              ),
              SizedBox(width: 8,),
              SvgPicture.asset(OwonPic.mHumidityWater,color:  OwonColor().getCurrent(context, "textColor",),width: 11,),
//              Icon(Icons.watch,color: OwonColor().getCurrent(context, "textColor",),size: 16,),

              Text("${widget.localHumi}%",style: TextStyle(
                  color:  OwonColor().getCurrent(context, "textColor",),fontSize: 14.0
              ),),


            ],
          ),
          SizedBox(height: 5,),
          Text(widget.localTemp,style: TextStyle(
              color:  OwonColor().getCurrent(context, "textColor",),fontSize: 70.0
          ),),
        ],
      ),
    );
  }
}
