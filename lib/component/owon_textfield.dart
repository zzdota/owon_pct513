import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../res/owon_themeColor.dart';

class OwonTextField {
  static Widget textField(
      BuildContext context,
      TextEditingController textEditingController,
      String hint,
      String imageUrl,
      FocusNode focusNode,
      bool offstage,
      {double width = double.infinity}) {
    return Container(
      width: width,
      child: TextField(
          controller: textEditingController,
          focusNode: focusNode,
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
            prefixIcon: Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Container(
                  child: SvgPicture.asset(
                imageUrl,
                color: OwonColor().getCurrent(context, "orange"),
                width: 5,
              )),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: OwonColor().getCurrent(context, "textfieldColor")),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: OwonColor().getCurrent(context, "textfieldColor")),
            ),
            suffixIcon: Offstage(
              offstage: offstage,
              child: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: OwonColor().getCurrent(context, "textColor"),
                ),
                onPressed: () {
                  textEditingController.clear();
                },
              ),
            ),
            hintText: hint,
            hintStyle: TextStyle(
                fontSize: 14,
                color: OwonColor().getCurrent(context, "textColor")),
          )),
    );
  }
}
