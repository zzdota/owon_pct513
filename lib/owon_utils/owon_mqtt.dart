import 'dart:async';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:typed_data/typed_buffers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../owon_utils/owon_clientid.dart';

typedef ConnectedCallback = void Function();
typedef AConnectedCallback = void Function(
    List<MqttReceivedMessage<MqttMessage>> data);

class OwonMqtt {
  MqttQos qos = MqttQos.atLeastOnce;
  MqttClient mqttClient;
  static OwonMqtt _instance;

  static OwonMqtt getInstance() {
    if (_instance == null) {
      _instance = OwonMqtt();
    }
    return _instance;
  }

  Future<MqttClientConnectionStatus> connect(String server, int port,
      String clientIdentifier, String username, String password, {bool isSsl = true}) {
    mqttClient = MqttClient.withPort(server, clientIdentifier, port);

    mqttClient.onDisconnected = _onDisconnected;

    mqttClient.onSubscribed = _onSubscribed;

    mqttClient.onSubscribeFail = _onSubscribeFail;

    mqttClient.onUnsubscribed = _onUnSubscribed;

    mqttClient.setProtocolV311();
    mqttClient.logging(on: false);
    if (isSsl) {
      mqttClient.secure = true;
      mqttClient.onBadCertificate = (bool) {
        return true;
      };
    }
    _log("_正在连接中...");
    return mqttClient.connect(username, password);
  }

  disconnect() {
    mqttClient.disconnect();
    _log("_disconnect");
  }

  int publishMessage(String pTopic, String msg) {
    Uint8Buffer uint8buffer = Uint8Buffer();
    var codeUnits = msg.codeUnits;
    uint8buffer.addAll(codeUnits);
    return mqttClient.publishMessage(pTopic, qos, uint8buffer, retain: false);
  }

  Subscription subscribeMessage(String subtopic) {
    return mqttClient.subscribe(subtopic, qos);
  }

  unsubscribeMessage(String unSubtopic) {
    mqttClient.unsubscribe(unSubtopic);
  }

  MqttClientConnectionStatus getMqttStatus() {
    return mqttClient.connectionStatus;
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>> updates() {
    _log("_监听成功!");
    return mqttClient.updates;
  }

  onConnected(ConnectedCallback callback) {
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
