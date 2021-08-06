// To parse this JSON data, do
//
//     final categoryServiceModel = categoryServiceModelFromJson(jsonString);

import 'dart:convert';

CategoryServiceModel categoryServiceModelFromJson(String str) => CategoryServiceModel.fromJson(json.decode(str));

String categoryServiceModelToJson(CategoryServiceModel data) => json.encode(data.toJson());

class CategoryServiceModel {
  CategoryServiceModel({
    this.success,
    this.data,
  });

  bool success;
  List<ServiceData> data;

  factory CategoryServiceModel.fromJson(Map<String, dynamic> json) => CategoryServiceModel(
    success: json["success"],
    data: List<ServiceData>.from(json["data"].map((x) => ServiceData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ServiceData {
  ServiceData({
    this.id,
    this.title,
    this.lang2Title,
    this.version,
    this.parentId,
    this.status,
    this.deleted,
    this.sort,
    this.parentCategory,
    this.parentCategoryLang2Title,
    this.image10080,
    this.image300200,
    this.image,
    this.products,
  });

  String id;
  String title;
  String lang2Title;
  String version;
  String parentId;
  String status;
  bool deleted;
  String sort;
  String parentCategory;
  String parentCategoryLang2Title;
  String image10080;
  String image300200;
  String image;
  List<Product> products;

  factory ServiceData.fromJson(Map<String, dynamic> json) => ServiceData(
    id: json["id"],
    title: json["title"],
    lang2Title: json["lang_2_title"],
    version: json["version"],
    parentId: json["parent_id"],
    status: json["status"],
    deleted: json["deleted"],
    sort: json["sort"],
    parentCategory: json["parent_category"],
    parentCategoryLang2Title: json["parent_category_lang_2_title"],
    image10080: json["image_100_80"],
    image300200: json["image_300_200"],
    image: json["image"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "lang_2_title": lang2Title,
    "version": version,
    "parent_id": parentId,
    "status": status,
    "deleted": deleted,
    "sort": sort,
    "parent_category": parentCategory,
    "parent_category_lang_2_title": parentCategoryLang2Title,
    "image_100_80": image10080,
    "image_300_200": image300200,
    "image": image,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class Product {
  Product({
    this.id,
    this.title,
    this.categoryIds,
    this.variants,
  });

  String id;
  String title;
  String categoryIds;
  List<Variant> variants;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    title: json["title"],
    categoryIds: json["category_ids"],
    variants: List<Variant>.from(json["variants"].map((x) => Variant.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "category_ids": categoryIds,
    "variants": List<dynamic>.from(variants.map((x) => x.toJson())),
  };
}

class Variant {
  Variant({
    this.id,
    this.productId,
    this.duration,
    this.mrpPrice,
    this.price,
    this.discount,
    this.servicePayout,
  });

  String id;
  String productId;
  String duration;
  String mrpPrice;
  String price;
  String discount;
  String servicePayout;

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    id: json["id"],
    productId: json["product_id"],
    duration: json["duration"],
    mrpPrice: json["mrp_price"],
    price: json["price"],
    discount: json["discount"],
    servicePayout: json["service_payout"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "duration": duration,
    "mrp_price": mrpPrice,
    "price": price,
    "discount": discount,
    "service_payout": servicePayout,
  };
}
