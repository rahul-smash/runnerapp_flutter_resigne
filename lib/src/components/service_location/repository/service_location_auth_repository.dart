import 'package:marketplace_service_provider/src/components/service_location/repository/service_location_repository.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';

import 'service_location_network_repository.dart';

class ServiceLocationAuthRepository extends ServiceLocationRepository{

  ServiceLocationAuthRepository();

  @override
  Future<BaseResponse> saveLocation({String locationId, String userId}) async {
    return await ServiceLocationNetworkRepository.instance.saveLocationApi(locationId, userId);
  }

}