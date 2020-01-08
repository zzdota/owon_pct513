import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:owon_pct513/component/owon_header.dart';
import 'package:owon_pct513/owon_api/model/address_model_entity.dart';
import 'package:owon_pct513/owon_providers/owon_evenBus/list_evenbus.dart';
import 'package:owon_pct513/owon_utils/owon_loading.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:owon_pct513/owon_utils/owon_mqtt.dart';
import 'package:owon_pct513/owon_utils/owon_toast.dart';
import 'package:owon_pct513/res/owon_constant.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import 'package:owon_pct513/res/owon_sequence.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../generated/i18n.dart';
enum FromPage {
  blank,

  list,

  devices
}
class AddressEditPage extends StatefulWidget {
  AddressModelAddr addrModel;
  FromPage isFromPage;
  AddressEditPage(this.addrModel,this.isFromPage);
  @override
  _AddressEditPageState createState() => _AddressEditPageState();
}

class _AddressEditPageState extends State<AddressEditPage> {
  var _homeVC = TextEditingController();
  var _addressVC = TextEditingController();
  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;

  @override
  void initState() {
    super.initState();
    _homeVC.text = (widget.addrModel.addrname == null?"":widget.addrModel.addrname);
    _addressVC.text = (widget.addrModel.addrdesc== null?"":widget.addrModel.addrdesc);
    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
      String topic = msg["topic"];

      if (msg["type"] == "json") {
        Map<String, dynamic> payload = msg["payload"];

        if (payload["command"] == "addr.add") {

          if(widget.isFromPage == FromPage.blank){
            OwonLoading(context).hide().then((e) {
              OwonToast.show(S.of(context).global_save_success);
              Navigator.of(context)..pop()..pop();
            });
            OwonLog.e("----回复的payload=$payload");
          }else if(widget.isFromPage == FromPage.list){
            OwonLoading(context).hide().then((e) {
              OwonToast.show(S.of(context).global_save_success);
              Navigator.of(context)..pop();
            });
            OwonLog.e("----回复的payload=$payload");
          }


        }else if (payload["command"] == "addr.update") {
          OwonLoading(context).hide().then((e) {
            OwonToast.show(S.of(context).global_save_success);
            Navigator.of(context)..pop();
          });
          OwonLog.e("----回复update的payload=$payload");

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

  addAddress() async {


    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic = "api/cloud/$clientID";
    Map p = Map();
    p["command"] = "addr.add";
    p["sequence"] = OwonSequence.temp;
    p["addrname"] = _homeVC.text;
    p["addrdesc"] = _addressVC.text;
    p["lon"] = 118.08;
    p["lat"] = 24.48;
    p["fencingscope"] = 100;

    var msg = JsonEncoder.withIndent("  ").convert(p);
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }

  updateAddress() async {


    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic = "api/cloud/$clientID";
    Map p = Map();
    p["command"] = "addr.update";
    p["sequence"] = OwonSequence.temp;
    p["addrname"] = _homeVC.text;
    p["addrdesc"] = _addressVC.text;
    p["lon"] = widget.addrModel.lon;
    p["lat"] = widget.addrModel.lat;
    p["fencingscope"] = widget.addrModel.fencingscope;
    p["addrid"] = widget.addrModel.addrid;


    var msg = JsonEncoder.withIndent("  ").convert(p);
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }





  @override
  void dispose() {
    super.dispose();
    _listEvenBusSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: () {
//              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                return AddressEditPage();
//              }));
               OwonLoading(context).show();
              if(widget.isFromPage == FromPage.list) {
                addAddress();

              }else if(widget.isFromPage == FromPage.devices){
                updateAddress();

              }else if(widget.isFromPage == FromPage.blank){
                addAddress();

              }
            },
            child: Text(
              S.of(context).global_save,
              style: TextStyle(
                  fontSize: 18,
                  color: OwonColor().getCurrent(context, "textColor")),
            ),
          )
        ],
        title: Text("Edit Home"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Container(
                padding: EdgeInsets.only(left: 40),
                child: OwonHeader.normalHeader(context, OwonPic.addressLocation,
                    "Give your Home a name and address",
                    subTitle:
                        "This gives your Devices access to smart features",
                    width: 150,
                    fontSize: 20)),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TextField(
//          autofocus: true,
                  style: TextStyle(
                      color: OwonColor().getCurrent(
                        context,
                        "textColor",
                      ),
                      fontSize: 24.0),
                  controller: _homeVC,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.edit,
                      color: OwonColor().getCurrent(context, "orange"),
                    ),
                    labelText: S.of(context).dSet_rename_tip,
                    labelStyle: TextStyle(
                        fontSize: 17,
                        color: OwonColor().getCurrent(context, "textColor")),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15.0),
                    filled: false,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: OwonColor()
                              .getCurrent(context, "textfieldColor")),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: OwonColor()
                              .getCurrent(context, "textfieldColor")),
                    ),
//              hintText: S.of(context).dSet_rename_tip,
//              hintStyle: TextStyle(
//                  fontSize: 14,
//                  color: OwonColor().getCurrent(context, "textColor")),
                  )),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
//          autofocus: true,
                          style: TextStyle(
                              color: OwonColor().getCurrent(
                                context,
                                "textColor",
                              ),
                              fontSize: 24.0),
                          controller: _addressVC,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.edit,
                              color: OwonColor().getCurrent(context, "orange"),
                            ),
                            labelText: S.of(context).dSet_rename_tip,
                            labelStyle: TextStyle(
                                fontSize: 17,
                                color: OwonColor()
                                    .getCurrent(context, "textColor")),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            filled: false,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: OwonColor()
                                      .getCurrent(context, "textfieldColor")),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: OwonColor()
                                      .getCurrent(context, "textfieldColor")),
                            ),
//              hintText: S.of(context).dSet_rename_tip,
//              hintStyle: TextStyle(
//                  fontSize: 14,
//                  color: OwonColor().getCurrent(context, "textColor")),
                          )),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 30),
                        width: 60,
                        child: Image.asset(
                          OwonPic.addressShowLocal,
                          width: 50,
                        )),
                  ],
                )),
          ],
        ),
      ),
    );
    ;
  }
}
