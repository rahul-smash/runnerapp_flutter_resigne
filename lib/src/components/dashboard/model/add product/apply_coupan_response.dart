import 'dart:convert';

ApplyCouponResponse applyCouponResponseFromJson(String str) => ApplyCouponResponse.fromJson(json.decode(str));
String applyCouponResponseToJson(ApplyCouponResponse data) => json.encode(data.toJson());
class ApplyCouponResponse {
  bool success;
  String message;
  String discountAmount;
  CouponData data;

  ApplyCouponResponse({this.success, this.message, this.data});

  ApplyCouponResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    discountAmount = json['DiscountAmount'];
    data = json['data'] != null ? new CouponData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['DiscountAmount'] = this.discountAmount;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class CouponData{

  String id;
  String storeId;
  String discountType;
  String orderFacilities;
  String paymentMethod;
  String name;
  String couponCode;
  String discount;
  String discountUpto;
  String minimumOrderAmount;
  String usageLimit;
  String validFrom;
  String validTo;
  String offerNotification;
  String offerTermCondition;
  String offerDescription;
  String status;
  String show;
  String sort;
  String created;
  String modified;

  CouponData({this.id, this.storeId, this.discountType, this.orderFacilities,
    this.paymentMethod, this.name, this.couponCode, this.discount,this.discountUpto,
    this.minimumOrderAmount,this.usageLimit, this.validFrom, this.validTo, this.offerNotification,
    this.offerTermCondition, this.offerDescription, this.status,this.show,
    this.sort,this.created,this.modified
  });

  CouponData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    discountType = json['discount_type'];
    orderFacilities = json['order_facilities'];
    paymentMethod = json['payment_method'];
    name = json['name'];
    couponCode = json['coupon_code'];
    discount = json['discount'];
    discountUpto = json['discount_upto'];
    minimumOrderAmount = json['minimum_order_amount'];
    usageLimit = json['usage_limit'];
    validFrom = json['valid_from'];
    validTo = json['valid_to'];
    offerNotification = json['offer_notification'];
    offerTermCondition = json['offer_term_condition'];
    offerDescription = json['offer_description'];
    status = json['status'];
    show = json['show'];
    sort = json['sort'];
    created = json['created'];
    modified = json['modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_id'] = this.storeId;
    data['discount_type'] = this.discountType;
    data['order_facilities'] = this.orderFacilities;
    data['payment_method'] = this.paymentMethod;
    data['name'] = this.name;
    data['coupon_code'] = this.couponCode;
    data['discount'] = this.discount;
    data['discount_upto'] = this.discountUpto;
    data['minimum_order_amount'] = this.minimumOrderAmount;
    data['usage_limit'] = this.usageLimit;
    data['valid_from'] = this.validFrom;
    data['valid_to'] = this.validTo;
    data['offer_notification'] = this.offerNotification;
    data['offer_term_condition'] = this.offerTermCondition;
    data['offer_description'] = this.offerDescription;
    data['status'] = this.status;
    data['show'] = this.show;
    data['sort'] = this.sort;
    data['created']  = this.created;
    data['modified'] = this.modified;
    return data;
  }
}