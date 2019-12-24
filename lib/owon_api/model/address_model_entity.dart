class AddressModelEntity {
	List<AddressModelAddr> addrs;
	String command;

	AddressModelEntity({this.addrs, this.command});

	AddressModelEntity.fromJson(Map<String, dynamic> json) {
		if (json['addrs'] != null) {
			addrs = new List<AddressModelAddr>();(json['addrs'] as List).forEach((v) { addrs.add(new AddressModelAddr.fromJson(v)); });
		}
		command = json['command'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.addrs != null) {
      data['addrs'] =  this.addrs.map((v) => v.toJson()).toList();
    }
		data['command'] = this.command;
		return data;
	}
}

class AddressModelAddr {
	String addrname;
	List<AddressModelAddrsDevlist> devlist;
	int addrid;
	double lon;
	double lat;

	AddressModelAddr({this.addrname, this.devlist, this.addrid, this.lon, this.lat});

	AddressModelAddr.fromJson(Map<String, dynamic> json) {
		addrname = json['addrname'];
		if (json['devlist'] != null) {
			devlist = new List<AddressModelAddrsDevlist>();(json['devlist'] as List).forEach((v) { devlist.add(new AddressModelAddrsDevlist.fromJson(v)); });
		}
		addrid = json['addrid'];
		lon = json['lon'];
		lat = json['lat'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['addrname'] = this.addrname;
		if (this.devlist != null) {
      data['devlist'] =  this.devlist.map((v) => v.toJson()).toList();
    }
		data['addrid'] = this.addrid;
		data['lon'] = this.lon;
		data['lat'] = this.lat;
		return data;
	}
}

class AddressModelAddrsDevlist {
	String modelid;
	String devname;
	String deviceid;
	bool tempUnit;

	AddressModelAddrsDevlist({this.modelid, this.devname, this.deviceid, this.tempUnit});

	AddressModelAddrsDevlist.fromJson(Map<String, dynamic> json) {
		modelid = json['modelid'];
		devname = json['devname'];
		deviceid = json['deviceid'];
		tempUnit = json['tempUnit'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['modelid'] = this.modelid;
		data['devname'] = this.devname;
		data['deviceid'] = this.deviceid;
		data['tempUnit'] = this.tempUnit;
		return data;
	}
}
