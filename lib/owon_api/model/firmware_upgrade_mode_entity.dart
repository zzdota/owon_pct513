class FirmwareUpgradeModeEntity {
	int sequence;
	int code;
	int filenum;
	String firmwaretype;
	String description;
	List<FirmwareUpgradeModeFile> files;
	int updatemethod;
	String type;
	String version;
	String command;
	String url;

	FirmwareUpgradeModeEntity({this.sequence, this.code, this.filenum, this.firmwaretype, this.description, this.files, this.updatemethod, this.type, this.version, this.command, this.url});

	FirmwareUpgradeModeEntity.fromJson(Map<String, dynamic> json) {
		sequence = json['sequence'];
		code = json['code'];
		filenum = json['filenum'];
		firmwaretype = json['firmwaretype'];
		description = json['description'];
		if (json['files'] != null) {
			files = new List<FirmwareUpgradeModeFile>();(json['files'] as List).forEach((v) { files.add(new FirmwareUpgradeModeFile.fromJson(v)); });
		}
		updatemethod = json['updatemethod'];
		type = json['type'];
		version = json['version'];
		command = json['command'];
		url = json['url'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['sequence'] = this.sequence;
		data['code'] = this.code;
		data['filenum'] = this.filenum;
		data['firmwaretype'] = this.firmwaretype;
		data['description'] = this.description;
		if (this.files != null) {
      data['files'] =  this.files.map((v) => v.toJson()).toList();
    }
		data['updatemethod'] = this.updatemethod;
		data['type'] = this.type;
		data['version'] = this.version;
		data['command'] = this.command;
		data['url'] = this.url;
		return data;
	}
}

class FirmwareUpgradeModeFile {
	String fileName;
	String checksum;
	int fileSize;

	FirmwareUpgradeModeFile({this.fileName, this.checksum, this.fileSize});

	FirmwareUpgradeModeFile.fromJson(Map<String, dynamic> json) {
		fileName = json['file_name'];
		checksum = json['checksum'];
		fileSize = json['file_size'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['file_name'] = this.fileName;
		data['checksum'] = this.checksum;
		data['file_size'] = this.fileSize;
		return data;
	}
}
