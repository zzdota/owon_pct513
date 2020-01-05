import 'package:owon_pct513/owon_api/model/get_geofence_mode_entity.dart';
import 'package:owon_pct513/generated/json/base/json_filed.dart';

getGeofenceModeEntityFromJson(GetGeofenceModeEntity data, Map<String, dynamic> json) {
	data.code = json['code'];
	data.command = json['command'];
	data.response = json['response'] != null ? new GetGeofenceModeResponse().fromJson(json['response']) : null;
	data.sequence = json['sequence'];
	return data;
}

Map<String, dynamic> getGeofenceModeEntityToJson(GetGeofenceModeEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['command'] = entity.command;
	if (entity.response != null) {
		data['response'] = GetGeofenceModeResponse().toJson();
	}
	data['sequence'] = entity.sequence;
	return data;
}

getGeofenceModeResponseFromJson(GetGeofenceModeResponse data, Map<String, dynamic> json) {
	if (json['devices'] != null) {
		data.devices = new List<GetGeofenceModeResponseDevice>();
		(json['devices'] as List).forEach((v) {
			data.devices.add(new GetGeofenceModeResponseDevice().fromJson(v));
		});
	}
	data.enterGeofenceAction = json['enterGeofenceAction'];
	data.geoFencingEnable = json['geoFencingEnable'];
	data.leaveGeofenceAction = json['leaveGeofenceAction'];
	return data;
}

Map<String, dynamic> getGeofenceModeResponseToJson(GetGeofenceModeResponse entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.devices != null) {
		data['devices'] =  entity.devices.map((v) => v.toJson()).toList();
	}
	data['enterGeofenceAction'] = entity.enterGeofenceAction;
	data['geoFencingEnable'] = entity.geoFencingEnable;
	data['leaveGeofenceAction'] = entity.leaveGeofenceAction;
	return data;
}

getGeofenceModeResponseDeviceFromJson(GetGeofenceModeResponseDevice data, Map<String, dynamic> json) {
	data.deviceid = json['deviceid'];
	data.devname = json['devname'];
	data.geoSelect = json['geoSelect'];
	return data;
}

Map<String, dynamic> getGeofenceModeResponseDeviceToJson(GetGeofenceModeResponseDevice entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['deviceid'] = entity.deviceid;
	data['devname'] = entity.devname;
	data['geoSelect'] = entity.geoSelect;
	return data;
}