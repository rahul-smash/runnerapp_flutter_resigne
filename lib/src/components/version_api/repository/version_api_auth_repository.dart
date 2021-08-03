import 'package:marketplace_service_provider/src/components/version_api/model/service_location_response.dart';
import 'package:marketplace_service_provider/src/model/store_response_model.dart';

abstract class VersionApiRepository {
  /// version api
  Future<StoreResponse> versionApi();

  Future<ServiceLocationResponse> serviceLocationsApi();
}
