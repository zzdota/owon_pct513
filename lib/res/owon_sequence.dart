class OwonSequence {
  static const int addList = 0;
  static const int temp = addList + 1;
  static const int humid = temp + 1;
  static const int schedule = humid + 1;
  static const int settingTempUnit = schedule + 1;
  static const int getScheduleEnable = settingTempUnit + 1;
  static const int getSensorList = getScheduleEnable + 1;
  static const int getDeviceInfo = getSensorList + 1;
  static const int getDeviceUpgradeInfo = getDeviceInfo + 1;
  static const int getGeofence = getDeviceUpgradeInfo + 1;
  static const int setGeofence = getGeofence + 1;
}
