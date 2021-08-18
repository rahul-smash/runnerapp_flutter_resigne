import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/network/api/dio_base_service.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_details_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/dashboard_resposne.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/network/app_network_constants.dart';
import 'package:marketplace_service_provider/src/network/components/common_network_utils.dart';
import 'package:marketplace_service_provider/src/singleton/store_config_singleton.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';

class DashboardNetworkRepository extends DioBaseService {
  static DashboardNetworkRepository _instance;
  static const _dashboard = '/runner_orders/dashboard/';
  static const _bookings = '/runner_orders/myBookings/';
  static const _bookingDetails = '/runner_orders/getBookingDetail/';
  static const _bookingsRequestAction =
      '/runner_orders/changeBookingRequestStatus';
  static const _bookingsAction = '/runner_orders/changeBookingStatus';
  static const _bookingsCashCollection = '/runner_orders/cashCollection';

  DashboardNetworkRepository._() : super(AppNetworkConstants.baseUrl);

  static DashboardNetworkRepository get instance =>
      _instance ??= DashboardNetworkRepository._();

  String apiPath(String storeId, String path) =>
      '$storeId${AppNetworkConstants.baseRoute}$path';

  Future<DashboardResponse> getDashboardSummary(
      String user_id, String filterOption) async {
    try {
      Map<String, dynamic> param =
          getIt.get<CommonNetworkUtils>().getDeviceParams();
      var response = await post(
          apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
              '${_dashboard}/${user_id}/${filterOption}'),
          param);
      DashboardResponse dashboardResponse =
          DashboardResponse.fromJson(jsonDecode(response));
      return dashboardResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<BookingResponse> getBookings(
      String user_id, status, FilterType bookingSorting) async {
    _bookingSorting(FilterType bookingSorting) {
      switch (bookingSorting) {
        case FilterType.Booking_Date:
          return 'booking_date';
          break;
        default:
          return 'delivery_time_slot';
          break;
      }
    }

    try {
      Map<String, dynamic> param =
          getIt.get<CommonNetworkUtils>().getDeviceParams();
      param['user_id'] = user_id;
      param['status'] = status;
      param['filter'] = _bookingSorting;
      var response = await post(
          apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
              '${_bookings}/${1}/100'),
          param);
      BookingResponse bookingResponse =
          BookingResponse.fromJson(jsonDecode(response));
      return bookingResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<BaseResponse> changeBookingRequestAction(
      String userId, String orderId, String status) async {
    try {
      Map<String, dynamic> param =
          getIt.get<CommonNetworkUtils>().getDeviceParams();
      param['user_id'] = userId;
      param['order_id'] = orderId;
      param['status'] = status;
      var response = await post(
          apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
              '${_bookingsRequestAction}'),
          param);
      BaseResponse bookingResponse =
          BaseResponse.fromJson(jsonDecode(response));
      return bookingResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<BaseResponse> changeBookingAction(
      String userId, String orderId, String status) async {
    try {
      Map<String, dynamic> param =
          getIt.get<CommonNetworkUtils>().getDeviceParams();
      param['user_id'] = userId;
      param['order_id'] = orderId;
      param['status'] = status;
      var response = await post(
          apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
              '${_bookingsAction}'),
          param);
      BaseResponse bookingResponse =
          BaseResponse.fromJson(jsonDecode(response));
      return bookingResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<BaseResponse> changeBookingCashCollectionAction(String userId,
      String orderId, String total, String paymentMethod) async {
    try {
      Map<String, dynamic> param =
          getIt.get<CommonNetworkUtils>().getDeviceParams();
      param['user_id'] = userId;
      param['order_id'] = orderId;
      param['total'] = total;
      param['payment_method'] = paymentMethod;
      var response = await post(
          apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
              '${_bookingsCashCollection}'),
          param);
      BaseResponse bookingResponse =
          BaseResponse.fromJson(jsonDecode(response));
      return bookingResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<BookingDetailsResponse> getBookingsdetails(
    String userId,
    String orderId,
  ) async {
    try {
      Map<String, dynamic> param =
          getIt.get<CommonNetworkUtils>().getDeviceParams();
      param['user_id'] = userId;
      param['order_id'] = orderId;
      var response = await post(
          apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
              '${_bookingDetails}${orderId}'),
          param);
      BookingDetailsResponse bookingResponse =
          BookingDetailsResponse.fromJson(jsonDecode(response));
      return bookingResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
