import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:owon_pct513/owon_pages/list_pages/list_page.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import '../../generated/i18n.dart';

class ConfigTipsPage extends StatefulWidget {
  @override
  _ConfigTipsPageState createState() {
    return _ConfigTipsPageState();
  }
}

class _ConfigTipsPageState extends State<ConfigTipsPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ListPage();
            }))
          },
        ),
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
                  flex: 1,
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
                                  image: AssetImage(OwonPic.mConfigTipnumberBG),
                                ),
                              ),
                              Text(
                                "1",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 35.0),
                              )
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
                              S.of(context).configtipspage_tips,
                              style: TextStyle(color: Colors.white),
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
                  flex: 5,
                  child: Image.asset(OwonPic.mConfigTipsImg),
                ),
                Spacer(
                  flex: 1,
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                      width: double.infinity,
                      child: FlatButton(
                          child: Text(S.of(context).general_next),
                          textColor: Colors.white,
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          onPressed: () => Navigator.pushNamed(
                              context, "configoperatepage")),
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
