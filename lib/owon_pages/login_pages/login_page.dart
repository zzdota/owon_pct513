import 'package:flutter/material.dart';
import 'package:owon_pct513/owon_pages/home_page.dart';
import '../../owon_providers/theme_provider.dart';
import '../../owon_utils/owon_log.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
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
          child: FlatButton(onPressed: () async{
            SharedPreferences pre = await SharedPreferences.getInstance();
            int index = await pre.getInt("themeColor");
            OwonLog.e("index=$index");

            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return HomePage();
            }));
          }, child: Text("点我啊",style: TextStyle(color: Colors.white,fontSize: 50.0),))
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async{
        SharedPreferences pre = await SharedPreferences.getInstance();
        pre.setInt("themeColor", 1);
        Provider.of<ThemeProvider>(context).setTheme(1);


//        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//          return HomePage();
//        }));
      }),
    );
  }
}
