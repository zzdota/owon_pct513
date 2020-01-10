library wheel_chooser;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WheelChooser extends StatefulWidget {
  final TextStyle selectTextStyle;
  final TextStyle unSelectTextStyle;
  final Function(dynamic) onValueChanged;
  final List<dynamic> datas;
  final int startPosition;
  final double itemSize;
  final double squeeze;
  final double magnification;
  final double perspective;
  final double listHeight;
  final double listWidth;
  final List<Widget> children;
  final bool horizontal;
  static const double _defaultItemSize = 48.0;

  static Widget widgetPicker(
    onValueChanged,
    children, {
    selectTextStyle: const TextStyle(color: Colors.blue),
    unSelectTextStyle: const TextStyle(color: Colors.grey),
    startPosition = 0,
    squeeze = 0.85,
    itemSize = _defaultItemSize,
    magnification = 1.5,
    perspective = 0.0009,
    listWidth,
    listHeight,
    horizontal = false,
  }) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.loose,
        children: <Widget>[
          WheelChooser.custom(
            selectTextStyle: selectTextStyle,
            unSelectTextStyle: unSelectTextStyle,
            magnification: magnification,
            startPosition: startPosition,
            squeeze: squeeze,
            itemSize: itemSize,
            perspective: perspective,
            listHeight: listHeight,
            listWidth: listWidth,
            horizontal: horizontal,
            onValueChanged: onValueChanged,
            children: children,
          ),
          horizontal
              ? Positioned(
                  left: listHeight / 2 - _defaultItemSize,
                  child: Container(
                    alignment: Alignment.center,
                    width: 1,
                    height: listWidth,
                    color: Colors.blue,
                  ),
                )
              : Positioned(
                  top: listHeight / 2 - _defaultItemSize,
                  child: Container(
                    alignment: Alignment.center,
                    width: listWidth,
                    height: 1,
                    color: Colors.blue,
                  ),
                ),
          horizontal
              ? Positioned(
                  right: listHeight / 2 - _defaultItemSize / 2,
                  child: Container(
                    alignment: Alignment.center,
                    width: 1,
                    height: listWidth,
                    color: Colors.blue,
                  ),
                )
              : Positioned(
                  child: Container(
                    alignment: Alignment.center,
                    width: listWidth,
                    height: 1,
                    color: Colors.blue,
                  ),
                )
        ],
      ),
    );
  }

  static Widget dynamicPicker(
    onValueChanged,
    datas, {
    selectTextStyle: const TextStyle(color: Colors.blue),
    unSelectTextStyle: const TextStyle(color: Colors.grey),
    startPosition = 0,
    squeeze = 0.85,
    itemSize = _defaultItemSize,
    magnification = 1.5,
    perspective = 0.0009,
    listWidth,
    listHeight,
    horizontal = false,
  }) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.loose,
        children: <Widget>[
          WheelChooser(
            selectTextStyle: selectTextStyle,
            unSelectTextStyle: unSelectTextStyle,
            magnification: magnification,
            startPosition: startPosition,
            squeeze: squeeze,
            itemSize: itemSize,
            perspective: perspective,
            listHeight: listHeight,
            listWidth: listWidth,
            horizontal: horizontal,
            onValueChanged: onValueChanged,
            datas: datas,
          ),
          horizontal
              ? Positioned(
                  left: listHeight / 2 - _defaultItemSize,
                  child: Container(
                    alignment: Alignment.center,
                    width: 1,
                    height: listWidth,
                    color: Colors.blue,
                  ),
                )
              : Positioned(
                  top: listHeight / 2 - _defaultItemSize,
                  child: Container(
                    alignment: Alignment.center,
                    width: listWidth,
                    height: 1,
                    color: Colors.blue,
                  ),
                ),
          horizontal
              ? Positioned(
                  right: listHeight / 2 - _defaultItemSize / 2,
                  child: Container(
                    alignment: Alignment.center,
                    width: 1,
                    height: listWidth,
                    color: Colors.blue,
                  ),
                )
              : Positioned(
                  child: Container(
                    alignment: Alignment.center,
                    width: listWidth,
                    height: 1,
                    color: Colors.blue,
                  ),
                )
        ],
      ),
    );
  }

  static Widget intPicker(
    onValueChanged,
    initValue,
    minValue,
    maxValue, {
    step = 1,
    selectTextStyle: const TextStyle(color: Colors.blue),
    unSelectTextStyle: const TextStyle(color: Colors.grey),
    squeeze = 0.85,
    itemSize = _defaultItemSize,
    magnification = 1.5,
    perspective = 0.0009,
    listWidth,
    listHeight,
    horizontal = false,
    reverse = false,
  }) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.loose,
        children: <Widget>[
          WheelChooser.integer(
            onValueChanged: onValueChanged,
            initValue: initValue,
            maxValue: maxValue,
            minValue: minValue,
            step: step,
            selectTextStyle: selectTextStyle,
            unSelectTextStyle: unSelectTextStyle,
            magnification: magnification,
            squeeze: squeeze,
            itemSize: itemSize,
            perspective: perspective,
            listHeight: listHeight,
            listWidth: listWidth,
            horizontal: horizontal,
            reverse: reverse,
          ),
          horizontal
              ? Positioned(
                  left: listHeight / 2 - _defaultItemSize,
                  child: Container(
                    alignment: Alignment.center,
                    width: 1,
                    height: listWidth,
                    color: Colors.blue,
                  ),
                )
              : Positioned(
                  top: listHeight / 2 - _defaultItemSize,
                  child: Container(
                    alignment: Alignment.center,
                    width: listWidth,
                    height: 1,
                    color: Colors.blue,
                  ),
                ),
          horizontal
              ? Positioned(
                  right: listHeight / 2 - _defaultItemSize / 2,
                  child: Container(
                    alignment: Alignment.center,
                    width: 1,
                    height: listWidth,
                    color: Colors.blue,
                  ),
                )
              : Positioned(
                  child: Container(
                    alignment: Alignment.center,
                    width: listWidth,
                    height: 1,
                    color: Colors.blue,
                  ),
                )
        ],
      ),
    );
  }

  static Widget doublePicker(
    onValueChanged,
    initValue,
    minValue,
    maxValue, {
    step = 1.0,
    selectTextStyle: const TextStyle(color: Colors.blue),
    unSelectTextStyle: const TextStyle(color: Colors.grey),
    squeeze = 0.85,
    itemSize = _defaultItemSize,
    magnification = 1.5,
    perspective = 0.0009,
    listWidth,
    listHeight,
    horizontal = false,
    reverse = false,
  }) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.loose,
        children: <Widget>[
          WheelChooser.double(
            onValueChanged: onValueChanged,
            initValue: initValue,
            maxValue: maxValue,
            minValue: minValue,
            step: step,
            selectTextStyle: selectTextStyle,
            unSelectTextStyle: unSelectTextStyle,
            magnification: magnification,
            squeeze: squeeze,
            itemSize: itemSize,
            perspective: perspective,
            listHeight: listHeight,
            listWidth: listWidth,
            horizontal: horizontal,
            reverse: reverse,
          ),
          horizontal
              ? Positioned(
                  left: listHeight / 2 - _defaultItemSize,
                  child: Container(
                    alignment: Alignment.center,
                    width: 1,
                    height: listWidth,
                    color: Colors.blue,
                  ),
                )
              : Positioned(
                  top: listHeight / 2 - _defaultItemSize,
                  child: Container(
                    alignment: Alignment.center,
                    width: listWidth,
                    height: 1,
                    color: Colors.blue,
                  ),
                ),
          horizontal
              ? Positioned(
                  right: listHeight / 2 - _defaultItemSize / 2,
                  child: Container(
                    alignment: Alignment.center,
                    width: 1,
                    height: listWidth,
                    color: Colors.blue,
                  ),
                )
              : Positioned(
                  child: Container(
                    alignment: Alignment.center,
                    width: listWidth,
                    height: 1,
                    color: Colors.blue,
                  ),
                )
        ],
      ),
    );
  }

  WheelChooser({
    @required this.onValueChanged,
    @required this.datas,
    this.selectTextStyle,
    this.unSelectTextStyle,
    this.startPosition = 0,
    this.squeeze = 1.0,
    this.itemSize = _defaultItemSize,
    this.magnification = 1,
    this.perspective = 0.01,
    this.listWidth,
    this.listHeight,
    this.horizontal = false,
  })  : assert(perspective <= 0.01),
        children = null;

  WheelChooser.custom({
    @required this.onValueChanged,
    @required this.children,
    this.selectTextStyle,
    this.unSelectTextStyle,
    this.datas,
    this.startPosition = 0,
    this.squeeze = 1.0,
    this.itemSize = _defaultItemSize,
    this.magnification = 1,
    this.perspective = 0.01,
    this.listWidth,
    this.listHeight,
    this.horizontal = false,
  })  : assert(perspective <= 0.01),
        assert(datas == null || datas.length == children.length);

  WheelChooser.integer({
    @required this.onValueChanged,
    @required int maxValue,
    @required int minValue,
    int initValue,
    int step = 1,
    this.selectTextStyle,
    this.unSelectTextStyle,
    this.squeeze = 1.0,
    this.itemSize = _defaultItemSize,
    this.magnification = 1,
    this.perspective = 0.01,
    this.listWidth,
    this.listHeight,
    this.horizontal = false,
    bool reverse = false,
  })  : assert(perspective <= 0.01),
        assert(minValue < maxValue),
        assert(initValue == null || initValue >= minValue),
        assert(initValue == null || maxValue >= initValue),
        assert(step > 0),
        children = null,
        datas = _createIntegerList(minValue, maxValue, step, reverse),
        startPosition = initValue == null
            ? 0
            : reverse
                ? (maxValue - initValue) ~/ step
                : (initValue - minValue) ~/ step;

  static List<String> _createIntegerList(
      int minValue, int maxValue, int step, bool reverse) {
    List<String> result = [];
    if (reverse) {
      for (int i = maxValue; i >= minValue; i -= step) {
        result.add(i.toString());
      }
    } else {
      for (int i = minValue; i <= maxValue; i += step) {
        result.add(i.toString());
      }
    }
    return result;
  }

  WheelChooser.double({
    @required this.onValueChanged,
    @required double maxValue,
    @required double minValue,
    double initValue,
    double step = 1.0,
    this.selectTextStyle,
    this.unSelectTextStyle,
    this.squeeze = 1.0,
    this.itemSize = _defaultItemSize,
    this.magnification = 1,
    this.perspective = 0.01,
    this.listWidth,
    this.listHeight,
    this.horizontal = false,
    bool reverse = false,
  })  : assert(perspective <= 0.01),
        assert(minValue < maxValue),
        assert(initValue == null || initValue >= minValue),
        assert(initValue == null || maxValue >= initValue),
        assert(step > 0 && step < 0.99999999),
        children = null,
        datas = _createDoubleList(minValue, maxValue, step, reverse),
        startPosition = initValue == null
            ? 0
            : reverse
                ? (maxValue - initValue) ~/ step
                : (initValue - minValue) ~/ step;

  static List<String> _createDoubleList(
      double minValue, double maxValue, double step, bool reverse) {
    List<String> result = [];
    int length = step
        .toString()
        .substring(step.toString().indexOf(".") + 1, step.toString().length)
        .length;
    if (reverse) {
      for (double i = maxValue; i >= minValue; i -= step) {
        int buf = i.toInt();
        String buf1 = (i - buf).toStringAsFixed(length);
        result.add((buf + double.parse(buf1)).toStringAsFixed(length));
      }
    } else {
      for (double i = minValue; i <= maxValue; i += step) {
        int buf = i.toInt();
        String buf1 = (i - buf).toStringAsFixed(length);
        result.add((buf + double.parse(buf1)).toStringAsFixed(length));
      }
    }
    return result;
  }

  @override
  _WheelChooserState createState() {
    return _WheelChooserState();
  }
}

class _WheelChooserState extends State<WheelChooser> {
  FixedExtentScrollController fixedExtentScrollController;
  int currentPosition;
  @override
  void initState() {
    super.initState();
    currentPosition = widget.startPosition;
    fixedExtentScrollController =
        FixedExtentScrollController(initialItem: currentPosition);
  }

  void _listener(int position) {
    setState(() {
      currentPosition = position;
    });
    if (widget.datas == null) {
      widget.onValueChanged(currentPosition);
    } else {
      widget.onValueChanged(widget.datas[currentPosition]);
    }
  }

  void updateCurrentPosition(String value){
    setState(() {
      for(int i = 0; i < widget.datas.length; i ++){
        if(widget.datas[i].toString() == value){
          currentPosition = i;
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
        quarterTurns: widget.horizontal ? 3 : 0,
        child: Container(
            height: widget.listHeight ?? double.infinity,
            width: widget.listWidth ?? double.infinity,
            child: ListWheelScrollView(
              onSelectedItemChanged: _listener,
              perspective: widget.perspective,
              squeeze: widget.squeeze,
              controller: fixedExtentScrollController,
              physics: FixedExtentScrollPhysics(),
              children: _convertListItems() ?? _buildListItems(),
              useMagnifier: true,
              magnification: widget.magnification,
              itemExtent: widget.itemSize,
            )));
  }

  List<Widget> _buildListItems() {
    List<Widget> result = List<Widget>();
    for (int i = 0; i < widget.datas.length; i++) {
      result.add(
        RotatedBox(
          quarterTurns: widget.horizontal ? 1 : 0,
          child: Container(
            child: Column(
              children: <Widget>[
                Text(
                  widget.datas[i].toString(),
                  textAlign: TextAlign.start,
                  textScaleFactor: 1,
                  style: i == currentPosition
                      ? widget.selectTextStyle ?? null
                      : widget.unSelectTextStyle ?? null,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return result;
  }

  List<Widget> _convertListItems() {
    if (widget.children == null) {
      return null;
    } else {
      List<Widget> result = List<Widget>();
      for (int i = 0; i < widget.children.length; i++) {
        result.add(
          RotatedBox(
            quarterTurns: widget.horizontal ? 1 : 0,
            child: widget.children[i],
          ),
        );
      }
      return result;
    }
  }
}
