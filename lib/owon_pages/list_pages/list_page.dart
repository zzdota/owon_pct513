import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:owon_pct513/owon_providers/theme_provider.dart';
import '../../owon_utils/owon_log.dart';
import '../../owon_utils/owon_http.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import '../../res/owon_themeColor.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
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
        body: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return Container(
                height: 110,
                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Card(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color:
                              OwonColor().getCurrent(context, "borderNormal"),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                "assets/images/launch_icon.png",
                                fit: BoxFit.contain,
                                height: 40,
                              ),
                              SizedBox(
                                height: 5,
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
              );
            }));
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
}
