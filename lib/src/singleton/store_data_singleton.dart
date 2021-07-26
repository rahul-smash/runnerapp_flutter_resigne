import 'package:valueappz_feature_component/src/model/store_response_model.dart';

class StoreDataSingleton {
  static StoreDataSingleton _instance;
  StoreModel store;

  StoreDataSingleton._();

  static StoreDataSingleton get instance =>
      _instance ??= StoreDataSingleton._();
}
