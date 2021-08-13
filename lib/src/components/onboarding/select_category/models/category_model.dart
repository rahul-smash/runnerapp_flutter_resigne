// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    this.success,
    this.data,
  });

  bool success;
  List<CategoryData> data;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    success: json["success"],
    data: List<CategoryData>.from(json["data"].map((x) => CategoryData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CategoryData {
  CategoryData({
    this.id,
    this.title,
    this.serviceCount,
  });

  String id;
  String title;
  String serviceCount;

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
    id: json["id"],
    title: json["title"],
    serviceCount: json["service_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "service_count": serviceCount,
  };
}
