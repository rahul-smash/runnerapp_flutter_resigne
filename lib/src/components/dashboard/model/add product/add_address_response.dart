import 'dart:convert';

AddAddressResponse addressResponseFromJson(String str) => AddAddressResponse.fromJson(json.decode(str));

String addressResponseToJson(AddAddressResponse data) => json.encode(data.toJson());

class AddAddressResponse {
  bool success;
  Data data;
  String message;

  AddAddressResponse({this.success, this.data, this.message});

  AddAddressResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String userId;
  String method;
  String firstName;
  String mobile;
  String address;
  String areaName;
  String areaId;
  String state;
  String city;
  String zipcode;
  String addressId;
  String storeId;
  String brandId;
  String county;
  dynamic lat;
  dynamic lng;
  String modified;
  String created;
  String id;

  Data(
      {this.userId,
        this.method,
        this.firstName,
        this.mobile,
        this.address,
        this.areaName,
        this.areaId,
        this.state,
        this.city,
        this.zipcode,
        this.addressId,
        this.storeId,
        this.brandId,
        this.county,
        this.lat,
        this.lng,
        this.modified,
        this.created,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    method = json['method'];
    firstName = json['first_name'];
    mobile = json['mobile'];
    address = json['address'];
    areaName = json['area_name'];
    areaId = json['area_id'];
    state = json['state'];
    city = json['city'];
    zipcode = json['zipcode'];
    addressId = json['address_id'];
    storeId = json['store_id'];
    brandId = json['brand_id'];
    county = json['county'];
    lat = json['lat'];
    lng = json['lng'];
    modified = json['modified'];
    created = json['created'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['method'] = this.method;
    data['first_name'] = this.firstName;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['area_name'] = this.areaName;
    data['area_id'] = this.areaId;
    data['state'] = this.state;
    data['city'] = this.city;
    data['zipcode'] = this.zipcode;
    data['address_id'] = this.addressId;
    data['store_id'] = this.storeId;
    data['brand_id'] = this.brandId;
    data['county'] = this.county;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['modified'] = this.modified;
    data['created'] = this.created;
    data['id'] = this.id;
    return data;
  }
}