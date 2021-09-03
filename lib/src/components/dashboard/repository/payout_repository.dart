import 'package:marketplace_service_provider/src/components/dashboard/model/payout_summary_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/pending_summary_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/payout_network_repository.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';

class PayoutRepository {
  Future<PayoutSummaryResponse> getPayoutSummary(
      {String userId, String filterOption}) async {
    return await PayoutNetworkRepository.instance
        .getPaymentSummary(userId, filterOption);
  }

  Future<PendingSummaryResponse> getPendingPayout(
      {String userId, String filterOption}) async {
    return await PayoutNetworkRepository.instance
        .getPendingPayout(userId, filterOption);
  }

  Future<BaseResponse> getDepositCash({
    String ids
    /*pending deposit index id*/,
    String orderIds,
    String totalOrdersAmount,
    String totalOrders,
    String runnerId,
  }) async {
    return await PayoutNetworkRepository.instance.getDepositCash(
      ids,
      orderIds,
      totalOrdersAmount,
      totalOrders,
      runnerId,
    );
  }

  Future<BaseResponse> getDepositCashList(
      {String userId, String filterOption}) async {
    return await PayoutNetworkRepository.instance
        .getDepositCashList(userId, filterOption);
  }

  Future<BaseResponse> getCompletePayoutList(
      {String userId, String filterOption}) async {
    return await PayoutNetworkRepository.instance
        .getCompletePayoutList(userId, filterOption);
  }

  Future<BaseResponse> getCompletePayoutDetails(
      {String userId, String batchId}) async {
    return await PayoutNetworkRepository.instance
        .getCompletePayoutDetails(userId, batchId);
  }

  Future<BaseResponse> getDepositsCompletedPayoutsList(
      String userId, String filterOption) async {
    return await PayoutNetworkRepository.instance
        .getDepositsCompletedPayoutsList(userId, filterOption);
  }

  Future<BaseResponse> getDepositsCompletedPayoutDetail(
      String userId, String batchId) async {
    return await PayoutNetworkRepository.instance
        .getDepositsCompletedPayoutDetail(userId, batchId);
  }
}
