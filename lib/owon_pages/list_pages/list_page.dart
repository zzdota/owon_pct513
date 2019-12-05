import 'dart:convert';

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
            IconButton(icon: Icon(Icons.add,color: OwonColor().getCurrent(context, "textColor"),
              size: 30,))
          ],
        ),
        body: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return Container(
                height: 110,
                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Card(
                  shape:  RoundedRectangleBorder(
                    side: BorderSide(
                      color:  OwonColor().getCurrent(context, "borderNormal"),
                      width: 1.0,
                    ),
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  child: FlatButton (
                    child: Text("hkkljljk",style: TextStyle(
                      color:  OwonColor().getCurrent(context, "textColor"),
                    ),),
                    onPressed: () async{
                      print("button");
                      var url = "https://gn1.owon.com:8443/accsystem/api/json";
                      Map param = Map();
                      param["account"] = "86-18559697016";
                      param["cversion"] = "2.2.7";
                      param["os"] = "iOS_13.2.2";
                      param["password"] = "63ab9508485e131f946ce59ab9b3b687";

                      var p = Map<String, dynamic>();
                      p["ts"] = 628682130;
                      p["type"] = "/nt/user/applogin";
                      p["param"] = param;

                    OwonHttp.getInstance().post(url, p, (data){
                      OwonLog.e("===data=$data");
                    },(e){});
//                    OwonHttp.getInstance().get("http://www.baidu.com", (data){}, (e){});
                    },
                  ),
                ),
              );
            }));
  }
}
