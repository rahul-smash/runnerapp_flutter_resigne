import 'booking_details_response.dart';

class TaxOrderProductItem {
  TaxOrderProductItem({
    this.id,
    this.storeId,
    this.userId,
    this.orderId,
    this.deviceId,
    this.deviceToken,
    this.platform,
    this.productId,
    this.productName,
    this.variantId,
    this.weight,
    this.mrpPrice,
    this.price,
    this.discount,
    this.servicePayout,
    this.walletRefundAmount,
    this.refundStatus,
    this.unitType,
    this.quantity,
    this.oldQuantity,
    this.changeStatus,
    this.comment,
    this.isTaxEnable,
    this.hsnCode,
    this.gstDetail,
    this.cgst,
    this.sgst,
    this.igst,
    this.gstType,
    this.gstTaxRate,
    this.gstState,
    this.variants,
    this.status,
    this.created,
    this.modified,
    this.image10080,
    this.image300200,
    this.image,
  });

  String id;
  String storeId;
  String userId;
  String orderId;
  String deviceId;
  String deviceToken;
  String platform;
  String productId;
  String productName;
  String variantId;
  String weight;
  String mrpPrice;
  String price;
  String discount;
  String servicePayout;
  String walletRefundAmount;
  String refundStatus;
  String unitType;
  String quantity;
  String oldQuantity;
  String changeStatus;
  String comment;
  String isTaxEnable;
  String hsnCode;
  String gstDetail;
  String cgst;
  String sgst;
  String igst;
  String gstType;
  String gstTaxRate;
  String gstState;
  String status;
  String created;
  String modified;
  List<Variant> variants;
  String image10080;
  String image300200;
  String image;

  static TaxOrderProductItem copyWith({
    dynamic item,
    String variantId,
    String price,
    String quantity,
    String oldQuantity,
    String changeStatus,
  }) =>
      TaxOrderProductItem(
        id: item.id,
        storeId: item.storeId,
        userId: item.userId,
        orderId: item.orderId,
        deviceId: item.deviceId,
        deviceToken: item.deviceToken,
        platform: item.platform,
        productId: item.productId,
        productName: item.productName,
        variantId: variantId,
        weight: item.weight,
        mrpPrice: item.mrpPrice,
        price: price,
        discount: item.discount,
        servicePayout: item.servicePayout,
        walletRefundAmount: item.walletRefundAmount,
        refundStatus: item.refundStatus,
        unitType: item.unitType,
        quantity: quantity,
        oldQuantity: oldQuantity,
        changeStatus: changeStatus,
        comment: item.comment,
        isTaxEnable: item.isTaxEnable,
        hsnCode: item.hsnCode,
        gstDetail: item.gstDetail,
        cgst: item.cgst,
        sgst: item.sgst,
        igst: item.igst,
        gstType: item.gstType,
        gstTaxRate: item.gstTaxRate,
        gstState: item.gstState,
        status: item.status,
        created: item.created,
        modified: item.modified,
        image10080: item.image10080,
        image300200: item.image300200,
        image: item.image,
      );

  factory TaxOrderProductItem.fromJson(Map<String, dynamic> json) =>
      TaxOrderProductItem(
        id: json["id"] == null ? null : json["id"].toString(),
        storeId: json["store_id"] == null ? null : json["store_id"].toString(),
        userId: json["user_id"] == null ? null : json["user_id"].toString(),
        orderId: json["order_id"] == null ? null : json["order_id"].toString(),
        deviceId:
            json["device_id"] == null ? null : json["device_id"].toString(),
        deviceToken: json["device_token"] == null
            ? null
            : json["device_token"].toString(),
        platform: json["platform"] == null ? null : json["platform"].toString(),
        productId:
            json["product_id"] == null ? null : json["product_id"].toString(),
        productName: json["product_name"] == null
            ? null
            : json["product_name"].toString(),
        variantId:
            json["variant_id"] == null ? null : json["variant_id"].toString(),
        weight: json["weight"] == null ? null : json["weight"].toString(),
        mrpPrice:
            json["mrp_price"] == null ? null : json["mrp_price"].toString(),
        price: json["price"] == null ? null : json["price"].toString(),
        discount: json["discount"] == null ? null : json["discount"].toString(),
        variants: json["variants"] == null
            ? null
            : List<Variant>.from(
                json["variants"].map((x) => Variant.fromJson(x))),
        servicePayout: json["service_payout"] == null
            ? null
            : json["service_payout"].toString(),
        walletRefundAmount: json["wallet_refund_amount"] == null
            ? null
            : json["wallet_refund_amount"].toString(),
        refundStatus: json["refund_status"] == null
            ? null
            : json["refund_status"].toString(),
        unitType:
            json["unit_type"] == null ? null : json["unit_type"].toString(),
        quantity: json["quantity"] == null ? null : json["quantity"].toString(),
        oldQuantity: json["old_quantity"] == null
            ? null
            : json["old_quantity"].toString(),
        changeStatus: json["change_status"] == null
            ? null
            : json["change_status"].toString(),
        comment: json["comment"] == null ? null : json["comment"].toString(),
        isTaxEnable:
            json["isTaxEnable"] == null ? null : json["isTaxEnable"].toString(),
        hsnCode: json["hsn_code"] == null ? null : json["hsn_code"].toString(),
        gstDetail:
            json["gst_detail"] == null ? null : json["gst_detail"].toString(),
        cgst: json["cgst"] == null ? null : json["cgst"].toString(),
        sgst: json["sgst"] == null ? null : json["sgst"].toString(),
        igst: json["igst"] == null ? null : json["igst"].toString(),
        gstType: json["gst_type"] == null ? null : json["gst_type"].toString(),
        gstTaxRate: json["gst_tax_rate"] == null
            ? null
            : json["gst_tax_rate"].toString(),
        gstState:
            json["gst_state"] == null ? null : json["gst_state"].toString(),
        status: json["status"] == null ? null : json["status"].toString(),
        created: json["created"] == null ? null : json["created"].toString(),
        modified: json["modified"] == null ? null : json["modified"].toString(),
        image10080: json["image_100_80"] == null
            ? null
            : json["image_100_80"].toString(),
        image300200: json["image_300_200"] == null
            ? null
            : json["image_300_200"].toString(),
        image: json["image"] == null ? null : json["image"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "store_id": storeId == null ? null : storeId,
        "user_id": userId == null ? null : userId,
        "order_id": orderId == null ? null : orderId,
        "device_id": deviceId == null ? null : deviceId,
        "device_token": deviceToken == null ? null : deviceToken,
        "platform": platform == null ? null : platform,
        "product_id": productId == null ? null : productId,
        "product_name": productName == null ? null : productName,
        "variant_id": variantId == null ? null : variantId,
        "weight": weight == null ? null : weight,
        "mrp_price": mrpPrice == null ? null : mrpPrice,
        "price": price == null ? null : price,
        "discount": discount == null ? null : discount,
        "service_payout": servicePayout == null ? null : servicePayout,
        "wallet_refund_amount":
            walletRefundAmount == null ? null : walletRefundAmount,
        "refund_status": refundStatus == null ? null : refundStatus,
        "unit_type": unitType == null ? null : unitType,
        "quantity": quantity == null ? null : quantity,
        "old_quantity": oldQuantity == null ? null : oldQuantity,
        "change_status": changeStatus == null ? null : changeStatus,
        "comment": comment == null ? null : comment,
        "isTaxEnable": isTaxEnable == null ? null : isTaxEnable,
        "hsn_code": hsnCode == null ? null : hsnCode,
        "gst_detail": gstDetail == null ? null : gstDetail,
        "variants": variants == null
            ? null
            : List<dynamic>.from(variants.map((x) => x.toJson())),
        "cgst": cgst == null ? null : cgst,
        "sgst": sgst == null ? null : sgst,
        "igst": igst == null ? null : igst,
        "gst_type": gstType == null ? null : gstType,
        "gst_tax_rate": gstTaxRate == null ? null : gstTaxRate,
        "gst_state": gstState == null ? null : gstState,
        "status": status == null ? null : status,
        "created": created == null ? null : created,
        "modified": modified == null ? null : modified,
        "image_100_80": image10080 == null ? null : image10080,
        "image_300_200": image300200 == null ? null : image300200,
        "image": image == null ? null : image,
      };

  static List encodeListToJson(
    List<TaxOrderProductItem> list,
  ) {
    List jsonList = List.empty(growable: true);

    for (int i = 0; i < list.length; i++) {
      dynamic item = list[i];
      jsonList.add({


        "id": item.id == null ? null : item.id,
        "store_id": item.storeId == null ? null : item.storeId,
        "user_id": item.userId == null ? null : item.userId,
        "order_id": item.orderId == null ? null : item.orderId,
        "device_id": item.deviceId == null ? null : item.deviceId,
        "device_token": item.deviceToken == null ? null : item.deviceToken,
        "platform": item.platform == null ? null : item.platform,
        "product_id": item.productId == null ? null : item.productId,
        "product_name": item.productName == null ? null : item.productName,
        "variant_id": item.variantId == null ? null : item.variantId,
        "weight": item.weight == null ? null : item.weight,
        "mrp_price":item.mrpPrice == null ? null : item.mrpPrice,
        "price": item.price == null ? null : item.price,
        "discount": item.discount == null ? null : item.discount,
        "service_payout": item.servicePayout == null ? null : item.servicePayout,
        "wallet_refund_amount":
        item.walletRefundAmount == null ? null :item. walletRefundAmount,
        "refund_status": item.refundStatus == null ? null : item.refundStatus,
        "unit_type": item.unitType == null ? null : item.unitType,
        "quantity": item.quantity == null ? null : item.quantity,
        "old_quantity": item.oldQuantity == null ? null : item.oldQuantity,
        "change_status": item.changeStatus == null ? null : item.changeStatus,
        "comment": item.comment == null ? null : item.comment,
        "isTaxEnable": item.isTaxEnable == null ? null : item.isTaxEnable,
        "hsn_code": item.hsnCode == null ? null : item.hsnCode,
        "gst_detail": item.gstDetail == null ? null : item.gstDetail,
        "cgst": item.cgst == null ? null : item.cgst,
        "sgst": item.sgst == null ? null : item.sgst,
        "igst": item.igst == null ? null : item.igst,
        "gst_type": item.gstType == null ? null : item.gstType,
        "gst_tax_rate": item.gstTaxRate == null ? null : item.gstTaxRate,
        "gst_state":item.gstState == null ? null : item.gstState,
        "status": item.status == null ? null : item.status,
        "created":item.created == null ? null : item.created,
        "modified": item.modified == null ? null : item.modified,
        "image_100_80": item.image10080 == null ? null : item.image10080,
        "image_300_200": item.image300200 == null ? null : item.image300200,
        "image": item.image == null ? null : item.image,
        "variant_id": item.variantId == null ? null : item.variantId,
      });
    }
    return jsonList;
  }
}
