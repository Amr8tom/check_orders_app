import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/core/utils/app_storage_keys.dart';
import '../api/end_points.dart';
import '../config/di.dart';
import 'api_clinet.dart';
import 'logging_interceptor.dart';

class DioClient extends ApiClient {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;
  final SharedPreferences sharedPreferences;

  final Dio dio;
  SharedPreferences prefs = sl.get<SharedPreferences>();
  DioClient(
    this.baseUrl, {
    required this.dio,
    required this.loggingInterceptor,
    required this.sharedPreferences,
  }) {
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(seconds: 60)
      ..options.receiveTimeout = const Duration(seconds: 60)
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": " application/json",
        "Authorization": "Bearer ${prefs.getString(AppStorageKey.token)}"
      };
    dio.interceptors.add(PrettyDioLogger(
      request: true,
      responseBody: true,requestBody: true,requestHeader: true
    ));
  }

  updateHeader(token) {
    dio.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Accept": " application/json",
      if(token!=null)
      "Authorization": "Bearer $token"
    };
  }
  updateBaseUrl(Url) {
    dio
      ..options.baseUrl = Url
      ..options.connectTimeout = const Duration(seconds: 60)
      ..options.receiveTimeout = const Duration(seconds: 60)
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": " application/json",
        "Authorization": "Bearer ${prefs.getString(AppStorageKey.token)}"
      };
  }

  @override
  Future<Response> get({
    required String uri,
    bool useGoogleUri=false,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {

      var response = await dio.get(uri, queryParameters: queryParameters);

      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future post(
      {required String uri,
      Map<String, dynamic>? queryParameters,
      data}) async {
    try {
      dio.options.baseUrl = baseUrl;
      var response = await dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future put(
      {required String uri,
      Map<String, dynamic>? queryParameters,
      data}) async {
    try {
      dio.options.baseUrl = baseUrl;
      var response = await dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future delete(
      {required String uri,
      Map<String, dynamic>? queryParameters,
      data}) async {
    try {
      dio.options.baseUrl = baseUrl;
      var response = await dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
}