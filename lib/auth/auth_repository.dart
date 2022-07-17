import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmdb_app/src/string.dart';
import 'package:tmdb_app/src/url.dart';
import '../api/api_client.dart';
import '../api/api_response.dart';
import '../api/api_route.dart';

import '../model/login_response.dart';

class AuthRepository {
  final options = BaseOptions();
  final client = APIClient(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
  ));
  late LoginResponse loginResponse;
  AuthRepository();



    Future<bool> loginWithFinger() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? username = prefs.getString(SHARED_USERNAME);
      String? password = prefs.getString(SHARED_PASSWORD);
      Map<String,dynamic> param = {
        "api_key" : apiKey,
      };
      final result = await client.request(
          route: APIRoute(APIType.getToken, param: param),
          create: () => TokenRequest());
      final requestToken = result.response?.requestToken;
      if(requestToken != null){
        Map<String,dynamic> data = {
          "username": username,
          "password": password,
          "request_token": requestToken
        };
        final response = await client.request(
            route: APIRoute(APIType.postLogin, param: param, data: data),
            create: () => TokenRequest());
        final status = response.response?.status;
        if(status == true){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool(SHARED_LOGGED, true);
          prefs.setString(SHARED_TOKEN, requestToken);
          prefs.setString(SHARED_USERNAME, username!);
          prefs.setString(SHARED_PASSWORD, password!);
          return true;
        }
      }
      throw ErrorResponse(message: 'Can not login');
    }

  Future<bool> loginWithToken(String?username, String? password, String? token) async{
    Map<String,dynamic> param = {
      "api_key" : apiKey,
    };
      Map<String,dynamic> data = {
      "username": username,
      "password": password,
      "request_token": token
    };
    final response = await client.request(
        route: APIRoute(APIType.postLogin, param: param, data: data),
        create: () => TokenRequest());
    final status = response.response?.status;
    if(status == true){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(SHARED_LOGGED, true);
      return true;
    }
    throw ErrorResponse(message: 'Can not login');
  }

  Future<bool?> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SHARED_LOGGED, false);
    return prefs.getBool(SHARED_LOGGED);
  }

  Future<bool?> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SHARED_LOGGED);
  }

  Future<bool?> getBiometric() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SHARED_FINGERPRINT);
  }

  Future changeBiometric(bool fingerprint) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(SHARED_FINGERPRINT,fingerprint);
  }

  Future<bool> login(String username, String password) async {
    Map<String,dynamic> param = {
      "api_key" : apiKey,
    };
    final result = await client.request(
        route: APIRoute(APIType.getToken, param: param),
        create: () => TokenRequest());
    final requestToken = result.response?.requestToken;
    if(requestToken != null){
      Map<String,dynamic> data = {
       "username": username,
        "password": password,
        "request_token": requestToken
    };
      final response = await client.request(
          route: APIRoute(APIType.postLogin, param: param, data: data),
          create: () => TokenRequest());
      final status = response.response?.status;
      if(status == true){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool(SHARED_LOGGED, true);
        prefs.setString(SHARED_TOKEN, requestToken);
        prefs.setString(SHARED_USERNAME, username);
        prefs.setString(SHARED_PASSWORD, password);
        return true;
      }
    }
    throw ErrorResponse(message: 'Can not login');
  }
}




