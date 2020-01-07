import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../generated/i18n.dart';
import '../../owon_api/model/address_model_entity.dart';
import '../../owon_api/model/firmware_upgrade_mode_entity.dart';
import '../../owon_api/model/firmware_upgrade_state_mode_entity.dart';
import '../../owon_providers/owon_evenBus/list_evenbus.dart';
import '../../owon_utils/owon_dialog.dart';
import '../../owon_utils/owon_loading.dart';
import '../../owon_utils/owon_log.dart';
import '../../owon_utils/owon_mqtt.dart';
import '../../owon_utils/owon_text_icon_button.dart';
import '../../owon_utils/owon_toast.dart';
import '../../res/owon_picture.dart';
import '../../res/owon_sequence.dart';
import '../../res/owon_themeColor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../res/owon_constant.dart';
import 'device_about_progress_dialog_page.dart';

class DeviceAboutPage extends StatefulWidget {
  AddressModelAddrsDevlist devModel;
  DeviceAboutPage(this.devModel);

  @override
  _DeviceAboutPageState createState() => _DeviceAboutPageState();
}

class _DeviceAboutPageState extends State<DeviceAboutPage> {
  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;

  String mCurrentVersion = "",
      mUpgradeVersion = "",
      mWifiCurrentVersion = "",
      mWifiUpgradeVersion = "",
      mDeviceId = "";

  int mUpgradeProgress = 0;
  String mUpgradeByteProgress = "";

  FirmwareUpgradeModeEntity mWifiFirmwareUpgradeMode,
      mPCT513FirmwareUpgradeMode;

  var mOwonDialog;

  bool isStartUpgrade = true;
  int mStartUpgradeType = 1;
  bool mPCT513UpgradeFlag = false, mWifiUpgradeFlag = false;

  @override
  void initState() {
    super.initState();
    mDeviceId = widget.devModel.deviceid;
    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
      String topic = msg["topic"];

      if (msg["type"] == "json") {
        Map<String, dynamic> payload = msg["payload"];
        if (payload.containsValue("device.attr.str.batch")) {
          List tempList = payload["response"];
          tempList.forEach((item) {
            String attr = item["attrName"];
            if (attr == "versionname") {
              setState(() {
                mCurrentVersion = item["attrValue"];
              });
            } else if (attr == "wifiversion") {
              setState(() {
                mWifiCurrentVersion = item["attrValue"];
              });
            }
          });
          getDeviceUpgradeInfo(false);
          getDeviceUpgradeInfo(true);
        } else if (payload.containsValue("version.get")) {
          if (topic.startsWith("reply")) {
            OwonLoading(context).dismiss();
            FirmwareUpgradeModeEntity firmwareUpgradeModeEntity =
                FirmwareUpgradeModeEntity.fromJson(payload);
            if (firmwareUpgradeModeEntity.code == 100) {
              if (firmwareUpgradeModeEntity.firmwaretype == "wifi") {
                mWifiFirmwareUpgradeMode = firmwareUpgradeModeEntity;
                setState(() {
                  int lastVersion = int.parse(mWifiFirmwareUpgradeMode.version);
                  mWifiUpgradeVersion =
                      "${mWifiFirmwareUpgradeMode.firmwaretype.toUpperCase()}_V${lastVersion ~/ 1000}.${lastVersion ~/ 100}.${lastVersion % 10}";
                  if (mWifiCurrentVersion == "" ||
                      mWifiCurrentVersion == null) {
                    mWifiCurrentVersion = mWifiUpgradeVersion;
                  }
                  String buf = mWifiCurrentVersion
                      .substring(mWifiCurrentVersion.indexOf("V") + 1,
                          mWifiCurrentVersion.length)
                      .replaceAll(".", "");
                  buf = buf.substring(0, buf.indexOf("_"));
                  OwonLog.e("=====>>>>buf$buf---->>>$lastVersion");
                  int version = int.parse(buf);
                  if (lastVersion > version) {
                    mWifiUpgradeFlag = true;
                  } else {
                    mWifiUpgradeVersion = mWifiCurrentVersion;
                    mWifiUpgradeFlag = false;
                  }
                });
              } else if (firmwareUpgradeModeEntity.firmwaretype == "pct513") {
                mPCT513FirmwareUpgradeMode = firmwareUpgradeModeEntity;
                setState(() {
                  int lastVersion =
                      int.parse(mPCT513FirmwareUpgradeMode.version);
                  mUpgradeVersion =
                      "${mPCT513FirmwareUpgradeMode.firmwaretype.toUpperCase()}_V${lastVersion ~/ 1000}.${lastVersion ~/ 100}.${lastVersion % 10}";
                  if (mCurrentVersion == null || mCurrentVersion == "") {
                    mCurrentVersion = mUpgradeVersion;
                  }
                  String buf = mCurrentVersion
                      .substring(mCurrentVersion.indexOf("V") + 1,
                          mCurrentVersion.length)
                      .replaceAll(".", "");
                  int version = int.parse(buf);
                  if (lastVersion > version) {
                    mPCT513UpgradeFlag = true;
                  } else {
                    mUpgradeVersion = mCurrentVersion;
                    mPCT513UpgradeFlag = false;
                  }
                });
              }
            }
          }
        }
      } else if (msg["type"] == "string") {
        String payload = msg["payload"];
        if (topic.contains("upgradestate") && isStartUpgrade) {
          Map<String, dynamic> state = jsonDecode(payload);
          FirmwareUpgradeStateModeEntity firmwareUpgradeStateModeEntity =
              FirmwareUpgradeStateModeEntity.fromJson(state);
          switch (firmwareUpgradeStateModeEntity.state) {
            case 0:
//              if (mUpgradeCount == 3) {
////                mUpgradeCount -= 1;
////                startUpgrade();
////              } else {
//              showUpgradSuccess();
//              }
              break;
            case 1:
              int mTotalFileByteCount = 0;
              if (mStartUpgradeType == 0) {
                return;
              } else if (mStartUpgradeType == 1) {
                //513
                mTotalFileByteCount = mPCT513FirmwareUpgradeMode
                    .files[firmwareUpgradeStateModeEntity.index].fileSize;
              } else if (mStartUpgradeType == 2) {
                //wifi
                mTotalFileByteCount = mWifiFirmwareUpgradeMode
                    .files[firmwareUpgradeStateModeEntity.index].fileSize;
              }
              if (mOwonDialog == null) {
                showUpgrading();
              } else {
                mStateSetter(() {
                  mUpgradeProgress = ((firmwareUpgradeStateModeEntity.progress /
                      mTotalFileByteCount) *
                          100)
                      .toInt();
                  mUpgradeByteProgress = "${firmwareUpgradeStateModeEntity.progress} / $mTotalFileByteCount";
                  OwonLog.e("---->mUpgradeProgress$mUpgradeProgress"
                      "---->mTotalFileByteCount$mTotalFileByteCount");
                });
              }
              break;
            default:
              break;
          }
        }
      }
    });
    Future.delayed(Duration(seconds: 0), () {
      getDeviceInfo();
      OwonDialog.init(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _listEvenBusSubscription.cancel();
  }

  getDeviceUpgradeInfo(bool flag) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic = "api/cloud/$clientID";
    Map p = Map();
    p["command"] = "version.get";
    p["type"] = "UAA8BC7Cais7dJGc";
    p["sequence"] = OwonSequence.getDeviceUpgradeInfo;
    p["language"] = "en";
    if (flag)
      p["firmwaretype"] = "pct513";
    else
      p["firmwaretype"] = "wifi";
    var msg = JsonEncoder.withIndent("  ").convert(p);
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }

  getDeviceInfo() async {
    OwonLoading(context).show();
    List attrsList = ["versionname", "wifiversion"];
    List paramList = [];
    for (int i = 0; i < attrsList.length; i++) {
      String p = attrsList[i];
      Map paramMap = Map();
      paramMap["attrName"] = p;
      paramList.add(paramMap);
    }

    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic = "api/cloud/$clientID";
    Map p = Map();
    p["command"] = "device.attr.str.batch";
    p["sequence"] = OwonSequence.getDeviceInfo;
    p["deviceid"] = widget.devModel.deviceid;
    p["param"] = paramList;

    var msg = JsonEncoder.withIndent("  ").convert(p);
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }

  showConfirmUpgrade(int type) {
    showDialog(
        context: context,
        //点击背景不消失
        barrierDismissible: false,
        builder: (ctx) {
          //StatefulBuilder 来构建 dialog
          //使用参数 state来更新 dialog 中的数据内容
          return StatefulBuilder(builder: (ctx, state) {
            mStateSetter = state;
            //创建dialog
            return ShowCommonAlert(
              negativeText: S.of(ctx).device_info_late_update_btn,
              positiveText: S.of(ctx).device_info_update_btn,
              isShowTitleDivide: false,
              isShowBottomDivide: true,
              onPositivePressEvent: () {
                isStartUpgrade = true;
                mStartUpgradeType = type;
                startUpgrade();
                Navigator.pop(ctx);
              },
              onCloseEvent: () {
                Navigator.pop(ctx);
              },
              childWidget: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    S.of(ctx).device_info_confirm_title,
                    style: TextStyle(
                        color: OwonColor().getCurrent(ctx, "blue"),
                        fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            );
          });
        });
  }

  StateSetter mStateSetter;
  showUpgrading() {
    double width = 300;
    double height = 20;
    double radius = 20;
    mOwonDialog = showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return StatefulBuilder(builder: (ctx, state) {
            mStateSetter = state;
            return ShowCommonAlert(
              negativeText: S.of(ctx).global_cancel,
              isShowTitleDivide: false,
              isShowBottomDivide: true,
              onCloseEvent: () {
                Navigator.pop(ctx);
                isStartUpgrade = false;
                mStartUpgradeType = 0;
              },
              childWidget: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    S.of(ctx).device_info_upgrading,
                    style: TextStyle(
                        color: OwonColor().getCurrent(ctx, "blue"),
                        fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: width,
                      height: height,
                      child: ClipRRect(
                          borderRadius:
                              BorderRadius.all(Radius.circular(radius)),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: width,
                                height: height,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2.0,
                                        color: OwonColor()
                                            .getCurrent(ctx, "blue")),
                                    borderRadius: BorderRadius.circular(radius),
                                    color: Colors.transparent),
                              ),
                              Positioned(
                                left: 0,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(radius)),
                                  child: Container(
                                    width: mUpgradeProgress / 100 * width,
                                    height: height,
                                    decoration: BoxDecoration(
                                        color: OwonColor()
                                            .getCurrent(ctx, "blue")),
                                  ),
                                ),
                              )
                            ],
                          ))),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "$mUpgradeProgress%",
                    style: TextStyle(
                        color: OwonColor().getCurrent(ctx, "blue"),
                        fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "$mUpgradeByteProgress",
                    style: TextStyle(
                        color: OwonColor().getCurrent(ctx, "blue"),
                        fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            );
          });
        });
  }

  showUpgradSuccess() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return StatefulBuilder(builder: (ctx, state) {
            mStateSetter = state;
            return ShowCommonAlert(
              negativeText: S.of(ctx).global_ok,
              isShowTitleDivide: false,
              isShowBottomDivide: true,
              onCloseEvent: () {
                Navigator.pop(ctx);
              },
              childWidget: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        OwonPic.successIcon,
                        width: 50,
                        color: OwonColor().getCurrent(ctx, "blue"),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        S.of(ctx).device_info_upgrade_success,
                        style: TextStyle(
                            color: OwonColor().getCurrent(ctx, "blue"),
                            fontSize: 20.0),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            );
          });
        });
  }

  showUpgradeFail() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return StatefulBuilder(builder: (ctx, state) {
            mStateSetter = state;
            return ShowCommonAlert(
              negativeText: S.of(ctx).global_cancel,
              positiveText: S.of(ctx).global_ok,
              isShowTitleDivide: false,
              isShowBottomDivide: true,
              onPositivePressEvent: () {
                Navigator.pop(ctx);
              },
              onCloseEvent: () {
                Navigator.pop(ctx);
              },
              childWidget: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        OwonPic.failIcon,
                        width: 50,
                        color: OwonColor().getCurrent(ctx, "blue"),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        S.of(ctx).device_info_upgrade_fail,
                        style: TextStyle(
                            color: OwonColor().getCurrent(ctx, "blue"),
                            fontSize: 20.0),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            );
          });
        });
  }

  startUpgrade() async {
    Map p = Map();
    if (mStartUpgradeType == 1) {
      p["firmwaretype"] = mPCT513FirmwareUpgradeMode.firmwaretype;
      p["version"] = mUpgradeVersion;
      p["filenum"] = mPCT513FirmwareUpgradeMode.files.length;
      p["file"] = mPCT513FirmwareUpgradeMode.files;
      p["url"] = mPCT513FirmwareUpgradeMode.url;
    } else if (mStartUpgradeType == 2) {
      p["firmwaretype"] = mWifiFirmwareUpgradeMode.firmwaretype;
      p["version"] = mWifiUpgradeVersion;
      p["filenum"] = mWifiFirmwareUpgradeMode.files.length;
      p["file"] = mWifiFirmwareUpgradeMode.files;
      p["url"] = mWifiFirmwareUpgradeMode.url;
    }
//    OwonLoading(context).show();
    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic = "api/device/${widget.devModel.deviceid}/$clientID/upgrade";

    var msg = JsonEncoder.withIndent("  ").convert(p);
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).device_info_title),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${S.of(context).device_info_mac}$mDeviceId",
                        style: TextStyle(
                            fontSize: 20,
                            color:
                                OwonColor().getCurrent(context, "textColor"))),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "${S.of(context).device_info_current_version}",
                      style: TextStyle(
                          fontSize: 20,
                          color: OwonColor().getCurrent(context, "textColor")),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text("$mCurrentVersion",
                          style: TextStyle(
                              fontSize: 20,
                              color: OwonColor()
                                  .getCurrent(context, "blue"))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text("${S.of(context).device_info_upgrade_version}",
                        style: TextStyle(
                            fontSize: 20,
                            color:
                                OwonColor().getCurrent(context, "textColor"))),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text("$mUpgradeVersion",
                          style: TextStyle(
                              fontSize: 20,
                              color: OwonColor()
                                  .getCurrent(context, "blue"))),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Container(
                        height: OwonConstant.systemHeight,
                        width: double.infinity,
                        child: OwonTextIconButton.icon(
//                      color: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(OwonConstant.cRadius),
                            ),
                            onPressed: () {
                              if(mPCT513UpgradeFlag) {
                                showConfirmUpgrade(1);
                              } else {
                                OwonToast.show(S.of(context).device_info_up_to_data);
                              }
                            },
                            icon: SvgPicture.asset(
                              OwonPic.dSettingUpgrade,
                              width: 25,
                              color: OwonColor()
                                  .getCurrent(context, "textColor"),
                            ),
                            label: Text(
                              S.of(context).device_info_upgrade,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            iconTextAlignment:
                                TextIconAlignment.iconRightTextLeft)),
                    SizedBox(
                      height: 35,
                    ),
                    Text("${S.of(context).device_info_wifi_current_version}",
                        style: TextStyle(
                            fontSize: 20,
                            color:
                                OwonColor().getCurrent(context, "textColor"))),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text("$mWifiCurrentVersion",
                          style: TextStyle(
                              fontSize: 20,
                              color: OwonColor()
                                  .getCurrent(context, "blue"))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text("${S.of(context).device_info_wifi_upgrade_version}",
                        style: TextStyle(
                            fontSize: 20,
                            color:
                                OwonColor().getCurrent(context, "textColor"))),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text("$mWifiUpgradeVersion",
                          style: TextStyle(
                              fontSize: 20,
                              color: OwonColor()
                                  .getCurrent(context, "blue"))),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Container(
                        height: OwonConstant.systemHeight,
                        width: double.infinity,
                        child: OwonTextIconButton.icon(
//                      color: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(OwonConstant.cRadius),
                            ),
                            onPressed: () {
                              if(mWifiUpgradeFlag) {
                                showConfirmUpgrade(2);
                              } else {
                                OwonToast.show(S.of(context).device_info_up_to_data);
                              }
                            },
                            icon: SvgPicture.asset(
                              OwonPic.dSettingUpgrade,
                              width: 25,
                              color: OwonColor()
                                  .getCurrent(context, "textColor"),
                            ),
                            label: Text(
                              S.of(context).device_info_upgrade,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            iconTextAlignment:
                                TextIconAlignment.iconRightTextLeft))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
