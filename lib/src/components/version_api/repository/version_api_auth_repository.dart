import 'package:marketplace_service_provider/src/model/store_response_model.dart';

abstract class VersionApiRepository {
  /// version api
  Future<StoreResponse> versionApi();
}
