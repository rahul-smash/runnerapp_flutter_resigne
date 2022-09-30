// To parse this JSON data, do
//
//     final getInvoiceImageResponse = getInvoiceImageResponseFromJson(jsonString);

import 'dart:convert';

GetInvoiceImageResponse getInvoiceImageResponseFromJson(String str) =>
    GetInvoiceImageResponse.fromJson(json.decode(str));

String getInvoiceImageResponseToJson(GetInvoiceImageResponse data) =>
    json.encode(data.toJson());

class GetInvoiceImageResponse {
  GetInvoiceImageResponse({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory GetInvoiceImageResponse.fromJson(Map<String, dynamic> json) =>
      GetInvoiceImageResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data":
            data == null ? [] : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.invoiceImage,
  });

  InvoiceImage invoiceImage;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        invoiceImage: json["InvoiceImage"] == null
            ? null
            : InvoiceImage.fromJson(json["InvoiceImage"]),
      );

  Map<String, dynamic> toJson() => {
        "InvoiceImage": invoiceImage == null ? null : invoiceImage.toJson(),
      };
}

class InvoiceImage {
  InvoiceImage({
    this.id,
    this.brandId,
    this.storeId,
    this.orderId,
    this.runnerId,
    this.image,
    this.imageType,
    this.remarks,
    this.created,
    this.modified,
  });

  String id;
  String brandId;
  String storeId;
  String orderId;
  String runnerId;
  String image;
  String imageType;
  String remarks;
  DateTime created;
  DateTime modified;

  factory InvoiceImage.fromJson(Map<String, dynamic> json) => InvoiceImage(
        id: json["id"] == null ? null : json["id"],
        brandId: json["brand_id"] == null ? null : json["brand_id"],
        storeId: json["store_id"] == null ? null : json["store_id"],
        orderId: json["order_id"] == null ? null : json["order_id"],
        runnerId: json["runner_id"] == null ? null : json["runner_id"],
        image: json["image"] == null ? null : json["image"],
        imageType: json["image_type"] == null ? null : json["image_type"],
        remarks: json["remarks"] == null ? null : json["remarks"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        modified:
            json["modified"] == null ? null : DateTime.parse(json["modified"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "brand_id": brandId == null ? null : brandId,
        "store_id": storeId == null ? null : storeId,
        "order_id": orderId == null ? null : orderId,
        "runner_id": runnerId == null ? null : runnerId,
        "image": image == null ? null : image,
        "image_type": imageType == null ? null : imageType,
        "remarks": remarks == null ? null : remarks,
        "created": created == null ? null : created.toIso8601String(),
        "modified": modified == null ? null : modified.toIso8601String(),
      };
}
