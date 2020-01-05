import 'package:owon_pct513/generated/json/base/json_convert_content.dart';
import 'package:owon_pct513/generated/json/base/json_filed.dart';

class GetGeofenceModeEntity with JsonConvert<GetGeofenceModeEntity> {
	int code;
	String command;
	GetGeofenceModeResponse response;
	int sequence;
}

class GetGeofenceModeResponse with JsonConvert<GetGeofenceModeResponse> {
	List<GetGeofenceModeResponseDevice> devices;
	int enterGeofenceAction;
	int geoFencingEnable;
	int leaveGeofenceAction;
}

class GetGeofenceModeResponseDevice with JsonConvert<GetGeofenceModeResponseDevice> {
	String deviceid;
	String devname;
	int geoSelect;
}
