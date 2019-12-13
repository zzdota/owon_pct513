import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:owon_pct513/res/owon_constant.dart';

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

  Map<String, dynamic> getVerifyCode(
    String userName,
    int cType,
  ) {
    return <String, dynamic>{
      'type': "/nt/user/register",
      'ts': DateTime.now().millisecondsSinceEpoch.toString(),
      'token': "",
      'param': <String, dynamic>{
        "account": userName,
        "atype": RegexUtil.isEmail(userName) ? 1 : 2,
        "ctype": cType,
        "agentid": OwonConstant.agentID,
      },
    };
  }

  Map<String, dynamic> registerAccount(String userName, String password,
      String cType, String lang, String timezoneId, String verifyCode) {
    return <String, dynamic>{
      'type': "/sendvcode",
      'ts': DateTime.now().millisecondsSinceEpoch.toString(),
      'token': "",
      'param': <String, dynamic>{
        "account": userName,
        "password": password,
        "atype": RegexUtil.isEmail(userName) ? 1 : 2,
        "ctype": cType,
        "agentid": OwonConstant.agentID,
        "lang": lang,
        "timezoneid": timezoneId,
        "vcode": verifyCode
      },
    };
  }

  Map<String, dynamic> changePassword(String userName, String oldPassword,
      String newPassword) {
    return <String, dynamic>{
      'type': "/nt/user/pswmodify",
      'ts': DateTime.now().millisecondsSinceEpoch.toString(),
      'token': "",
      'param': <String, dynamic>{
        "account": userName,
        "opsw": oldPassword,
        "npsw": newPassword,
      },
    };
  }

  Map<String, dynamic> recoveryPassword(String userName, String newPassword,String verifyCode) {
    return <String, dynamic>{
      'type': "/nt/user/pswrecovery",
      'ts': DateTime.now().millisecondsSinceEpoch.toString(),
      'token': "",
      'param': <String, dynamic>{
        "account": userName,
        "atype": RegexUtil.isEmail(userName) ? 1 : 2,
        "npsw": newPassword,
        "vcode": verifyCode
      },
    };
  }


}
