import 'package:flutter/material.dart';
import '../generated/i18n.dart';

class BaseDialog {
  List<Widget> widgetList = [];
  static BuildContext _context;
  BuildContext context;

  double width = 280;
  double height;
  Duration duration = Duration(milliseconds: 250);
  Gravity gravity = Gravity.center;
  bool gravityAnimationEnable = false;
  Color barrierColor = Colors.black.withOpacity(.3);
  Color backgroundColor = Colors.white;
  double borderRadius = 10.0;
  BoxConstraints constraints;
  Function(Widget child, Animation<double> animation) animatedFunc =
      (child, animation) {
    return ScaleTransition(
      child: child,
      scale: Tween(begin: 0.0, end: 1.0).animate(animation),
    );
  };
  bool barrierDismissible = false;
  EdgeInsets margin = EdgeInsets.all(0.0);

  get isShowing => _isShowing;
  bool _isShowing = false;

  static void init(BuildContext ctx) {
    _context = ctx;
  }

  BaseDialog build([BuildContext ctx]) {
    if (ctx == null && _context != null) {
      this.context = _context;
      return this;
    }
    this.context = ctx;
    return this;
  }

  BaseDialog widget(Widget child) {
    this.widgetList.add(child);
    return this;
  }

  BaseDialog text(
      {padding,
      text,
      color,
      fontSize,
      alignment,
      textAlign,
      maxLines,
      textDirection,
      overflow,
      fontWeight,
      fontFamily}) {
    return this.widget(
      Padding(
        padding: padding ?? EdgeInsets.all(0.0),
        child: Align(
          alignment: alignment ?? Alignment.centerLeft,
          child: Text(
            text ?? "",
            textAlign: textAlign,
            maxLines: maxLines,
            textDirection: textDirection,
            overflow: overflow,
            style: TextStyle(
              color: color ?? Colors.black,
              fontSize: fontSize ?? 14.0,
              fontWeight: fontWeight,
              fontFamily: fontFamily,
            ),
          ),
        ),
      ),
    );
  }

  BaseDialog doubleButton({
    padding,
    gravity,
    height,
    isClickAutoDismiss = true,
    withDivider = false,
    text1,
    color1,
    fontSize1,
    fontWeight1,
    fontFamily1,
    VoidCallback onTap1,
    text2,
    color2,
    fontSize2,
    fontWeight2,
    fontFamily2,
    onTap2,
  }) {
    return this.widget(
      SizedBox(
        height: height ?? 45.0,
        child: Row(
          mainAxisAlignment: getRowMainAxisAlignment(gravity),
          children: <Widget>[
            Expanded(
              flex: 1,
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  if (onTap1 != null) onTap1();
                  if (isClickAutoDismiss) {
                    dismiss();
                  }
                },
                padding: EdgeInsets.all(0.0),
                child: Text(
                  text1 ?? "",
                  style: TextStyle(
                    color: color1 ?? null,
                    fontSize: fontSize1 ?? null,
                    fontWeight: fontWeight1,
                    fontFamily: fontFamily1,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: withDivider,
              child: VerticalDivider(),
            ),
            Expanded(
                flex: 1,
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    if (onTap2 != null) onTap2();
                    if (isClickAutoDismiss) {
                      dismiss();
                    }
                  },
                  padding: EdgeInsets.all(0.0),
                  child: Text(
                    text2 ?? "",
                    style: TextStyle(
                      color: color2 ?? Colors.black,
                      fontSize: fontSize2 ?? 14.0,
                      fontWeight: fontWeight2,
                      fontFamily: fontFamily2,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  BaseDialog singleButton({
    padding,
    gravity,
    height,
    isClickAutoDismiss = true,
    withDivider = false,
    text1,
    color1,
    fontSize1,
    fontWeight1,
    fontFamily1,
    VoidCallback onTap1,
  }) {
    return this.widget(
      SizedBox(
        height: height ?? 45.0,
        child: Container(
          width: double.infinity,
          child: FlatButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              if (onTap1 != null) onTap1();
              if (isClickAutoDismiss) {
                dismiss();
              }
            },
            padding: EdgeInsets.all(0.0),
            child: Text(
              text1 ?? "",
              style: TextStyle(
                color: color1 ?? null,
                fontSize: fontSize1 ?? null,
                fontWeight: fontWeight1,
                fontFamily: fontFamily1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  BaseDialog listViewOfListTile({
    List<ListTileItem> items,
    double height,
    isClickAutoDismiss = true,
    Function(int) onClickItemListener,
  }) {
    return this.widget(
      Container(
        height: height,
        child: ListView.builder(
          padding: EdgeInsets.all(0.0),
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Material(
              color: Colors.white,
              child: InkWell(
                child: ListTile(
                  onTap: () {
                    if (onClickItemListener != null) {
                      onClickItemListener(index);
                    }
                    if (isClickAutoDismiss) {
                      dismiss();
                    }
                  },
                  contentPadding: items[index].padding ?? EdgeInsets.all(0.0),
                  leading: items[index].leading,
                  title: Text(
                    items[index].text ?? "",
                    style: TextStyle(
                      color: items[index].color ?? null,
                      fontSize: items[index].fontSize ?? null,
                      fontWeight: items[index].fontWeight,
                      fontFamily: items[index].fontFamily,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  BaseDialog circularProgress(
      {padding, backgroundColor, valueColor, strokeWidth}) {
    return this.widget(Padding(
      padding: padding,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth ?? 4.0,
        backgroundColor: backgroundColor,
        valueColor: AlwaysStoppedAnimation<Color>(valueColor),
      ),
    ));
  }

  BaseDialog divider({color, height}) {
    return this.widget(
      Divider(
        color: color ?? Colors.grey[300],
        height: height ?? 0.1,
      ),
    );
  }

  void show([x, y]) {
    var mainAxisAlignment = getColumnMainAxisAlignment(gravity);
    var crossAxisAlignment = getColumnCrossAxisAlignment(gravity);
    if (x != null && y != null) {
      gravity = Gravity.leftTop;
      margin = EdgeInsets.only(left: x, top: y);
    }
    CustomDialog(
      gravity: gravity,
      gravityAnimationEnable: gravityAnimationEnable,
      context: this.context,
      barrierColor: barrierColor,
      animatedFunc: animatedFunc,
      barrierDismissible: barrierDismissible,
      duration: duration,
      child: Padding(
        padding: margin,
        child: Column(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: <Widget>[
            Material(
              type: MaterialType.transparency,
              child: Container(
                padding: EdgeInsets.all(borderRadius / 3.14),
                width: width ?? null,
                height: height ?? null,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: backgroundColor,
                ),
                constraints: constraints ?? BoxConstraints(),
                child: CustomDialogChildren(
                  widgetList: widgetList,
                  isShowingChange: (bool isShowingChange) {
                    _isShowing = isShowingChange;
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void dismiss() {
    if (_isShowing) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  getColumnMainAxisAlignment(gravity) {
    var mainAxisAlignment = MainAxisAlignment.start;
    switch (gravity) {
      case Gravity.bottom:
      case Gravity.leftBottom:
      case Gravity.rightBottom:
        mainAxisAlignment = MainAxisAlignment.end;
        break;
      case Gravity.top:
      case Gravity.leftTop:
      case Gravity.rightTop:
        mainAxisAlignment = MainAxisAlignment.start;
        break;
      case Gravity.left:
        mainAxisAlignment = MainAxisAlignment.center;
        break;
      case Gravity.right:
        mainAxisAlignment = MainAxisAlignment.center;
        break;
      case Gravity.center:
      default:
        mainAxisAlignment = MainAxisAlignment.center;
        break;
    }
    return mainAxisAlignment;
  }

  getColumnCrossAxisAlignment(gravity) {
    var crossAxisAlignment = CrossAxisAlignment.center;
    switch (gravity) {
      case Gravity.bottom:
        break;
      case Gravity.top:
        break;
      case Gravity.left:
      case Gravity.leftTop:
      case Gravity.leftBottom:
        crossAxisAlignment = CrossAxisAlignment.start;
        break;
      case Gravity.right:
      case Gravity.rightTop:
      case Gravity.rightBottom:
        crossAxisAlignment = CrossAxisAlignment.end;
        break;
      default:
        break;
    }
    return crossAxisAlignment;
  }

  getRowMainAxisAlignment(gravity) {
    var mainAxisAlignment = MainAxisAlignment.start;
    switch (gravity) {
      case Gravity.bottom:
        break;
      case Gravity.top:
        break;
      case Gravity.left:
        mainAxisAlignment = MainAxisAlignment.start;
        break;
      case Gravity.right:
        mainAxisAlignment = MainAxisAlignment.end;
        break;
      case Gravity.center:
      default:
        mainAxisAlignment = MainAxisAlignment.center;
        break;
    }
    return mainAxisAlignment;
  }
}

// ignore: must_be_immutable
class CustomDialogChildren extends StatefulWidget {
  List<Widget> widgetList = []; //弹窗内部所有组件
  Function(bool) isShowingChange;

  CustomDialogChildren({this.widgetList, this.isShowingChange});

  @override
  CustomDialogChildState createState() => CustomDialogChildState();
}

class CustomDialogChildState extends State<CustomDialogChildren> {
  @override
  Widget build(BuildContext context) {
    widget.isShowingChange(true);
    return Column(
      children: widget.widgetList,
    );
  }

  @override
  void dispose() {
    widget.isShowingChange(false);
    super.dispose();
  }
}

class CustomDialog {
  BuildContext _context;
  Widget _child;
  Duration _duration;
  Color _barrierColor;
  RouteTransitionsBuilder _transitionsBuilder;
  bool _barrierDismissible;
  Gravity _gravity;
  bool _gravityAnimationEnable;
  Function _animatedFunc;

  CustomDialog({
    @required Widget child,
    @required BuildContext context,
    Duration duration,
    Color barrierColor,
    RouteTransitionsBuilder transitionsBuilder,
    Gravity gravity,
    bool gravityAnimationEnable,
    Function animatedFunc,
    bool barrierDismissible,
  })  : _child = child,
        _context = context,
        _gravity = gravity,
        _gravityAnimationEnable = gravityAnimationEnable,
        _duration = duration,
        _barrierColor = barrierColor,
        _animatedFunc = animatedFunc,
        _transitionsBuilder = transitionsBuilder,
        _barrierDismissible = barrierDismissible {
    this.show();
  }

  show() {
    if (_barrierColor == Colors.transparent) {
      _barrierColor = Colors.white.withOpacity(0.0);
    }

    showGeneralDialog(
      context: _context,
      barrierColor: _barrierColor ?? Colors.black.withOpacity(.3),
      barrierDismissible: _barrierDismissible ?? true,
      barrierLabel: "",
      transitionDuration: _duration ?? Duration(milliseconds: 250),
      transitionBuilder: _transitionsBuilder ?? _buildMaterialDialogTransitions,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Builder(
          builder: (BuildContext context) {
            return _child;
          },
        );
      },
    );
  }

  Widget _buildMaterialDialogTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    Animation<Offset> custom;
    switch (_gravity) {
      case Gravity.top:
      case Gravity.leftTop:
      case Gravity.rightTop:
        custom = Tween<Offset>(
          begin: Offset(0.0, -1.0),
          end: Offset(0.0, 0.0),
        ).animate(animation);
        break;
      case Gravity.left:
        custom = Tween<Offset>(
          begin: Offset(-1.0, 0.0),
          end: Offset(0.0, 0.0),
        ).animate(animation);
        break;
      case Gravity.right:
        custom = Tween<Offset>(
          begin: Offset(1.0, 0.0),
          end: Offset(0.0, 0.0),
        ).animate(animation);
        break;
      case Gravity.bottom:
      case Gravity.leftBottom:
      case Gravity.rightBottom:
        custom = Tween<Offset>(
          begin: Offset(0.0, 1.0),
          end: Offset(0.0, 0.0),
        ).animate(animation);
        break;
      case Gravity.center:
      default:
        custom = Tween<Offset>(
          begin: Offset(0.0, 0.0),
          end: Offset(0.0, 0.0),
        ).animate(animation);
        break;
    }

    if (_animatedFunc != null) {
      return _animatedFunc(child, animation);
    }

    if (!_gravityAnimationEnable) {
      custom = Tween<Offset>(
        begin: Offset(0.0, 0.0),
        end: Offset(0.0, 0.0),
      ).animate(animation);
    }

    return SlideTransition(
      position: custom,
      child: child,
    );
  }
}

enum Gravity {
  left,
  top,
  bottom,
  right,
  center,
  rightTop,
  leftTop,
  rightBottom,
  leftBottom,
}

class ListTileItem {
  ListTileItem({
    this.padding,
    this.leading,
    this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
  });

  EdgeInsets padding;
  Widget leading;
  String text;
  Color color;
  double fontSize;
  FontWeight fontWeight;
  String fontFamily;
}

class RadioItem {
  RadioItem({
    this.padding,
    this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.onTap,
  });

  EdgeInsets padding;
  String text;
  Color color;
  double fontSize;
  FontWeight fontWeight;
  Function(int) onTap;
}

typedef VoidCallback = void Function();

class OwonDialog {
  VoidCallback cancelPressed, okPressed;

  OwonDialog({@required this.cancelPressed, this.okPressed});

  static init(BuildContext ctx) {
    BaseDialog.init(ctx);
  }

  show(String msg, {String lButton, String rButton}) {
    BaseDialog().build()
      ..text(
        padding: EdgeInsets.all(25.0),
        alignment: Alignment.center,
        text: msg,
        color: Colors.black,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      )
      ..divider()
      ..doubleButton(
        gravity: Gravity.center,
        withDivider: true,
        text1: lButton ?? S.of(BaseDialog._context).global_cancel,
        color1: Colors.grey,
        fontSize1: 14.0,
        fontWeight1: FontWeight.bold,
        onTap1: cancelPressed,
        text2: rButton ?? S.of(BaseDialog._context).global_ok,
        color2: Colors.grey,
        fontSize2: 14.0,
        fontWeight2: FontWeight.bold,
        onTap2: okPressed,
      )
      ..show();
  }

  showOK(String msg, {String buttonName}) {
    BaseDialog().build()
      ..text(
        padding: EdgeInsets.all(25.0),
        alignment: Alignment.center,
        text: msg,
        color: Colors.black,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      )
      ..divider()
      ..singleButton(
        gravity: Gravity.center,
        withDivider: true,
        text1: buttonName ?? S.of(BaseDialog._context).global_cancel,
        color1: Colors.grey,
        fontSize1: 14.0,
        fontWeight1: FontWeight.bold,
        onTap1: cancelPressed,
      )
      ..show();
  }
}
