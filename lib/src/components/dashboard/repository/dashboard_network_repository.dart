import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/network/api/dio_base_service.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_details_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/dashboard_resposne.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/notification_data.dart';
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
  static const _bookingscancelBookingByRunner =
      '/runner_orders/cancelBookingByRunner';
  static const _updateRunnerLatlng =
      '/runner_authentication/updateRunnerLatlng';
  static const _notificationRequest = '/runner_notifications/getNotifications';

  static const _orderCounts = '/runner_orders/OrderAssignmentCount';

  // Payment Summery
  // https://devservicemarketplace.valueappz.com/1/runner_v1/runner_payouts/paymentSummery/31
  // Pending Payout
  // https://devservicemarketplace.valueappz.com/1/runner_v1/runner_payouts/pendingPayouts/31

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

  Future<BaseResponse> changeBookingCashCollectionAction(
      String userId, String orderId, String total, String paymentMethod) async {
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

  Future<BaseResponse> addBookingWorkImages(String userId, String orderId,
      String total, String paymentMethod, List<File> images) async {
    try {
      Map<String, dynamic> param =
          getIt.get<CommonNetworkUtils>().getDeviceParams();
      FormData formData = FormData.fromMap({
        'platform': param["platform"],
        'device_id': param["device_id"],
        'user_id': userId,
        'order_id': orderId,
        'total': total,
        'payment_method': paymentMethod,
        'image1': images.length >= 1 && images[0] != null
            ? await MultipartFile.fromFile(
                images[0].path,
                filename: images[0].path == null
                    ? ""
                    : images[0].path.isEmpty
                        ? ""
                        : images[0].path.split('/').last,
              )
            : '',
        'image2': images.length >= 2 && images[1] != null
            ? await MultipartFile.fromFile(
                images[1].path,
                filename: images[1].path == null
                    ? ""
                    : images[1].path.isEmpty
                        ? ""
                        : images[1].path.split('/').last,
              )
            : "",
        'image3': images.length >= 3 && images[2] != null
            ? await MultipartFile.fromFile(
                images[2].path,
                filename: images[2].path == null
                    ? ""
                    : images[2].path.isEmpty
                        ? ""
                        : images[2].path.split('/').last,
              )
            : "",
        'image4': images.length >= 4 && images[3] != null
            ? await MultipartFile.fromFile(
                images[3].path,
                filename: images[3].path == null
                    ? ""
                    : images[3].path.isEmpty
                        ? ""
                        : images[3].path.split('/').last,
              )
            : "",
      });

      var response = await post(
          apiPath(
            StoreConfigurationSingleton.instance.configModel.storeId,
            '${_bookingsCashCollection}',
          ),
          null,
          isMultipartUploadRequest: true,
          formData: formData);
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

  Future<BaseResponse> bookingsCancelBookingByRunner(
      String userId, String orderId, String reasonOption, String reason) async {
    try {
      Map<String, dynamic> param =
          getIt.get<CommonNetworkUtils>().getDeviceParams();
      param['user_id'] = userId;
      param['order_id'] = orderId;
      param['reason_option'] = reasonOption;
      param['reason'] = reason;
      var response = await post(
          apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
              '${_bookingscancelBookingByRunner}'),
          param);
      BaseResponse baseResponse = BaseResponse.fromJson(jsonDecode(response));
      return baseResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<BaseResponse> updateRunnerLatlng(
      String userId, String lat, String lng, String address) async {
    print('getCurrentPosition ===start updating lat lng====');
    try {
      // Map<String, dynamic> param =
      // getIt.get<CommonNetworkUtils>().getDeviceParams();

      // CommonNetworkUtils commonNetworkUtils = CommonNetworkUtils();
      Map<String, dynamic> param = {'platform': 'android'};
      param['user_id'] = userId;
      param['lat'] = lat;
      param['lng'] = lng;
      param['address'] = address;
      print(" param... $param");
      var response = await post(apiPath('2', '${_updateRunnerLatlng}'), param);
      print('getCurrentPosition ===hit updating lat lng====');

      BaseResponse baseResponse = BaseResponse.fromJson(jsonDecode(response));
      print('getCurrentPosition ===response updating lat lng====');

      return baseResponse;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<Map<String, dynamic>> ordersCount(
      String storeId, String userId) async {
    try {
      var response = await get(
        apiPath(storeId, '$_orderCounts/$userId'),
      );
      print(response.toString());
      return jsonDecode(response);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<NotificationModel> getNotifications(String userId) async {
    try {
      Map<String, dynamic> param =
          getIt.get<CommonNetworkUtils>().getDeviceParams();
      param['user_id'] = userId;
      param['pagelength'] = 9999;
      param['page'] = 1;
      var response = await post(
          apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
              '$_notificationRequest'),
          param);
      return NotificationModel.fromJson(jsonDecode(response));
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
