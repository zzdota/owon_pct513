class VactionModelEntity {
	List<VactionModelPara> para;

	VactionModelEntity({this.para});

	VactionModelEntity.fromJson(Map<String, dynamic> json) {
		if (json['para'] != null) {
			para = new List<VactionModelPara>();(json['para'] as List).forEach((v) { para.add(new VactionModelPara.fromJson(v)); });
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

class VactionModelPara {
	int heat;
	int sHour;
	int eMonth;
	int eMin;
	int sMonth;
	int cool;
	int eHour;
	int eDay;
	int sMin;
	int eYear;
	int sDay;
	int sYear;

	VactionModelPara({this.heat, this.sHour, this.eMonth, this.eMin, this.sMonth, this.cool, this.eHour, this.eDay, this.sMin, this.eYear, this.sDay, this.sYear});

	VactionModelPara.fromJson(Map<String, dynamic> json) {
		heat = json['heat'];
		sHour = json['sHour'];
		eMonth = json['eMonth'];
		eMin = json['eMin'];
		sMonth = json['sMonth'];
		cool = json['cool'];
		eHour = json['eHour'];
		eDay = json['eDay'];
		sMin = json['sMin'];
		eYear = json['eYear'];
		sDay = json['sDay'];
		sYear = json['sYear'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['heat'] = this.heat;
		data['sHour'] = this.sHour;
		data['eMonth'] = this.eMonth;
		data['eMin'] = this.eMin;
		data['sMonth'] = this.sMonth;
		data['cool'] = this.cool;
		data['eHour'] = this.eHour;
		data['eDay'] = this.eDay;
		data['sMin'] = this.sMin;
		data['eYear'] = this.eYear;
		data['sDay'] = this.sDay;
		data['sYear'] = this.sYear;
		return data;
	}
}
