import 'package:marketplace_service_provider/src/components/onboarding/select_category/models/category_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/select_category/models/category_service_model.dart';
import 'package:marketplace_service_provider/src/model/base_response.dart';

abstract class CategoryListRemoteDataSource {
  /// Calls the getCategories/LOCATIONID.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<CategoryModel> getCategoryList(String locationId,String storeId);

  Future<CategoryServiceModel> getCategoriesServices(String locationId,String categoryId);

  Future<BaseResponse> saveCategories(String usrId,List<int>  category_ids);

}