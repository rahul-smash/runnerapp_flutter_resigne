// To parse this JSON data, do
//
//     final bookingDetailsResponse = bookingDetailsResponseFromJson(jsonString);

import 'dart:convert';

class BookingDetailsResponse {
  BookingDetailsResponse({
    this.success,
    this.bookingCounts,
    this.bookings,
  });

  bool success;
  String bookingCounts;
  Bookings bookings;

  BookingDetailsResponse copyWith({
    bool success,
    String bookingCounts,
    Bookings bookings,
  }) =>
      BookingDetailsResponse(
        success: success ?? this.success,
        bookingCounts: bookingCounts ?? this.bookingCounts,
        bookings: bookings ?? this.bookings,
      );

  factory BookingDetailsResponse.fromRawJson(String str) =>
      BookingDetailsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingDetailsResponse.fromJson(Map<String, dynamic> json) =>
      BookingDetailsResponse(
        success: json["success"] == null ? null : json["success"],
        bookingCounts:
            json["booking_counts"] == null ? null : json["booking_counts"],
        bookings: json["bookings"] == null
            ? null
            : Bookings.fromJson(json["bookings"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "booking_counts": bookingCounts == null ? null : bookingCounts,
        "bookings": bookings == null ? null : bookings.toJson(),
      };
}

class Bookings {
  Bookings({
    this.id,
    this.displayOrderId,
    this.brandId,
    this.storeId,
    this.userId,
    this.runnerId,
    this.runnerDeliveryAccepted,
    this.userAddressId,
    this.bookingsUserAddress,
    this.paymentMethod,
    this.discount,
    this.cartSaving,
    this.onlineMethod,
    this.platform,
    this.paymentRequestId,
    this.paymentId,
    this.note,
    this.couponCode,
    this.total,
    this.rating,
    this.checkout,
    this.shippingCharges,
    this.shippingTax,
    this.shippingTaxRate,
    this.tax,
    this.storeTaxRateDetail,
    this.calculatedTaxDetail,
    this.storeFixedTaxDetail,
    this.orderFacility,
    this.status,
    this.runnerAssigned,
    this.deliveryTimeSlot,
    this.created,
    this.modified,
    this.userAddress,
    this.user,
    this.cart,
    this.bookingDateTime,
    this.categoryTitle,
    this.serviceCount,
    this.serviceDuration,
  });

  String id;
  String displayOrderId;
  String brandId;
  String storeId;
  String userId;
  String runnerId;
  String runnerDeliveryAccepted;
  String userAddressId;
  String bookingsUserAddress;
  String paymentMethod;
  String discount;
  String cartSaving;
  String onlineMethod;
  String platform;
  String paymentRequestId;
  String paymentId;
  String note;
  String couponCode;
  String total;
  String rating;
  String checkout;
  String shippingCharges;
  String shippingTax;
  String shippingTaxRate;
  String tax;
  String storeTaxRateDetail;
  String calculatedTaxDetail;
  String storeFixedTaxDetail;
  String orderFacility;
  String status;
  String runnerAssigned;
  String deliveryTimeSlot;
  String created;
  String modified;
  UserAddress userAddress;
  User user;
  List<Cart> cart;
  String bookingDateTime;
  String categoryTitle;
  String serviceCount;
  String serviceDuration;

  Bookings copyWith({
    String id,
    String displayOrderId,
    String brandId,
    String storeId,
    String userId,
    String runnerId,
    String runnerDeliveryAccepted,
    String userAddressId,
    String bookingsUserAddress,
    String paymentMethod,
    String discount,
    String cartSaving,
    String onlineMethod,
    String platform,
    String paymentRequestId,
    String paymentId,
    String note,
    String couponCode,
    String total,
    String rating,
    String checkout,
    String shippingCharges,
    String shippingTax,
    String shippingTaxRate,
    String tax,
    String storeTaxRateDetail,
    String calculatedTaxDetail,
    String storeFixedTaxDetail,
    String orderFacility,
    String status,
    String runnerAssigned,
    String deliveryTimeSlot,
    String created,
    String modified,
    UserAddress userAddress,
    User user,
    List<Cart> cart,
    String bookingDateTime,
    String categoryTitle,
    String serviceCount,
    String serviceDuration,
  }) =>
      Bookings(
        id: id ?? this.id,
        displayOrderId: displayOrderId ?? this.displayOrderId,
        brandId: brandId ?? this.brandId,
        storeId: storeId ?? this.storeId,
        userId: userId ?? this.userId,
        runnerId: runnerId ?? this.runnerId,
        runnerDeliveryAccepted:
            runnerDeliveryAccepted ?? this.runnerDeliveryAccepted,
        userAddressId: userAddressId ?? this.userAddressId,
        bookingsUserAddress: bookingsUserAddress ?? this.bookingsUserAddress,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        discount: discount ?? this.discount,
        cartSaving: cartSaving ?? this.cartSaving,
        onlineMethod: onlineMethod ?? this.onlineMethod,
        platform: platform ?? this.platform,
        paymentRequestId: paymentRequestId ?? this.paymentRequestId,
        paymentId: paymentId ?? this.paymentId,
        note: note ?? this.note,
        couponCode: couponCode ?? this.couponCode,
        total: total ?? this.total,
        rating: rating ?? this.rating,
        checkout: checkout ?? this.checkout,
        shippingCharges: shippingCharges ?? this.shippingCharges,
        shippingTax: shippingTax ?? this.shippingTax,
        shippingTaxRate: shippingTaxRate ?? this.shippingTaxRate,
        tax: tax ?? this.tax,
        storeTaxRateDetail: storeTaxRateDetail ?? this.storeTaxRateDetail,
        calculatedTaxDetail: calculatedTaxDetail ?? this.calculatedTaxDetail,
        storeFixedTaxDetail: storeFixedTaxDetail ?? this.storeFixedTaxDetail,
        orderFacility: orderFacility ?? this.orderFacility,
        status: status ?? this.status,
        runnerAssigned: runnerAssigned ?? this.runnerAssigned,
        deliveryTimeSlot: deliveryTimeSlot ?? this.deliveryTimeSlot,
        created: created ?? this.created,
        modified: modified ?? this.modified,
        userAddress: userAddress ?? this.userAddress,
        user: user ?? this.user,
        cart: cart ?? this.cart,
        bookingDateTime: bookingDateTime ?? this.bookingDateTime,
        categoryTitle: categoryTitle ?? this.categoryTitle,
        serviceCount: serviceCount ?? this.serviceCount,
        serviceDuration: serviceDuration ?? this.serviceDuration,
      );

  factory Bookings.fromRawJson(String str) =>
      Bookings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Bookings.fromJson(Map<String, dynamic> json) => Bookings(
        id: json["id"] == null ? null : json["id"],
        displayOrderId:
            json["display_order_id"] == null ? null : json["display_order_id"],
        brandId: json["brand_id"] == null ? null : json["brand_id"],
        storeId: json["store_id"] == null ? null : json["store_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        runnerId: json["runner_id"] == null ? null : json["runner_id"],
        runnerDeliveryAccepted: json["runner_delivery_accepted"] == null
            ? null
            : json["runner_delivery_accepted"],
        userAddressId:
            json["user_address_id"] == null ? null : json["user_address_id"],
        bookingsUserAddress:
            json["user_address"] == null ? null : json["user_address"],
        paymentMethod:
            json["payment_method"] == null ? null : json["payment_method"],
        discount: json["discount"] == null ? null : json["discount"],
        cartSaving: json["cart_saving"] == null ? null : json["cart_saving"],
        onlineMethod:
            json["online_method"] == null ? null : json["online_method"],
        platform: json["platform"] == null ? null : json["platform"],
        paymentRequestId: json["payment_request_id"] == null
            ? null
            : json["payment_request_id"],
        paymentId: json["payment_id"] == null ? null : json["payment_id"],
        note: json["note"] == null ? null : json["note"],
        couponCode: json["coupon_code"] == null ? null : json["coupon_code"],
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
        storeTaxRateDetail: json["store_tax_rate_detail"] == null
            ? null
            : json["store_tax_rate_detail"],
        calculatedTaxDetail: json["calculated_tax_detail"] == null
            ? null
            : json["calculated_tax_detail"],
        storeFixedTaxDetail: json["store_fixed_tax_detail"] == null
            ? null
            : json["store_fixed_tax_detail"],
        orderFacility:
            json["order_facility"] == null ? null : json["order_facility"],
        status: json["status"] == null ? null : json["status"],
        runnerAssigned:
            json["runner_assigned"] == null ? null : json["runner_assigned"],
        deliveryTimeSlot: json["delivery_time_slot"] == null
            ? null
            : json["delivery_time_slot"],
        created: json["created"] == null ? null : json["created"],
        modified: json["modified"] == null ? null : json["modified"],
        userAddress: json["UserAddress"] == null
            ? null
            : UserAddress.fromJson(json["UserAddress"]),
        user: json["User"] == null ? null : User.fromJson(json["User"]),
        cart: json["Cart"] == null
            ? null
            : List<Cart>.from(json["Cart"].map((x) => Cart.fromJson(x))),
        bookingDateTime: json["booking_date_time"] == null
            ? null
            : json["booking_date_time"],
        categoryTitle:
            json["category_title"] == null ? null : json["category_title"],
        serviceCount:
            json["service_count"] == null ? null : json["service_count"],
        serviceDuration:
            json["service_duration"] == null ? null : json["service_duration"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "display_order_id": displayOrderId == null ? null : displayOrderId,
        "brand_id": brandId == null ? null : brandId,
        "store_id": storeId == null ? null : storeId,
        "user_id": userId == null ? null : userId,
        "runner_id": runnerId == null ? null : runnerId,
        "runner_delivery_accepted":
            runnerDeliveryAccepted == null ? null : runnerDeliveryAccepted,
        "user_address_id": userAddressId == null ? null : userAddressId,
        "user_address":
            bookingsUserAddress == null ? null : bookingsUserAddress,
        "payment_method": paymentMethod == null ? null : paymentMethod,
        "discount": discount == null ? null : discount,
        "cart_saving": cartSaving == null ? null : cartSaving,
        "online_method": onlineMethod == null ? null : onlineMethod,
        "platform": platform == null ? null : platform,
        "payment_request_id":
            paymentRequestId == null ? null : paymentRequestId,
        "payment_id": paymentId == null ? null : paymentId,
        "note": note == null ? null : note,
        "coupon_code": couponCode == null ? null : couponCode,
        "total": total == null ? null : total,
        "rating": rating == null ? null : rating,
        "checkout": checkout == null ? null : checkout,
        "shipping_charges": shippingCharges == null ? null : shippingCharges,
        "shipping_tax": shippingTax == null ? null : shippingTax,
        "shipping_tax_rate": shippingTaxRate == null ? null : shippingTaxRate,
        "tax": tax == null ? null : tax,
        "store_tax_rate_detail":
            storeTaxRateDetail == null ? null : storeTaxRateDetail,
        "calculated_tax_detail":
            calculatedTaxDetail == null ? null : calculatedTaxDetail,
        "store_fixed_tax_detail":
            storeFixedTaxDetail == null ? null : storeFixedTaxDetail,
        "order_facility": orderFacility == null ? null : orderFacility,
        "status": status == null ? null : status,
        "runner_assigned": runnerAssigned == null ? null : runnerAssigned,
        "delivery_time_slot":
            deliveryTimeSlot == null ? null : deliveryTimeSlot,
        "created": created == null ? null : created,
        "modified": modified == null ? null : modified,
        "UserAddress": userAddress == null ? null : userAddress.toJson(),
        "User": user == null ? null : user.toJson(),
        "Cart": cart == null
            ? null
            : List<dynamic>.from(cart.map((x) => x.toJson())),
        "booking_date_time": bookingDateTime == null ? null : bookingDateTime,
        "category_title": categoryTitle == null ? null : categoryTitle,
        "service_count": serviceCount == null ? null : serviceCount,
        "service_duration": serviceDuration == null ? null : serviceDuration,
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
    this.servicePayout,
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
  DateTime created;
  DateTime modified;
  String image10080;
  String image300200;
  String image;

  Cart copyWith({
    String id,
    String storeId,
    String userId,
    String orderId,
    String deviceId,
    String deviceToken,
    String platform,
    String productId,
    String productName,
    String variantId,
    String weight,
    String mrpPrice,
    String price,
    String discount,
    String servicePayout,
    String walletRefundAmount,
    String refundStatus,
    String unitType,
    String quantity,
    String comment,
    String isTaxEnable,
    String hsnCode,
    String gstDetail,
    String cgst,
    String sgst,
    String igst,
    String gstType,
    String gstTaxRate,
    String gstState,
    String status,
    DateTime created,
    DateTime modified,
    String image10080,
    String image300200,
    String image,
  }) =>
      Cart(
        id: id ?? this.id,
        storeId: storeId ?? this.storeId,
        userId: userId ?? this.userId,
        orderId: orderId ?? this.orderId,
        deviceId: deviceId ?? this.deviceId,
        deviceToken: deviceToken ?? this.deviceToken,
        platform: platform ?? this.platform,
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        variantId: variantId ?? this.variantId,
        weight: weight ?? this.weight,
        mrpPrice: mrpPrice ?? this.mrpPrice,
        price: price ?? this.price,
        discount: discount ?? this.discount,
        servicePayout: servicePayout ?? this.servicePayout,
        walletRefundAmount: walletRefundAmount ?? this.walletRefundAmount,
        refundStatus: refundStatus ?? this.refundStatus,
        unitType: unitType ?? this.unitType,
        quantity: quantity ?? this.quantity,
        comment: comment ?? this.comment,
        isTaxEnable: isTaxEnable ?? this.isTaxEnable,
        hsnCode: hsnCode ?? this.hsnCode,
        gstDetail: gstDetail ?? this.gstDetail,
        cgst: cgst ?? this.cgst,
        sgst: sgst ?? this.sgst,
        igst: igst ?? this.igst,
        gstType: gstType ?? this.gstType,
        gstTaxRate: gstTaxRate ?? this.gstTaxRate,
        gstState: gstState ?? this.gstState,
        status: status ?? this.status,
        created: created ?? this.created,
        modified: modified ?? this.modified,
        image10080: image10080 ?? this.image10080,
        image300200: image300200 ?? this.image300200,
        image: image ?? this.image,
      );

  factory Cart.fromRawJson(String str) => Cart.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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
        servicePayout:
            json["service_payout"] == null ? null : json["service_payout"],
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
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        modified:
            json["modified"] == null ? null : DateTime.parse(json["modified"]),
        image10080: json["image_100_80"] == null ? null : json["image_100_80"],
        image300200:
            json["image_300_200"] == null ? null : json["image_300_200"],
        image: json["image"] == null ? null : json["image"],
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
        "created": created == null ? null : created.toIso8601String(),
        "modified": modified == null ? null : modified.toIso8601String(),
        "image_100_80": image10080 == null ? null : image10080,
        "image_300_200": image300200 == null ? null : image300200,
        "image": image == null ? null : image,
      };
}

class User {
  User({
    this.phone,
    this.fullName,
    this.lastName,
  });

  String phone;
  String fullName;
  String lastName;

  User copyWith({
    String phone,
    String fullName,
    String lastName,
  }) =>
      User(
        phone: phone ?? this.phone,
        fullName: fullName ?? this.fullName,
        lastName: lastName ?? this.lastName,
      );

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        phone: json["phone"] == null ? null : json["phone"],
        fullName: json["full_name"] == null ? null : json["full_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone == null ? null : phone,
        "full_name": fullName == null ? null : fullName,
        "last_name": lastName == null ? null : lastName,
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
    this.completAddress,
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
  bool softdelete;
  DateTime created;
  DateTime modified;
  String completAddress;

  UserAddress copyWith({
    String id,
    String brandId,
    String userId,
    String firstName,
    String lastName,
    String mobile,
    String email,
    String address,
    String address2,
    String city,
    String state,
    String zipcode,
    String lat,
    String lng,
    String addressType,
    String setDefaultAddress,
    bool softdelete,
    DateTime created,
    DateTime modified,
    String completAddress,
  }) =>
      UserAddress(
        id: id ?? this.id,
        brandId: brandId ?? this.brandId,
        userId: userId ?? this.userId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        mobile: mobile ?? this.mobile,
        email: email ?? this.email,
        address: address ?? this.address,
        address2: address2 ?? this.address2,
        city: city ?? this.city,
        state: state ?? this.state,
        zipcode: zipcode ?? this.zipcode,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        addressType: addressType ?? this.addressType,
        setDefaultAddress: setDefaultAddress ?? this.setDefaultAddress,
        softdelete: softdelete ?? this.softdelete,
        created: created ?? this.created,
        modified: modified ?? this.modified,
        completAddress: completAddress ?? this.completAddress,
      );

  factory UserAddress.fromRawJson(String str) =>
      UserAddress.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        modified:
            json["modified"] == null ? null : DateTime.parse(json["modified"]),
        completAddress:
            json["complet_address"] == null ? null : json["complet_address"],
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
        "created": created == null ? null : created.toIso8601String(),
        "modified": modified == null ? null : modified.toIso8601String(),
        "complet_address": completAddress == null ? null : completAddress,
      };
}
