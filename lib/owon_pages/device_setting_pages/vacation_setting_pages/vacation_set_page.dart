import 'package:flutter/material.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import '../../../generated/i18n.dart';
import '../../../res/owon_themeColor.dart';

class VacationSettingPage extends StatefulWidget {
  @override
  _VacationSettingPageState createState() => _VacationSettingPageState();
}

class _VacationSettingPageState extends State<VacationSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).dSet_vacation),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
//            splashColor: Colors.red,
            onPressed: (){
            OwonLog.e("save is tap");
          }, child:
          Text(S.of(context).global_save,style: TextStyle(
              color:  OwonColor().getCurrent(context, "textColor",),fontSize: 22
          ),),
          ),
        ],
      ),
    );
  }
}
