import 'dart:io';

import 'package:marketplace_service_provider/src/components/dashboard/model/booking_details_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/dashboard_resposne.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/notification_data.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/dashboard_network_repository.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';

class DashboardRepository {
  Future<DashboardResponse> getDashboardSummary(
      {String userId, String filterOption}) async {
    return await DashboardNetworkRepository.instance
        .getDashboardSummary(userId, filterOption);
  }

  Future<BookingResponse> getBookings(
      {String userId, String status, FilterType bookingSorting}) async {
    return await DashboardNetworkRepository.instance
        .getBookings(userId, status, bookingSorting);
  }

  Future<BookingDetailsResponse> getBookingsdetails(
      {String userId, String orderId}) async {
    return await DashboardNetworkRepository.instance
        .getBookingsdetails(userId, orderId);
  }

  Future<BaseResponse> changeBookingRequestAction(
      {String userId, String orderId, String status}) async {
    return await DashboardNetworkRepository.instance
        .changeBookingRequestAction(userId, orderId, status);
  }

  Future<BaseResponse> changeBookingAction(
      {String userId, String orderId, String status}) async {
    return await DashboardNetworkRepository.instance
        .changeBookingAction(userId, orderId, status);
  }

  Future<BaseResponse> changeBookingCashCollectionAction(
      {String userId,
      String orderId,
      String total,
      String paymentMethod}) async {
    return await DashboardNetworkRepository.instance
        .changeBookingCashCollectionAction(
            userId, orderId, total, paymentMethod);
  }

  Future<BaseResponse> addBookingWorkImages(
      {String userId,
      String orderId,
      String total,
      String paymentMethod,
      List<File> imageList}) async {
    return await DashboardNetworkRepository.instance
        .addBookingWorkImages(userId, orderId, total, paymentMethod, imageList);
  }

  Future<BaseResponse> bookingsCancelBookingByRunner(
      {String userId,
      String orderId,
      String reasonOption,
      String reason}) async {
    return await DashboardNetworkRepository.instance
        .bookingsCancelBookingByRunner(userId, orderId, reasonOption, reason);
  }

  Future<BaseResponse> updateRunnerLatlng(
      {String userId, String lat, String lng, String address}) async {
    return await DashboardNetworkRepository.instance
        .updateRunnerLatlng(userId, lat, lng, address);
  }

  Future<NotificationModel> getNotifications({String userId}) async {
    return await DashboardNetworkRepository.instance.getNotifications(userId);
  }
}
