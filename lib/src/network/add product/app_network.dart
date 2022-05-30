import 'dart:convert' as convert;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/add_address_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/apply_coupan_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/best_product_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/calculate_amount_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/calculate_shipping.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/categories_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/coupan_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/delivery_slot.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/loyalty_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/user_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/add_customer_response.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';

import '../app_network_constants.dart';

class AppNetwork {
  static Dio _dio;
  static const REQUEST_CATEGORIES = "/getCategories";
  static const REQUEST_PRODUCTS = "/getAllProducts";
  static const REQUEST_GET_LOYALTY_POINTS = '/coupons/getLoyalityPoints';
  static const REQUEST_CALCULATING_SHIPPING = '/calculateShippingCharges';
  static const REQUEST_TAX_CALCULATION = '/tax_calculation';
  static const REQUEST_VALIDATE_COUPON = '/coupons/validateCoupon';
  static const REQUEST_GET_BESTSELLER = "/getBestProducts";
  static const REQUEST_CUSTOMER_BY_PHONE = "/getCustomerByPhone";
  static const REQUEST_GET_COUPONS = '/coupons/offersList';
  static const REQUEST_ADD_CUSTOMER = "/addCustomer";
  static const REQUEST_PLACE_ORDER = '/orders/placeOrder';
  static const REQUEST_DELIVERY_SLOTS = '/delivery_zones/deliveryTimeSlot';
  static const REQUEST_ADD_DELIVERY_ADDRESS = "/deliveryAddress";
  static const REQUEST_PLACE_PICKUP_ORDER = '/orders/pickupPlaceOrder';

  static void init() {
    _dio = new Dio();
    _dio
      ..options.baseUrl = AppNetworkConstants.baseUrl
      ..options.connectTimeout = 60000
      ..options.receiveTimeout = 60000
      ..options.responseType = ResponseType.plain
      ..options.contentType = "application/json";
  }

  static Future<BestProduct> getCategoryProducts(Map<String, dynamic> param,
      {String storeID}) async {
    try {
      FormData formData = new FormData.fromMap(param);
      Response response = await _dio.post(
          AppNetworkConstants.baseUrl +
              "${AppNetworkConstants.baseStoreParam}" +
              AppNetworkConstants.productRoute +
              "/${storeID}" +
              REQUEST_PRODUCTS,
          data: formData);
      print("store id=${storeID}");
      print("response=${response.data.toString()}");
      print("statusCode=${response.statusCode}");

      if (response.statusCode == 200) {
        return bestProductResponseFromJson(response.data.toString());
      }
    } on DioError catch (e) {
      print("DioError.response ${e.response.data}");
      print("DioError.statusCode ${e.response.statusCode}");
      throw new CustomException(e.response.data, e.response.statusCode);
    } catch (e) {
      print(e);
    }
  }

  static Future<LoyaltyResponse> getLoyaltyPoints(
      Map<String, dynamic> param) async {
    try {
      FormData formData = new FormData.fromMap(param);
      Response response = await _dio.post(
          AppNetworkConstants.baseUrl +
              "${AppNetworkConstants.baseStoreParam}" +
              AppNetworkConstants.productRoute +
              "${AppSharedPref.instance.getStoreId()}" +
              REQUEST_GET_LOYALTY_POINTS,
          data: formData);
      print("response=${response.data.toString()}");
      print("statusCode=${response.statusCode}");

      if (response.statusCode == 200) {
        return loyaltyResponseFromJson(response.data.toString());
      }
    } on DioError catch (e) {
      print("DioError.response ${e.response.data}");
      print("DioError.statusCode ${e.response.statusCode}");
      throw new CustomException(e.response.data, e.response.statusCode);
    }
  }

  static Future<CalculateShipping> calculateShipping(
      Map<String, dynamic> param) async {
    try {
      FormData formData = new FormData.fromMap(param);
      Response response = await _dio.post(
          AppNetworkConstants.baseUrl +
              "${AppNetworkConstants.baseStoreParam}" +
              AppNetworkConstants.productRoute +
              "${AppSharedPref.instance.getStoreId()}" +
              REQUEST_CALCULATING_SHIPPING,
          data: formData);
      print("response=${response.data.toString()}");
      print("statusCode=${response.statusCode}");

      if (response.statusCode == 200) {
        return calculateResponseFromJson(response.data.toString());
      }
    } on DioError catch (e) {
      print("DioError.response ${e.response.data}");
      print("DioError.statusCode ${e.response.statusCode}");
      throw new CustomException(e.response.data, e.response.statusCode);
    }
  }

  static Future<CalculateAmount> calculateAmount(Map<String, dynamic> param,
      {String storeID}) async {
    try {
      FormData formData = new FormData.fromMap(param);
      Response response = await _dio.post(
          AppNetworkConstants.baseUrl +
              "${AppNetworkConstants.baseStoreParam}" +
              AppNetworkConstants.productRoute +
              "/$storeID" +
              REQUEST_TAX_CALCULATION,
          data: formData);
      print("response=${response.data.toString()}");
      print("statusCode=${response.statusCode}");
      if (response.statusCode == 200) {
        return amountResponseFromJson(response.data.toString());
      }
    } on DioError catch (e) {
      print("DioError.response ${e.response.data}");
      print("DioError.statusCode ${e.response.statusCode}");
      throw new CustomException(e.response.data, e.response.statusCode);
    } catch (e) {
      print("Calculate Tax Amount error");
      print(e);
    }
  }

  static Future<ApplyCouponResponse> validateCoupon(
      Map<String, dynamic> param) async {
    try {
      FormData formData = new FormData.fromMap(param);
      Response response = await _dio.post(
          AppNetworkConstants.baseUrl +
              "${AppNetworkConstants.baseStoreParam}" +
              AppNetworkConstants.productRoute +
              "${AppSharedPref.instance.getStoreId()}" +
              REQUEST_VALIDATE_COUPON,
          data: formData);
      print("response=${response.data.toString()}");
      print("statusCode=${response.statusCode}");
      if (response.statusCode == 200) {
        return applyCouponResponseFromJson(response.data.toString());
      }
    } on DioError catch (e) {
      print("DioError.response ${e.response.data}");
      print("DioError.statusCode ${e.response.statusCode}");
      throw new CustomException(e.response.data, e.response.statusCode);
    } catch (e) {
      print("valid coupon error");
      print(e);
    }
  }

  static Future<CustomerData> getCustomerByPhone(
      Map<String, dynamic> param) async {
    try {
      FormData formData = new FormData.fromMap(param);
      Response response = await _dio.post(
          AppNetworkConstants.baseUrl +
              "${AppNetworkConstants.baseStoreParam}" +
              AppNetworkConstants.productRoute +
              "${AppSharedPref.instance.getStoreId()}" +
              REQUEST_CUSTOMER_BY_PHONE,
          data: formData);
      print("response=${response.data.toString()}");
      print("statusCode=${response.statusCode}");

      if (response.statusCode == 200) {
        return customerdataResponseFromJson(response.data.toString());
      }
    } on DioError catch (e) {
      print("DioError.response ${e.response.data}");
      print("DioError.statusCode ${e.response.statusCode}");
      throw new CustomException(e.response.data, e.response.statusCode);
    } catch (e) {
      print("CUSTOMER DATA error --");
      print(e);
    }
  }

  static Future<CategoriesResponse> getCategories(Map<String, dynamic> param,
      {String storeID}) async {
    try {
      FormData formData = new FormData.fromMap(param);
      Response response = await _dio.post(
          AppNetworkConstants.baseUrl +
              "${AppNetworkConstants.baseStoreParam}" +
              AppNetworkConstants.productRoute +
              "/${storeID}" +
              REQUEST_CATEGORIES,
          data: formData);
      print(
          "url=${AppNetworkConstants.baseUrl + "${AppNetworkConstants.baseStoreParam}" + AppNetworkConstants.productRoute + "/${storeID}" + REQUEST_CATEGORIES}");
      print("response Get Categories=${response.data.toString()}");
      print("statusCode=${response.statusCode}");

      if (response.statusCode == 200) {
        return categoriesResponseFromJson(response.data.toString());
      }
    } on DioError catch (e) {
      print("DioError.response ${e.response.data}");
      print("DioError.statusCode ${e.response.statusCode}");
      throw new CustomException(e.response.data, e.response.statusCode);
    }
  }

  static Future<BestProduct> getBestProducts(Map<String, dynamic> param,
      {String storeID}) async {
    try {
      // String body = convert.jsonEncode(param);
      FormData formData = new FormData.fromMap(param);
      print("form data:$formData");
      Response response = await _dio.post(
          AppNetworkConstants.baseUrl +
              "${AppNetworkConstants.baseStoreParam}" +
              AppNetworkConstants.productRoute +
              "/${storeID}" +
              REQUEST_GET_BESTSELLER,
          data: formData);
      print(
          'url== ${AppNetworkConstants.baseUrl + "${AppNetworkConstants.baseStoreParam}" + AppNetworkConstants.productRoute + "/${storeID}" + REQUEST_GET_BESTSELLER}');
      print("getBestProducts response=${response.data.toString()}");
      print("statusCode=${response.statusCode}");
      if (response.statusCode == 200) {
        return bestProductResponseFromJson(response.data.toString());
      }
    } on DioError catch (e) {
      print("DioError.response ${e.response.data}");
      print("DioError.statusCode ${e.response.statusCode}");
      throw new CustomException(e.response.data, e.response.statusCode);
    } catch (e) {
      print("BEst product error");
      print(e);
    }
  }

  static Future<CouponResponse> getCoupons() async {
    try {
      Response response = await _dio.get(
        AppNetworkConstants.baseUrl +
            "${AppNetworkConstants.baseStoreParam}" +
            AppNetworkConstants.productRoute +
            "${AppSharedPref.instance.getStoreId()}" +
            REQUEST_GET_COUPONS,
      );
      print(AppNetworkConstants.baseUrl +
          "${AppNetworkConstants.baseStoreParam}" +
          AppNetworkConstants.productRoute +
          "${AppSharedPref.instance.getStoreId()}" +
          REQUEST_GET_COUPONS);
      print("response=${response.data.toString()}");
      print("statusCode=${response.statusCode}");
      if (response.statusCode == 200) {
        return couponResponseFromJson(response.data.toString());
      }
    } on DioError catch (e) {
      print("DioError.response ${e.response.data}");
      print("DioError.statusCode ${e.response.statusCode}");
      throw new CustomException(e.response.data, e.response.statusCode);
    }
  }

  static Future<DeliverySlot> getDeliverySlots(
      Map<String, dynamic> param) async {
    try {
      FormData formData = new FormData.fromMap(param);
      Response response = await _dio.post(
          AppNetworkConstants.baseUrl +
              "${AppNetworkConstants.baseStoreParam}" +
              AppNetworkConstants.productRoute +
              "${AppSharedPref.instance.getStoreId()}" +
              REQUEST_DELIVERY_SLOTS,
          data: formData);
      print(AppNetworkConstants.baseUrl +
          "${AppNetworkConstants.baseStoreParam}" +
          AppNetworkConstants.productRoute +
          "${AppSharedPref.instance.getStoreId()}" +
          REQUEST_DELIVERY_SLOTS);
      print("response=${response.data.toString()}");
      print("statusCode=${response.statusCode}");

      if (response.statusCode == 200) {
        return deliverySlotResponseFromJson(response.data.toString());
      }
    } on DioError catch (e) {
      print("DioError.response ${e.response.data}");
      print("DioError.statusCode ${e.response.statusCode}");
      throw new CustomException(e.response.data, e.response.statusCode);
    } catch (e) {
      print(e);
    }
  }

  static Future<AddCustomerResponse> addCustomer(
      Map<String, dynamic> param) async {
    try {
      FormData formData = new FormData.fromMap(param);
      Response response = await _dio.post(
          AppNetworkConstants.baseUrl +
              "${AppNetworkConstants.baseStoreParam}" +
              AppNetworkConstants.productRoute +
              "${AppSharedPref.instance.getStoreId()}" +
              REQUEST_ADD_CUSTOMER,
          data: formData);
      print(
          "request =${AppNetworkConstants.baseUrl + "${AppNetworkConstants.baseStoreParam}" + AppNetworkConstants.productRoute + "${AppSharedPref.instance.getStoreId()}" + REQUEST_ADD_CUSTOMER}");
      print("response=${response.data.toString()}");
      print("statusCode=${response.statusCode}");

      if (response.statusCode == 200) {
        return addCustomerResponseFromJson(response.data.toString());
      }
    } on DioError catch (e) {
      print("DioError.response ${e.response.data}");
      print("DioError.statusCode ${e.response.statusCode}");
      throw new CustomException(e.response.data, e.response.statusCode);
    } catch (e) {
      print(e);
    }
  }

  static Future<AddAddressResponse> deliveryAddress(
      Map<String, dynamic> param) async {
    try {
      FormData formData = new FormData.fromMap(param);
      Response response = await _dio.post(
          AppNetworkConstants.baseUrl +
              "${AppNetworkConstants.baseStoreParam}" +
              AppNetworkConstants.productRoute +
              "${AppSharedPref.instance.getStoreId()}" +
              REQUEST_ADD_DELIVERY_ADDRESS,
          data: formData);
      print(AppNetworkConstants.baseUrl +
          "${AppNetworkConstants.baseStoreParam}" +
          AppNetworkConstants.productRoute +
          "${AppSharedPref.instance.getStoreId()}" +
          REQUEST_ADD_DELIVERY_ADDRESS);
      print("response=${response.data.toString()}");
      print("statusCode=${response.statusCode}");
      if (response.statusCode == 200) {
        return addressResponseFromJson(response.data.toString());
      }
    } on DioError catch (e) {
      print("DioError.response ${e.response.data}");
      print("DioError.statusCode ${e.response.statusCode}");
      throw new CustomException(e.response.data, e.response.statusCode);
    } catch (e) {
      print(e);
    }
  }

  static Future<CalculateShipping> pickupPlaceOrder(
      Map<String, dynamic> param) async {
    try {
      FormData formData = new FormData.fromMap(param);
      Response response = await _dio.post(
          AppNetworkConstants.baseUrl +
              "${AppNetworkConstants.baseStoreParam}" +
              AppNetworkConstants.productRoute +
              "${AppSharedPref.instance.getStoreId()}" +
              REQUEST_PLACE_PICKUP_ORDER,
          data: formData);
      print("response=${response.data.toString()}");
      print("statusCode=${response.statusCode}");
      if (response.statusCode == 200) {
        return calculateResponseFromJson(response.data.toString());
      }
    } on DioError catch (e) {
      print("DioError.response ${e.response.data}");
      print("DioError.statusCode ${e.response.statusCode}");
      throw new CustomException(e.response.data, e.response.statusCode);
    } catch (e) {
      print("CHECKOUT-----------");
      print(e);
    }
  }

  static Future<CalculateShipping> placeOrder(
      Map<String, dynamic> param) async {
    try {
      FormData formData = new FormData.fromMap(param);
      Response response = await _dio.post(
          AppNetworkConstants.baseUrl +
              "${AppNetworkConstants.baseStoreParam}" +
              AppNetworkConstants.productRoute +
              "${AppSharedPref.instance.getStoreId()}" +
              REQUEST_PLACE_ORDER,
          data: formData);
      print("response=${response.data.toString()}");
      print("statusCode=${response.statusCode}");
      if (response.statusCode == 200) {
        return calculateResponseFromJson(response.data.toString());
      }
    } on DioError catch (e) {
      print("DioError.response ${e.response.data}");
      print("DioError.statusCode ${e.response.statusCode}");
      throw new CustomException(e.response.data, e.response.statusCode);
    } catch (e) {
      print("CHECKOUT-----------");
      print(e);
    }
  }
}

class CustomException implements Exception {
  String cause;
  int statusCode;

  CustomException(this.cause, this.statusCode);

  @override
  String toString() {
    return cause;
  }
}
