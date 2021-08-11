import 'dart:convert';
import 'package:marketplace_service_provider/core/network/api/dio_base_service.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/onboarding/select_category/models/category_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/select_category/models/category_service_model.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';
import 'package:marketplace_service_provider/src/network/app_network_constants.dart';
import 'package:marketplace_service_provider/src/network/components/common_network_utils.dart';
import 'package:marketplace_service_provider/src/singleton/store_config_singleton.dart';
import 'category_list_remote_data_source.dart';


class CategoryListRemoteDataSourceImpl extends DioBaseService implements CategoryListRemoteDataSource {

  CategoryListRemoteDataSourceImpl() : super(AppNetworkConstants.baseUrl);

   static const _getCategories = '/runner_inventory/getCategories/';
   static const _getCategoryServices = '/runner_inventory/getCategoryServices/';
  static const _saveCategories = '/runner_authentication/saveCategories';

   String apiPath(String storeId, String path) =>
      '$storeId${AppNetworkConstants.baseRoute}$path';

  @override
  Future<CategoryModel> getCategoryList(String locationId,String storeId) async{
    try {
      String queryParms = "/${locationId}";
      var response = await get(apiPath(storeId, _getCategories)+queryParms, null);
      CategoryModel categoryModel = CategoryModel.fromJson(jsonDecode(response));
      return categoryModel;
    } catch (e) {
    }
    return null;
  }

  @override
  Future<CategoryServiceModel> getCategoriesServices(String locationId, String categoryId) async{
    try {
      String queryParms = "/${categoryId}/${locationId}";
      var response = await get(apiPath(StoreConfigurationSingleton.instance.configModel.storeId,
          _getCategoryServices)+queryParms, null);
      CategoryServiceModel categoryModel = CategoryServiceModel.fromJson(jsonDecode(response));
      return categoryModel;
    } catch (e) {
    }
    return null;
  }

  @override
  Future<BaseResponse> saveCategories(String userId,List<int> selectedCategoryIdsList) async{
    try {
      Map<String, dynamic> param = getIt.get<CommonNetworkUtils>().getDeviceParams();
      param['category_ids'] = selectedCategoryIdsList.join(',');
      param['user_id'] = userId;
      var response = await post(apiPath(StoreConfigurationSingleton.instance.configModel.storeId, _saveCategories),
          param);
      BaseResponse loginResponse = BaseResponse.fromJson(jsonDecode(response));
      return loginResponse;
    } catch (e) {
      print("catch=${e}");
    }
    return null;
  }


}