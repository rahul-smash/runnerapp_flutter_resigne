import 'dart:convert';
CouponResponse couponResponseFromJson(String str) => CouponResponse.fromJson(json.decode(str));
String couponResponseToJson(CouponResponse data) => json.encode(data.toJson());

class CouponResponse {
  bool success;
  String message;
  List<Data> data;

  CouponResponse({this.success, this.message, this.data});

  CouponResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String id;
  String brandId;
  String name;
  String couponCode;
  String discount;
  String usageLimit;
  String minimumOrderAmount;
  String orderFacilities;
  String offerNotification;
  String validFrom;
  String validTo;
  String offerTermCondition;
  String discountUpto;
  String discountType;
  String image;
  String image10080;
  String image300200;

  Data(
      {this.id,
        this.brandId,
        this.name,
        this.couponCode,
        this.discount,
        this.usageLimit,
        this.minimumOrderAmount,
        this.orderFacilities,
        this.offerNotification,
        this.validFrom,
        this.validTo,
        this.offerTermCondition,
        this.discountUpto,
        this.discountType,
        this.image,
        this.image10080,
        this.image300200});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brandId = json['brand_id'];
    name = json['name'];
    couponCode = json['coupon_code'];
    discount = json['discount'];
    usageLimit = json['usage_limit'];
    minimumOrderAmount = json['minimum_order_amount'];
    orderFacilities = json['order_facilities'];
    offerNotification = json['offer_notification'];
    validFrom = json['valid_from'];
    validTo = json['valid_to'];
    offerTermCondition = json['offer_term_condition'];
    discountUpto = json['discount_upto'];
    discountType = json['discount_type'];
    image = json['image'];
    image10080 = json['image_100_80'];
    image300200 = json['image_300_200'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['brand_id'] = this.brandId;
    data['name'] = this.name;
    data['coupon_code'] = this.couponCode;
    data['discount'] = this.discount;
    data['usage_limit'] = this.usageLimit;
    data['minimum_order_amount'] = this.minimumOrderAmount;
    data['order_facilities'] = this.orderFacilities;
    data['offer_notification'] = this.offerNotification;
    data['valid_from'] = this.validFrom;
    data['valid_to'] = this.validTo;
    data['offer_term_condition'] = this.offerTermCondition;
    data['discount_upto'] = this.discountUpto;
    data['discount_type'] = this.discountType;
    data['image'] = this.image;
    data['image_100_80'] = this.image10080;
    data['image_300_200'] = this.image300200;
    return data;
  }
}
