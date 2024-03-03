import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/models/refresh_model.dart';
import 'package:zaza_dashboard/network/local/cash_helper.dart';
import 'package:zaza_dashboard/ui/components/components.dart';

const url = 'https://zazastore-production.up.railway.app/';

class DioHelper {
  static late Dio dio;

  static init()
  {
    dio = Dio(
      BaseOptions(
        baseUrl: url,
        receiveDataWhenStatusError: true,
        connectTimeout:const Duration(  seconds: 60),
        receiveTimeout:  const Duration(  seconds: 60),
      ),

    );
  }

  DioHelper() {
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          print('On Request');
          options.headers["Accept"] = "application/json";
          options.headers["Authorization"] = 'Bearer ${token}'??'';
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final newAccessToken = await refreshToken();
            if (newAccessToken != null) {
              dio.options.headers["Authorization"] = 'Bearer ${newAccessToken}'??'';
              return handler.resolve(await dio.fetch(error.requestOptions));
            }
          }
          return handler.next(error);
        }
    ));
  }

  static Future <String?> refreshToken () async {
    try {

      final refreshTokenDio = Dio();
      refreshTokenDio.options.headers["Accept"] = "application/json";
      refreshTokenDio.options.headers["Authorization"] = 'Bearer ${token}'??'';

      final response = await refreshTokenDio.get('auth/refresh');

      String newAccessToken = response.data['accessToken'];
      String newRefreshToken = response.data['refreshToken'];

      print(newAccessToken);
      print(newRefreshToken);

      CacheHelper.saveData(
        key: 'refresh-token',
        value: newRefreshToken,
      );

      CacheHelper.saveData(
        key: 'token',
        value: newAccessToken,
      );
      return newAccessToken;
    }
    catch (exception) {
      print('error refresh token');
      CacheHelper.clearShared();
      showToast(text: 'Try Login Again', state: ToastState.error);
    }
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async
  {

    dio!.options.headers =
    {
      'Accept': 'application/json',
      'Authorization' : 'Bearer ${token}'??'',
    };

    return await dio!.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> deleteData({
    required String url,
    Map<dynamic, dynamic>? data,
    Map<String, dynamic>? query,
    String? token,
  }) async
  {

    dio!.options.headers =
    {
      'Accept': 'application/json',
      'Authorization' : 'Bearer ${token}'??'',
    };

    return dio!.delete(
      url,
      queryParameters: query,
      data: data,
    );
  }


  static Future<Response> postData({
    required String url,
    Map<dynamic, dynamic>? data,
    Map<String, dynamic>? query,
    String? token,
  }) async
  {

      dio!.options.headers =
      {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ${token}'??'',
      };
      return dio!.post(
        url,
        queryParameters: query,
        data: data,
      );
    }

  static Future<Response> postDataImage({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
    String? token,
  }) async
  {

    dio!.options.headers =
    {
      'Accept': 'application/json',
      'Authorization' : 'Bearer ${token}'??'',
    };


    return dio!.post(

      url,
      queryParameters: query,
      data: data,

    );
  }


  static Future<Response> patchData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
    String? token,
  }) async
  {

    dio!.options.headers =
    {
      'Accept': 'application/json',
      'Authorization' : 'Bearer ${token}'??'',
    };


    return dio!.patch(

      url,
      queryParameters: query,
      data: data,

    );
  }


}