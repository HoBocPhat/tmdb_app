

import 'dart:async';

import 'package:dio/dio.dart';

class CustomInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    return super.onRequest(options, handler);
  }
  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler)async{
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }
  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async{
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    switch(err.type){
      case DioErrorType.response:
        print("Error");
      break;
    }
    return super.onError(err, handler);
  }
}