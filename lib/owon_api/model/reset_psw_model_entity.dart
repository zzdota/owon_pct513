class ResetPswModelEntity {
	String msg;
	String code;
	dynamic response;
	String ts;

	ResetPswModelEntity({this.msg, this.code, this.response, this.ts});

	ResetPswModelEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		response = json['response'];
		ts = json['ts'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['msg'] = this.msg;
		data['code'] = this.code;
		data['response'] = this.response;
		data['ts'] = this.ts;
		return data;
	}
}
