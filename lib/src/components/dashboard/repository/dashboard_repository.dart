import 'package:marketplace_service_provider/src/components/dashboard/model/booking_details_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/dashboard_resposne.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/dashboard_network_repository.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';

class DashboardRepository {
  Future<DashboardResponse> getDashboardSummary({String userId,String filterOption}) async {
    return await DashboardNetworkRepository.instance
        .getDashboardSummary(userId,filterOption);
  }
  Future<BookingResponse> getBookings({String userId,String status, FilterType bookingSorting}) async {
    return await DashboardNetworkRepository.instance
        .getBookings(userId,status,bookingSorting);
  }
  Future<BookingDetailsResponse> getBookingsdetails({String userId,String orderId}) async {
    return await DashboardNetworkRepository.instance
        .getBookingsdetails(userId,orderId);
  }
  Future<BaseResponse> changeBookingRequestAction({String userId,String orderId,String status}) async {
    return await DashboardNetworkRepository.instance
        .changeBookingRequestAction(userId,orderId,status);
  }
  Future<BaseResponse> changeBookingAction({String userId,String orderId,String status}) async {
    return await DashboardNetworkRepository.instance
        .changeBookingAction(userId,orderId,status);
  }
}
