import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/src/components/signUp/model/register_response.dart';

abstract class ServiceLocationRepository {

  Future<void> saveLocation({@required String locationId,@required String userId});

}
