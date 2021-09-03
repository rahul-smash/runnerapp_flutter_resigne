import 'dart:convert';

import 'package:marketplace_service_provider/core/network/api/dio_base_service.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/complete_detail_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/complete_summary_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/payout_summary_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/pending_summary_response.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/network/app_network_constants.dart';
import 'package:marketplace_service_provider/src/network/components/common_network_utils.dart';
import 'package:marketplace_service_provider/src/singleton/store_config_singleton.dart';

class PayoutNetworkRepository extends DioBaseService {
  static PayoutNetworkRepository _instance;
  static const _paymentSummery = '/runner_payouts/paymentSummery';
  static const _pendingPayout = '/runner_payouts/pendingPayouts';

  static const _completePayoutList = '/runner_payouts/completedPayouts';
  static const _completePayoutDetail = '/runner_payouts/payoutHistory';

  static const _depositCashList = '/runner_deposits/collectedCash';//Pending Deposit List
  static const _depositCash = '/runner_deposits/depositCash';//Deposit Cash
  static const _depositsCompletedPayoutsList =
      '/runner_deposits/completedPayouts';//Completed Deposit List
  static const _depositsCompletedPayoutDetail =
      '/runner_deposits/depositHistory';//Completed Deposit History List

  PayoutNetworkRepository._() : super(AppNetworkConstants.baseUrl);

  static PayoutNetworkRepository get instance =>
      _instance ??= PayoutNetworkRepository._();

  String apiPath(String storeId, String path) =>
      '$storeId${AppNetworkConstants.baseRoute}$path';

  Future<PayoutSummaryResponse> getPaymentSummary(
      String user_id, String filterOption) async {
    try {
      Map<String, dynamic> param =
          getIt.get<CommonNetworkUtils>().getDeviceParams();
      var response = await post(
          apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
              '${_paymentSummery}/${user_id}'),
          param);
      PayoutSummaryResponse payoutSummaryResponse =
          PayoutSummaryResponse.fromJson(jsonDecode(response));
      return payoutSummaryResponse;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<PendingSummaryResponse> getPendingPayout(
      String userId, String filterOption) async {
    try {
      Map<String, dynamic> param =
          getIt.get<CommonNetworkUtils>().getDeviceParams();
      var response = await post(
          apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
              '${_pendingPayout}/${userId}/${filterOption}'),
          param);
      PendingSummaryResponse pendingSummaryResponse =
          PendingSummaryResponse.fromJson(jsonDecode(response));
      return pendingSummaryResponse;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<BaseResponse> getDepositCash(
    String ids
    /*pending deposit index id*/,
    String orderIds,
    String totalOrdersAmount,
    String totalOrders,
    String runnerId,
  ) async {
    try {
      Map<String, dynamic> param =
          getIt.get<CommonNetworkUtils>().getDeviceParams();
      param['ids'] = ids;
      param['order_ids'] = orderIds;
      param['total_orders_amount'] = totalOrdersAmount;
      param['total_orders'] = totalOrders;
      param['runner_id'] = runnerId;
      var response = await post(
          apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
              '${_depositCash}'),
          param);
      BaseResponse completeListSummaryResponse =
          BaseResponse.fromJson(jsonDecode(response));
      return completeListSummaryResponse;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<BaseResponse> getDepositCashList(
      String userId, String filterOption) async {
    try {
      Map<String, dynamic> param =
          getIt.get<CommonNetworkUtils>().getDeviceParams();
      var response = await post(
          apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
              '${_depositCashList}/${userId}/${filterOption}'),
          param);
      BaseResponse completeListSummaryResponse =
          BaseResponse.fromJson(jsonDecode(response));
      return completeListSummaryResponse;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<CompleteSummaryResponse> getCompletePayoutList(
      String userId, String filterOption) async {
    try {
      Map<String, dynamic> param =
          getIt.get<CommonNetworkUtils>().getDeviceParams();
      var response = await post(
          apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
              '${_completePayoutList}/${userId}/${filterOption}'),
          param);
      CompleteSummaryResponse completeListSummaryResponse =
      CompleteSummaryResponse.fromJson(jsonDecode(response));
      return completeListSummaryResponse;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<CompleteDetailResponse> getCompletePayoutDetails(
      String userId, String batchId) async {
    try {
      Map<String, dynamic> param =
          getIt.get<CommonNetworkUtils>().getDeviceParams();
      var response = await post(
          apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
              '${_completePayoutDetail}/${userId}/${batchId}'),
          param);
      CompleteDetailResponse completeDetailsResponse =
      CompleteDetailResponse.fromJson(jsonDecode(response));
      return completeDetailsResponse;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<BaseResponse> getDepositsCompletedPayoutsList(
      String userId, String filterOption) async {
    try {
      Map<String, dynamic> param =
          getIt.get<CommonNetworkUtils>().getDeviceParams();
      var response = await post(
          apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
              '${_depositsCompletedPayoutsList}/${userId}/${filterOption}'),
          param);
      BaseResponse completeListSummaryResponse =
          BaseResponse.fromJson(jsonDecode(response));
      return completeListSummaryResponse;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<BaseResponse> getDepositsCompletedPayoutDetail(
      String userId, String batchId) async {
    try {
      Map<String, dynamic> param =
          getIt.get<CommonNetworkUtils>().getDeviceParams();
      var response = await post(
          apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
              '${_depositsCompletedPayoutDetail}/${userId}/${batchId}'),
          param);
      BaseResponse completeListSummaryResponse =
          BaseResponse.fromJson(jsonDecode(response));
      return completeListSummaryResponse;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
