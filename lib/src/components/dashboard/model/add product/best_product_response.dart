
import 'dart:convert';

BestProduct bestProductResponseFromJson(String str) => BestProduct.fromJson(json.decode(str));

String bestProductResponseToJson(BestProduct data) => json.encode(data.toJson());

class BestProduct {
  bool success;
  String total;
  String page;
  List<Data> data;

  BestProduct({this.success, this.total, this.page, this.data});

  BestProduct.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    total = json['total'];
    page = json['page'];
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
    data['total'] = this.total;
    data['page'] = this.page;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String id;
  String storeId;
  String categoryIds;
  String posProductId;
  String title;
  String brand;
  String nutrient;
  String description;
  String tags;
  String hsnCode;
  String image;
  String imageType;
  String imageUrl;
  dynamic showPrice;
  String isTaxEnable;
  String gstTaxType;
  String gstTaxRate;
  String posTaxDetail;
  String status;
  String sort;
  String rating;
  String saleCount;
  String isExportFromFile;
  bool deleted;
  String created;
  String image10080;
  String image300200;
  List<Variants> variants;
  SelectedVariant selectedVariant;
  int count=0;
  int selectedVariantIndex=0;

  Data(
      {this.id,
        this.storeId,
        this.categoryIds,
        this.posProductId,
        this.title,
        this.brand,
        this.nutrient,
        this.description,
        this.tags,
        this.hsnCode,
        this.image,
        this.imageType,
        this.imageUrl,
        this.showPrice,
        this.isTaxEnable,
        this.gstTaxType,
        this.gstTaxRate,
        this.posTaxDetail,
        this.status,
        this.sort,
        this.rating,
        this.saleCount,
        this.isExportFromFile,
        this.deleted,
        this.created,
        this.image10080,
        this.image300200,
        this.variants,
        this.selectedVariant,
        this.count,
        this.selectedVariantIndex,
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    categoryIds = json['category_ids'];
    posProductId = json['pos_product_id'];
    title = json['title'];
    brand = json['brand'];
    nutrient = json['nutrient'];
    description = json['description'];
    tags = json['tags'];
    hsnCode = json['hsn_code'];
    image = json['image'];
    imageType = json['image_type'];
    imageUrl = json['image_url'];
    showPrice = json['show_price'];
    isTaxEnable = json['isTaxEnable'];
    gstTaxType = json['gst_tax_type'];
    gstTaxRate = json['gst_tax_rate'];
    posTaxDetail = json['pos_tax_detail'];
    status = json['status'];
    sort = json['sort'];
    rating = json['rating'];
    saleCount = json['sale_count'];
    isExportFromFile = json['is_export_from_file'];
    deleted = json['deleted'];
    created = json['created'];
    image10080 = json['image_100_80'];
    image300200 = json['image_300_200'];
    if (json['variants'] != null) {
      variants = new List<Variants>();
      json['variants'].forEach((v) {
        variants.add(new Variants.fromJson(v));
      });
    }
    selectedVariant = json['selectedVariant'] != null
        ? new SelectedVariant.fromJson(json['selectedVariant'])
        : null;
    // count = json['count']!=null ? json['count'] : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_id'] = this.storeId;
    data['category_ids'] = this.categoryIds;
    data['pos_product_id'] = this.posProductId;
    data['title'] = this.title;
    data['brand'] = this.brand;
    data['nutrient'] = this.nutrient;
    data['description'] = this.description;
    data['tags'] = this.tags;
    data['hsn_code'] = this.hsnCode;
    data['image'] = this.image;
    data['image_type'] = this.imageType;
    data['image_url'] = this.imageUrl;
    data['show_price'] = this.showPrice;
    data['isTaxEnable'] = this.isTaxEnable;
    data['gst_tax_type'] = this.gstTaxType;
    data['gst_tax_rate'] = this.gstTaxRate;
    data['pos_tax_detail'] = this.posTaxDetail;
    data['status'] = this.status;
    data['sort'] = this.sort;
    data['rating'] = this.rating;
    data['sale_count'] = this.saleCount;
    data['is_export_from_file'] = this.isExportFromFile;
    data['deleted'] = this.deleted;
    data['created'] = this.created;
    data['image_100_80'] = this.image10080;
    data['image_300_200'] = this.image300200;
    if (this.variants != null) {
      data['variants'] = this.variants.map((v) => v.toJson()).toList();
    }
    if (this.selectedVariant != null) {
      data['selectedVariant'] = this.selectedVariant.toJson();
    }
    // if(this.count != null){
    //   data['count'] = this.count;
    // }
    return data;
  }
}

class Variants {
  String id;
  String storeId;
  String productId;
  String sku;
  String unitType;
  String weight;
  String mrpPrice;
  String discount;
  String price;
  String orderBy;
  String customField1;
  String customField2;
  String customField3;
  String customField4;
  String sort;

  Variants(
      {this.id,
        this.storeId,
        this.productId,
        this.sku,
        this.unitType,
        this.weight,
        this.mrpPrice,
        this.discount,
        this.price,
        this.orderBy,
        this.customField1,
        this.customField2,
        this.customField3,
        this.customField4,
        this.sort});

  Variants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    productId = json['product_id'];
    sku = json['sku'];
    unitType = json['unit_type'];
    weight = json['weight'];
    mrpPrice = json['mrp_price'];
    discount = json['discount'];
    price = json['price'];
    orderBy = json['order_by'];
    customField1 = json['custom_field1'];
    customField2 = json['custom_field2'];
    customField3 = json['custom_field3'];
    customField4 = json['custom_field4'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_id'] = this.storeId;
    data['product_id'] = this.productId;
    data['sku'] = this.sku;
    data['unit_type'] = this.unitType;
    data['weight'] = this.weight;
    data['mrp_price'] = this.mrpPrice;
    data['discount'] = this.discount;
    data['price'] = this.price;
    data['order_by'] = this.orderBy;
    data['custom_field1'] = this.customField1;
    data['custom_field2'] = this.customField2;
    data['custom_field3'] = this.customField3;
    data['custom_field4'] = this.customField4;
    data['sort'] = this.sort;
    return data;
  }
}

class SelectedVariant {
  String variantId;
  String sku;
  String weight;
  String mrpPrice;
  String price;
  String discount;
  String unitType;
  String quantity;
  String customField1;
  String customField2;
  String customField3;
  String customField4;

  SelectedVariant(
      {this.variantId,
        this.sku,
        this.weight,
        this.mrpPrice,
        this.price,
        this.discount,
        this.unitType,
        this.quantity,
        this.customField1,
        this.customField2,
        this.customField3,
        this.customField4});

  SelectedVariant.fromJson(Map<String, dynamic> json) {
    variantId = json['variant_id'];
    sku = json['sku'];
    weight = json['weight'];
    mrpPrice = json['mrp_price'];
    price = json['price'];
    discount = json['discount'];
    unitType = json['unit_type'];
    quantity = json['quantity'];
    customField1 = json['custom_field1'];
    customField2 = json['custom_field2'];
    customField3 = json['custom_field3'];
    customField4 = json['custom_field4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['variant_id'] = this.variantId;
    data['sku'] = this.sku;
    data['weight'] = this.weight;
    data['mrp_price'] = this.mrpPrice;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['unit_type'] = this.unitType;
    data['quantity'] = this.quantity;
    data['custom_field1'] = this.customField1;
    data['custom_field2'] = this.customField2;
    data['custom_field3'] = this.customField3;
    data['custom_field4'] = this.customField4;
    return data;
  }
}
