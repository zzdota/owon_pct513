import 'package:flutter/material.dart';
import 'package:owon_pct513/owon_pages/home_page.dart';
import '../../owon_utils/owon_log.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    OwonLog.e("+++++");
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: FlatButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return HomePage();
            }));
          }, child: Text("点我啊"))
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      }),
    );
  }
}
