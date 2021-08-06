import 'dart:async';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/onboarding/select_category/models/category_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/select_category/repository/categorys_list_network_datasource.dart';
import 'package:rxdart/rxdart.dart';

enum CategoryAction {PerformApiCall}

class CategoryBloc{

  //This StreamController is used to update the state of widgets
  PublishSubject<CategoryStreamOutput> _stateStreamController = new PublishSubject();
  StreamSink<CategoryStreamOutput> get _categorySink => _stateStreamController.sink;
  Stream<CategoryStreamOutput> get categoryStream => _stateStreamController.stream;

  //user input event StreamController
  PublishSubject<CategoryAction> _eventStreamController = new PublishSubject();
  StreamSink<CategoryAction> get eventSink => _eventStreamController.sink;
  Stream<CategoryAction> get _eventStream => _eventStreamController.stream;

  String store_id, locationId;
  CategoryBloc() {
    _eventStream.listen((event) async {
      if (event == CategoryAction.PerformApiCall){
        _categorySink.add(CategoryStreamOutput(showLoader: true,categoryModel: null));
        CategoryModel categoryModel = await getIt.get<CategoryListRemoteDataSourceImpl>().getCategoryList(locationId, store_id);
        _categorySink.add(CategoryStreamOutput(showLoader: false,categoryModel: categoryModel));
      }
    });
  }

  void dispose(){
    _stateStreamController.close();
    _eventStreamController.close();
  }

  void sendParams(String store_id, String location_Id) {
    this.store_id = store_id;
    this.locationId = location_Id;
  }

}

class CategoryStreamOutput {
  bool showLoader;
  CategoryModel categoryModel;
  CategoryStreamOutput({this.showLoader,this.categoryModel});
}