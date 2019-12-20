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
}
