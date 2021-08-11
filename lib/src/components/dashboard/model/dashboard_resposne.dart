import 'dart:convert';

class DashboardResponse {
  DashboardResponse({
    this.success,
    this.summery,
    this.bookingRequests,
  });

  bool success;
  Summery summery;
  List<BookingRequest> bookingRequests;

  DashboardResponse copyWith({
    bool success,
    Summery summery,
    List<BookingRequest> bookingRequests,
  }) =>
      DashboardResponse(
        success: success ?? this.success,
        summery: summery ?? this.summery,
        bookingRequests: bookingRequests ?? this.bookingRequests,
      );

  factory DashboardResponse.fromRawJson(String str) =>
      DashboardResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DashboardResponse.fromJson(Map<String, dynamic> json) =>
      DashboardResponse(
        success: json["success"] == null ? null : json["success"],
        summery:
            json["summery"] == null ? null : Summery.fromJson(json["summery"]),
        bookingRequests: json["bookingRequests"] == null
            ? null
            : List<BookingRequest>.from(
                json["bookingRequests"].map((x) => BookingRequest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
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
    this.userId,
    this.userAddress,
    this.total,
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
  String bookingDateTime;
  String categoryTitle;
  String serviceCount;
  String serviceDuration;
  String services;

  BookingRequest copyWith({
    String id,
    String displayOrderId,
    String userId,
    String userAddress,
    String total,
    String bookingDateTime,
    String categoryTitle,
    String serviceCount,
    String serviceDuration,
    String services,
  }) =>
      BookingRequest(
        id: id ?? this.id,
        displayOrderId: displayOrderId ?? this.displayOrderId,
        userId: userId ?? this.userId,
        userAddress: userAddress ?? this.userAddress,
        total: total ?? this.total,
        bookingDateTime: bookingDateTime ?? this.bookingDateTime,
        categoryTitle: categoryTitle ?? this.categoryTitle,
        serviceCount: serviceCount ?? this.serviceCount,
        serviceDuration: serviceDuration ?? this.serviceDuration,
        services: services ?? this.services,
      );

  factory BookingRequest.fromRawJson(String str) =>
      BookingRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingRequest.fromJson(Map<String, dynamic> json) => BookingRequest(
        id: json["id"] == null ? null : json["id"],
        displayOrderId:
            json["display_order_id"] == null ? null : json["display_order_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        userAddress: json["user_address"] == null ? null : json["user_address"],
        total: json["total"] == null ? null : json["total"],
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
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "display_order_id": displayOrderId == null ? null : displayOrderId,
        "user_id": userId == null ? null : userId,
        "user_address": userAddress == null ? null : userAddress,
        "total": total == null ? null : total,
        "booking_date_time": bookingDateTime == null ? null : bookingDateTime,
        "category_title": categoryTitle == null ? null : categoryTitle,
        "service_count": serviceCount == null ? null : serviceCount,
        "service_duration": serviceDuration == null ? null : serviceDuration,
        "services": services == null ? null : services,
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

  Summery copyWith({
    String totalEarning,
    String totalBookings,
    String totalCustomers,
  }) =>
      Summery(
        totalEarning: totalEarning ?? this.totalEarning,
        totalBookings: totalBookings ?? this.totalBookings,
        totalCustomers: totalCustomers ?? this.totalCustomers,
      );

  factory Summery.fromRawJson(String str) => Summery.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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
