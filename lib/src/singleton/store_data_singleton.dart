import 'package:marketplace_service_provider/src/model/store_response_model.dart';

class StoreDataSingleton {
  static StoreDataSingleton _instance;

  StoreDataSingleton._();

  static StoreDataSingleton get instance =>
      _instance ??= StoreDataSingleton._();

  StoreResponse _storeData;

  StoreResponse get storeData => _storeData;

  set storeData(StoreResponse value) {
    _storeData = value;
  }
}
