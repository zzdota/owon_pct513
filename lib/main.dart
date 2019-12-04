import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'generated/i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'welcome_page.dart';

void main() {
  runApp(MultiProvider(
    providers: [
//        ChangeNotifierProvider(builder: (_) {
//          return Counter();
//        }),
//        ChangeNotifierProvider(builder: (_) {
//          return ThemeProvider();
//        }),
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

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
//        primaryColor: Colors.black,
//        scaffoldBackgroundColor: Colors.black,
        buttonTheme: ButtonThemeData(
//          highlightColor: Colors.red
        )
      ),
      home: WelcomePage(),

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
