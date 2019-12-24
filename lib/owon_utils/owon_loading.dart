import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../owon_utils/owon_toast.dart';
import '../res/owon_themeColor.dart';
import '../generated/i18n.dart';

enum OwonLoadingType { Normal, Download }

String _dialogMessage = "Loading...";
double _progress = 0.0, _maxProgress = 100.0;

bool _isShowing = false;
BuildContext _context, _dismissingContext;
OwonLoadingType _OwonLoadingType;
bool _barrierDismissible = true, _showLogs = true;

TextStyle _progressTextStyle = TextStyle(
        color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
    _messageStyle = TextStyle(
        color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.w400);

double _dialogElevation = 8.0, _borderRadius = 8.0;
Color _backgroundColor = Color.fromRGBO(220, 220, 220, 1.0);
Curve _insetAnimCurve = Curves.easeInOut;

Widget _progressWidget = CircularProgressIndicator(
    strokeWidth: 4.0,
    valueColor:
        AlwaysStoppedAnimation<Color>(OwonColor().getCurrent(_context, "blue"))
//  backgroundColor: ,
    );
//Image.asset(
//  'assets/up_blue.gif'
//);
//SpinKitFadingCircle(
//  color: Colors.blue,
//);
typedef VoidCallback = void Function();

class OwonLoading {
  Timer _timer;
  _Body _dialog;
  VoidCallback timeOutHandler;
  int timeOut;

  OwonLoading(BuildContext context,
      {OwonLoadingType type,
        bool isDismissible,
        bool showLogs,
        this.timeOutHandler,
        this.timeOut = 30}) {
    _context = context;
    _OwonLoadingType = type ?? OwonLoadingType.Normal;
    _barrierDismissible = isDismissible ?? true;
    _showLogs = showLogs ?? true;
  }

  void style({double progress,
    double maxProgress,
    String message,
    Widget progressWidget,
    Color backgroundColor,
    TextStyle progressTextStyle,
    TextStyle messageTextStyle,
    double elevation,
    double borderRadius,
    Curve insetAnimCurve}) {
    if (_isShowing) return;
    if (_OwonLoadingType == OwonLoadingType.Download) {
      _progress = progress ?? _progress;
    }

    _dialogMessage = message ?? _dialogMessage;
    _maxProgress = maxProgress ?? _maxProgress;
    _progressWidget = progressWidget ?? _progressWidget;
    _backgroundColor = backgroundColor ?? _backgroundColor;
    _messageStyle = messageTextStyle ?? _messageStyle;
    _progressTextStyle = progressTextStyle ?? _progressTextStyle;
    _dialogElevation = elevation ?? _dialogElevation;
    _borderRadius = borderRadius ?? _borderRadius;
    _insetAnimCurve = insetAnimCurve ?? _insetAnimCurve;
  }

  void update({double progress,
    double maxProgress,
    String message,
    Widget progressWidget,
    TextStyle progressTextStyle,
    TextStyle messageTextStyle}) {
    if (_OwonLoadingType == OwonLoadingType.Download) {
      _progress = progress ?? _progress;
    }

    _dialogMessage = message ?? _dialogMessage;
    _maxProgress = maxProgress ?? _maxProgress;
    _progressWidget = progressWidget ?? _progressWidget;
    _messageStyle = messageTextStyle ?? _messageStyle;
    _progressTextStyle = progressTextStyle ?? _progressTextStyle;

    if (_isShowing) _dialog.update();
  }

  bool isShowing() {
    return _isShowing;
  }

  void dismiss() {
    endTimer();
    if (_isShowing) {
      try {
        _isShowing = false;
        if (Navigator.of(_dismissingContext).canPop()) {
          Navigator.of(_dismissingContext).pop();
          if (_showLogs) debugPrint('OwonLoading dismissed');
        } else {
          if (_showLogs) debugPrint('Cant pop OwonLoading');
        }
      } catch (_) {}
    } else {
      if (_showLogs) debugPrint('OwonLoading already dismissed');
    }
  }

  Future<bool> hide() {
    endTimer();
    if (_isShowing) {
      try {
        _isShowing = false;
        Navigator.of(_dismissingContext).pop(true);
        if (_showLogs) debugPrint('OwonLoading dismissed');
        return Future.value(true);
      } catch (_) {
        return Future.value(false);
      }
    } else {
      if (_showLogs) debugPrint('OwonLoading already dismissed');
      return Future.value(false);
    }
  }

  void show() {
    if (!_isShowing) {
      _dialog = new _Body();
      _isShowing = true;

      if (_showLogs) debugPrint('OwonLoading shown');
      startTimer();
      showDialog<dynamic>(
        context: _context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          _dismissingContext = context;
          return WillPopScope(
            onWillPop: () {
              return Future.value(_barrierDismissible);
            },
            child: Dialog(
                backgroundColor: _backgroundColor,
                insetAnimationCurve: _insetAnimCurve,
                insetAnimationDuration: Duration(milliseconds: 100),
                elevation: _dialogElevation,
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(_borderRadius))),
                child: _dialog),
          );
        },
      );
    } else {
      if (_showLogs) debugPrint("OwonLoading already shown/showing");
    }
  }

  void startTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    _timer = Timer(Duration(seconds: this.timeOut), () {
      if (this.timeOutHandler == null) {
        hide().then((e) {
          OwonToast.show(S
              .of(_context)
              .global_timeout);
        });
      } else {
        hide();
        this.timeOutHandler();
      }
    });
  }

  void endTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }
}

// ignore: must_be_immutable
class _Body extends StatefulWidget {
  _BodyState _dialog = _BodyState();

  update() {
    _dialog.update();
  }

  @override
  State<StatefulWidget> createState() {
    return _dialog;
  }
}

class _BodyState extends State<_Body> {
  update() {
    setState(() {});
  }

  @override
  void dispose() {
    _isShowing = false;
    if (_showLogs) debugPrint('OwonLoading dismissed by back button');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      width: 280,
      child: Row(children: <Widget>[
        const SizedBox(width: 50.0),
        SizedBox(
          width: 45.0,
          height: 45.0,
          child: _progressWidget,
        ),
        const SizedBox(width: 25.0),
        Expanded(
          child: _OwonLoadingType == OwonLoadingType.Normal
              ? Text(_dialogMessage,
                  textAlign: TextAlign.justify, style: _messageStyle)
              : Stack(
                  children: <Widget>[
                    Positioned(
                      child: Text(_dialogMessage, style: _messageStyle),
                      top: 30.0,
                    ),
                    Positioned(
                      child: Text("$_progress/$_maxProgress",
                          style: _progressTextStyle),
                      bottom: 10.0,
                      right: 10.0,
                    ),
                  ],
                ),
        ),
        const SizedBox(width: 10.0)
      ]),
    );
  }
}
