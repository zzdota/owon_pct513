import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:owon_pct513/component/owon_header.dart';
import 'package:owon_pct513/owon_api/model/address_model_entity.dart';
import 'package:owon_pct513/owon_pages/address_management_pages/address_edit_page.dart';
import 'package:owon_pct513/owon_providers/owon_evenBus/list_evenbus.dart';
import 'package:owon_pct513/owon_utils/owon_loading.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:owon_pct513/owon_utils/owon_mqtt.dart';
import 'package:owon_pct513/owon_utils/owon_text_icon_button.dart';
import 'package:owon_pct513/owon_utils/owon_toast.dart';
import 'package:owon_pct513/res/owon_constant.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import 'package:owon_pct513/res/owon_sequence.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../generated/i18n.dart';

class AddressDevicesPage extends StatefulWidget {
  AddressModelAddr addrModel;
  AddressDevicesPage(this.addrModel);
  @override
  _AddressDevicesPageState createState() => _AddressDevicesPageState();
}

class _AddressDevicesPageState extends State<AddressDevicesPage> {
  bool hadDevice = true;
  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;

  @override
  void initState() {
    super.initState();

    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
          String topic = msg["topic"];

          if (msg["type"] == "json") {
            Map<String, dynamic> payload = msg["payload"];

            if (payload["command"] == "addr.del") {
              OwonLoading(context).hide().then((e) {
                OwonToast.show(S.of(context).global_save_success);
                Navigator.of(context).pop();
              });
              OwonLog.e("----回复的payload=$payload");

            }else if (payload["command"] == "addr.update") {
              OwonLoading(context).hide().then((e) {
                OwonToast.show(S.of(context).global_save_success);
                Navigator.of(context).pop();
              });
              OwonLog.e("----回复的payload=$payload");

            }
          } else if (msg["type"] == "string") {
            String payload = msg["payload"];
            if (topic.startsWith('reply') && topic.contains('VactionSchedule')) {
              OwonLoading(context).hide().then((e) {
                OwonToast.show(S.of(context).global_save_success);
              });
            }

            OwonLog.e("----上报的payload=$payload");
          } else if (msg["type"] == "raw") {}
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return AddressEditPage(widget.addrModel,false);
              }));
            },
            child: Text(
              "Edit",
              style: TextStyle(
                  fontSize: 18,
                  color: OwonColor().getCurrent(context, "textColor")),
            ),
          )
        ],
        title: Text(widget.addrModel.addrname),
      ),
      body:
          hadDevice ? getHasDeviceWidget(context) : getNoDeviceWidget(context),
    );
  }


  deleteAddress() async {


    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic = "api/cloud/$clientID";
    Map p = Map();
    p["command"] = "addr.del";
    p["sequence"] = OwonSequence.temp;
    p["addrid"] = widget.addrModel.addrid;


    var msg = JsonEncoder.withIndent("  ").convert(p);
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }

  Widget getHasDeviceWidget(context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 60,
          ),
          Container(
              padding: EdgeInsets.only(left: 20),
              child: OwonHeader.normalHeader(
                  context, OwonPic.addressHomeColorful, widget.addrModel.addrname,
                  subTitle:
                  widget.addrModel.addrdesc,
                  width: 180,
                  fontSize: 20)),
          SizedBox(
            height: 20,
          ),
          Container(
            height: (widget.addrModel.devlist.length > 4
                ? 4 * 120
                : widget.addrModel.devlist.length * 120.0),
            child: ListView.builder(
                physics: (widget.addrModel.devlist.length > 4
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics()),
                itemCount: widget.addrModel.devlist.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: OwonConstant.listHeight,
                    padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                    child: InkWell(
                      onTap: () {
//                      Navigator.of(context).push(MaterialPageRoute(
//                          builder: (context) => ManagementPage(
//                              _addressModel.devlist[index])));
                      },
                      child: Card(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: OwonColor()
                                    .getCurrent(context, "borderNormal"),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(OwonConstant.cRadius))),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      OwonPic.listPctIcon,
                                      fit: BoxFit.contain,
                                      height: 35,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      widget.addrModel.devlist[index].devname,
//                                    widget.addrModel
//                                        .devlist[index].devname,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: OwonColor().getCurrent(
                                              context, "textColor")),
                                    ),
                                  ],
                                ),
                                FlatButton(
                                  onPressed: () {
                                    OwonLog.e("---->");
                                  },
                                  child: Text("Move",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: OwonColor().getCurrent(
                                              context, "textColor"))),
                                )
                              ],
                            ),
                          )),
                    ),
                  );
                }),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              height: OwonConstant.systemHeight - 10,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: OwonTextIconButton.icon(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(OwonConstant.cRadius),
                  ),
                  onPressed: () {
                    OwonLoading(context).show();
                    deleteAddress();
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Delete Home",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  iconTextAlignment: TextIconAlignment.iconRightTextLeft))
        ],
      ),
    );
  }

  Widget getNoDeviceWidget(context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 60,
                ),
                Container(
                    padding: EdgeInsets.only(left: 20),
                    child: OwonHeader.normalHeader(
                        context, OwonPic.addressHomeColorful, "My home1",
                        subTitle:
                            "room 2 fu jian shen xia men shi si ming qu,zheng zhu wang chuang xing da sha B qu room 2 fu jian shen xia men shi si ming qu,zheng zhu wang chuang xing da sha B qu",
                        width: 180,
                        fontSize: 20)),
                SizedBox(
                  height: 20,
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    height: OwonConstant.systemHeight - 10,
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: OwonTextIconButton.icon(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(OwonConstant.cRadius),
                        ),
                        onPressed: () {},
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        label: Text(
                          S.of(context).vacation_delete,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        iconTextAlignment: TextIconAlignment.iconRightTextLeft))
              ],
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  OwonPic.addressNoDevice,
                  width: 60,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    padding: EdgeInsets.all(30),
                    child: OwonHeader.normalHeader(
                      context,
                      "",
                      "There is no devices in this Home",
                      width: 100,
                      alignment: MainAxisAlignment.center,
                      fontSize: 22,
                    ))
              ],
            )),
          ],
        ));
  }
}
