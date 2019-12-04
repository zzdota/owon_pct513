import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
typedef dataHandler = void Function(Uint8List data);
enum SocketConnectionState {
  disconnected,

  disconnecting,

  connecting,

  connected,

  faulted
}


class OwonSocketClient {
  String host = "127.0.0.1";
  int port = 9999;

//  String host = "connect.owon.com";
//  int port = 11500;
  Socket socketClient;
  static OwonSocketClient _instance;
  SocketConnectionState socketState;

  OwonSocketClient._() {
    print("====>有没有调用 呢");
    socketState = SocketConnectionState.disconnected;
  }

  static OwonSocketClient getInstance() {
    if (_instance == null) {
      _instance = OwonSocketClient._();
    }
    return _instance;
  }

  Future<Socket> connect()async{
    print("socket连接中...");
    socketClient = await Socket.connect(host, port,timeout: Duration(seconds: 10));
    socketState = SocketConnectionState.connected;
    print("socket连接成功!");
    return socketClient;
  }

  addListener(dataHandler) {
    if(socketState == SocketConnectionState.connected){

    }
    socketClient.listen(dataHandler,onDone:_onDone);
  }
  _onDone(){
    print("socket已经断开");
    socketState = SocketConnectionState.disconnected;
  }

  sendData(Map data){
    int prefix = 0x2;
    String prefixString = String.fromCharCode(prefix);
    int suffix = 0x3;
    String suffixString = String.fromCharCode(suffix);

    String paramString = prefixString.toString() + jsonEncode(data) + suffixString.toString();

    socketClient.write(paramString);
    print("client send data======paramString=$paramString");
  }

  close() {
    if(socketState == SocketConnectionState.disconnected){
      print("socket已经断开状态");
    }
    if(socketState == SocketConnectionState.connected){
      print("socket正在断开中...");
      socketState = SocketConnectionState.disconnecting;

    }

    socketClient.destroy();
  }

}