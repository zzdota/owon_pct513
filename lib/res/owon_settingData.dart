import 'package:flutter/material.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import '../generated/i18n.dart';
List loadSettingData(context) {
  return [
    {
      "name": S.of(context).set_resetPsw,
      "description": "与傀儡和石像鬼类似，撼地者也曾经是大地的一部分，不过如今他自由行走于大地之",
      "imageUrl": OwonPic.setModifyB,
      "imageUrlW": OwonPic.setModifyW,

    },
    {
      "name": S.of(context).set_appearance,
      "description": "斯温是一名守夜骑士的私生子，身怀苍白南海人的血统，在影承废墟长大。他父亲因",
      "imageUrl": OwonPic.setAppearB,
      "imageUrlW": OwonPic.setAppearW,

    },
    {
      "name": S.of(context).set_dig,
      "description":
      "多年来骑士达维安一直在追寻一条传说中的古龙，而他发现自己最终面对的敌人后感到失望：过去让人闻风丧胆的神龙斯莱瑞克已经变得苍老而脆弱，它的双翼已经残破",
      "imageUrl": OwonPic.setMapB,
      "imageUrlW": OwonPic.setMapW,

    },
//  {
//    "name": "帮助",
//    "description":
//    "没有人见过主宰尤涅若面具下的真面目。甚至有人认为他没有脸部。作为公然反抗腐败领主的惩罚，主宰被古老的遮面之岛流放了，这反而救了他的性命。不久后海岛在一个充斥着复仇魔法的夜晚被海浪彻底毁灭了",
//    "imageUrl": "assets/images/launch_icon.png",
//  },
    {
      "name": S.of(context).set_about,
      "description":
      "西部森林中隐藏了无数的秘密。其中之一就是受到风神眷顾的森林弓箭大师莱瑞蕾。风行者莱瑞蕾的家人在她出生那夜的暴风雨中全部去世了，狂风摧毁了他们的房屋，一切都化为乌有。",
      "imageUrl": OwonPic.setAboutB,
      "imageUrlW": OwonPic.setAboutW,

    }
    ,
    {
      "name": S.of(context).set_exit,
      "description":
      "西部森林中隐藏了无数的秘密。其中之一就是受到风神眷顾的森林弓箭大师莱瑞蕾。风行者莱瑞蕾的家人在她出生那夜的暴风雨中全部去世了，狂风摧毁了他们的房屋，一切都化为乌有。",
      "imageUrl": OwonPic.setExit,
      "imageUrlW": OwonPic.setExit,

    }
  ];
}
//List loadSettingData = [
//  {
//    "name": S.of(context).set_resetPsw,
//    "description": "与傀儡和石像鬼类似，撼地者也曾经是大地的一部分，不过如今他自由行走于大地之",
//    "imageUrl": OwonPic.setModifyB,
//    "imageUrlW": OwonPic.setModifyW,
//
//  },
//  {
//    "name": "个性主题",
//    "description": "斯温是一名守夜骑士的私生子，身怀苍白南海人的血统，在影承废墟长大。他父亲因",
//    "imageUrl": OwonPic.setAppearB,
//    "imageUrlW": OwonPic.setAppearW,
//
//  },
//  {
//    "name": "电子围栏",
//    "description":
//    "多年来骑士达维安一直在追寻一条传说中的古龙，而他发现自己最终面对的敌人后感到失望：过去让人闻风丧胆的神龙斯莱瑞克已经变得苍老而脆弱，它的双翼已经残破",
//    "imageUrl": OwonPic.setMapB,
//    "imageUrlW": OwonPic.setMapW,
//
//  },
////  {
////    "name": "帮助",
////    "description":
////    "没有人见过主宰尤涅若面具下的真面目。甚至有人认为他没有脸部。作为公然反抗腐败领主的惩罚，主宰被古老的遮面之岛流放了，这反而救了他的性命。不久后海岛在一个充斥着复仇魔法的夜晚被海浪彻底毁灭了",
////    "imageUrl": "assets/images/launch_icon.png",
////  },
//  {
//    "name": "关于我们",
//    "description":
//    "西部森林中隐藏了无数的秘密。其中之一就是受到风神眷顾的森林弓箭大师莱瑞蕾。风行者莱瑞蕾的家人在她出生那夜的暴风雨中全部去世了，狂风摧毁了他们的房屋，一切都化为乌有。",
//    "imageUrl": OwonPic.setAboutB,
//    "imageUrlW": OwonPic.setAboutW,
//
//  }
//  ,
//  {
//    "name": "退出登录",
//    "description":
//    "西部森林中隐藏了无数的秘密。其中之一就是受到风神眷顾的森林弓箭大师莱瑞蕾。风行者莱瑞蕾的家人在她出生那夜的暴风雨中全部去世了，狂风摧毁了他们的房屋，一切都化为乌有。",
//    "imageUrl": OwonPic.setExit,
//    "imageUrlW": OwonPic.setExit,
//
//  }
//];
List loadSystemData = [
  {
    "name": "Off",
    "description": "与傀儡和石像鬼类似，撼地者也曾经是大地的一部分，不过如今他自由行走于大地之",
    "imageUrl": "assets/images/management/m_sys_off.svg",
    "color": Colors.white,

  },
  {
    "name": "Auto",
    "description": "斯温是一名守夜骑士的私生子，身怀苍白南海人的血统，在影承废墟长大。他父亲因",
    "imageUrl": "auto",
//    "color": Colors.blue,

  },
  {
    "name": "Cool",
    "description":
    "多年来骑士达维安一直在追寻一条传说中的古龙，而他发现自己最终面对的敌人后感到失望：过去让人闻风丧胆的神龙斯莱瑞克已经变得苍老而脆弱，它的双翼已经残破",
    "imageUrl": "assets/images/management/m_sys_cool.svg",
    "color": Colors.blue,
  }
  ,
  {
    "name": "Heat",
    "description":
    "多年来骑士达维安一直在追寻一条传说中的古龙，而他发现自己最终面对的敌人后感到失望：过去让人闻风丧胆的神龙斯莱瑞克已经变得苍老而脆弱，它的双翼已经残破",
    "imageUrl": "assets/images/management/m_sys_heat.svg",
    "color": Colors.red,
  }
  ,
  {
    "name": "Emergyce Heat",
    "description":
    "多年来骑士达维安一直在追寻一条传说中的古龙，而他发现自己最终面对的敌人后感到失望：过去让人闻风丧胆的神龙斯莱瑞克已经变得苍老而脆弱，它的双翼已经残破",
    "imageUrl": "assets/images/management/m_sys_eHeat.svg",
    "color": Colors.red,

  }
];
List loadFanData = [
  {
    "name": "On",
    "description": "与傀儡和石像鬼类似，撼地者也曾经是大地的一部分，不过如今他自由行走于大地之",
    "imageUrl": "assets/images/management/m_fan_show.svg",
    "color": Colors.white,

  },
  {
    "name": "Auto",
    "description": "斯温是一名守夜骑士的私生子，身怀苍白南海人的血统，在影承废墟长大。他父亲因",
    "imageUrl": "assets/images/management/m_fan_auto.svg",
  },
  {
    "name": "Cycle",
    "description":
    "多年来骑士达维安一直在追寻一条传说中的古龙，而他发现自己最终面对的敌人后感到失望：过去让人闻风丧胆的神龙斯莱瑞克已经变得苍老而脆弱，它的双翼已经残破",
    "imageUrl": "assets/images/management/m_fan_circle.svg",
  }
];
List loadHoldData = [
  {
    "name": "Follow Schedule",
    "description": "与傀儡和石像鬼类似，撼地者也曾经是大地的一部分，不过如今他自由行走于大地之",
    "imageUrl": "assets/images/management/m_hold_schedule.svg",
    "color": Colors.green,

  },
  {
    "name": "Per Hold",
    "description": "斯温是一名守夜骑士的私生子，身怀苍白南海人的血统，在影承废墟长大。他父亲因",
    "imageUrl": "assets/images/management/m_hold_permHold.svg",
    "color": Colors.white,

  },
  {
    "name": "Hold Until",
    "description":
    "多年来骑士达维安一直在追寻一条传说中的古龙，而他发现自己最终面对的敌人后感到失望：过去让人闻风丧胆的神龙斯莱瑞克已经变得苍老而脆弱，它的双翼已经残破",
    "imageUrl": "assets/images/login/login_forgot_psw_icon.svg",
    "color": Colors.white,

  }
];




List loadDeviceSettingData(context) {
  return [
    {
      "name": S.of(context).dSet_rename,
      "description": "与傀儡和石像鬼类似，撼地者也曾经是大地的一部分，不过如今他自由行走于大地之",
      "imageUrl": OwonPic.dSetRenameB,
      "imageUrlW": OwonPic.dSetRenameW,

    },
    {
      "name": S.of(context).dSet_vacation,
      "description": "斯温是一名守夜骑士的私生子，身怀苍白南海人的血统，在影承废墟长大。他父亲因",
      "imageUrl": OwonPic.dSetVacSetB,
      "imageUrlW": OwonPic.dSetVacSetW,

    },
    {
      "name": S.of(context).dSet_fan_set,
      "description":
      "多年来骑士达维安一直在追寻一条传说中的古龙，而他发现自己最终面对的敌人后感到失望：过去让人闻风丧胆的神龙斯莱瑞克已经变得苍老而脆弱，它的双翼已经残破",
      "imageUrl": OwonPic.dSetCirSetB,
      "imageUrlW": OwonPic.dSetCirSetW,

    },
    {
      "name": S.of(context).dSet_sensor,
      "description":
      "西部森林中隐藏了无数的秘密。其中之一就是受到风神眷顾的森林弓箭大师莱瑞蕾。风行者莱瑞蕾的家人在她出生那夜的暴风雨中全部去世了，狂风摧毁了他们的房屋，一切都化为乌有。",
      "imageUrl": OwonPic.dSetSensorSetB,
      "imageUrlW": OwonPic.dSetSensorSetW,

    }
    ,
    {
      "name": S.of(context).dSet_temp,
      "description":
      "西部森林中隐藏了无数的秘密。其中之一就是受到风神眷顾的森林弓箭大师莱瑞蕾。风行者莱瑞蕾的家人在她出生那夜的暴风雨中全部去世了，狂风摧毁了他们的房屋，一切都化为乌有。",
      "imageUrl": OwonPic.dSetTempSetB,
      "imageUrlW": OwonPic.dSetTempSetW,

    }
    ,
    {
      "name": S.of(context).dSet_device_info,
      "description":
      "西部森林中隐藏了无数的秘密。其中之一就是受到风神眷顾的森林弓箭大师莱瑞蕾。风行者莱瑞蕾的家人在她出生那夜的暴风雨中全部去世了，狂风摧毁了他们的房屋，一切都化为乌有。",
      "imageUrl": OwonPic.dSetDeviceInfoB,
      "imageUrlW": OwonPic.dSetDeviceInfoW,

    }
  ];
}