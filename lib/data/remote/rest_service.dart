import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_base_architecture/exception/base_error.dart';

class RESTService {
  static const int GET = 1;
  static const int POST = 2;
  static const int PUT = 3;
  static const int DELETE = 4;
  static const int FORMDATA = 5;
  static const int URI = 6;
  static const int PATCH = 7;
  static const int PATCH_URI = 8;
  static const String data = "data";
  static const String API_URL = "APIURL";
  static const String EXTRA_FORCE_REFRESH = "EXTRA_FORCE_REFRESH";
  static const String EXTRA_HTTP_VERB = "EXTRA_HTTP_VERB";
  static const String REST_API_CALL_IDENTIFIER = "REST_API_CALL_IDENTIFIER";
  static const String EXTRA_PARAMS = "EXTRA_PARAMS";

  Future<Response> onHandleIntent(Map<String, dynamic> params) async {
    dynamic action = params.putIfAbsent(data, () {});

    int verb = params.putIfAbsent(EXTRA_HTTP_VERB, () {
      return GET;
    });

    String apiUrl = params.putIfAbsent(API_URL, () {
      return "";
    });

    bool forceRefresh = params.putIfAbsent(EXTRA_FORCE_REFRESH, () {
      return false;
    });

    int apiCallIdentifier = params.putIfAbsent(REST_API_CALL_IDENTIFIER, () {
      return -1;
    });

    Map<String, dynamic> parameters = params.putIfAbsent(EXTRA_PARAMS, () {
      return null;
    });

    try {
      Dio request = Dio();
      request.interceptors
        ..add(DioCacheManager(CacheConfig(baseUrl: apiUrl)).interceptor)
        ..add(InterceptorsWrapper(onRequest: (Options options) async {
          //Set the token to headers
          options.headers["apiCallIdentifier"] = apiCallIdentifier;
          if (getHeaders() != null) {
            options.headers.addAll(getHeaders());
          }
          options.extra.addAll(
              buildCacheOptions(Duration(days: 7), forceRefresh: forceRefresh)
                  .extra);
          options.extra.update("apiCallIdentifier", (value) => value,
              ifAbsent: () => apiCallIdentifier);
          options.extra
              .update("cached", (value) => value, ifAbsent: () => true);

          return options; //continue
        }, onError: (DioError e) async {
          if (e.response != null) {
            print(e.response.data);
            print(e.response.headers);
            print(e.response.request);

            return parseErrorResponse(e, apiCallIdentifier);
          } else {
            // Something happened in setting up or sending the request that triggered an Error
            print(e.request);
            print(e.message);
            return parseErrorResponse(e, apiCallIdentifier);
          }
        }, onResponse: (response) {
          response.headers
              .add("apiCallIdentifier", apiCallIdentifier.toString());
          response.extra.update("apiCallIdentifier", (value) => value,
              ifAbsent: () => apiCallIdentifier);
          response.extra
              .update("cached", (value) => false, ifAbsent: () => false);
        }));
      request.interceptors.add(LogInterceptor(responseBody: false));

      logParams(parameters);

      switch (verb) {
        case RESTService.GET:
          Future<Response> response = request.get(action,
              queryParameters: attachUriWithQuery(parameters));
          return parseResponse(response, apiCallIdentifier);

        case RESTService.URI:
          Uri uri = action as Uri;
          Future<Response> response = request.getUri(Uri(
              scheme: uri.scheme,
              host: uri.host,
              path: uri.path,
              queryParameters: attachUriWithQuery(parameters)));

          return parseResponse(response, apiCallIdentifier);

        case RESTService.POST:
          /* request.options.contentType =
              ContentType.parse("application/x-www-form-urlencoded");
*/
          Future<Response> response = request.post(action, data: parameters);
          //  Future<Response> response = request.post(action,data: paramsToJson(parameters));
          return parseResponse(response, apiCallIdentifier);
        // return request.post(action,data: paramsToJson(parameters));

        case RESTService.FORMDATA:
          FormData formData = FormData.fromMap(parameters);
          Future<Response> response = request.post(action, data: formData);
          return parseResponse(response, apiCallIdentifier);

        case RESTService.PUT:
          Future<Response> response =
              request.put(action, data: paramstoJson(parameters));
          return parseResponse(response, apiCallIdentifier);
          break;

        case RESTService.DELETE:
          Future<Response> response =
              request.delete(action, data: paramstoJson(parameters));
          return parseResponse(response, apiCallIdentifier);
          break;

        case RESTService.PATCH:
          Future<Response> response = request.patch(action, data: parameters);
          return parseResponse(response, apiCallIdentifier);
          break;

        case RESTService.PATCH_URI:
          Uri uri = Uri.parse(action);
          Future<Response> response = request.patchUri(Uri(
              scheme: uri.scheme,
              port: uri.port,
              host: uri.host,
              path: uri.path,
              queryParameters: attachUriWithQuery(parameters)));

          return parseResponse(response, apiCallIdentifier);
          break;

        default:
          throw DioError(
            response: Response(headers: Headers()),
          );
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      // print(_handleError(error));
      return parseErrorResponse(error, apiCallIdentifier);
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      /* print("Exception e::"+e.toString());
      if(e is DioError) {
        print("DioError e::"+e.toString());
        if (e.response != null) {
          print(e.response.data);
          print(e.response.headers);
          print(e.response.request);

          return parseErrorResponse(e, apiCallIdentifier);
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(e.request);
          print(e.message);
          return parseErrorResponse(e, apiCallIdentifier);
        }
      }else{
        print("e::"+e.toString());
      }*/

    }
  }

  BaseError _handleError(Exception error) {
    BaseError amerError = BaseError();

    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.CANCEL:
          amerError.type = BaseErrorType.DEFAULT;
          amerError.message = "Request to API server was cancelled";
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          amerError.type = BaseErrorType.SERVER_TIMEOUT;
          amerError.message = "Connection timeout with API server";
          break;
        case DioErrorType.DEFAULT:
          amerError.type = BaseErrorType.DEFAULT;
          amerError.message =
              "Connection to API server failed due to internet connection";
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          amerError.type = BaseErrorType.SERVER_TIMEOUT;
          amerError.message = "Receive timeout in connection with API server";
          break;
        case DioErrorType.RESPONSE:
          amerError.type = BaseErrorType.INVALID_RESPONSE;
          amerError.message =
              "Received invalid status code: ${error.response.statusCode}";
          break;
        case DioErrorType.SEND_TIMEOUT:
          amerError.type = BaseErrorType.SERVER_TIMEOUT;
          amerError.message = "Receive timeout exception";
          break;
      }
    } else {
      amerError.type = BaseErrorType.UNEXPECTED;
      amerError.message = "Unexpected error occured";
    }
    return amerError;
  }

  logParams(dynamic params) {
    print("Parameters:");
    print("$params");
  }

  paramstoJson(Map<String, dynamic> params) {
    return json.encode(params);
  }

  Future<Response> parseErrorResponse(
      Exception exception, apiCallIdentifier) async {
    return await Future<Response>(() {
      Response response;

      if (exception is DioError) {
        if (exception.response != null) {
          response = exception.response;
        } else {
          response = Response(headers: Headers());
        }
      } else {
        response = Response(headers: Headers());
      }
      //response.data = null;
      response.headers.set("apiCallIdentifier", apiCallIdentifier.toString());

      //response.statusMessage = _handleError(exception);
      response.extra = Map();
      response.extra.putIfAbsent("exception", () => _handleError(exception));
      response.extra.update("apiCallIdentifier", (value) => value,
          ifAbsent: () => apiCallIdentifier);
      response.extra.update("cached", (value) => false, ifAbsent: () => false);
      return response;
    });
  }

  Future<Response> parseResponse(
      Future<Response> response, apiCallIdentifier) async {
    return await response;
  }

  dynamic paramsToJson(Map<String, dynamic> parameters) {
    return json.encode(parameters);
  }

  Map<String, dynamic> attachUriWithQuery(Map<String, dynamic> parameters) {
    return parameters;
  }

  Map<String, dynamic> getHeaders() {
    return null;
  }
}
