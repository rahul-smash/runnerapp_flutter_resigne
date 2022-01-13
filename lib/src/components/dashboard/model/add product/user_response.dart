import 'dart:convert';

CustomerData customerdataResponseFromJson(String str) => CustomerData.fromJson(json.decode(str));

String customerdataResponseToJson(CustomerData data) => json.encode(data.toJson());

class CustomerData {
  bool success;
  String message;
  AddressData data;

  CustomerData({this.success, this.message, this.data});

  CustomerData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new AddressData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class AddressData {
  String id;
  String fullName;
  String phone;
  String email;
  String status;
  String profileImage;
  String brandId;
  dynamic loyalityPoints;
  List<CustomerAddress> customerAddress;

  AddressData(
      {this.id,
        this.fullName,
        this.phone,
        this.email,
        this.status,
        this.profileImage,
        this.brandId,
        this.loyalityPoints,
        this.customerAddress});

  AddressData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    phone = json['phone'];
    email = json['email'];
    status = json['status'];
    profileImage = json['profile_image'];
    brandId = json['brand_id'];
    loyalityPoints = json['loyalityPoints'];
    if (json['customer_address'] != null) {
      customerAddress = new List<CustomerAddress>();
      json['customer_address'].forEach((v) {
        customerAddress.add(new CustomerAddress.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['status'] = this.status;
    data['profile_image'] = this.profileImage;
    data['brand_id'] = this.brandId;
    data['loyalityPoints'] = this.loyalityPoints;
    if (this.customerAddress != null) {
      data['customer_address'] =
          this.customerAddress.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerAddress {
  String id;
  String brandId;
  String userId;
  String firstName;
  String lastName;
  String mobile;
  String email;
  String address;
  String address2;
  String city;
  String state;
  String zipcode;
  String lat;
  String lng;
  String addressType;
  String setDefaultAddress;
  String areaName;
  bool notAllow;
  String areaCharges;
  String minAmount;
  String note;
  String cityId;
  bool isDeleted;
  DeliveryTimeSlot deliveryTimeSlot;

  CustomerAddress(
      {this.id,
        this.brandId,
        this.userId,
        this.firstName,
        this.lastName,
        this.mobile,
        this.email,
        this.address,
        this.address2,
        this.city,
        this.state,
        this.zipcode,
        this.lat,
        this.lng,
        this.addressType,
        this.setDefaultAddress,
        this.areaName,
        this.notAllow,
        this.areaCharges,
        this.minAmount,
        this.note,
        this.cityId,
        this.isDeleted,
        this.deliveryTimeSlot});

  CustomerAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brandId = json['brand_id'];
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    email = json['email'];
    address = json['address'];
    address2 = json['address2'];
    city = json['city'];
    state = json['state'];
    zipcode = json['zipcode'];
    lat = json['lat'];
    lng = json['lng'];
    addressType = json['address_type'];
    setDefaultAddress = json['set_default_address'];
    areaName = json['area_name'];
    notAllow = json['not_allow'];
    areaCharges = json['area_charges'];
    minAmount = json['min_amount'];
    note = json['note'];
    cityId = json['city_id'];
    isDeleted = json['is_deleted'];
    deliveryTimeSlot = json['delivery_time_slot'] != null
        ? new DeliveryTimeSlot.fromJson(json['delivery_time_slot'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['brand_id'] = this.brandId;
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['address'] = this.address;
    data['address2'] = this.address2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zipcode'] = this.zipcode;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address_type'] = this.addressType;
    data['set_default_address'] = this.setDefaultAddress;
    data['area_name'] = this.areaName;
    data['not_allow'] = this.notAllow;
    data['area_charges'] = this.areaCharges;
    data['min_amount'] = this.minAmount;
    data['note'] = this.note;
    data['city_id'] = this.cityId;
    data['is_deleted'] = this.isDeleted;
    if (this.deliveryTimeSlot != null) {
      data['delivery_time_slot'] = this.deliveryTimeSlot.toJson();
    }
    return data;
  }
}

class DeliveryTimeSlot {
  String zoneId;
  String is24x7Open;

  DeliveryTimeSlot({this.zoneId, this.is24x7Open});

  DeliveryTimeSlot.fromJson(Map<String, dynamic> json) {
    zoneId = json['zone_id'];
    is24x7Open = json['is24x7_open'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zone_id'] = this.zoneId;
    data['is24x7_open'] = this.is24x7Open;
    return data;
  }
}