import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import '../../generated/i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../owon_providers/owon_evenBus/list_evenbus.dart';
import 'dart:async';
import '../../owon_utils/owon_mqtt.dart';
import '../../owon_pages/home_page.dart';

class ConfigSuccessPage extends StatefulWidget {
  @override
  _ConfigSuccessPageState createState() {
    return _ConfigSuccessPageState();
  }
}

class _ConfigSuccessPageState extends State<ConfigSuccessPage> {
  SharedPreferences msharepreferencesutil;
  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;
  TextEditingController renameController = TextEditingController();
  String deviceid = "";

  @override
  void initState() {
    super.initState();
    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
      String topic = msg["topic"];

      if (msg["type"] == "json") {
        Map<String, dynamic> payload = msg["payload"];
      } else if (msg["type"] == "string") {
        String payload = msg["payload"];
        if (topic == "") {
        } else if (topic == "") {
        } else if (topic == "") {
        } else if (topic == "") {}
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initUtil() async {
    msharepreferencesutil = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (deviceid == "") {
      Map args = ModalRoute.of(context).settings.arguments;
      deviceid = args['deviceid'];
    }
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: Text(""),
        title: Text(S.of(context).configoperatepage_title),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Image.asset(
              OwonPic.mDivideLineHori,
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Spacer(
                  flex: 1,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Image(
                                  image: AssetImage(OwonPic.mConfigSuccessIcon),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          color: Colors.white,
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                            child: Text(
                              S.of(context).configsuccesspage_tip,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 10,
                        ),
                        TextField(
                          style: TextStyle(fontSize: 15.0, color: Colors.white),
                          controller: renameController,
                          decoration: InputDecoration(
                              hintText: S.of(context).general_rename,
                              hintStyle: TextStyle(color: Colors.white),
                              icon: Icon(Icons.edit, color: Colors.orange)),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                Expanded(
                  flex: 4,
                  child: Image.asset(OwonPic.mConfigSuccessImg),
                ),
                Spacer(
                  flex: 2,
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                      width: double.infinity,
                      child: FlatButton(
                        child: Text(S.of(context).general_complete),
                        textColor: Colors.white,
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        onPressed: () {
                          String topic =
                              "device/$deviceid/attribute/DeviceName";
                          String payload = renameController.text;
                          OwonMqtt.getInstance().publishMessage(topic, payload);
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return HomePage();
                          }));
                        },
                        disabledColor: Color.fromRGBO(89, 87, 87, 1),
                      ),
                    )),
                Spacer(
                  flex: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
