import 'dart:convert';

CalculateAmount amountResponseFromJson(String str) => CalculateAmount.fromJson(json.decode(str));
String amountResponseToJson(CalculateAmount data) => json.encode(data.toJson());

class CalculateAmount {
  bool success;
  AmountData data;
  String message;

  CalculateAmount({this.success, this.data, this.message});

  CalculateAmount.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new AmountData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}
class AmountData {
  String total;
  String walletRefund;
  String itemSubTotal;
  String tax;
  String discount;
  String shipping;
  String fixedTaxAmount;
  List<TaxDetailResponse> taxDetail;
  List<TaxLabelResponse> taxLabel;
  List<Object> fixedTax;
  List<OrderDetailResponse> orderDetail;
  bool isChanged;

  AmountData(
      {this.total,
        this.walletRefund,
        this.itemSubTotal,
        this.tax,
        this.discount,
        this.shipping,
        this.fixedTaxAmount,
        this.taxDetail,
        this.taxLabel,
        this.fixedTax,
        this.orderDetail,
        this.isChanged,
      });

  AmountData.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    walletRefund = json['wallet_refund'];
    itemSubTotal = json['item_sub_total'];
    tax = json['tax'];
    discount = json['discount'];
    shipping = json['shipping'];
    fixedTaxAmount = json['fixed_tax_amount'];
    if (json['tax_detail'] != null) {
      taxDetail = new List<TaxDetailResponse>();
      json['tax_detail'].forEach((v) {
        taxDetail.add(new TaxDetailResponse.fromJson(v));
      });
    }
    if (json['tax_label'] != null) {
      taxLabel = new List<TaxLabelResponse>();
      json['tax_label'].forEach((v) {
        taxLabel.add(new TaxLabelResponse.fromJson(v));
      });
    }
    fixedTax = json['fixed_tax'];
    if (json['order_detail'] != null) {
      orderDetail = new List<OrderDetailResponse>();
      json['order_detail'].forEach((v) {
        orderDetail.add(new OrderDetailResponse.fromJson(v));
      });
    }
    isChanged = json['is_changed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['wallet_refund'] = this.walletRefund;
    data['item_sub_total'] = this.itemSubTotal;
    data['tax'] = this.tax;
    data['discount'] = this.discount;
    data['shipping'] = this.shipping;
    data['fixed_tax_amount'] = this.fixedTaxAmount;
    data['tax_detail'] = this.taxDetail;
    if (this.taxDetail != null) {
      data['tax_detail'] = this.taxDetail.map((v) => v.toJson()).toList();
    }
    if (this.taxLabel != null) {
      data['tax_label'] = this.taxLabel.map((v) => v.toJson()).toList();
    }
    data['fixed_tax'] = this.fixedTax;
    if (this.orderDetail != null) {
      data['order_detail'] = this.orderDetail.map((v) => v.toJson()).toList();
    }
    data['is_changed'] = this.total;
    return data;
  }
}


class TaxDetailResponse {
  String label;
  String rate;
  String tax;

  TaxDetailResponse(
      {
        this.label,
        this.rate,
        this.tax,
      });

  TaxDetailResponse.fromJson(Map<String, dynamic> json) {
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
class TaxLabelResponse {
  String label;
  String rate;

  TaxLabelResponse(
      {
        this.label,
        this.rate,
      });

  TaxLabelResponse.fromJson(Map<String, dynamic> json) {
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
class OrderDetailResponse {
  String discount;
  String isTaxEnable;
  String mrpPrice;
  String price;
  String productId;
  String productName;
  String productType;
  int quantity;
  String unitType;
  String variantId;
  String weight;
  String productStatus;
  String hsnCode;
  dynamic gstTaxRate;

  OrderDetailResponse(
      {
        this.discount,
        this.isTaxEnable,
        this.mrpPrice,
        this.price,
        this.productId,
        this.productName,
        this.productType,
        this.quantity,
        this.unitType,
        this.variantId,
        this.weight,
        this.productStatus,
        this.hsnCode,
        this.gstTaxRate,
      });

  OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    discount = json['discount'];
    isTaxEnable= json['isTaxEnable'];
    mrpPrice = json['mrp_price'];
    price = json['price'];
    productId = json['product_id'];
    productName = json['product_name'];
    productType = json['product_type'];
    quantity = json['quantity'];
    unitType = json['unit_type'];
    variantId = json['variant_id'];
    weight = json['weight'];
    productStatus = json['product_status'];
    hsnCode = json['hsn_code'];
    gstTaxRate = json['gst_tax_rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discount'] = this.discount;
    data['isTaxEnable'] = this.isTaxEnable;
    data['mrp_price'] = this.mrpPrice;
    data['price'] = this.price;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_type'] = this.productType;
    data['quantity'] = this.quantity;
    data['unit_type'] = this.unitType;
    data['variant_id'] = this.variantId;
    data['weight'] = this.weight;
    data['product_status'] = this.productStatus;
    data['hsn_code'] = this.hsnCode;
    data['gst_tax_rate'] = this.gstTaxRate;
    return data;
  }
}
