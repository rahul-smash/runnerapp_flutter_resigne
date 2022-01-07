// To parse this JSON data, do
//
//     final dashboardResponse = dashboardResponseFromJson(jsonString);

import 'dart:convert';

DashboardResponseSummary dashboardResponseFromJson(String str) =>
    DashboardResponseSummary.fromJson(json.decode(str));

String dashboardResponseToJson(DashboardResponseSummary data) =>
    json.encode(data.toJson());

class DashboardResponseSummary {
  DashboardResponseSummary({
    this.success,
    this.page,
    this.limit,
    this.totalOrder,
    this.summery,
    this.bookingRequests,
  });

  bool success;
  dynamic page;
  dynamic limit;
  int totalOrder;
  Summery summery;
  List<BookingRequest> bookingRequests;

  factory DashboardResponseSummary.fromJson(Map<String, dynamic> json) =>
      DashboardResponseSummary(
        success: json["success"] == null ? null : json["success"],
        page: json["page"] == null ? null : json["page"],
        limit: json["limit"] == null ? null : json["limit"],
        totalOrder: json["total_order"] == null ? null : json["total_order"],
        summery:
            json["summery"] == null ? null : Summery.fromJson(json["summery"]),
        bookingRequests: json["bookingRequests"] == null
            ? null
            : List<BookingRequest>.from(
                json["bookingRequests"].map((x) => BookingRequest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "page": page == null ? null : page,
        "limit": limit == null ? null : limit,
        "total_order": totalOrder == null ? null : totalOrder,
        "summery": summery == null ? null : summery.toJson(),
        "bookingRequests": bookingRequests == null
            ? null
            : List<dynamic>.from(bookingRequests.map((x) => x.toJson())),
      };
}

class BookingRequest {
  BookingRequest({
    this.id,
    this.displayOrderId,
    this.posOrderId,
    this.brandId,
    this.storeId,
    this.userId,
    this.runnerId,
    this.runnerDeliveryAccepted,
    this.userAddressId,
    this.bookingRequestUserAddress,
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
    this.user,
    this.userAddress,
    this.cart,
    this.store,
    this.bookingDateTime,
    this.categoryTitle,
    this.serviceCount,
    this.serviceDuration,
    this.services,
    this.isManualAssignment,
    this.readStatus,
  });

  String id;
  String displayOrderId;
  String posOrderId;
  String brandId;
  String storeId;
  String userId;
  String runnerId;
  dynamic runnerDeliveryAccepted;
  String userAddressId;
  String bookingRequestUserAddress;
  String gmapAttribute;
  String paid;
  String paymentMethod;
  String discount;
  String cartSaving;
  String walletRefund;
  dynamic refundStatus;
  String customerRefund;
  String tcsCommission;
  String commission;
  String commissionWithoutDiscount;
  String payoutStatus;
  String payoutDatetime;
  String onlineMethod;
  String platform;
  String paymentRequestId;
  String paymentId;
  String note;
  String couponCode;
  dynamic isMembershipCouponEnabled;
  String membershipPlanDetailId;
  String posBranchCode;
  String total;
  String rating;
  String checkout;
  String shippingCharges;
  String shippingTax;
  String shippingTaxRate;
  String tax;
  String taxRate;
  String storeTaxRateDetail;
  String calculatedTaxDetail;
  String storeFixedTaxDetail;
  String diningTable;
  String orderFacility;
  String status;
  String orderRejectionNote;
  String deliveryTimeSlot;
  String deliverySlot;
  String distance;
  String travelTime;
  String created;
  String modified;
  User user;
  UserAddress userAddress;
  List<Cart> cart;
  Store store;
  String bookingDateTime;
  String categoryTitle;
  String serviceCount;
  String serviceDuration;
  String services;
  String isManualAssignment;
  String readStatus;

  factory BookingRequest.fromJson(Map<String, dynamic> json) => BookingRequest(
        id: json["id"] == null ? null : json["id"],
        displayOrderId:
            json["display_order_id"] == null ? null : json["display_order_id"],
        posOrderId: json["pos_order_id"] == null ? null : json["pos_order_id"],
        brandId: json["brand_id"] == null ? null : json["brand_id"],
        storeId: json["store_id"] == null ? null : json["store_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        runnerId: json["runner_id"] == null ? null : json["runner_id"],
        runnerDeliveryAccepted: json["runner_delivery_accepted"] == null
            ? null
            : json["runner_delivery_accepted"],
        userAddressId:
            json["user_address_id"] == null ? null : json["user_address_id"],
        bookingRequestUserAddress:
            json["user_address"] == null ? null : json["user_address"],
        gmapAttribute:
            json["gmap_attribute"] == null ? null : json["gmap_attribute"],
        paid: json["paid"] == null ? null : json["paid"],
        paymentMethod:
            json["payment_method"] == null ? null : json["payment_method"],
        discount: json["discount"] == null ? null : json["discount"],
        cartSaving: json["cart_saving"] == null ? null : json["cart_saving"],
        walletRefund:
            json["wallet_refund"] == null ? null : json["wallet_refund"],
        refundStatus:
            json["refund_status"] == null ? null : json["refund_status"],
        customerRefund:
            json["customer_refund"] == null ? null : json["customer_refund"],
        tcsCommission:
            json["tcs_commission"] == null ? null : json["tcs_commission"],
        commission: json["commission"] == null ? null : json["commission"],
        commissionWithoutDiscount: json["commission_without_discount"] == null
            ? null
            : json["commission_without_discount"],
        payoutStatus:
            json["payout_status"] == null ? null : json["payout_status"],
        payoutDatetime:
            json["payout_datetime"] == null ? null : json["payout_datetime"],
        onlineMethod:
            json["online_method"] == null ? null : json["online_method"],
        platform: json["platform"] == null ? null : json["platform"],
        paymentRequestId: json["payment_request_id"] == null
            ? null
            : json["payment_request_id"],
        paymentId: json["payment_id"] == null ? null : json["payment_id"],
        note: json["note"] == null ? null : json["note"],
        couponCode: json["coupon_code"] == null ? null : json["coupon_code"],
        isMembershipCouponEnabled: json["is_membership_coupon_enabled"] == null
            ? null
            : json["is_membership_coupon_enabled"],
        membershipPlanDetailId: json["membership_plan_detail_id"] == null
            ? null
            : json["membership_plan_detail_id"],
        posBranchCode:
            json["pos_branch_code"] == null ? null : json["pos_branch_code"],
        total: json["total"] == null ? null : json["total"],
        rating: json["rating"] == null ? null : json["rating"],
        checkout: json["checkout"] == null ? null : json["checkout"],
        shippingCharges:
            json["shipping_charges"] == null ? null : json["shipping_charges"],
        shippingTax: json["shipping_tax"] == null ? null : json["shipping_tax"],
        shippingTaxRate: json["shipping_tax_rate"] == null
            ? null
            : json["shipping_tax_rate"],
        tax: json["tax"] == null ? null : json["tax"],
        taxRate: json["tax_rate"] == null ? null : json["tax_rate"],
        storeTaxRateDetail: json["store_tax_rate_detail"] == null
            ? null
            : json["store_tax_rate_detail"],
        calculatedTaxDetail: json["calculated_tax_detail"] == null
            ? null
            : json["calculated_tax_detail"],
        storeFixedTaxDetail: json["store_fixed_tax_detail"] == null
            ? null
            : json["store_fixed_tax_detail"],
        diningTable: json["dining_table"] == null ? null : json["dining_table"],
        orderFacility:
            json["order_facility"] == null ? null : json["order_facility"],
        status: json["status"] == null ? null : json["status"],
        orderRejectionNote: json["order_rejection_note"] == null
            ? null
            : json["order_rejection_note"],
        deliveryTimeSlot: json["delivery_time_slot"] == null
            ? null
            : json["delivery_time_slot"],
        deliverySlot:
            json["delivery_slot"] == null ? null : json["delivery_slot"],
        distance: json["distance"] == null ? null : json["distance"],
        travelTime: json["travel_time"] == null ? null : json["travel_time"],
        created: json["created"] == null ? null : json["created"],
        modified: json["modified"] == null ? null : json["modified"],
        user: json["User"] == null ? null : User.fromJson(json["User"]),
        userAddress: json["UserAddress"] == null
            ? null
            : UserAddress.fromJson(json["UserAddress"]),
        cart: json["Cart"] == null
            ? null
            : List<Cart>.from(json["Cart"].map((x) => Cart.fromJson(x))),
        store: json["Store"] == null ? null : Store.fromJson(json["Store"]),
        bookingDateTime: json["booking_date_time"] == null
            ? null
            : json["booking_date_time"],
        categoryTitle:
            json["category_title"] == null ? null : json["category_title"],
        serviceCount:
            json["service_count"] == null ? null : json["service_count"],
        serviceDuration:
            json["service_duration"] == null ? null : json["service_duration"],
        services: json["services"] == null ? null : json["services"],
        isManualAssignment: json["is_manual_assignment"] == null
            ? null
            : json["is_manual_assignment"],
    readStatus: json["read_status"] == null
            ? null
            : json["read_status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "display_order_id": displayOrderId == null ? null : displayOrderId,
        "pos_order_id": posOrderId == null ? null : posOrderId,
        "brand_id": brandId == null ? null : brandId,
        "store_id": storeId == null ? null : storeId,
        "user_id": userId == null ? null : userId,
        "runner_id": runnerId == null ? null : runnerId,
        "runner_delivery_accepted":
            runnerDeliveryAccepted == null ? null : runnerDeliveryAccepted,
        "user_address_id": userAddressId == null ? null : userAddressId,
        "user_address": bookingRequestUserAddress == null
            ? null
            : bookingRequestUserAddress,
        "gmap_attribute": gmapAttribute == null ? null : gmapAttribute,
        "paid": paid == null ? null : paid,
        "payment_method": paymentMethod == null ? null : paymentMethod,
        "discount": discount == null ? null : discount,
        "cart_saving": cartSaving == null ? null : cartSaving,
        "wallet_refund": walletRefund == null ? null : walletRefund,
        "refund_status": refundStatus == null ? null : refundStatus,
        "customer_refund": customerRefund == null ? null : customerRefund,
        "tcs_commission": tcsCommission == null ? null : tcsCommission,
        "commission": commission == null ? null : commission,
        "commission_without_discount": commissionWithoutDiscount == null
            ? null
            : commissionWithoutDiscount,
        "payout_status": payoutStatus == null ? null : payoutStatus,
        "payout_datetime": payoutDatetime == null ? null : payoutDatetime,
        "online_method": onlineMethod == null ? null : onlineMethod,
        "platform": platform == null ? null : platform,
        "payment_request_id":
            paymentRequestId == null ? null : paymentRequestId,
        "payment_id": paymentId == null ? null : paymentId,
        "note": note == null ? null : note,
        "coupon_code": couponCode == null ? null : couponCode,
        "is_membership_coupon_enabled": isMembershipCouponEnabled == null
            ? null
            : isMembershipCouponEnabled,
        "membership_plan_detail_id":
            membershipPlanDetailId == null ? null : membershipPlanDetailId,
        "pos_branch_code": posBranchCode == null ? null : posBranchCode,
        "total": total == null ? null : total,
        "rating": rating == null ? null : rating,
        "checkout": checkout == null ? null : checkout,
        "shipping_charges": shippingCharges == null ? null : shippingCharges,
        "shipping_tax": shippingTax == null ? null : shippingTax,
        "shipping_tax_rate": shippingTaxRate == null ? null : shippingTaxRate,
        "tax": tax == null ? null : tax,
        "tax_rate": taxRate == null ? null : taxRate,
        "store_tax_rate_detail":
            storeTaxRateDetail == null ? null : storeTaxRateDetail,
        "calculated_tax_detail":
            calculatedTaxDetail == null ? null : calculatedTaxDetail,
        "store_fixed_tax_detail":
            storeFixedTaxDetail == null ? null : storeFixedTaxDetail,
        "dining_table": diningTable == null ? null : diningTable,
        "order_facility": orderFacility == null ? null : orderFacility,
        "status": status == null ? null : status,
        "order_rejection_note":
            orderRejectionNote == null ? null : orderRejectionNote,
        "delivery_time_slot":
            deliveryTimeSlot == null ? null : deliveryTimeSlot,
        "delivery_slot": deliverySlot == null ? null : deliverySlot,
        "distance": distance == null ? null : distance,
        "travel_time": travelTime == null ? null : travelTime,
        "created": created == null ? null : created,
        "modified": modified == null ? null : modified,
        "User": user == null ? null : user.toJson(),
        "UserAddress": userAddress == null ? null : userAddress.toJson(),
        "Cart": cart == null
            ? null
            : List<dynamic>.from(cart.map((x) => x.toJson())),
        "Store": store == null ? null : store.toJson(),
        "booking_date_time": bookingDateTime == null ? null : bookingDateTime,
        "category_title": categoryTitle == null ? null : categoryTitle,
        "service_count": serviceCount == null ? null : serviceCount,
        "service_duration": serviceDuration == null ? null : serviceDuration,
        "services": services == null ? null : services,
        "is_manual_assignment": isManualAssignment == null ? null : isManualAssignment,
        "read_status": readStatus == null ? null : readStatus,
      };
}

class Cart {
  Cart({
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
    this.walletRefundAmount,
    this.refundStatus,
    this.unitType,
    this.quantity,
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
    this.status,
    this.created,
    this.modified,
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
  String walletRefundAmount;
  String refundStatus;
  String unitType;
  String quantity;
  String comment;
  dynamic isTaxEnable;
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

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["id"] == null ? null : json["id"],
        storeId: json["store_id"] == null ? null : json["store_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        orderId: json["order_id"] == null ? null : json["order_id"],
        deviceId: json["device_id"] == null ? null : json["device_id"],
        deviceToken: json["device_token"] == null ? null : json["device_token"],
        platform: json["platform"] == null ? null : json["platform"],
        productId: json["product_id"] == null ? null : json["product_id"],
        productName: json["product_name"] == null ? null : json["product_name"],
        variantId: json["variant_id"] == null ? null : json["variant_id"],
        weight: json["weight"] == null ? null : json["weight"],
        mrpPrice: json["mrp_price"] == null ? null : json["mrp_price"],
        price: json["price"] == null ? null : json["price"],
        discount: json["discount"] == null ? null : json["discount"],
        walletRefundAmount: json["wallet_refund_amount"] == null
            ? null
            : json["wallet_refund_amount"],
        refundStatus:
            json["refund_status"] == null ? null : json["refund_status"],
        unitType: json["unit_type"] == null ? null : json["unit_type"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        comment: json["comment"] == null ? null : json["comment"],
        isTaxEnable: json["isTaxEnable"] == null ? null : json["isTaxEnable"],
        hsnCode: json["hsn_code"] == null ? null : json["hsn_code"],
        gstDetail: json["gst_detail"] == null ? null : json["gst_detail"],
        cgst: json["cgst"] == null ? null : json["cgst"],
        sgst: json["sgst"] == null ? null : json["sgst"],
        igst: json["igst"] == null ? null : json["igst"],
        gstType: json["gst_type"] == null ? null : json["gst_type"],
        gstTaxRate: json["gst_tax_rate"] == null ? null : json["gst_tax_rate"],
        gstState: json["gst_state"] == null ? null : json["gst_state"],
        status: json["status"] == null ? null : json["status"],
        created: json["created"] == null ? null : json["created"],
        modified: json["modified"] == null ? null : json["modified"],
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
        "wallet_refund_amount":
            walletRefundAmount == null ? null : walletRefundAmount,
        "refund_status": refundStatus == null ? null : refundStatus,
        "unit_type": unitType == null ? null : unitType,
        "quantity": quantity == null ? null : quantity,
        "comment": comment == null ? null : comment,
        "isTaxEnable": isTaxEnable == null ? null : isTaxEnable,
        "hsn_code": hsnCode == null ? null : hsnCode,
        "gst_detail": gstDetail == null ? null : gstDetail,
        "cgst": cgst == null ? null : cgst,
        "sgst": sgst == null ? null : sgst,
        "igst": igst == null ? null : igst,
        "gst_type": gstType == null ? null : gstType,
        "gst_tax_rate": gstTaxRate == null ? null : gstTaxRate,
        "gst_state": gstState == null ? null : gstState,
        "status": status == null ? null : status,
        "created": created == null ? null : created,
        "modified": modified == null ? null : modified,
      };
}

class Store {
  Store({
    this.id,
    this.storeName,
    this.preparationTime,
    this.rating,
    this.status,
    this.type,
    this.contactEmail,
    this.contactNumber,
    this.contactPerson,
    this.lng,
    this.lat,
    this.zipcode,
    this.timezone,
    this.state,
    this.city,
    this.location,
  });

  String id;
  String storeName;
  String preparationTime;
  String rating;
  String status;
  String type;
  String contactEmail;
  String contactNumber;
  String contactPerson;
  String lng;
  String lat;
  String zipcode;
  String timezone;
  String state;
  String city;
  String location;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json["id"] == null ? null : json["id"],
        storeName: json["store_name"] == null ? null : json["store_name"],
        preparationTime:
            json["preparation_time"] == null ? null : json["preparation_time"],
        rating: json["rating"] == null ? null : json["rating"],
        status: json["status"] == null ? null : json["status"],
        type: json["type"] == null ? null : json["type"],
        contactEmail:
            json["contact_email"] == null ? null : json["contact_email"],
        contactNumber:
            json["contact_number"] == null ? null : json["contact_number"],
        contactPerson:
            json["contact_person"] == null ? null : json["contact_person"],
        lng: json["lng"] == null ? null : json["lng"],
        lat: json["lat"] == null ? null : json["lat"],
        zipcode: json["zipcode"] == null ? null : json["zipcode"],
        timezone: json["timezone"] == null ? null : json["timezone"],
        state: json["state"] == null ? null : json["state"],
        city: json["city"] == null ? null : json["city"],
        location: json["location"] == null ? null : json["location"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "store_name": storeName == null ? null : storeName,
        "preparation_time": preparationTime == null ? null : preparationTime,
        "rating": rating == null ? null : rating,
        "status": status == null ? null : status,
        "type": type == null ? null : type,
        "contact_email": contactEmail == null ? null : contactEmail,
        "contact_number": contactNumber == null ? null : contactNumber,
        "contact_person": contactPerson == null ? null : contactPerson,
        "lng": lng == null ? null : lng,
        "lat": lat == null ? null : lat,
        "zipcode": zipcode == null ? null : zipcode,
        "timezone": timezone == null ? null : timezone,
        "state": state == null ? null : state,
        "city": city == null ? null : city,
        "location": location == null ? null : location,
      };
}

class User {
  User({
    this.id,
    this.fullName,
    this.lastName,
    this.fbId,
    this.email,
    this.password,
    this.decodedPassword,
    this.phone,
    this.gender,
    this.dob,
    this.profileImage,
    this.otpVerify,
    this.userReferCode,
    this.userReferredBy,
    this.status,
    this.loginStatus,
    this.deviceId,
    this.deviceToken,
    this.platform,
    this.posCustomerId,
    this.verificationCode,
    this.verificationCodeStatus,
    this.created,
    this.modified,
  });

  String id;
  String fullName;
  String lastName;
  String fbId;
  String email;
  String password;
  String decodedPassword;
  String phone;
  String gender;
  String dob;
  String profileImage;
  String otpVerify;
  String userReferCode;
  String userReferredBy;
  String status;
  String loginStatus;
  String deviceId;
  String deviceToken;
  String platform;
  String posCustomerId;
  String verificationCode;
  String verificationCodeStatus;
  String created;
  String modified;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        fullName: json["full_name"] == null ? null : json["full_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        fbId: json["fb_id"] == null ? null : json["fb_id"],
        email: json["email"] == null ? null : json["email"],
        password: json["password"] == null ? null : json["password"],
        decodedPassword:
            json["decoded_password"] == null ? null : json["decoded_password"],
        phone: json["phone"] == null ? null : json["phone"],
        gender: json["gender"] == null ? null : json["gender"],
        dob: json["dob"] == null ? null : json["dob"],
        profileImage:
            json["profile_image"] == null ? null : json["profile_image"],
        otpVerify: json["otp_verify"] == null ? null : json["otp_verify"],
        userReferCode:
            json["user_refer_code"] == null ? null : json["user_refer_code"],
        userReferredBy:
            json["user_referred_by"] == null ? null : json["user_referred_by"],
        status: json["status"] == null ? null : json["status"],
        loginStatus: json["login_status"] == null ? null : json["login_status"],
        deviceId: json["device_id"] == null ? null : json["device_id"],
        deviceToken: json["device_token"] == null ? null : json["device_token"],
        platform: json["platform"] == null ? null : json["platform"],
        posCustomerId:
            json["pos_customer_id"] == null ? null : json["pos_customer_id"],
        verificationCode: json["verification_code"] == null
            ? null
            : json["verification_code"],
        verificationCodeStatus: json["verification_code_status"] == null
            ? null
            : json["verification_code_status"],
        created: json["created"] == null ? null : json["created"],
        modified: json["modified"] == null ? null : json["modified"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "full_name": fullName == null ? null : fullName,
        "last_name": lastName == null ? null : lastName,
        "fb_id": fbId == null ? null : fbId,
        "email": email == null ? null : email,
        "password": password == null ? null : password,
        "decoded_password": decodedPassword == null ? null : decodedPassword,
        "phone": phone == null ? null : phone,
        "gender": gender == null ? null : gender,
        "dob": dob == null ? null : dob,
        "profile_image": profileImage == null ? null : profileImage,
        "otp_verify": otpVerify == null ? null : otpVerify,
        "user_refer_code": userReferCode == null ? null : userReferCode,
        "user_referred_by": userReferredBy == null ? null : userReferredBy,
        "status": status == null ? null : status,
        "login_status": loginStatus == null ? null : loginStatus,
        "device_id": deviceId == null ? null : deviceId,
        "device_token": deviceToken == null ? null : deviceToken,
        "platform": platform == null ? null : platform,
        "pos_customer_id": posCustomerId == null ? null : posCustomerId,
        "verification_code": verificationCode == null ? null : verificationCode,
        "verification_code_status":
            verificationCodeStatus == null ? null : verificationCodeStatus,
        "created": created == null ? null : created,
        "modified": modified == null ? null : modified,
      };
}

class UserAddress {
  UserAddress({
    this.id,
    this.brandId,
    this.userId,
    this.firstName,
    this.lastName,
    this.mobile,
    this.email,
    this.address,
    this.address2,
    this.city,
    this.state,
    this.zipcode,
    this.lat,
    this.lng,
    this.addressType,
    this.setDefaultAddress,
    this.softdelete,
    this.created,
    this.modified,
  });

  String id;
  String brandId;
  String userId;
  String firstName;
  String lastName;
  String mobile;
  String email;
  String address;
  String address2;
  String city;
  String state;
  String zipcode;
  String lat;
  String lng;
  String addressType;
  String setDefaultAddress;
  dynamic softdelete;
  String created;
  String modified;

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        id: json["id"] == null ? null : json["id"],
        brandId: json["brand_id"] == null ? null : json["brand_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        firstName: json["first_name"] == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        email: json["email"] == null ? null : json["email"],
        address: json["address"] == null ? null : json["address"],
        address2: json["address2"] == null ? null : json["address2"],
        city: json["city"] == null ? null : json["city"],
        state: json["state"] == null ? null : json["state"],
        zipcode: json["zipcode"] == null ? null : json["zipcode"],
        lat: json["lat"] == null ? null : json["lat"],
        lng: json["lng"] == null ? null : json["lng"],
        addressType: json["address_type"] == null ? null : json["address_type"],
        setDefaultAddress: json["set_default_address"] == null
            ? null
            : json["set_default_address"],
        softdelete: json["softdelete"] == null ? null : json["softdelete"],
        created: json["created"] == null ? null : json["created"],
        modified: json["modified"] == null ? null : json["modified"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "brand_id": brandId == null ? null : brandId,
        "user_id": userId == null ? null : userId,
        "first_name": firstName == null ? null : firstName,
        "last_name": lastName == null ? null : lastName,
        "mobile": mobile == null ? null : mobile,
        "email": email == null ? null : email,
        "address": address == null ? null : address,
        "address2": address2 == null ? null : address2,
        "city": city == null ? null : city,
        "state": state == null ? null : state,
        "zipcode": zipcode == null ? null : zipcode,
        "lat": lat == null ? null : lat,
        "lng": lng == null ? null : lng,
        "address_type": addressType == null ? null : addressType,
        "set_default_address":
            setDefaultAddress == null ? null : setDefaultAddress,
        "softdelete": softdelete == null ? null : softdelete,
        "created": created == null ? null : created,
        "modified": modified == null ? null : modified,
      };
}

class Summery {
  Summery({
    this.totalEarning,
    this.totalBookings,
    this.totalCustomers,
  });

  String totalEarning;
  String totalBookings;
  String totalCustomers;

  factory Summery.fromJson(Map<String, dynamic> json) => Summery(
        totalEarning:
            json["total_earning"] == null ? null : json["total_earning"],
        totalBookings:
            json["total_bookings"] == null ? null : json["total_bookings"],
        totalCustomers:
            json["total_customers"] == null ? null : json["total_customers"],
      );

  Map<String, dynamic> toJson() => {
        "total_earning": totalEarning == null ? null : totalEarning,
        "total_bookings": totalBookings == null ? null : totalBookings,
        "total_customers": totalCustomers == null ? null : totalCustomers,
      };
}
