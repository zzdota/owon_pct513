import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';
import 'package:package_info/package_info.dart';
import '../../generated/i18n.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String appName;
  String version = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appName = packageInfo.appName;
      version = packageInfo.version;
      OwonLog.e("---$version");
      setState(() {

      });
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).set_about),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset("assets/images/launch_icon.png",width: 80,),
            SizedBox(height: 15,),
            Text(version,style: TextStyle(
                color: OwonColor().getCurrent(context, "textColor")
            ),)
          ],
        ),
      ),
    );
  }
}
