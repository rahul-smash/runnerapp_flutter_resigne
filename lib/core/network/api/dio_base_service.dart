import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import 'api_exception.dart';

abstract class DioBaseService {
  static const REQUEST_TIME_OUT = 10000;
  static const RESPONSE_TIME_OUT = 10000;
  static const CONNECTION_TIME_OUT = 30000;
  Dio _dioClient;
  String _baseUrl;
  Map<String, dynamic> _headers;

  DioBaseService(String baseUrl) {
    this._baseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    this._headers = getHeader();
    _createClient();
  }

  @protected
  Map<String, dynamic> getHeader() {
    return {"Content-Type": "application/json"};
  }

  void _createClient() {
    _dioClient = new Dio();
    _dioClient.options
      ..baseUrl = _baseUrl
      ..connectTimeout = CONNECTION_TIME_OUT
      ..sendTimeout = REQUEST_TIME_OUT
      ..receiveTimeout = RESPONSE_TIME_OUT
      ..headers = _headers
      ..responseType = ResponseType.json;

    _dioClient.interceptors.add(new LogInterceptor(
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        request: false));
    _dioClient.interceptors.add(new InterceptorsWrapper(
      onRequest: (options, handler) {

      },
    ));
  }

  @protected
  Future<dynamic> get(String path, [Map<String, dynamic> queryParams]) async {
    try {
      Response response =
          await _dioClient.get(path, queryParameters: queryParams);
      return _responseHandler(response);
    } on DioError catch (dioError) {
      _errorHandler(dioError);
    }
  }

  @protected
  Future<dynamic> post(String path, Map<String, dynamic> data) async {
    try {
      Response response = await _dioClient.post(path, data: data);
      return _responseHandler(response);
    } on DioError catch (dioError) {
      _errorHandler(dioError);
    }
  }

  @protected
  Future<dynamic> put(String path, Map<String, dynamic> data) async {
    try {
      Response response = await _dioClient.put(path, data: data);
      return _responseHandler(response);
    } on DioError catch (dioError) {
      _errorHandler(dioError);
    }
  }

  @protected
  Future<dynamic> delete(String path, Map<String, dynamic> data) async {
    try {
      Response response = await _dioClient.delete(path, data: data);
      return _responseHandler(response);
    } on DioError catch (dioError) {
      _errorHandler(dioError);
    }
  }

  void _errorHandler(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
        throw ConnectionException('connection time out');
      case DioErrorType.sendTimeout:
        throw ConnectionException('request time out');
      case DioErrorType.receiveTimeout:
        throw ConnectionException('response time out');
      case DioErrorType.response:
        _errorStatus(error.response);
        break;
      case DioErrorType.cancel:
        break;
      case DioErrorType.other:
        if (error.error is SocketException) {
          throw FetchDataException('Socket');
        }
        throw FetchDataException('No internet connection');
    }
  }

  dynamic _responseHandler(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
      case 203:
        if (response.data == null || response.data.isEmpty) {
          throw EmptyResultApiException();
        }
        return response.data;
    }
  }

  void _errorStatus(Response response) {
    switch (response.statusCode) {
      case 400:
        throw BadRequestException(response.data?.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.data?.toString());
      case 404:
        throw NotFoundException(response.data?.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
