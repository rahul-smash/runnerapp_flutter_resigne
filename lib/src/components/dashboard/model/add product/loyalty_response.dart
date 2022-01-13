import 'dart:convert';

LoyaltyResponse loyaltyResponseFromJson(String str) => LoyaltyResponse.fromJson(json.decode(str));

String loyaltyResponseToJson(LoyaltyResponse data) => json.encode(data.toJson());

class LoyaltyResponse {
  bool success;
  String loyalityPoints;
  String redeemLimit;
  List<Data> data;

  LoyaltyResponse(
      {this.success, this.loyalityPoints, this.redeemLimit, this.data});

  LoyaltyResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    loyalityPoints = json['loyality_points'];
    redeemLimit = json['redeem_limit'];
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
    data['loyality_points'] = this.loyalityPoints;
    data['redeem_limit'] = this.redeemLimit;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String id;
  String brandId;
  String amount;
  String points;
  String couponCode;

  Data({this.id, this.brandId, this.amount, this.points, this.couponCode});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brandId = json['brand_id'];
    amount = json['amount'];
    points = json['points'];
    couponCode = json['coupon_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['brand_id'] = this.brandId;
    data['amount'] = this.amount;
    data['points'] = this.points;
    data['coupon_code'] = this.couponCode;
    return data;
  }
}