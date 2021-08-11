// To parse this JSON data, do
//
//     final bookingResponse = bookingResponseFromJson(jsonString);

import 'dart:convert';

class BookingResponse {
  BookingResponse({
    this.success,
    this.bookingCounts,
    this.bookings,
  });

  bool success;
  BookingCounts bookingCounts;
  List<Booking> bookings;

  BookingResponse copyWith({
    bool success,
    BookingCounts bookingCounts,
    List<Booking> bookings,
  }) =>
      BookingResponse(
        success: success ?? this.success,
        bookingCounts: bookingCounts ?? this.bookingCounts,
        bookings: bookings ?? this.bookings,
      );

  factory BookingResponse.fromRawJson(String str) => BookingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingResponse.fromJson(Map<String, dynamic> json) => BookingResponse(
    success: json["success"] == null ? null : json["success"],
    bookingCounts: json["booking_counts"] == null ? null : BookingCounts.fromJson(json["booking_counts"]),
    bookings: json["bookings"] == null ? null : List<Booking>.from(json["bookings"].map((x) => Booking.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "booking_counts": bookingCounts == null ? null : bookingCounts.toJson(),
    "bookings": bookings == null ? null : List<dynamic>.from(bookings.map((x) => x.toJson())),
  };
}

class BookingCounts {
  BookingCounts({
    this.all,
    this.upcoming,
    this.ongoing,
    this.completed,
    this.rejected,
  });

  String all;
  String upcoming;
  String ongoing;
  String completed;
  String rejected;

  BookingCounts copyWith({
    String all,
    String upcoming,
    String ongoing,
    String completed,
    String rejected,
  }) =>
      BookingCounts(
        all: all ?? this.all,
        upcoming: upcoming ?? this.upcoming,
        ongoing: ongoing ?? this.ongoing,
        completed: completed ?? this.completed,
        rejected: rejected ?? this.rejected,
      );

  factory BookingCounts.fromRawJson(String str) => BookingCounts.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingCounts.fromJson(Map<String, dynamic> json) => BookingCounts(
    all: json["all"] == null ? null : json["all"],
    upcoming: json["upcoming"] == null ? null : json["upcoming"],
    ongoing: json["ongoing"] == null ? null : json["ongoing"],
    completed: json["completed"] == null ? null : json["completed"],
    rejected: json["rejected"] == null ? null : json["rejected"],
  );

  Map<String, dynamic> toJson() => {
    "all": all == null ? null : all,
    "upcoming": upcoming == null ? null : upcoming,
    "ongoing": ongoing == null ? null : ongoing,
    "completed": completed == null ? null : completed,
    "rejected": rejected == null ? null : rejected,
  };
}

class Booking {
  Booking({
    this.id,
    this.displayOrderId,
    this.userId,
    this.userAddress,
    this.total,
    this.status,
    this.paymentMethod,
    this.customerName,
    this.customerPhone,
    this.bookingDateTime,
    this.categoryTitle,
    this.serviceCount,
    this.serviceDuration,
    this.services,
  });

  String id;
  String displayOrderId;
  String userId;
  String userAddress;
  String total;
  String status;
  String paymentMethod;
  String customerName;
  String customerPhone;
  String bookingDateTime;
  String categoryTitle;
  String serviceCount;
  String serviceDuration;
  String services;

  Booking copyWith({
    String id,
    String displayOrderId,
    String userId,
    String userAddress,
    String total,
    String status,
    String paymentMethod,
    String customerName,
    String customerPhone,
    String bookingDateTime,
    String categoryTitle,
    String serviceCount,
    String serviceDuration,
    String services,
  }) =>
      Booking(
        id: id ?? this.id,
        displayOrderId: displayOrderId ?? this.displayOrderId,
        userId: userId ?? this.userId,
        userAddress: userAddress ?? this.userAddress,
        total: total ?? this.total,
        status: status ?? this.status,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        customerName: customerName ?? this.customerName,
        customerPhone: customerPhone ?? this.customerPhone,
        bookingDateTime: bookingDateTime ?? this.bookingDateTime,
        categoryTitle: categoryTitle ?? this.categoryTitle,
        serviceCount: serviceCount ?? this.serviceCount,
        serviceDuration: serviceDuration ?? this.serviceDuration,
        services: services ?? this.services,
      );

  factory Booking.fromRawJson(String str) => Booking.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json["id"] == null ? null : json["id"],
    displayOrderId: json["display_order_id"] == null ? null : json["display_order_id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    userAddress: json["user_address"] == null ? null : json["user_address"],
    total: json["total"] == null ? null : json["total"],
    status: json["status"] == null ? null : json["status"],
    paymentMethod: json["payment_method"] == null ? null : json["payment_method"],
    customerName: json["customer_name"] == null ? null : json["customer_name"],
    customerPhone: json["customer_phone"] == null ? null : json["customer_phone"],
    bookingDateTime: json["booking_date_time"] == null ? null : json["booking_date_time"],
    categoryTitle: json["category_title"] == null ? null : json["category_title"],
    serviceCount: json["service_count"] == null ? null : json["service_count"],
    serviceDuration: json["service_duration"] == null ? null : json["service_duration"],
    services: json["services"] == null ? null : json["services"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "display_order_id": displayOrderId == null ? null : displayOrderId,
    "user_id": userId == null ? null : userId,
    "user_address": userAddress == null ? null : userAddress,
    "total": total == null ? null : total,
    "status": status == null ? null : status,
    "payment_method": paymentMethod == null ? null : paymentMethod,
    "customer_name": customerName == null ? null : customerName,
    "customer_phone": customerPhone == null ? null : customerPhone,
    "booking_date_time": bookingDateTime == null ? null : bookingDateTime,
    "category_title": categoryTitle == null ? null : categoryTitle,
    "service_count": serviceCount == null ? null : serviceCount,
    "service_duration": serviceDuration == null ? null : serviceDuration,
    "services": services == null ? null : services,
  };
}
