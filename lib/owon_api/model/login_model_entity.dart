class LoginModelEntity {
  String msg;
  String code;
  LoginModelResponse response;
  String ts;

  LoginModelEntity({this.msg, this.code, this.response, this.ts});

  LoginModelEntity.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    response = json['response'] != null
        ? new LoginModelResponse.fromJson(json['response'])
        : null;
    ts = json['ts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    data['ts'] = this.ts;
    return data;
  }
}

class LoginModelResponse {
  String mqttserver;
  int update;
  dynamic retryPswRemainCout;
  int mqttport;
  String uversion;
  dynamic retryRemainTime;
  String token;
  String refreshToken;
  int mqttsslport;

  LoginModelResponse(
      {this.mqttserver,
      this.update,
      this.retryPswRemainCout,
      this.mqttport,
      this.uversion,
      this.retryRemainTime,
      this.token,
      this.refreshToken,
      this.mqttsslport});

  LoginModelResponse.fromJson(Map<String, dynamic> json) {
    mqttserver = json['mqttserver'];
    update = json['update'];
    retryPswRemainCout = json['retryPswRemainCout'];
    mqttport = json['mqttport'];
    uversion = json['uversion'];
    retryRemainTime = json['retryRemainTime'];
    token = json['token'];
    refreshToken = json['refreshToken'];
    mqttsslport = json['mqttsslport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mqttserver'] = this.mqttserver;
    data['update'] = this.update;
    data['retryPswRemainCout'] = this.retryPswRemainCout;
    data['mqttport'] = this.mqttport;
    data['uversion'] = this.uversion;
    data['retryRemainTime'] = this.retryRemainTime;
    data['token'] = this.token;
    data['refreshToken'] = this.refreshToken;
    data['mqttsslport'] = this.mqttsslport;
    return data;
  }
}
