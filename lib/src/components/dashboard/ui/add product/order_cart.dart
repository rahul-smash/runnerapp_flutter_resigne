
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/best_product_response.dart';

class OderCart {
  static Map<String, Data> orderCartMap ={};
  static List<Data> dataList =[];
  static void putOrder(Data productData) {
    // dataList.add(productData);
    // fixme: why stopped using this, it looks good. Just a Suggestion!
    orderCartMap.update(productData.id, (v) => productData, ifAbsent: () => productData);
  }
  static void removeOrder(String productId) {
    // dataList.removeWhere((item) => item.id == productId);
    orderCartMap.remove(productId);
  }
  static Map<String, Data> getOrderCartMap() {
    print('called  ${orderCartMap.length}');
    return orderCartMap;
  }

  static bool isCartEmpty() {
    return orderCartMap.isEmpty;
  }
  static void clearOrderCartMap() {
    orderCartMap.clear();
  }
  static int countOrderCartMap() {
    orderCartMap.length;
  }
}
