class SensorListModelEntity {
	List<SensorListModelParam> para;

	SensorListModelEntity({this.para});

	SensorListModelEntity.fromJson(Map<String, dynamic> json) {
		if (json['para'] != null) {
			para = new List<SensorListModelParam>();(json['para'] as List).forEach((v) { para.add(new SensorListModelParam.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.para != null) {
      data['para'] =  this.para.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class SensorListModelParam {
	int temp;
	int occupy;
	int batteryStatus;
	int enable;
	String name;
	int id;
	String reserver;
	int connect;
	int scheduleId;

	SensorListModelParam({this.temp, this.occupy, this.batteryStatus, this.enable, this.name, this.id, this.reserver, this.connect, this.scheduleId});

	SensorListModelParam.fromJson(Map<String, dynamic> json) {
		temp = json['temp'];
		occupy = json['occupy'];
		batteryStatus = json['batteryStatus'];
		enable = json['enable'];
		name = json['name'];
		id = json['id'];
		reserver = json['reserver'];
		connect = json['connect'];
		scheduleId = json['scheduleId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['temp'] = this.temp;
		data['occupy'] = this.occupy;
		data['batteryStatus'] = this.batteryStatus;
		data['enable'] = this.enable;
		data['name'] = this.name;
		data['id'] = this.id;
		data['reserver'] = this.reserver;
		data['connect'] = this.connect;
		data['scheduleId'] = this.scheduleId;
		return data;
	}
}
