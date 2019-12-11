import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

class OwonApiHttp {
  Map<String, dynamic> login(String userName, String password) {
    return <String, dynamic>{
      "type": "/nt/user/mqttapplogin",
      "ts": DateTime.now().millisecondsSinceEpoch.toString(),
      "token": "",
      "param": <String, dynamic>{
        "account": userName,
        "password": EnDecodeUtil.encodeMd5(password),
        // ignore: unrelated_type_equality_checks
        "os": TargetPlatform == TargetPlatform.android ? "android" : "ios",
        "cversion": "0.0.1"
      }
    };
  }
}
