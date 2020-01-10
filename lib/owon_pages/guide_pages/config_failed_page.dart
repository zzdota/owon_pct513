import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import '../../generated/i18n.dart';

class ConfigFailedPage extends StatefulWidget {
  @override
  _ConfigFailedPageState createState() {
    return _ConfigFailedPageState();
  }
}

class _ConfigFailedPageState extends State<ConfigFailedPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: Text(""),
        title: Text(S.of(context).configtipspage_title),
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
                  flex: 4,
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
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
                                  image: AssetImage(OwonPic.mConfigFailedImg),
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
                            padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                            child: Text(
                              S.of(context).configfailedpage_tip,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(
                  flex: 4,
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                      width: double.infinity,
                      child: FlatButton(
                          child: Text(S.of(context).configfailedpage_retry),
                          textColor: Colors.white,
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          onPressed: () =>
                              Navigator.pushNamed(context, "configtipspage")),
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
