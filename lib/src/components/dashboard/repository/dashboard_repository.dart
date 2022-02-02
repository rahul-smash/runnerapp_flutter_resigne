import 'dart:io';

import 'package:marketplace_service_provider/src/components/dashboard/model/TaxCalculationResponse.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_details_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/dashboard_response_summary.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/notification_data.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/reminder_order_count_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/dashboard_network_repository.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';

class DashboardRepository {
  Future<DashboardResponseSummary> getDashboardSummary(
      {String userId, String filterOption, int page = 1, int limit = 5}) async {
    return await DashboardNetworkRepository.instance
        .getDashboardSummary(userId, filterOption, page, limit);
  }

  Future<BookingResponse> getBookings(
      {String userId,
      String status,
      FilterType bookingSorting,
      int page = 1,
      int limit = 1000}) async {
    return await DashboardNetworkRepository.instance
        .getBookings(userId, status, bookingSorting, page, limit);
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
      {String userId,
      String lat,
      String lng,
      String address,
      String storeID}) async {
    return await DashboardNetworkRepository.instance
        .updateRunnerLatlng(userId, lat, lng, address, storeID);
  }

  Future<ReminderOrderCountResponse> ordersCount(
      {String storeId, String userId}) async {
    return await DashboardNetworkRepository.instance
        .ordersCount(storeId, userId);
  }

  Future<BaseResponse> getReadBooking({String userId, String orderId}) async {
    return await DashboardNetworkRepository.instance
        .getReadBooking(userId, orderId);
  }

  Future<NotificationModel> getNotifications({String userId}) async {
    return await DashboardNetworkRepository.instance.getNotifications(userId);
  }

  Future<TaxCalculationResponse> taxCalculationApi({
    String userId,
    String shipping,
    String userWallet,
    String discount,
    String cartSaving,
    String tax,
    String fixedDiscountAmount,
    String orderDetail,
    String storeID,
  }) async {
    return await DashboardNetworkRepository.instance.taxCalculationApi(
        userId,
        shipping,
        userWallet,
        discount,cartSaving,
        tax,
        fixedDiscountAmount,
        orderDetail,
        storeID);
  }

  Future<BaseResponse> editPlaceOrder({
    String orderId,
    String deviceId,
    String deviceToken,
    String userAddressId,
    String userAddress,
    String platform,
    String total,
    String discount,
    String cartSaving,
    String paymentMethod,
    String couponCode,
    String checkout,
    String userId,
    String shippingCharges,
    String userWallet,
    String tax,
    String fixedDiscountAmount,
    String orders,
    String storeID,
  }) async {
    return await DashboardNetworkRepository.instance.editPlaceOrder(
      cartSaving,
      orderId,
      deviceId,
      deviceToken,
      userAddressId,
      userAddress,
      platform,
      total,
      discount,
      paymentMethod,
      couponCode,
      checkout,
      userId,
      shippingCharges,
      userWallet,
      tax,
      fixedDiscountAmount,
      orders,
      storeID,
    );
  }
}
