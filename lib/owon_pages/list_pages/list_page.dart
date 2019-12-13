import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:owon_pct513/owon_pages/management_page/management_page.dart';
import '../../owon_utils/owon_mqtt.dart';
import '../../res/owon_constant.dart';
import '../../res/owon_picture.dart';
import '../../owon_utils/owon_log.dart';
import '../../res/owon_themeColor.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../generated/i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../owon_providers/owon_evenBus/list_evenbus.dart';
import '../../owon_api/model/address_model_entity.dart';
class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final SlidableController slidableController = SlidableController();
  EasyRefreshController refreshController = EasyRefreshController();
  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;
  @override
  void dispose() {
    _listEvenBusSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
//      OwonLog.e("canvas =>>>>topic=${msg["topic"]}");
      OwonLog.e("canvas =>>>>payload=${msg["payload"]}");
      Map<String, dynamic> payload = msg["payload"];
//      OwonLog.e("canvas =>>>>cmd=${payload["command"]}");
//      OwonLog.e("canvas =>>>>addrs=${payload["addrs"]}");
      String cmd = AddressModelEntity.fromJson(payload).addrs[0].addrname;
      OwonLog.e("canvas =>>>>cmd=$cmd");
    });
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      toGetList();
    });
  }

  toGetList() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    var clientID = pre.get(OwonConstant.clientID);
    String topic = "api/cloud/$clientID";
    Map p = Map();
    p["command"] = "addr.dev.list";
    var msg = JsonEncoder.withIndent("  ").convert(p);
    OwonMqtt.getInstance().publishMessage(topic, msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Text(""),
          title: GestureDetector(child: Text(S.of(context).global_thermostat),onTap: (){
            print("----");
           return showMenu(
             context: context,
             items: <PopupMenuEntry>[
               //items 子项
               PopupMenuItem(
                 value: 0,
                 child: Text('Item 1'),
               ),
               PopupMenuDivider(),
               PopupMenuItem(
                 value: 1,
                 child: Text('Item 2'),
               ),
               // 分割线
               PopupMenuDivider(),
               // 带有复选标记的子项
               PopupMenuItem(
                 value: 2,
                 child: Text('Item 3'),
               ),
             ],
             position: RelativeRect.fromLTRB(100, 88, 100, 200),
           ).then((e){
             if(e == 2) {
               OwonLog.e("index=$e");
             }
           });
          },),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.add,
                  color: OwonColor().getCurrent(context, "textColor"),
                  size: 30,
                ))
          ],
        ),
        body: EasyRefresh(
          controller: refreshController,
          header: ClassicalHeader(
            textColor: OwonColor().getCurrent(context, "textColor"),
          ),
          footer: ClassicalFooter(
              textColor: OwonColor().getCurrent(context, "textColor"),
              enableInfiniteLoad: false),
          onRefresh: () async {
            toGetList();
            OwonLog.e("refresh");
          },
          onLoad: () async {
            OwonLog.e("load");
          },
          child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return Slidable(
                  key: Key(index.toString()),
                  controller: slidableController,
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  enabled: true,
                  dismissal: SlidableDismissal(
                    dismissThresholds: {SlideActionType.secondary: 0.6},
                    child: SlidableDrawerDismissal(),
                    onDismissed: (actionType) {
                      OwonLog.e("什么时候调用 啊");
                    },
                    onWillDismiss: (actionType) {
                      return _slideDelete(index);
                    },
                  ),
                  child: Container(
                    height: 110,
                    padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ManagementPage()));
                      },
                      child: Card(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: OwonColor()
                                    .getCurrent(context, "borderNormal"),
                                width: 1.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
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
                                      "PCT513",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: OwonColor().getCurrent(
                                              context, "textColor")),
                                    ),
                                  ],
                                ),
                                getRightWidget(true)
                              ],
                            ),
                          )),
                    ),
                  ),
                  secondaryActions: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      child: IconSlideAction(
                          caption: S.of(context).global_delete,
                          color: Colors.red,
                          icon: Icons.delete,
                          closeOnTap: true,
                          onTap: () {
                            _tapDelete(index);
                          }),
                    ),
                  ],
                );
              }),
        ));
  }

  Widget getRightWidget(bool normal) {
    if (normal) {
      return Icon(
        Icons.keyboard_arrow_right,
        color: OwonColor().getCurrent(context, "textColor"),
      );
    } else {
      return Row(
        children: <Widget>[
          Image.asset(
            "assets/images/launch_icon.png",
            fit: BoxFit.contain,
            height: 20,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            S.of(context).list_disconnect,
            style: TextStyle(
                color: OwonColor().getCurrent(context, "borderDisconnect")),
          )
        ],
      );
    }
  }

  FutureOr<bool> _slideDelete(int index) {
    OwonLog.e("====$index");
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete'),
          content: Text('Item will be deleted'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  _tapDelete(int index) {
    OwonLog.e("点击了删除index=$index");
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete'),
          content: Text('Item will be deleted'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }
}
