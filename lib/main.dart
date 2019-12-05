import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:owon_pct513/owon_pages/login_pages/login_page.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:provider/provider.dart';
import 'generated/i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'welcome_page.dart';
import 'owon_providers/theme_provider.dart';
import 'res/owon_themeColor.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MultiProvider(
    providers: [
//        ChangeNotifierProvider(builder: (_) {
//          return Counter();
//        }),
      ChangeNotifierProvider(create: (_) {
        return ThemeProvider();
      }),
//        ChangeNotifierProvider(builder: (_) {
//          return MqttProvider();
//        }),
    ],
    child: MyApp(),
  ));
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Color.fromARGB(255, 230, 230, 230),
        systemNavigationBarIconBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getIndex();
  }

  Future getIndex() async {
    int index;
    SharedPreferences pre = await SharedPreferences.getInstance();
    index = await pre.getInt("themeColor");
    if (index == null) {
      index = 0;
    }
    Future.delayed(Duration(milliseconds: 2000), () {
      Provider.of<ThemeProvider>(context).setTheme(index);
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
//      title: "513",
      onGenerateTitle: (BuildContext context) => S.of(context).app_name,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: OwonColor().getCurrent(context, "itemColor"),
          scaffoldBackgroundColor: OwonColor().getCurrent(context, "primaryColor"),
          cardColor: OwonColor().getCurrent(context, "itemColor"),
          buttonTheme: ButtonThemeData(
//          highlightColor: Colors.red
              )),
      home: LoginPage(),

//      initialRoute: "/",
//      routes: <String, WidgetBuilder>{
//        "/": (context) => HomePage(),
//        "route": (BuildContext context) => DemoRoute(),
//        "dialog": (BuildContext context) => DemoAlertDialog(),
//        "timer": (BuildContext context) => DemoTimer(),
//        "refresh": (BuildContext context) => DemoRefresh(),
//        "progress": (BuildContext context) => DemoProgressIndicator(),
//        "canvas": (BuildContext context) => CanvasDemo(),
//        "card": (BuildContext context) => DemoCard(),
//        "path": (BuildContext context) => CanvasPathDemo()

//      },
    );
  }
}
