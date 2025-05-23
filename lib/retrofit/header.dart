// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';
import 'package:stepowner/utils/const_preference/preference.dart';
import 'package:stepowner/utils/const_preference/shared_preference_utils.dart';

class RestClient {
  Dio dioData() {
    final dio = Dio();
    dio.options.headers["Accept"] = "application/json";
    // config your dio headers globally
    dio.options.headers["Authorization"] =
        "Bearer ${PreferenceManager.getString(SharePreferenceKey.tokenKey)}";
    dio.options.followRedirects = false;
    dio.options.connectTimeout = const Duration(seconds: 30); //5ss
    dio.options.receiveTimeout = const Duration(seconds: 30);
    return dio;
  }
}
