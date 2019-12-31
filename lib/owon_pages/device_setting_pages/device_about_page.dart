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

  int mUpgradeCount = 0;
  int mUpgradeProgress = 0;

  int mTotalFileByteCount = 0; //所有需要升级的文件字节数
  int mTotalRecByteCount = 0; //下载完成的文件字节数
  int mLastTimeProgress = 0; //上次上报的progress字段字

  FirmwareUpgradeModeEntity mWifiFirmwareUpgradeMode,
      mPCT513FirmwareUpgradeMode;

  var mOwonDialog;

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
                  mWifiCurrentVersion = "WIFI_V0.0.1";
                  int lastVersion = int.parse(mWifiFirmwareUpgradeMode.version);
                  String buf = mWifiCurrentVersion
                      .substring(mWifiCurrentVersion.indexOf("V") + 1,
                          mWifiCurrentVersion.length)
                      .replaceAll(".", "");
                  OwonLog.e("=====>>>>buf$buf---->>>$lastVersion");
                  int version = int.parse(buf);
                  if (lastVersion > version) {
                    mWifiUpgradeVersion =
                        "${mWifiFirmwareUpgradeMode.firmwaretype.toUpperCase()}_V${lastVersion ~/ 1000}.${lastVersion ~/ 100}.${lastVersion % 10}";
                    mUpgradeCount += 2;
                    for (int i = 0;
                        i < mWifiFirmwareUpgradeMode.files.length;
                        i++) {
                      mTotalFileByteCount +=
                          mWifiFirmwareUpgradeMode.files[i].fileSize;
                    }
                    OwonLog.e("=====>>>>wifi mUpgradeCount$mUpgradeCount");
                  } else {
                    mWifiUpgradeVersion = mWifiCurrentVersion;
                  }
                });
              } else if (firmwareUpgradeModeEntity.firmwaretype == "pct513") {
                mPCT513FirmwareUpgradeMode = firmwareUpgradeModeEntity;
                setState(() {
                  mCurrentVersion = "PCT513_V0.0.1";
                  int lastVersion =
                      int.parse(mPCT513FirmwareUpgradeMode.version);
                  String buf = mCurrentVersion
                      .substring(mCurrentVersion.indexOf("V") + 1,
                          mCurrentVersion.length)
                      .replaceAll(".", "");
                  int version = int.parse(buf);
                  if (lastVersion > version) {
                    mUpgradeVersion =
                        "${mPCT513FirmwareUpgradeMode.firmwaretype.toUpperCase()}_V${lastVersion ~/ 1000}.${lastVersion ~/ 100}.${lastVersion % 10}";
                    mUpgradeCount += 1;
                    for (int i = 0;
                        i < mPCT513FirmwareUpgradeMode.files.length;
                        i++) {
                      mTotalFileByteCount +=
                          mPCT513FirmwareUpgradeMode.files[i].fileSize;
                    }
                    OwonLog.e("=====>>>>513mUpgradeCount$mUpgradeCount");
                  } else {
                    mUpgradeVersion = mCurrentVersion;
                  }
                });
              }
            }
          }
        }
      } else if (msg["type"] == "string") {
        String payload = msg["payload"];
        if (topic.contains("upgradestate")) {
          Map<String, dynamic> state = jsonDecode(payload);
          FirmwareUpgradeStateModeEntity firmwareUpgradeStateModeEntity =
              FirmwareUpgradeStateModeEntity.fromJson(state);
          switch (firmwareUpgradeStateModeEntity.state) {
            case 0:
              if (mUpgradeCount == 3) {
                mUpgradeCount -=1;
                startUpgrade();
              } else {
                showUpgradSuccess();
              }
              break;
            case 1:
              OwonLog.e(
                  "1111------->$mLastTimeProgress=====>>>${firmwareUpgradeStateModeEntity.progress}");
              mTotalRecByteCount = mTotalRecByteCount +
                  (firmwareUpgradeStateModeEntity.progress - mLastTimeProgress);

              if (mOwonDialog == null) {
                showUpgrading();
                OwonLog.e("owon dialog is null");
              } else {
                OwonLog.e("owon dialog is not null");
                mStateSetter(() {
                  mUpgradeProgress =
                      ((mTotalRecByteCount / mTotalFileByteCount) * 100)
                          .toInt();
                  OwonLog.e(
                      "---->mUpgradeProgress$mUpgradeProgress---->mTotalRecByteCount$mTotalRecByteCount---->mTotalFileByteCount$mTotalFileByteCount");
                });
              }
              mLastTimeProgress = firmwareUpgradeStateModeEntity.progress;
              OwonLog.e("2222------->$mLastTimeProgress");
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
//    OwonLoading(context).show();
    List attrsList = [
      "deviceid",
      "versionname",
    ];
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

  showConfirmUpgrade() {
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
        //点击背景不消失
        barrierDismissible: false,
        builder: (ctx) {
          //StatefulBuilder 来构建 dialog
          //使用参数 state来更新 dialog 中的数据内容
          return StatefulBuilder(builder: (ctx, state) {
            mStateSetter = state;
            //创建dialog
            return ShowCommonAlert(
              negativeText: S.of(ctx).global_cancel,
              isShowTitleDivide: false,
              isShowBottomDivide: true,
              onCloseEvent: () {
                Navigator.pop(ctx);
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
        //点击背景不消失
        barrierDismissible: false,
        builder: (ctx) {
          //StatefulBuilder 来构建 dialog
          //使用参数 state来更新 dialog 中的数据内容
          return StatefulBuilder(builder: (ctx, state) {
            mStateSetter = state;
            //创建dialog
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
        //点击背景不消失
        barrierDismissible: false,
        builder: (ctx) {
          //StatefulBuilder 来构建 dialog
          //使用参数 state来更新 dialog 中的数据内容
          return StatefulBuilder(builder: (ctx, state) {
            mStateSetter = state;
            //创建dialog
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
    OwonLog.e(
        "----count$mUpgradeCount======>>>mTotalFileByteCount$mTotalFileByteCount");
    Map p = Map();
    if (mUpgradeCount == 1 || mUpgradeCount == 3) {
      p["firmwaretype"] = mPCT513FirmwareUpgradeMode.firmwaretype;
      p["version"] = mUpgradeVersion;
      p["filenum"] = mPCT513FirmwareUpgradeMode.files.length;
      p["file"] = mPCT513FirmwareUpgradeMode.files;
      p["url"] = mPCT513FirmwareUpgradeMode.url;
    } else if (mUpgradeCount == 2) {
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
//        color: Colors.red,
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
                      "${S.of(context).device_info_current_version}$mCurrentVersion",
                      style: TextStyle(
                          fontSize: 20,
                          color: OwonColor().getCurrent(context, "textColor")),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                        "${S.of(context).device_info_upgrade_version}$mUpgradeVersion",
                        style: TextStyle(
                            fontSize: 20,
                            color:
                                OwonColor().getCurrent(context, "textColor"))),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                        "${S.of(context).device_info_wifi_current_version}$mWifiCurrentVersion",
                        style: TextStyle(
                            fontSize: 20,
                            color:
                                OwonColor().getCurrent(context, "textColor"))),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                        "${S.of(context).device_info_wifi_upgrade_version}$mWifiUpgradeVersion",
                        style: TextStyle(
                            fontSize: 20,
                            color:
                                OwonColor().getCurrent(context, "textColor"))),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  height: OwonConstant.systemHeight,
                  width: double.infinity,
                  child: OwonTextIconButton.icon(
//                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(OwonConstant.cRadius),
                      ),
                      onPressed: () {
                        if (mUpgradeCount == 0) {
                          OwonToast.show("已是最新固件");
                          return;
                        } else {
                          mTotalRecByteCount = 0;
                          showConfirmUpgrade();
                        }
                      },
                      icon: SvgPicture.asset(
                        OwonPic.dSettingUpgrade,
                        width: 25,
                        color: OwonColor().getCurrent(context, "textColor"),
                      ),
                      label: Text(
                        S.of(context).device_info_upgrade,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      iconTextAlignment: TextIconAlignment.iconRightTextLeft)),
            )
          ],
        ),
      ),
    );
  }
}
