import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:owon_pct513/owon_pages/management_page/management_page.dart';
import 'package:owon_pct513/owon_utils/owon_loading.dart';
import 'package:owon_pct513/owon_utils/owon_mqtt.dart';
import 'package:owon_pct513/res/owon_constant.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import 'package:owon_pct513/res/owon_sequence.dart';
import '../../owon_utils/owon_log.dart';
import '../../res/owon_themeColor.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../generated/i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../owon_providers/owon_evenBus/list_evenbus.dart';
import 'package:cool_ui/cool_ui.dart';
import '../../owon_api/model/address_model_entity.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final SlidableController slidableController = SlidableController();
  EasyRefreshController refreshController = EasyRefreshController();
  StreamSubscription<Map<dynamic, dynamic>> _listEvenBusSubscription;
  AddressModelEntity _addrModels = AddressModelEntity(
      addrs: [AddressModelAddr(addrid: 1, addrname: "默认地址1")]);
  AddressModelAddr _addressModel =
      AddressModelAddr(addrid: 1, addrname: "...", devlist: []);
  @override
  void initState() {
    _listEvenBusSubscription =
        ListEventBus.getDefault().register<Map<dynamic, dynamic>>((msg) {
          String topic = msg["topic"];

          if(msg["type"] == "json"){
        Map<String, dynamic> payload = msg["payload"];
        OwonLoading(context).dismiss();
        setState(() {
          _addrModels = AddressModelEntity.fromJson(payload);
          _addressModel = _addrModels.addrs.first;
          _addrModels.addrs.forEach((item){
            item.devlist.forEach((deviceItem){
              String deviceId = deviceItem.deviceid;
              String deviceTopic = "device/$deviceId/#";

              OwonMqtt.getInstance().subscribeMessage(deviceTopic);


            });
          });
        });
      }else if (msg["type"] == "string"){

        String payload = msg["payload"];
        if(topic == ""){

        }else if(topic == ""){

        }else if(topic == ""){

        }else if(topic == ""){

        }

        OwonLog.e("----list上报的payload=$payload");

      }
    });
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      OwonLoading(context).show();
    });
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
    p["sequence"] = OwonSequence.addList;
    var msg = JsonEncoder.withIndent("  ").convert(p);
    OwonMqtt.getInstance().publishMessage(topic, msg);



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Text(""),
          title: GestureDetector(
            onTap: () {
              OwonLog.e("-----title");
            },
            child: _buildPopoverButton(_addressModel, _addrModels.addrs),
          ),
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
        body: (_addressModel.devlist == null ||
                _addressModel.devlist.length == 0)
            ? Center(
                child: Text(
                  "当前家庭没有设备",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : EasyRefresh(
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
                    itemCount: _addressModel.devlist.length,
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
                          height: OwonConstant.listHeight,
                          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ManagementPage(_addressModel.devlist[index])));
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                            _addressModel
                                                .devlist[index].devname,
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

  Widget _buildPopoverButton(AddressModelAddr addrModel, List addrList) {
    String btnTitle = addrModel.addrname;
    return Container(
        child: CupertinoPopoverButton(
            radius: OwonConstant.cRadius,
            popoverConstraints: BoxConstraints(
              minWidth: 50,
              maxWidth: 210.99,
              minHeight: 250,
              maxHeight: 400,
            ),
            child: Container(
              alignment: Alignment.center,
              width: 203, //支持28个单词了
              height: 55,
//              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        btnTitle,
                        style: TextStyle(
                            color: OwonColor().getCurrent(context, "textColor"),
                            fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      )),
                  Icon(Icons.keyboard_arrow_down,
                      size: 20.0,
                      color: OwonColor().getCurrent(context, "textColor")),
                ],
              ),
            ),
            popoverBuild: (context) {
              return CupertinoPopoverMenuList(
                  children: createAddrWidget(addrList));
            }));
  }

  List<Widget> createAddrWidget(List addressList) {
    if (addressList.length == 0) return [];
    List<Widget> desList = [];

    addressList.forEach((value) {
      AddressModelAddr addrModel = value;
      desList.add(Container(
        height: 30,
        margin: EdgeInsets.all(10),
        child: CupertinoPopoverMenuItem(
          child: Text(addrModel.addrname),
          onTap: () {
            print("-----$value");
            setState(() {
              _addressModel = value;
            });
            return false;
          },
        ),
      ));
    });
    return desList;
  }
}
