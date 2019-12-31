import 'package:flutter/material.dart';

class AddressManagementPage extends StatefulWidget {
  @override
  _AddressManagementPageState createState() => _AddressManagementPageState();
}

class _AddressManagementPageState extends State<AddressManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("地址列表"),
      ),
      body: Center(
        child: Text("地址"),
      ),
    );
  }
}
