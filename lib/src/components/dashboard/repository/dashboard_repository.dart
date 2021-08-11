import 'package:marketplace_service_provider/src/components/dashboard/model/booking_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/dashboard_resposne.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/dashboard_network_repository.dart';

class DashboardRepository {
  Future<DashboardResponse> getDashboardSummary({String userId}) async {
    return await DashboardNetworkRepository.instance
        .getDashboardSummary(userId);
  }
  Future<BookingResponse> getBookings({String userId,String status}) async {
    return await DashboardNetworkRepository.instance
        .getBookings(userId,status);
  }
}
