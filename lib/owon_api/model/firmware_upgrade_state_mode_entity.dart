class FirmwareUpgradeStateModeEntity {
	int index;
	int progress;
	int state;
	int filesize;

	FirmwareUpgradeStateModeEntity({this.index, this.progress, this.state, this.filesize});

	FirmwareUpgradeStateModeEntity.fromJson(Map<String, dynamic> json) {
		index = json['index'];
		progress = json['progress'];
		state = json['state'];
		filesize = json['filesize'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['index'] = this.index;
		data['progress'] = this.progress;
		data['state'] = this.state;
		data['filesize'] = this.filesize;
		return data;
	}
}
