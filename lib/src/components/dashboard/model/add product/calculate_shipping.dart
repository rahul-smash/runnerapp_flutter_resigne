import 'dart:convert';

CalculateShipping calculateResponseFromJson(String str) => CalculateShipping.fromJson(json.decode(str));

String calculateResponseToJson(CalculateShipping data) => json.encode(data.toJson());


class CalculateShipping {
  bool success;
  String shipping;
  String message;

  CalculateShipping({this.success, this.shipping, this.message});

  CalculateShipping.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    shipping = json['shipping'];
    message = json['message'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['shipping'] = this.shipping;
    data['message'] = this.message;
    return data;
  }
}