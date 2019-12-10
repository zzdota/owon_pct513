import 'dart:async';
import 'package:flutter/material.dart';
import 'package:owon_pct513/owon_pages/management_page/management_page.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import '../../owon_utils/owon_log.dart';
import '../../res/owon_themeColor.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final SlidableController slidableController = SlidableController();
  EasyRefreshController refreshController = EasyRefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Text(""),
          title: Text("List"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
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
              enableInfiniteLoad: false
              ),
          onRefresh: () async {
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
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ManagementPage()));
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
                                          color: OwonColor()
                                              .getCurrent(context, "textColor")),
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
                          caption: 'Delete',
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
            "连接断开",
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
