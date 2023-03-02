/*
 * Project Name:  [HWST] - hwst
 * File: /Users/bakbeom/work/hwst/lib/service/api_service.dart
 * Created Date: 2021-08-22 21:53:15
 * Last Modified: 2023-03-02 19:15:36
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---  --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
 *                        Discription                         
 * ---  --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
 */
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hwst/util/log_util.dart';
import 'package:hwst/enums/request_type.dart';
import 'package:hwst/service/key_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hwst/model/common/request_result.dart';
import 'package:hwst/view/common/function_of_print.dart';
import 'package:hwst/globalProvider/connect_status_provider.dart';

typedef HttpSuccessCallback<T> = void Function(dynamic data);

typedef DownLoadCallBack = Function(int, int);
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

class ApiService {
  Map<String, CancelToken?> _cancelTokens = Map<String, CancelToken?>();

  RequestType? requestType;
  final isWithLog = false;

  List<Cookie>? responseCookies;
  List<Cookie>? requestcookies;

  // * Dio Singleton
  Dio? _client;
  Dio get client => _client!;
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal() {
    if (_client == null) {
      final _baseOption = BaseOptions(
          connectTimeout: 5000,
          receiveTimeout: 5000,
          sendTimeout: 5000,
          contentType: 'application/json');
      _client = Dio(_baseOption)
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: onRequestWrapper,
            onResponse: onResponseWrapper,
            onError: onErrorWrapper,
          ),
        );
      //*  서버에서 보내온 데이터 JSON 으로 바꿔주기.
      (_client!.transformer as DefaultTransformer).jsonDecodeCallback =
          parseJson;
    }
  }

  void init(RequestType type) async {
    requestType = type;
  }

  void onRequestWrapper(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (isWithLog) {
      pr('===== Requtest ==== \n'
          'path: ${options.baseUrl}${options.path}\n'
          'headers: ${options.headers}\n'
          'body: ${options.data}\n'
          'param: ${options.queryParameters}\n'
          '===== Requtest ==== \n');
    }
    return handler.next(options);
  }

  void onResponseWrapper(
      Response resp, ResponseInterceptorHandler handler) async {
    print(requestType);
    if (isWithLog) {
      customLogger.d(
        'path: ${resp.requestOptions.baseUrl}${resp.requestOptions.path}\n'
        'headers: ${resp.headers}'
        'body: ${resp.data}\n',
      );
    }
    return handler.next(resp);
  }

  void onErrorWrapper(DioError error, ErrorInterceptorHandler handler) async {
    cancelAll();
    if (isWithLog) {
      customLogger.d(
        'path: ${error.requestOptions.baseUrl}${error.requestOptions.path}\n'
        'status code: ${error.response?.statusCode ?? ''}\n'
        'body: ${error.response?.data.toString() ?? ''}\n'
        'headers: ${error.response?.headers ?? ''}\n'
        'requestType: $requestType',
      );
    }
    handler.next(error);
  }

  void upload(
      {required String? url,
      FormData? data,
      ProgressCallback? onSendProgress,
      Map<String, dynamic>? params,
      Options? options,
      HttpSuccessCallback? successCallback,
      required String? tag}) async {
    try {
      CancelToken? cancelToken;
      if (tag != null) {
        cancelToken =
            _cancelTokens[tag] == null ? CancelToken() : _cancelTokens[tag]!;
        _cancelTokens[tag] = cancelToken;
      }

      Response<Map<String, dynamic>> response = await _client!.request('$url',
          onSendProgress: onSendProgress,
          data: data,
          queryParameters: params,
          options: options,
          cancelToken: cancelToken);
      String statusCode = response.data!['statusCode'];
      if (statusCode != '200') {
        // do something;
      }
    } on DioError catch (e, s) {
      print(s);
    } catch (e) {}
  }

  void cancel(String tag) {
    if (_cancelTokens.containsKey(tag)) {
      if (!_cancelTokens[tag]!.isCancelled) {
        _cancelTokens[tag]!.cancel();
      }
      _cancelTokens.remove(tag);
    }
  }

  void cancelAll() {
    _cancelTokens.forEach((key, cancelToken) {
      cancelToken!.cancel();
    });
  }

// * params 는 GET 에 사용.
// * body는 POST에 사용.
  Future<RequestResult?> request(
      {Map<String, dynamic>? body,
      Map<String, dynamic>? params,
      String? passingUrl}) async {
    final cp =
        KeyService.baseAppKey.currentContext!.read<ConnectStatusProvider>();
    var status = await cp.currenStream;
    var notConnected = status == null
        ? !(await cp.checkFirstStatus)
        : status != ConnectivityResult.mobile ||
            status != ConnectivityResult.wifi;
    if (notConnected) {
      return RequestResult(-2, null, 'networkError',
          errorMessage: 'networkError');
    } else {
      final CancelToken? cancelToken;
      final tag = requestType!.tag;
      cancelToken = _cancelTokens[tag] ?? CancelToken();
      _cancelTokens[tag] = cancelToken;

      if (requestType!.httpMethod == 'POST') {
        try {
          final Response<Map<String, dynamic>> response = await _client!
              .request(passingUrl ?? requestType!.url(),
                  data: body != null && requestType!.httpMethod == 'POST'
                      ? requestType!.is_x_www_form_urlencoded
                          ? body
                          : jsonEncode(body)
                      : null,
                  queryParameters: params != null ? params : null,
                  options: requestType!.is_x_www_form_urlencoded
                      ? Options(
                          method: requestType!.httpMethod,
                          contentType: Headers.formUrlEncodedContentType)
                      : Options(method: requestType!.httpMethod),
                  cancelToken: cancelToken);
          return RequestResult(
              response.statusCode!, response.data, response.statusMessage!);
        } on DioError catch (e, s) {
          cancel(tag);
          print(s);
          pr(e.message);
          pr(e.response);
          pr(e.stackTrace);
          pr(e.type);
          return RequestResult(-1, null, 'serverError',
              errorMessage: 'serverError');
        }
      }
      return RequestResult(0, null, 'anothor error',
          errorMessage: 'anothor error');
    }
  }
}
