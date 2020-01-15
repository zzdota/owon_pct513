class AddressInfoModelEntity {
  String address;
  String description;
  double latitude;
  double longitude;

  AddressInfoModelEntity({this.address, this.description, this.latitude, this.longitude});

  AddressInfoModelEntity.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    description = json['description'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['description'] = this.description;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
