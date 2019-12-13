import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:owon_pct513/res/owon_constant.dart';
import '../res/owon_themeColor.dart';

class OwonTextField {
  static Widget textField(BuildContext context,
      TextEditingController textEditingController, String hint, String imageUrl,
      {double width = double.infinity}) {
    return Container(
      width: width,
      child: Theme(
        data: ThemeData(
            primaryColor: OwonColor().getCurrent(context, "textfieldColor"),
            highlightColor: Colors.blue),
        child: TextField(
            controller: textEditingController,
            maxLines: 1,
            autofocus: false,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: OwonColor().getCurrent(context, "textColor"),
                fontSize: 20.0),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              filled: false,
//            fillColor: OwonColor().getCurrent(context, "itemColor"),
//              hoverColor: Colors.red,
//              fillColor: Colors.blue,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Container(
                    child: SvgPicture.asset(
                  imageUrl,
                  color: OwonColor().getCurrent(context, "orange"),
                  width: 5,
                )),
              ),
//            border: InputBorder(bo),
//            enabledBorder: OutInputBorder(
//              borderSide: BorderSide(
//                  color: Colors.red),
//            ),
//            focusedBorder: OutlineInputBorder(
//              borderSide: BorderSide(
//                  color: OwonColor().getCurrent(
//                      context, "borderNormal")),
//            ),
              hintText: hint,
              hintStyle: TextStyle(
                  fontSize: 14,
                  color: OwonColor().getCurrent(context, "textColor")),
            )),
      ),
    );
  }
}
