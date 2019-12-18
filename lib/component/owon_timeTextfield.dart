import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../res/owon_themeColor.dart';
class OwonTimeTextField extends TextField {

  OwonTimeTextField(BuildContext context,TextEditingController vc,VoidCallback myTap):super(
    onTap:myTap,
      controller:vc,
      style: TextStyle(color: OwonColor().getCurrent(context, "textColor"), fontSize: 20.0),
      decoration:InputDecoration(
        suffixIcon: Icon(Icons.keyboard_arrow_down,color: OwonColor().getCurrent(context, "textColor"),),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: OwonColor().getCurrent(context, "blue")),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: OwonColor().getCurrent(context, "blue")),
        ),
      )
  );
}


