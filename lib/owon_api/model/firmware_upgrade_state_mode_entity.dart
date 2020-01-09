class FirmwareUpgradeStateModeEntity {
	int index;
	int progress;
	int state;
	int filesize;
	int filenum;

	FirmwareUpgradeStateModeEntity({this.index, this.progress, this.state, this.filesize, this.filenum});

	FirmwareUpgradeStateModeEntity.fromJson(Map<String, dynamic> json) {
		index = json['index'];
		progress = json['progress'];
		state = json['state'];
		filesize = json['file_size'];
		filenum = json['file_num'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['index'] = this.index;
		data['progress'] = this.progress;
		data['state'] = this.state;
		data['file_size'] = this.filesize;
		data['file_num'] = this.filenum;
		return data;
	}
}
