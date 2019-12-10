import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../res/owon_themeColor.dart';

class OwonTextField {
  static Widget textField(BuildContext context,
      TextEditingController textEditingController, String hint, String imageUrl,
      {double width = double.infinity}) {
    return Container(
      width: width,
      child: TextField(
          controller: textEditingController, //绑定controller
          maxLines: 1, //最多一行
          autofocus: false, //自动获取焦点
          textAlign: TextAlign.left, //从左到右对齐
          style: TextStyle(
              color: OwonColor().getCurrent(context, "textColor"),
              fontSize: 20.0), //输入内容颜色和字体大小
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            //添加装饰效果
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            filled: false, //背景是否填充
            fillColor: OwonColor().getCurrent(
                context, "itemColor"), //添加黄色填充色（filled: true必须设置，否则单独设置填充色不会生效）
            prefixIcon: Padding(
              padding:
                  const EdgeInsets.only(top: 15, bottom: 15),
              child: Container(
                  child: SvgPicture.asset(
                    imageUrl,
                    color: OwonColor().getCurrent(context, "orange"),
                    width: 5,
                  )),
            ),
            hintText: hint, //hint提示文案
            hintStyle: TextStyle(
                fontSize: 14,
                color: OwonColor().getCurrent(context, "textColor")),
          )),
    );
  }
}
