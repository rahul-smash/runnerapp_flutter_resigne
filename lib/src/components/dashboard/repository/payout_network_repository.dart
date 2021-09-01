import 'dart:convert';

import 'package:marketplace_service_provider/core/network/api/dio_base_service.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
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

  Future<PendingSummaryResponse> getPendingPayout(String user_id, String filterOption) async {
    try {
      Map<String, dynamic> param =
          getIt.get<CommonNetworkUtils>().getDeviceParams();
      var response = await post(
          apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
              '${_pendingPayout}/${user_id}'),
          param);
      PendingSummaryResponse pendingSummaryResponse =
      PendingSummaryResponse.fromJson(jsonDecode(response));
      return pendingSummaryResponse;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
