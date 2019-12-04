import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

import 'owon_log.dart';


class OwonSocketServer {
  static OwonSocketServer _instance;
  static ServerSocket _serverSocket;
  static Socket _clientSocket;

  static OwonSocketServer getInstance() {
    if (_instance == null) {
      _instance = OwonSocketServer();
    }
    return _instance;
  }
  void closeServer() {
    _clientSocket.destroy();
    _serverSocket.close();
  }

  void startServer() {
    ServerSocket.bind('127.0.0.1', 9999).then((serverSocket) {
      print('connected');
      _serverSocket = serverSocket;
      _serverSocket.listen(_handleClientSocket);


    });
    print(DateTime.now().toString() + " Socket服务启动，正在监听端口 4041...");

  }

  _handleClientSocket(Socket clientSocket) {
    _clientSocket = clientSocket;
    clientSocket.listen((data) {
      Uint8List responseData = data;
      List<int> responseDataList = responseData.toList();
      responseDataList.removeAt(0);
      responseDataList.removeAt(responseDataList.length - 1);
      String str = String.fromCharCodes(responseDataList);
      Map map = jsonDecode(str);

      OwonLog.e("--->recerve data:$map");


      int seq = map["sequence"];
     switch (seq){
       case 1:{

       }
       break;
       case 2:{

       }
       break;
       case 10000:{
         Map m = Map();
         m["key"] = "hello client";
         sendData(m, clientSocket);
       }
       break;

     }
    });
  }

  sendData(Map data,Socket clientSocket){
    int prefix = 0x2;
    String prefixString = String.fromCharCode(prefix);
    int suffix = 0x3;
    String suffixString = String.fromCharCode(suffix);

    String paramString = prefixString.toString() + jsonEncode(data) + suffixString.toString();

    clientSocket.write(paramString);
    print("server send data======paramString=$paramString");
  }
}
