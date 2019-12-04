import 'dart:async';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:typed_data/typed_buffers.dart';

typedef ConnectedCallback = void Function();
typedef AConnectedCallback = void Function(List<MqttReceivedMessage<MqttMessage>> data);

class OwonMqtt {
  String server = "110.80.23.122";
  int port = 1883;
  String clientIdentifier = "798diokkjhxckljlzgjkhadkjdsaljdlajd";
  MqttQos qos = MqttQos.atLeastOnce;
  MqttClient mqttClient;
  static OwonMqtt _instance;
  OwonMqtt._() {

    mqttClient = MqttClient.withPort(server, clientIdentifier, port);

    mqttClient.onDisconnected = _onDisconnected;

    mqttClient.onSubscribed = _onSubscribed;

    mqttClient.onSubscribeFail = _onSubscribeFail;

    mqttClient.onUnsubscribed = _onUnSubscribed;

    mqttClient.setProtocolV311();
    mqttClient.logging(on: false);

  }

  static OwonMqtt getInstance() {
    if (_instance == null) {
      _instance = OwonMqtt._();
    }
    return _instance;
  }
  Future<MqttClientConnectionStatus> connect([String username, String password]) {
    _log("_正在连接中...");
    return mqttClient.connect(username,password);
  }

  disconnect() {
    mqttClient.disconnect();
    _log("_disconnect");
  }



  int publishMessage(String pTopic,String msg) {
    Uint8Buffer uint8buffer = Uint8Buffer();
    var codeUnits = msg.codeUnits;
    uint8buffer.addAll(codeUnits);
   return mqttClient.publishMessage(pTopic, qos, uint8buffer,retain: false);
  }

  Subscription subscribeMessage(String subtopic){
   return mqttClient.subscribe(subtopic, qos);
  }

  unsubscribeMessage(String unSubtopic) {
   mqttClient.unsubscribe(unSubtopic);
  }

  MqttClientConnectionStatus getMqttStatus(){
    return mqttClient.connectionStatus;
  }


  Stream<List<MqttReceivedMessage<MqttMessage>>> updates(){
    _log("_监听成功!");
    return mqttClient.updates;

  }



  onConnected(ConnectedCallback callback){
    mqttClient.onConnected = callback;
  }


  _onDisconnected() {
    _log("_onDisconnected");
  }

  _onSubscribed(String topic) {
    _log("_订阅主题成功---topic:$topic");

  }
  _onUnSubscribed(String topic) {
    _log("_取消订阅主题成功---topic:$topic");

  }
  _onSubscribeFail(String topic) {
    _log("_onSubscribeFail");
  }


  _log(String msg) {
    print("MQTT-->$msg");
  }
}
