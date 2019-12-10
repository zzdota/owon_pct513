import 'package:flutter/material.dart';
import 'package:owon_pct513/owon_utils/owon_bottomsheet.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:owon_pct513/res/owon_constant.dart';
import '../../res/owon_themeColor.dart';
import '../../component/owon_twoBtn.dart';
import '../../component/owon_tempHumi.dart';
import '../../component/owon_adjustTemp.dart';
import '../../component/owon_mode.dart';
import '../../res/owon_settingData.dart';

class ManagementPage extends StatefulWidget {
  @override
  _ManagementPageState createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("PCT513"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
            color: OwonColor().getCurrent(context, "textColor"),
          )
        ],
      ),
      body: Container(child: getWidget(context)),
    );
  }
}

Widget getWidget(context) {
  var dataList = loadSystemData;

  return Column(
    children: <Widget>[
      Expanded(
        child: Container(
          color: Colors.red,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 0, 20),
                child: OwonAdjustTemp(
                  title: "Heat To",
                  tempTitle: "30.0",
                  upBtnPressed: () {
                    OwonLog.e("up");
                  },
                  downBtnPressed: () {
                    OwonLog.e("down");
                  },
                ),
              ),
              Expanded(child: OwonTempHumi()),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 8, 20),
                child: OwonAdjustTemp(
                  title: "Heat To",
                  tempTitle: "30.0",
                  upBtnPressed: () {
                    OwonLog.e("up");
                  },
                  downBtnPressed: () {
                    OwonLog.e("down");
                  },
                ),
              ),
            ],
          ),
        ),
        flex: 5,
      ),
      Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              OwonMode(
                leftTitle: "系统模式",
                rightTitle: "Cool",
              ),
              OwonMode(
                leftTitle: "风扇",
                rightTitle: "Follow Schedule",
              ),
              OwonMode(
                leftTitle: "System",
                rightTitle: "Emergency Heat",
                onPressed: () {
                  OwonLog.e("----");
                  OwonBottomSheet.show(context, dataList).then((val){
                                        print("--消失后的回调-->$val");

                  });

//                  .then((val) {
//                    print("--消失后的回调-->$val");
//                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: getBottomWidget(),
              )
            ],
          ))
    ],
  );
}

Widget getBottomWidget() {
  return OwonTwoBtn(
    leftTitle: "Temp Hold",
    rightTitle: "Schedule",
    leftBtnPressed: () {
      OwonLog.e("left");
    },
    rightBtnPressed: () {
      OwonLog.e("right");
    },
  );
}
