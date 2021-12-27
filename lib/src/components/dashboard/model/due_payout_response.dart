// To parse this JSON data, do
//
//     final duePayoutResponse = duePayoutResponseFromJson(jsonString);

import 'dart:convert';

DuePayoutResponse duePayoutResponseFromJson(String str) => DuePayoutResponse.fromJson(json.decode(str));

String duePayoutResponseToJson(DuePayoutResponse data) => json.encode(data.toJson());

class DuePayoutResponse {
  DuePayoutResponse({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory DuePayoutResponse.fromJson(Map<String, dynamic> json) => DuePayoutResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.order,
  });

  Order order;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    order: json["Order"] == null ? null : Order.fromJson(json["Order"]),
  );

  Map<String, dynamic> toJson() => {
    "Order": order == null ? null : order.toJson(),
  };
}

class Order {
  Order({
    this.id,
    this.displayOrderId,
    this.posOrderId,
    this.brandId,
    this.storeId,
    this.userId,
    this.runnerId,
    this.runnerDeliveryAccepted,
    this.userAddressId,
    this.userAddress,
    this.gmapAttribute,
    this.paid,
    this.paymentMethod,
    this.discount,
    this.cartSaving,
    this.walletRefund,
    this.refundStatus,
    this.customerRefund,
    this.tcsCommission,
    this.commission,
    this.commissionWithoutDiscount,
    this.hqCommission,
    this.hqFixedCharge,
    this.hqCommissionStatus,
    this.hqPayoutDatetime,
    this.operatorCommission,
    this.payoutStatus,
    this.payoutDatetime,
    this.onlineMethod,
    this.platform,
    this.paymentRequestId,
    this.paymentId,
    this.note,
    this.couponCode,
    this.isMembershipCouponEnabled,
    this.membershipPlanDetailId,
    this.posBranchCode,
    this.total,
    this.rating,
    this.checkout,
    this.checkoutBeforeCommission,
    this.shippingCharges,
    this.shippingTax,
    this.shippingTaxRate,
    this.tax,
    this.taxRate,
    this.storeTaxRateDetail,
    this.calculatedTaxDetail,
    this.storeFixedTaxDetail,
    this.diningTable,
    this.orderFacility,
    this.status,
    this.orderRejectionNote,
    this.deliveryTimeSlot,
    this.deliverySlot,
    this.distance,
    this.travelTime,
    this.created,
    this.modified,
    this.netPayable,
    this.formula,
  });

  String id;
  String displayOrderId;
  String posOrderId;
  String brandId;
  String storeId;
  String userId;
  String runnerId;
  String runnerDeliveryAccepted;
  String userAddressId;
  String userAddress;
  String gmapAttribute;
  String paid;
  PaymentMethod paymentMethod;
  CustomerRefund discount;
  String cartSaving;
  CustomerRefund walletRefund;
  String refundStatus;
  CustomerRefund customerRefund;
  CustomerRefund tcsCommission;
  String commission;
  String commissionWithoutDiscount;
  String hqCommission;
  HqFixedCharge hqFixedCharge;
  String hqCommissionStatus;
  String hqPayoutDatetime;
  String operatorCommission;
  String payoutStatus;
  String payoutDatetime;
  String onlineMethod;
  Platform platform;
  String paymentRequestId;
  String paymentId;
  String note;
  String couponCode;
  String isMembershipCouponEnabled;
  String membershipPlanDetailId;
  String posBranchCode;
  String total;
  String rating;
  String checkout;
  String checkoutBeforeCommission;
  String shippingCharges;
  CustomerRefund shippingTax;
  CustomerRefund shippingTaxRate;
  CustomerRefund tax;
  CustomerRefund taxRate;
  Detail storeTaxRateDetail;
  Detail calculatedTaxDetail;
  Detail storeFixedTaxDetail;
  String diningTable;
  OrderFacility orderFacility;
  String status;
  String orderRejectionNote;
  String deliveryTimeSlot;
  String deliverySlot;
  String distance;
  String travelTime;
  DateTime created;
  DateTime modified;
  double netPayable;
  Formula formula;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"] == null ? null : json["id"],
    displayOrderId: json["display_order_id"] == null ? null : json["display_order_id"],
    posOrderId: json["pos_order_id"] == null ? null : json["pos_order_id"],
    brandId: json["brand_id"] == null ? null : json["brand_id"],
    storeId: json["store_id"] == null ? null : json["store_id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    runnerId: json["runner_id"] == null ? null : json["runner_id"],
    runnerDeliveryAccepted: json["runner_delivery_accepted"] == null ? null : json["runner_delivery_accepted"],
    userAddressId: json["user_address_id"] == null ? null : json["user_address_id"],
    userAddress: json["user_address"] == null ? null : json["user_address"],
    gmapAttribute: json["gmap_attribute"] == null ? null : json["gmap_attribute"],
    paid: json["paid"] == null ? null : json["paid"],
    paymentMethod: json["payment_method"] == null ? null : paymentMethodValues.map[json["payment_method"]],
    discount: json["discount"] == null ? null : customerRefundValues.map[json["discount"]],
    cartSaving: json["cart_saving"] == null ? null : json["cart_saving"],
    walletRefund: json["wallet_refund"] == null ? null : customerRefundValues.map[json["wallet_refund"]],
    refundStatus: json["refund_status"] == null ? null : json["refund_status"],
    customerRefund: json["customer_refund"] == null ? null : customerRefundValues.map[json["customer_refund"]],
    tcsCommission: json["tcs_commission"] == null ? null : customerRefundValues.map[json["tcs_commission"]],
    commission: json["commission"] == null ? null : json["commission"],
    commissionWithoutDiscount: json["commission_without_discount"] == null ? null : json["commission_without_discount"],
    hqCommission: json["hq_commission"] == null ? null : json["hq_commission"],
    hqFixedCharge: json["hq_fixed_charge"] == null ? null : hqFixedChargeValues.map[json["hq_fixed_charge"]],
    hqCommissionStatus: json["hq_commission_status"] == null ? null : json["hq_commission_status"],
    hqPayoutDatetime: json["hq_payout_datetime"] == null ? null : json["hq_payout_datetime"],
    operatorCommission: json["operator_commission"] == null ? null : json["operator_commission"],
    payoutStatus: json["payout_status"] == null ? null : json["payout_status"],
    payoutDatetime: json["payout_datetime"] == null ? null : json["payout_datetime"],
    onlineMethod: json["online_method"] == null ? null : json["online_method"],
    platform: json["platform"] == null ? null : platformValues.map[json["platform"]],
    paymentRequestId: json["payment_request_id"] == null ? null : json["payment_request_id"],
    paymentId: json["payment_id"] == null ? null : json["payment_id"],
    note: json["note"] == null ? null : json["note"],
    couponCode: json["coupon_code"] == null ? null : json["coupon_code"],
    isMembershipCouponEnabled: json["is_membership_coupon_enabled"] == null ? null : json["is_membership_coupon_enabled"],
    membershipPlanDetailId: json["membership_plan_detail_id"] == null ? null : json["membership_plan_detail_id"],
    posBranchCode: json["pos_branch_code"] == null ? null : json["pos_branch_code"],
    total: json["total"] == null ? null : json["total"],
    rating: json["rating"] == null ? null : json["rating"],
    checkout: json["checkout"] == null ? null : json["checkout"],
    checkoutBeforeCommission: json["checkout_before_commission"] == null ? null : json["checkout_before_commission"],
    shippingCharges: json["shipping_charges"] == null ? null : json["shipping_charges"],
    shippingTax: json["shipping_tax"] == null ? null : customerRefundValues.map[json["shipping_tax"]],
    shippingTaxRate: json["shipping_tax_rate"] == null ? null : customerRefundValues.map[json["shipping_tax_rate"]],
    tax: json["tax"] == null ? null : customerRefundValues.map[json["tax"]],
    taxRate: json["tax_rate"] == null ? null : customerRefundValues.map[json["tax_rate"]],
    storeTaxRateDetail: json["store_tax_rate_detail"] == null ? null : detailValues.map[json["store_tax_rate_detail"]],
    calculatedTaxDetail: json["calculated_tax_detail"] == null ? null : detailValues.map[json["calculated_tax_detail"]],
    storeFixedTaxDetail: json["store_fixed_tax_detail"] == null ? null : detailValues.map[json["store_fixed_tax_detail"]],
    diningTable: json["dining_table"] == null ? null : json["dining_table"],
    orderFacility: json["order_facility"] == null ? null : orderFacilityValues.map[json["order_facility"]],
    status: json["status"] == null ? null : json["status"],
    orderRejectionNote: json["order_rejection_note"] == null ? null : json["order_rejection_note"],
    deliveryTimeSlot: json["delivery_time_slot"] == null ? null : json["delivery_time_slot"],
    deliverySlot: json["delivery_slot"] == null ? null : json["delivery_slot"],
    distance: json["distance"] == null ? null : json["distance"],
    travelTime: json["travel_time"] == null ? null : json["travel_time"],
    created: json["created"] == null ? null : DateTime.parse(json["created"]),
    modified: json["modified"] == null ? null : DateTime.parse(json["modified"]),
    netPayable: json["net_payable"] == null ? null : json["net_payable"].toDouble(),
    formula: json["formula"] == null ? null : formulaValues.map[json["formula"]],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "display_order_id": displayOrderId == null ? null : displayOrderId,
    "pos_order_id": posOrderId == null ? null : posOrderId,
    "brand_id": brandId == null ? null : brandId,
    "store_id": storeId == null ? null : storeId,
    "user_id": userId == null ? null : userId,
    "runner_id": runnerId == null ? null : runnerId,
    "runner_delivery_accepted": runnerDeliveryAccepted == null ? null : runnerDeliveryAccepted,
    "user_address_id": userAddressId == null ? null : userAddressId,
    "user_address": userAddress == null ? null : userAddress,
    "gmap_attribute": gmapAttribute == null ? null : gmapAttribute,
    "paid": paid == null ? null : paid,
    "payment_method": paymentMethod == null ? null : paymentMethodValues.reverse[paymentMethod],
    "discount": discount == null ? null : customerRefundValues.reverse[discount],
    "cart_saving": cartSaving == null ? null : cartSaving,
    "wallet_refund": walletRefund == null ? null : customerRefundValues.reverse[walletRefund],
    "refund_status": refundStatus == null ? null : refundStatus,
    "customer_refund": customerRefund == null ? null : customerRefundValues.reverse[customerRefund],
    "tcs_commission": tcsCommission == null ? null : customerRefundValues.reverse[tcsCommission],
    "commission": commission == null ? null : commission,
    "commission_without_discount": commissionWithoutDiscount == null ? null : commissionWithoutDiscount,
    "hq_commission": hqCommission == null ? null : hqCommission,
    "hq_fixed_charge": hqFixedCharge == null ? null : hqFixedChargeValues.reverse[hqFixedCharge],
    "hq_commission_status": hqCommissionStatus == null ? null : hqCommissionStatus,
    "hq_payout_datetime": hqPayoutDatetime == null ? null : hqPayoutDatetime,
    "operator_commission": operatorCommission == null ? null : operatorCommission,
    "payout_status": payoutStatus == null ? null : payoutStatus,
    "payout_datetime": payoutDatetime == null ? null : payoutDatetime,
    "online_method": onlineMethod == null ? null : onlineMethod,
    "platform": platform == null ? null : platformValues.reverse[platform],
    "payment_request_id": paymentRequestId == null ? null : paymentRequestId,
    "payment_id": paymentId == null ? null : paymentId,
    "note": note == null ? null : note,
    "coupon_code": couponCode == null ? null : couponCode,
    "is_membership_coupon_enabled": isMembershipCouponEnabled == null ? null : isMembershipCouponEnabled,
    "membership_plan_detail_id": membershipPlanDetailId == null ? null : membershipPlanDetailId,
    "pos_branch_code": posBranchCode == null ? null : posBranchCode,
    "total": total == null ? null : total,
    "rating": rating == null ? null : rating,
    "checkout": checkout == null ? null : checkout,
    "checkout_before_commission": checkoutBeforeCommission == null ? null : checkoutBeforeCommission,
    "shipping_charges": shippingCharges == null ? null : shippingCharges,
    "shipping_tax": shippingTax == null ? null : customerRefundValues.reverse[shippingTax],
    "shipping_tax_rate": shippingTaxRate == null ? null : customerRefundValues.reverse[shippingTaxRate],
    "tax": tax == null ? null : customerRefundValues.reverse[tax],
    "tax_rate": taxRate == null ? null : customerRefundValues.reverse[taxRate],
    "store_tax_rate_detail": storeTaxRateDetail == null ? null : detailValues.reverse[storeTaxRateDetail],
    "calculated_tax_detail": calculatedTaxDetail == null ? null : detailValues.reverse[calculatedTaxDetail],
    "store_fixed_tax_detail": storeFixedTaxDetail == null ? null : detailValues.reverse[storeFixedTaxDetail],
    "dining_table": diningTable == null ? null : diningTable,
    "order_facility": orderFacility == null ? null : orderFacilityValues.reverse[orderFacility],
    "status": status == null ? null : status,
    "order_rejection_note": orderRejectionNote == null ? null : orderRejectionNote,
    "delivery_time_slot": deliveryTimeSlot == null ? null : deliveryTimeSlot,
    "delivery_slot": deliverySlot == null ? null : deliverySlot,
    "distance": distance == null ? null : distance,
    "travel_time": travelTime == null ? null : travelTime,
    "created": created == null ? null : created.toIso8601String(),
    "modified": modified == null ? null : modified.toIso8601String(),
    "net_payable": netPayable == null ? null : netPayable,
    "formula": formula == null ? null : formulaValues.reverse[formula],
  };
}

enum Detail { EMPTY }

final detailValues = EnumValues({
  "[]": Detail.EMPTY
});

enum CustomerRefund { THE_000, EMPTY }

final customerRefundValues = EnumValues({
  "": CustomerRefund.EMPTY,
  "0.00": CustomerRefund.THE_000
});

enum Formula { PAID_BY_CUSTOMER_ITEMS_TOTAL_TAX_DISCOUNT }

final formulaValues = EnumValues({
  "(Paid by Customer -((Items Total+Tax)-(Discount )))": Formula.PAID_BY_CUSTOMER_ITEMS_TOTAL_TAX_DISCOUNT
});

enum HqFixedCharge { THE_100, EMPTY }

final hqFixedChargeValues = EnumValues({
  "": HqFixedCharge.EMPTY,
  "1.00": HqFixedCharge.THE_100
});

enum OrderFacility { DELIVERY }

final orderFacilityValues = EnumValues({
  "Delivery": OrderFacility.DELIVERY
});

enum PaymentMethod { COD }

final paymentMethodValues = EnumValues({
  "cod": PaymentMethod.COD
});

enum Platform { WEB, ANDROID }

final platformValues = EnumValues({
  "Android": Platform.ANDROID,
  "web": Platform.WEB
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
