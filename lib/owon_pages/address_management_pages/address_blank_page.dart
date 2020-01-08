import 'package:flutter/material.dart';
import 'package:owon_pct513/component/owon_header.dart';
import 'package:owon_pct513/owon_api/model/address_model_entity.dart';
import 'package:owon_pct513/owon_pages/address_management_pages/address_edit_page.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:owon_pct513/owon_utils/owon_text_icon_button.dart';
import 'package:owon_pct513/owon_utils/owon_toast.dart';
import 'package:owon_pct513/res/owon_constant.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import 'package:owon_pct513/res/owon_sequence.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';
import '../../generated/i18n.dart';

class AddressBlankPage extends StatefulWidget {
  AddressModelAddr addrModel;
  AddressBlankPage();
  @override
  _AddressBlankPageState createState() => _AddressBlankPageState();
}

class _AddressBlankPageState extends State<AddressBlankPage> {
  double leftRightPadding = 50.0;

  @override
  void initState() {
    super.initState();
    widget.addrModel = AddressModelAddr(addrid: 1, addrname: "", devlist: []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Container(
                padding: EdgeInsets.fromLTRB(leftRightPadding, 100, leftRightPadding, 80),
                child: OwonHeader.baseHeader(context, "Introduceing Home",
                    imageWidget: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Image.asset(
                        OwonPic.addressHomeColorful,
                        width: 90,
                      ),
                    ),
                    subtitleStyle: TextStyle(
                        fontSize: 32,
                        color: OwonColor().getCurrent(context, "textColor")))),

            Container(
              child: Image.asset(
                OwonPic.addressHomeColorful,
                width: 200,
              ),
            ),
            Container(
              child:Padding(padding: EdgeInsets.fromLTRB(leftRightPadding,30,leftRightPadding,0),child:
                Text("Your devices will be organized by homes which will allow your devices to work better together",style: TextStyle(
                    fontSize: 24,
                    color: OwonColor().getCurrent(context, "textColor"))),),),


            Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 50),
              child: Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  height: OwonConstant.systemHeight,
                  width: double.infinity,
                  child: OwonTextIconButton.icon(
//                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(OwonConstant.cRadius),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddressEditPage(widget.addrModel, FromPage.blank)));
                      },
                      icon: Icon(
                        Icons.save_alt,
                        color: Colors.white,
                      ),
                      label: Text(
                        S.of(context).global_save,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      iconTextAlignment: TextIconAlignment.iconRightTextLeft)),
            )


          ],
        ),
      ),
    );
    ;
  }
}
