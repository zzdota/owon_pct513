import 'package:flutter/material.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';
import '../../generated/i18n.dart';

class DeviceRenamePage extends StatelessWidget {
  var _tfVC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).dSet_rename),
        actions: <Widget>[
          FlatButton(
//            splashColor: Colors.red,
            onPressed: () {

              OwonLog.e("save is tap text${_tfVC.text}");
            },
            child: Text(
              S.of(context).global_save,
              style: TextStyle(
                  color: OwonColor().getCurrent(
                    context,
                    "textColor",
                  ),
                  fontSize: 22),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: TextField(
//          autofocus: true,
            style: TextStyle(
              color: OwonColor().getCurrent(
                context,
                "textColor",
              ),
              fontSize: 24.0
            ),
            controller: _tfVC,
            decoration: InputDecoration(
              labelText: S.of(context).dSet_rename_tip,
              labelStyle:  TextStyle(
                  fontSize: 14,
                  color: OwonColor().getCurrent(context, "blue")),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              filled: false,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: OwonColor().getCurrent(context, "textfieldColor")),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: OwonColor().getCurrent(context, "textfieldColor")),
              ),
//              hintText: S.of(context).dSet_rename_tip,
//              hintStyle: TextStyle(
//                  fontSize: 14,
//                  color: OwonColor().getCurrent(context, "textColor")),
            )),
      ),
    );
  }
}
