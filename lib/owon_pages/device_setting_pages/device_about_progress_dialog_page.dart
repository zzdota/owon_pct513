import 'package:flutter/material.dart';
import '../../res/owon_themeColor.dart';

class ShowCommonAlert extends Dialog {
  Widget childWidget;
  //左侧按钮
  String negativeText;
  //右侧按钮
  String positiveText;
  //标题
  String title;
  //显示标题下的分隔线
  bool isShowTitleDivide;
  //显示底部确认按钮上的分隔线
  bool isShowBottomDivide;
  //左侧按钮点击事件（取消）
  Function onCloseEvent;
  //右侧按钮点击事件（确认）
  Function onPositivePressEvent;

  //标题默认高度
  double defaultTitleHeight = 40.0;

  ShowCommonAlert({
    Key key,
    @required this.childWidget,
    this.title = "",
    this.negativeText,
    this.positiveText,
    this.onPositivePressEvent,
    this.isShowTitleDivide = false,
    this.isShowBottomDivide = false,
    @required this.onCloseEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //白色背景
            Container(
              decoration: ShapeDecoration(
                color: Color(0xffffffff), //可以自定义一个颜色传过来
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
              ),
              margin: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  //标题
                  title != ""
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 30, bottom: 10),
                          child: Container(
                            height: defaultTitleHeight,
                            child: Center(
                              child: Text(
                                title,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: OwonColor()
                                        .getCurrent(context, "blue")),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  //标题下的分隔线
                  isShowTitleDivide
                      ? Container(
                          color: OwonColor().getCurrent(context, "blue"),
                          margin: EdgeInsets.only(bottom: 10.0),
                          height: 1.0,
                        )
                      : Container(),
                  //中间显示的Widget
                  Container(
                    constraints: BoxConstraints(minHeight: 80.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: childWidget,
                    ),
                  ),
                  //底部的分隔线
                  isShowBottomDivide
                      ? Container(
                          color: OwonColor().getCurrent(context, "blue"),
                          margin: EdgeInsets.only(top: 10.0),
                          height: 1.0,
                        )
                      : Container(),
                  //底部的确认取消按钮
                  this._buildBottomButtonGroup(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtonGroup(BuildContext context) {
    var widgets = <Widget>[];
    if (negativeText != null && negativeText.isNotEmpty) {
      widgets.add(Expanded(flex: 1, child: _buildBottomCancelButton(context)));
    }
    if (negativeText != null && positiveText != null) {
      widgets.add(Container(
        color: isShowBottomDivide
            ? OwonColor().getCurrent(context, "blue")
            : Color(0xffffffff),
        height: 60.0,
        width: 1,
      ));
    }
    if (positiveText != null && positiveText.isNotEmpty) {
      widgets
          .add(Expanded(flex: 1, child: _buildBottomPositiveButton(context)));
    }

    return Container(
      height: 60.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widgets,
      ),
    );
  }

  Widget _buildBottomCancelButton(BuildContext context) {
    return InkWell(
      onTap: onCloseEvent,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          negativeText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            color: OwonColor().getCurrent(context, "blue"),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPositiveButton(BuildContext context) {
    return InkWell(
      onTap: onPositivePressEvent,
      child: Container(
        height: double.infinity,
        alignment: Alignment.center,
        child: Text(
          positiveText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: OwonColor().getCurrent(context, "blue"),
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
