import 'dart:convert';

import 'package:marketplace_service_provider/src/components/dashboard/model/TaxOrderProductItem.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_details_response.dart';

class TaxCalculationResponse {
  bool success;
  String message;

  TaxCalculationModel taxCalculation;

  TaxCalculationResponse({this.success, this.taxCalculation});

  TaxCalculationResponse.fromJson(
      String couponCode, Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    taxCalculation = json['data'] != null
        ? TaxCalculationModel.fromJson(couponCode, json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.taxCalculation != null) {
      data['data'] = this.taxCalculation.toJson();
    }
    return data;
  }
}

class TaxCalculationModel {
  String total;
  String itemSubTotal;
  String tax;
  String discount;
  String shipping;
  String couponCode;
  String fixedTaxAmount;
  String wallet_refund = "0";
  List<TaxDetail> taxDetail;
  List<TaxLabel> taxLabel;
  List<FixedTax> fixedTax;
  List<TaxOrderProductItem> orderDetail;
  bool isChanged;
  String storeStatus;
  String storeMsg;
  StoreTimeSetting storeTimeSetting;

  TaxCalculationModel({
    this.total,
    this.itemSubTotal,
    this.tax,
    this.wallet_refund,
    this.discount,
    this.shipping,
    this.couponCode,
    this.fixedTaxAmount,
    this.taxDetail,
    this.taxLabel,
    this.fixedTax,
    this.orderDetail,
    this.isChanged,
    this.storeStatus,
    this.storeMsg,
    this.storeTimeSetting,
  });

  factory TaxCalculationModel.fromJson(
      String couponCode, Map<String, dynamic> json) {
    TaxCalculationModel model = TaxCalculationModel();

    model.total = json['total'];
    model.itemSubTotal = json['item_sub_total'];
    model.tax = json['tax'];
    model.discount = json['discount'];
    model.shipping = json['shipping'];
    model.wallet_refund = json['wallet_refund'].toString();
    model.couponCode = couponCode;
    model.fixedTaxAmount = json['fixed_tax_amount'];
    if (json['tax_detail'] != null) {
      model.taxDetail = new List<TaxDetail>();
      json['tax_detail'].forEach((v) {
        model.taxDetail.add(new TaxDetail.fromJson(v));
      });
    }
    if (json['tax_label'] != null) {
      model.taxLabel = new List<TaxLabel>();
      json['tax_label'].forEach((v) {
        model.taxLabel.add(new TaxLabel.fromJson(v));
      });
    }
    if (json['fixed_Tax'] != null) {
      model.fixedTax = new List<FixedTax>();
      json['fixed_Tax'].forEach((v) {
        model.fixedTax.add(new FixedTax.fromJson(v));
      });
    }

    if (json["order_detail"] != null) {
      model.orderDetail = List<TaxOrderProductItem>.from(
          json["order_detail"].map((x) => TaxOrderProductItem.fromJson(x)));
    }
    model.isChanged = json['is_changed'] == null ? false : json['is_changed'];
    model.storeStatus =
    json["store_status"] == null ? null : json["store_status"];
    model.storeMsg = json["store_msg"] == null ? null : json["store_msg"];
    model.storeTimeSetting = json["StoreTimeSetting"] == null
        ? null
        : StoreTimeSetting.fromJson(json["StoreTimeSetting"]);

    return model;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['item_sub_total'] = this.itemSubTotal;
    data['tax'] = this.tax;
    data['discount'] = this.discount;
    data['shipping'] = this.shipping;
    data['fixed_tax_amount'] = this.fixedTaxAmount;
    data['wallet_refund'] = this.wallet_refund;
    if (this.taxDetail != null) {
      data['tax_detail'] = this.taxDetail.map((v) => v.toJson()).toList();
    }
    if (this.taxLabel != null) {
      data['tax_label'] = this.taxLabel.map((v) => v.toJson()).toList();
    }
    if (this.fixedTax != null) {
      data['fixed_Tax'] = this.fixedTax.map((v) => v.toJson()).toList();
    }
    if (this.orderDetail != null) {
      data["order_detail"] = this.orderDetail.map((v) => v.toJson()).toList();
    }
    data['is_changed'] = this.isChanged;
    data['store_status'] = this.storeStatus;
    data['store_msg'] = this.storeMsg;
    data['StoreTimeSetting'] =
    storeTimeSetting == null ? null : storeTimeSetting.toJson();
    return data;
  }
}

class TaxDetail {
  String label;
  String rate;
  String tax;

  TaxDetail({this.label, this.rate, this.tax});

  TaxDetail.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    rate = json['rate'];
    tax = json['tax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['rate'] = this.rate;
    data['tax'] = this.tax;
    return data;
  }
}

class OrderDetail {
  OrderDetail({
    this.productId,
    this.productName,
    this.variantId,
    this.isTaxEnable,
    this.quantity,
    this.price,
    this.weight,
    this.mrpPrice,
    //this.unitType,
    this.productStatus,
    this.discount,
    this.productType,
    this.newMrpPrice,
    this.newDiscount,
    this.newPrice,
    this.gst_state,
    this.gst_tax_rate,
    this.cgst,
    this.sgst,
    this.igst,
    this.gst_type,
    this.hsn_code,
  });

  String productId;
  String productName;
  String variantId;
  String isTaxEnable;
  dynamic quantity;
  String price;
  String weight;
  String mrpPrice;
  String unitType = "";
  String productStatus;
  String discount;
  int productType;
  String newMrpPrice;
  String newDiscount;
  String newPrice;
  String gst_state;
  dynamic gst_tax_rate;
  dynamic cgst;
  dynamic sgst;
  dynamic igst;
  String gst_type;
  String hsn_code;

  OrderDetail copyWith({
    String productId,
    String productName,
    String variantId,
    String isTaxEnable,
    dynamic quantity,
    String price,
    String weight,
    String mrpPrice,
    //String unitType,
    String productStatus,
    String discount,
    int productType,
    String newMrpPrice,
    String newDiscount,
    String newPrice,
    String gst_state,
    String gst_tax_rate,
    dynamic cgst,
    dynamic sgst,
    dynamic igst,
    String gst_type,
    String hsn_code,
  }) =>
      OrderDetail(
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        variantId: variantId ?? this.variantId,
        isTaxEnable: isTaxEnable ?? this.isTaxEnable,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        weight: weight ?? this.weight,
        mrpPrice: mrpPrice ?? this.mrpPrice,
        //unitType: unitType ?? this.unitType,
        productStatus: productStatus ?? this.productStatus,
        discount: discount ?? this.discount,
        productType: productType ?? this.productType,
        newMrpPrice: newMrpPrice ?? this.newMrpPrice,
        newDiscount: newDiscount ?? this.newDiscount,
        newPrice: newPrice ?? this.newPrice,
        gst_state: gst_state ?? this.gst_state,
        gst_tax_rate: gst_tax_rate ?? this.gst_tax_rate,
        cgst: cgst ?? this.cgst,
        sgst: sgst ?? this.sgst,
        igst: igst ?? this.igst,
        gst_type: gst_type ?? this.gst_type,
        hsn_code: hsn_code ?? this.hsn_code,
      );

  factory OrderDetail.fromRawJson(String str) =>
      OrderDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    productId: json["product_id"] == null ? null : json["product_id"],
    productName: json["product_name"] == null ? null : json["product_name"],
    variantId: json["variant_id"] == null ? null : json["variant_id"],
    isTaxEnable: json["isTaxEnable"] == null ? null : json["isTaxEnable"],
    quantity: json["quantity"],
    price: json["price"] == null ? null : json["price"],
    weight: json["weight"] == null ? null : json["weight"],
    mrpPrice: json["mrp_price"] == null ? null : json["mrp_price"],
    //unitType: json["unit_type"] == null ? null : json["unit_type"],
    productStatus:
    json["product_status"] == null ? null : json["product_status"],
    discount: json["discount"] == null ? null : json["discount"],
    productType: json["product_type"] == null ? null : json["product_type"],
    newMrpPrice:
    json["new_mrp_price"] == null ? null : json["new_mrp_price"],
    newDiscount: json["new_discount"] == null ? null : json["new_discount"],
    newPrice: json["new_price"] == null ? null : json["new_price"],
    gst_state: json["gst_state"] == null ? null : json["gst_state"],
    gst_tax_rate:
    json["gst_tax_rate"] == null ? null : json["gst_tax_rate"],
    cgst: json["cgst"] == null ? 0 : json["cgst"],
    sgst: json["sgst"] == null ? 0 : json["sgst"],
    igst: json["igst"] == null ? 0 : json["igst"],
    gst_type: json["gst_type"] == null ? null : json["gst_type"],
    hsn_code: json["hsn_code"] == null ? "" : json["hsn_code"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId == null ? null : productId,
    "product_name": productName == null ? null : productName,
    "variant_id": variantId == null ? null : variantId,
    "isTaxEnable": isTaxEnable == null ? null : isTaxEnable,
    "quantity": quantity,
    "price": price == null ? null : price,
    "weight": weight == null ? null : weight,
    "mrp_price": mrpPrice == null ? null : mrpPrice,
    //"unit_type": unitType == null ? null : unitType,
    "product_status": productStatus == null ? null : productStatus,
    "discount": discount == null ? null : discount,
    "product_type": productType == null ? null : productType,
    "new_mrp_price": newMrpPrice == null ? null : newMrpPrice,
    "new_discount": newDiscount == null ? null : newDiscount,
    "new_price": newPrice == null ? null : newPrice,
    "gst_state": gst_state == null ? null : gst_state,
    "gst_tax_rate": gst_tax_rate == null ? null : gst_tax_rate,
    "cgst": cgst == null ? 0 : cgst,
    "sgst": sgst == null ? 0 : sgst,
    "igst": igst == null ? 0 : igst,
    "gst_type": gst_type == null ? null : gst_type,
    "hsn_code": hsn_code == null ? "" : hsn_code,
  };

}

class TaxLabel {
  String label;
  String rate;

  TaxLabel({this.label, this.rate});

  TaxLabel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['rate'] = this.rate;
    return data;
  }
}

class StoreTimeSetting {
  StoreTimeSetting({
    this.is24X7Open,
    this.openhoursFrom,
    this.openhoursTo,
    this.closehoursMessage,
    this.storeOpenDays,
  });

  String is24X7Open;
  String openhoursFrom;
  String openhoursTo;
  String closehoursMessage;
  String storeOpenDays;

  StoreTimeSetting copyWith({
    String is24X7Open,
    String openhoursFrom,
    String openhoursTo,
    String closehoursMessage,
    String storeOpenDays,
  }) =>
      StoreTimeSetting(
        is24X7Open: is24X7Open ?? this.is24X7Open,
        openhoursFrom: openhoursFrom ?? this.openhoursFrom,
        openhoursTo: openhoursTo ?? this.openhoursTo,
        closehoursMessage: closehoursMessage ?? this.closehoursMessage,
        storeOpenDays: storeOpenDays ?? this.storeOpenDays,
      );

  factory StoreTimeSetting.fromRawJson(String str) =>
      StoreTimeSetting.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StoreTimeSetting.fromJson(Map<String, dynamic> json) =>
      StoreTimeSetting(
        is24X7Open: json["is24x7_open"] == null ? null : json["is24x7_open"],
        openhoursFrom:
        json["openhours_from"] == null ? null : json["openhours_from"],
        openhoursTo: json["openhours_to"] == null ? null : json["openhours_to"],
        closehoursMessage: json["closehours_message"] == null
            ? null
            : json["closehours_message"],
        storeOpenDays:
        json["store_open_days"] == null ? null : json["store_open_days"],
      );

  Map<String, dynamic> toJson() => {
    "is24x7_open": is24X7Open == null ? null : is24X7Open,
    "openhours_from": openhoursFrom == null ? null : openhoursFrom,
    "openhours_to": openhoursTo == null ? null : openhoursTo,
    "closehours_message":
    closehoursMessage == null ? null : closehoursMessage,
    "store_open_days": storeOpenDays == null ? null : storeOpenDays,
  };
}

class FixedTax {
  String sort;
  String fixedTaxLabel;
  String fixedTaxAmount;
  String isTaxEnable;
  String isDiscountApplicable;

  FixedTax(
      {this.sort,
        this.fixedTaxLabel,
        this.fixedTaxAmount,
        this.isTaxEnable,
        this.isDiscountApplicable});

  FixedTax.fromJson(Map<String, dynamic> json) {
    sort = json['sort'];
    fixedTaxLabel = json['fixed_tax_label'];
    fixedTaxAmount = json['fixed_tax_amount'];
    isTaxEnable = json['is_tax_enable'];
    isDiscountApplicable = json['is_discount_applicable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sort'] = this.sort;
    data['fixed_tax_label'] = this.fixedTaxLabel;
    data['fixed_tax_amount'] = this.fixedTaxAmount;
    data['is_tax_enable'] = this.isTaxEnable;
    data['is_discount_applicable'] = this.isDiscountApplicable;
    return data;
  }
}
