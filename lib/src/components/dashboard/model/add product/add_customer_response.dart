import 'dart:convert';

AddCustomerResponse addCustomerResponseFromJson(String str) => AddCustomerResponse.fromJson(json.decode(str));

String addCustomerResponseToJson(AddCustomerResponse data) => json.encode(data.toJson());
class AddCustomerResponse {
  bool success;
  Data data;
  String message;

  AddCustomerResponse({this.success, this.data, this.message});

  AddCustomerResponse.fromJson(Map<String, dynamic> json) {
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
  StoreUser storeUser;
  User user;
  Address address;

  Data({this.storeUser, this.user, this.address});

  Data.fromJson(Map<String, dynamic> json) {
    storeUser = json['StoreUser'] != null
        ? new StoreUser.fromJson(json['StoreUser'])
        : null;
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.storeUser != null) {
      data['StoreUser'] = this.storeUser.toJson();
    }
    if (this.user != null) {
      data['User'] = this.user.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    return data;
  }
}

class StoreUser {
  int storeId;
  String userId;
  String roleId;
  String storeCreatedBy;
  String brandId;
  String modified;
  String created;
  String id;

  StoreUser(
      {this.storeId,
        this.userId,
        this.roleId,
        this.storeCreatedBy,
        this.brandId,
        this.modified,
        this.created,
        this.id});

  StoreUser.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    userId = json['user_id'];
    roleId = json['role_id'];
    storeCreatedBy = json['store_created_by'];
    brandId = json['brand_id'];
    modified = json['modified'];
    created = json['created'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_id'] = this.storeId;
    data['user_id'] = this.userId;
    data['role_id'] = this.roleId;
    data['store_created_by'] = this.storeCreatedBy;
    data['brand_id'] = this.brandId;
    data['modified'] = this.modified;
    data['created'] = this.created;
    data['id'] = this.id;
    return data;
  }
}

class User {
  String phone;
  String fullName;
  String email;

  User({this.phone, this.fullName, this.email});

  User.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    fullName = json['full_name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    return data;
  }
}

class Address {
  String brandId;
  String addressType;
  String setDefaultAddress;
  String softdelete;
  String userId;
  String firstName;
  String mobile;
  String email;
  String address;
  String city;
  String state;
  String zipcode;
  dynamic lat;
  dynamic lng;
  String modified;
  String created;
  String id;

  Address(
      {this.brandId,
        this.addressType,
        this.setDefaultAddress,
        this.softdelete,
        this.userId,
        this.firstName,
        this.mobile,
        this.email,
        this.address,
        this.city,
        this.state,
        this.zipcode,
        this.lat,
        this.lng,
        this.modified,
        this.created,
        this.id});

  Address.fromJson(Map<String, dynamic> json) {
    brandId = json['brand_id'];
    addressType = json['address_type'];
    setDefaultAddress = json['set_default_address'];
    softdelete = json['softdelete'];
    userId = json['user_id'];
    firstName = json['first_name'];
    mobile = json['mobile'];
    email = json['email'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zipcode = json['zipcode'];
    lat = json['lat'];
    lng = json['lng'];
    modified = json['modified'];
    created = json['created'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brand_id'] = this.brandId;
    data['address_type'] = this.addressType;
    data['set_default_address'] = this.setDefaultAddress;
    data['softdelete'] = this.softdelete;
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zipcode'] = this.zipcode;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['modified'] = this.modified;
    data['created'] = this.created;
    data['id'] = this.id;
    return data;
  }
}