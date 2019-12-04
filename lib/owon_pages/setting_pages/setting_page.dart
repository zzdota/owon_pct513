import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Text(""),
          title: Text("Setting"),
          centerTitle: true,
        ),
        body: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                height: 90,
                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Card(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    child: ListTile(
                        leading: Icon(Icons.add),
                        title: Text("设置 第 $index 行"),
                        subtitle: Text("详细内容 $index"),
                        trailing: Icon(Icons.keyboard_arrow_right))),
              );
            }));
  }
}
