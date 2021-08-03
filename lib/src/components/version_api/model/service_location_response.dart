// To parse this JSON data, do
//
//     final serviceLocationResponse = serviceLocationResponseFromJson(jsonString);

import 'dart:convert';

ServiceLocationResponse serviceLocationResponseFromJson(String str) => ServiceLocationResponse.fromJson(json.decode(str));

String serviceLocationResponseToJson(ServiceLocationResponse data) => json.encode(data.toJson());

class ServiceLocationResponse {
  ServiceLocationResponse({
    this.success,
    this.data,
  });

  bool success;
  List<ServiceLocationData> data;

  factory ServiceLocationResponse.fromJson(Map<String, dynamic> json) => ServiceLocationResponse(
    success: json["success"],
    data: List<ServiceLocationData>.from(json["data"].map((x) => ServiceLocationData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ServiceLocationData {
  ServiceLocationData({
    this.id,
    this.brandId,
    this.name,
  });

  String id;
  String brandId;
  String name;

  factory ServiceLocationData.fromJson(Map<String, dynamic> json) => ServiceLocationData(
    id: json["id"],
    brandId: json["brand_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "brand_id": brandId,
    "name": name,
  };
}
