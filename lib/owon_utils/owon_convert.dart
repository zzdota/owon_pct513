import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';
import 'package:flutter/material.dart';
class OwonConvert {
  static String reduce100(String str) {
    String desString;
    int num = int.parse(str);
    double desNum = num / 100.0;
    desString = desNum.toStringAsFixed(1);
    return desString;
  }

  static String zoom100(String str) {
    String desString;
    double num = double.parse(str);
    int desNum = (num * 100) as int;
    desString = desNum.toString();
    return desString;
  }



  static String toSystemMode(String str) {
    String desString;
    if(str == "0"){
      desString = "Off";
    }else if(str == "1"){
      desString = "Auto";
    }else if(str == "3"){
      desString = "Cool";
    }else if(str == "4"){
      desString = "Heat";
    }else if(str == "5"){
      desString = "Emergyce Heat";
    }
//    else {
//      desString = "未知模式";
//    }
    return desString;
  }

  static String toFanMode(String str) {
    String desString;
    if(str == "4"){
      desString = "On";
    }else if(str == "6"){
      desString = "Auto";
    }else if(str == "5"){
      desString = "Cycle";
    }
    else {
      desString = "未知风扇模式";
    }
    return desString;
  }


  static String toHoldMode({String setPointHold,String setPointHoldDuration}) {
    String desString;
   if(setPointHold == "0"){
     desString = "Follow Schedule";
   }else {
     if(setPointHoldDuration == "65535"){
       desString = "Per Hold";
     }else{
       desString = "Hold Until";
     }
   }

    return desString;
  }



  static Widget createSystemIcon(String str) {
    Widget desWidget;
    if(str == "0"){
      desWidget = SvgPicture.asset(OwonPic.mSysOff,color:Colors.white,width: 20,);
    }else if(str == "1"){
      desWidget = SvgPicture.asset(OwonPic.mSysAuto,color:Colors.white,width: 20,);
    }else if(str == "3"){
      desWidget = SvgPicture.asset(OwonPic.mSysCool,color:Colors.blue,width: 20,);
    }else if(str == "4"){
      desWidget = SvgPicture.asset(OwonPic.mSysHeat,color:Colors.red,width: 20,);
    }else if(str == "5"){
      desWidget = SvgPicture.asset(OwonPic.mSysEHeat,color:Colors.red,width: 20,);
    }
//    else {
//      desString = "未知模式";
//    }
    return desWidget;
  }

  static Widget createFanIcon(String str) {

    Widget desWidget;
    if(str == "4"){
      desWidget = SvgPicture.asset(OwonPic.mFanShow,color:Colors.white,width: 20,);
    }else if(str == "6"){
      desWidget = SvgPicture.asset(OwonPic.mFanAuto,color:Colors.grey,width: 20,);
    }else if(str == "5"){
      desWidget = SvgPicture.asset(OwonPic.mFanCircle,color:Colors.grey,width: 20,);
    }
    return desWidget;

  }


  static Widget createHoldIcon({String setPointHold,String setPointHoldDuration}) {

    Widget desWidget;
    if(setPointHold == "0"){
      desWidget = SvgPicture.asset(OwonPic.mHoldSchedule,color:Colors.green,width: 20,);
    }else {
      if(setPointHoldDuration == "65535") {
        desWidget = SvgPicture.asset(OwonPic.mHoldPermHold,color:Colors.white,width: 20,);

      }else{
        desWidget = SvgPicture.asset(OwonPic.mHoldTempHold,color:Colors.white,width: 20,);

      }
    }
    return desWidget;

  }
}
