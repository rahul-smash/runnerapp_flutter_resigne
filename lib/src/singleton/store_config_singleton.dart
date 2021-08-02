import 'package:marketplace_service_provider/src/model/config_model.dart';

class StoreConfigurationSingleton{

  static StoreConfigurationSingleton _instance;
  ConfigModel configModel;

  StoreConfigurationSingleton._();

  static StoreConfigurationSingleton get instance {
    return _instance ??= StoreConfigurationSingleton._();
  }

}