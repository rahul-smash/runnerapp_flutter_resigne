
import 'package:marketplace_service_provider/src/components/version_api/model/service_location_response.dart';

class SingletonServiceLocations{

  static SingletonServiceLocations _instance;
  ServiceLocationResponse serviceLocationResponse;

  SingletonServiceLocations._();

  static SingletonServiceLocations get instance {
    return _instance ??= SingletonServiceLocations._();
  }

}

