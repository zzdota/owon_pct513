import 'package:flutter/material.dart';
import 'package:owon_pct513/component/owon_header.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';
import '../../generated/i18n.dart';

class AddressEditPage extends StatefulWidget {
  @override
  _AddressEditPageState createState() => _AddressEditPageState();
}

class _AddressEditPageState extends State<AddressEditPage> {

  var _tfVC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: (){
//              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                return AddressEditPage();
//              }));
            },
            child: Text(
              S.of(context).global_save,
              style: TextStyle(
                  fontSize: 18,
                  color: OwonColor().getCurrent(context, "textColor")),
            ),
          )
        ],
        title: Text("Edit Home"),
      ),
      body:Container(
        child:Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Container(
                padding: EdgeInsets.only(left: 40),
                child: OwonHeader.normalHeader(
                    context, OwonPic.addressLocation, "Give your Home a name and address",
                    subTitle:
                    "This gives your Devices access to smart features",
                    width: 150,
                    fontSize: 20)),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TextField(
//          autofocus: true,
                  style: TextStyle(
                      color: OwonColor().getCurrent(
                        context,
                        "textColor",
                      ),
                      fontSize: 24.0),
                  controller: _tfVC,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.edit,
                      color: OwonColor().getCurrent(context, "orange"),
                    ),
                    labelText: S.of(context).dSet_rename_tip,
                    labelStyle: TextStyle(
                        fontSize: 17,
                        color: OwonColor().getCurrent(context, "textColor")),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15.0),
                    filled: false,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: OwonColor()
                              .getCurrent(context, "textfieldColor")),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: OwonColor()
                              .getCurrent(context, "textfieldColor")),
                    ),
//              hintText: S.of(context).dSet_rename_tip,
//              hintStyle: TextStyle(
//                  fontSize: 14,
//                  color: OwonColor().getCurrent(context, "textColor")),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
//          autofocus: true,
                        style: TextStyle(
                            color: OwonColor().getCurrent(
                              context,
                              "textColor",
                            ),
                            fontSize: 24.0),
                        controller: _tfVC,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.edit,
                            color: OwonColor().getCurrent(context, "orange"),
                          ),
                          labelText: S.of(context).dSet_rename_tip,
                          labelStyle: TextStyle(
                              fontSize: 17,
                              color: OwonColor().getCurrent(context, "textColor")),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          filled: false,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: OwonColor()
                                    .getCurrent(context, "textfieldColor")),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: OwonColor()
                                    .getCurrent(context, "textfieldColor")),
                          ),
//              hintText: S.of(context).dSet_rename_tip,
//              hintStyle: TextStyle(
//                  fontSize: 14,
//                  color: OwonColor().getCurrent(context, "textColor")),
                        )),
                  ),
                  Container(margin: EdgeInsets.only(left: 30),
                      width:60,child: Image.asset(OwonPic.addressShowLocal,width: 50,)),
                ],
              )
            ),
          ],
        ),
      ),
    );;
  }
}
