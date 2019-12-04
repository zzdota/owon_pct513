import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'dart:io';
enum MethodType{
  Post,
  Get
}

/*
 * 网络请求管理类
 */
class OwonHttp {

  //写一个单例
  //在 Dart 里，带下划线开头的变量是私有变量
  static OwonHttp _instance;

  static OwonHttp getInstance() {
    if (_instance == null) {
      _instance = OwonHttp();
    }
    return _instance;
  }
  Dio dio = new Dio();
  OwonHttp() {
    var headers = Map<String, String>();
    headers['Content-Type'] = 'application/json';

    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;
    dio.options.headers.addAll(headers);


    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate  = (client) {
      client.badCertificateCallback=(X509Certificate cert, String host, int port){

      return true;
      };
    };

  }



//  //get请求
  get(String url,Function successCallBack,Function errorCallBack, [Map params]) async {
    _requestHttp(url, successCallBack, MethodType.Get, params, errorCallBack);
  }

  //post请求
  post(String url, params,Function successCallBack,Function errorCallBack) async {
    _requestHttp(url, successCallBack, MethodType.Post, params, errorCallBack);
  }

  _requestHttp(String url, Function successCallBack,
      [MethodType method, Map params, Function errorCallBack]) async {
    Response response;
    try {
      if (method == MethodType.Get) {
        if (params != null) {
          response = await dio.get(url, queryParameters: params);
        } else {
          response = await dio.get(url);
        }
      } else if (method == MethodType.Post) {
        if (params != null) {
          response = await dio.post(url, data: params);
        } else {
          response = await dio.post(url);
        }
      }
    }on DioError catch(error) {
      // 请求错误处理
      Response errorResponse;
      if (error.response != null) {
        errorResponse = error.response;
      } else {
        errorResponse = new Response(statusCode: 666);
      }
      // 请求超时
      if (error.type == DioErrorType.CONNECT_TIMEOUT) {
        errorResponse.statusCode = ResultCode.CONNECT_TIMEOUT;
      }
      // 一般服务器错误
      else if (error.type == DioErrorType.RECEIVE_TIMEOUT) {
        errorResponse.statusCode = ResultCode.RECEIVE_TIMEOUT;
      }

      // debug模式才打印
      if (GlobalConfig.isDebug) {
        print('请求异常: ' + error.toString());
        print('请求异常url: ' + url);
        print('请求头: ' + dio.options.headers.toString());
        print('method: ' + dio.options.method);
      }
      _error(errorCallBack, error.message);
      return '';
    }
    // debug模式打印相关数据
    if (GlobalConfig.isDebug) {
      print('请求url: ' + url);
      print('请求头: ' + dio.options.headers.toString());
      if (params != null) {
        print('请求参数: ' + params.toString());
      }
      if (response != null) {
        print('返回参数: ' + response.toString());
      }
    }
    String dataStr = json.encode(response.data);
    Map<String, dynamic> dataMap = json.decode(dataStr);
    if (dataMap == null || dataMap['state'] == 0) {
      _error(errorCallBack, '错误码：' + dataMap['errorCode'].toString() + '，' + response.data.toString());
    }else if (successCallBack != null) {
      successCallBack(dataMap);
    }
  }
  _error(Function errorCallBack, String error) {
    if (errorCallBack != null) {
      errorCallBack(error);
    }
  }
}


/*
 * dio网络请求失败的回调错误码
 */
class ResultCode {

  //正常返回是1
  static const SUCCESS = 1;

  //异常返回是0
  static const ERROR = 0;

  /// When opening  url timeout, it occurs.
  static const CONNECT_TIMEOUT = -1;

  ///It occurs when receiving timeout.
  static const RECEIVE_TIMEOUT = -2;

  /// When the server response, but with a incorrect status, such as 404, 503...
  static const RESPONSE = -3;
  /// When the request is cancelled, dio will throw a error with this type.
  static const CANCEL = -4;

  /// read the DioError.error if it is not null.
  static const DEFAULT = -5;
}

class GlobalConfig {
  static bool isDebug = true;//是否是调试模式
}

