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
      {String userId,String filterOption}) async {
    return await PayoutNetworkRepository.instance
        .getPendingPayout(userId,filterOption);
  }
}
