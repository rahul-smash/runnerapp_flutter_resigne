// To parse this JSON data, do
//
//     final categoriesResponse = categoriesResponseFromJson(jsonString);

import 'dart:convert';

CategoriesResponse categoriesResponseFromJson(String str) =>
    CategoriesResponse.fromJson(json.decode(str));

String categoriesResponseToJson(CategoriesResponse data) =>
    json.encode(data.toJson());

class CategoriesResponse {
  CategoriesResponse({
    this.page,
    this.pagelength,
    this.categoryTotal,
    this.success,
    this.data,
  });

  String page;
  String pagelength;
  int categoryTotal;
  bool success;
  List<Category> data;

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) =>
      CategoriesResponse(
        page: json["page"] == null ? null : json["page"],
        pagelength: json["pagelength"] == null ? null : json["pagelength"],
        categoryTotal:
        json["category_total"] == null ? null : json["category_total"],
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null
            ? null
            : List<Category>.from(
            json["data"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "page": page == null ? null : page,
    "pagelength": pagelength == null ? null : pagelength,
    "category_total": categoryTotal == null ? null : categoryTotal,
    "success": success == null ? null : success,
    "data": data == null
        ? null
        : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Category {
  Category({
    this.id,
    this.title,
    this.version,
    this.status,
    this.deleted,
    this.showProductImage,
    this.sort,
    this.image10080,
    this.image300200,
    this.image,
    this.subCategoryTotal,
    this.subCategory,
  });

  String id;
  String title;
  String version;
  String status;
  bool deleted;
  String showProductImage;
  String sort;
  String image10080;
  String image300200;
  String image;
  int subCategoryTotal;
  List<SubCategory> subCategory;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    version: json["version"] == null ? null : json["version"],
    status: json["status"] == null ? null : json["status"],
    deleted: json["deleted"] == null ? null : json["deleted"],
    showProductImage: json["show_product_image"] == null
        ? null
        : json["show_product_image"],
    sort: json["sort"] == null ? null : json["sort"],
    image10080: json["image_100_80"] == null ? null : json["image_100_80"],
    image300200:
    json["image_300_200"] == null ? null : json["image_300_200"],
    image: json["image"] == null ? null : json["image"],
    subCategoryTotal: json["sub_category_total"] == null
        ? null
        : json["sub_category_total"],
    subCategory: json["sub_category"] == null
        ? null
        : List<SubCategory>.from(
        json["sub_category"].map((x) => SubCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "version": version == null ? null : version,
    "status": status == null ? null : status,
    "deleted": deleted == null ? null : deleted,
    "show_product_image":
    showProductImage == null ? null : showProductImage,
    "sort": sort == null ? null : sort,
    "image_100_80": image10080 == null ? null : image10080,
    "image_300_200": image300200 == null ? null : image300200,
    "image": image == null ? null : image,
    "sub_category_total":
    subCategoryTotal == null ? null : subCategoryTotal,
    "sub_category": subCategory == null
        ? null
        : List<dynamic>.from(subCategory.map((x) => x.toJson())),
  };
}

class SubCategory {
  SubCategory({
    this.id,
    this.title,
    this.version,
    this.status,
    this.deleted,
    this.showProductImage,
    this.sort,
    this.image10080,
    this.image300200,
    this.image,
  });

  String id;
  String title;
  String version;
  String status;
  bool deleted;
  String showProductImage;
  String sort;
  String image10080;
  String image300200;
  String image;
  String categoryName;
  String categoryId;
  bool isOpen;

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    version: json["version"] == null ? null : json["version"],
    status: json["status"] == null ? null : json["status"],
    deleted: json["deleted"] == null ? null : json["deleted"],
    showProductImage: json["show_product_image"] == null
        ? null
        : json["show_product_image"],
    sort: json["sort"] == null ? null : json["sort"],
    image10080: json["image_100_80"] == null ? null : json["image_100_80"],
    image300200:
    json["image_300_200"] == null ? null : json["image_300_200"],
    image: json["image"] == null ? null : json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "version": version == null ? null : version,
    "status": status == null ? null : status,
    "deleted": deleted == null ? null : deleted,
    "show_product_image":
    showProductImage == null ? null : showProductImage,
    "sort": sort == null ? null : sort,
    "image_100_80": image10080 == null ? null : image10080,
    "image_300_200": image300200 == null ? null : image300200,
    "image": image == null ? null : image,
  };
}
