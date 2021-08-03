import 'package:marketplace_service_provider/src/components/version_api/model/service_location_response.dart';
import 'package:marketplace_service_provider/src/components/version_api/repository/version_api_auth_repository.dart';
import 'package:marketplace_service_provider/src/model/store_response_model.dart';
import 'package:marketplace_service_provider/src/singleton/store_config_singleton.dart';
import 'version_api_network_repository.dart';

class VersionAuthRepository extends VersionApiRepository{

  @override
  Future<StoreResponse> versionApi() async {
    StoreResponse storeData =
    await VersionApiNetworkRepository.instance.versionApi(StoreConfigurationSingleton.instance.configModel.storeId);
    return storeData;
  }

  @override
  Future<ServiceLocationResponse> serviceLocationsApi() async {
    return await VersionApiNetworkRepository.instance.serviceLocationsApi(StoreConfigurationSingleton.instance.configModel.storeId);
  }

}