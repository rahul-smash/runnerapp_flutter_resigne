import 'package:marketplace_service_provider/src/model/store_response_model.dart';

class VersionApiSingleton{

  static VersionApiSingleton _instance;
  StoreResponse storeResponse;

  VersionApiSingleton._();

  static VersionApiSingleton get instance {
    return _instance ??= VersionApiSingleton._();
  }

}