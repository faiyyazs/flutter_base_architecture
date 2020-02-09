import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_base_architecture/exception/base_error.dart';

class RESTService {
  static const int GET = 1;
  static const int POST = 2;
  static const int PUT = 3;
  static const int DELETE = 4;
  static const int FORMDATA = 5;
  static const int URI = 6;
  static const String data = "data";
  static const String EXTRA_HTTP_VERB = "EXTRA_HTTP_VERB";
  static const String REST_API_CALL_IDENTIFIER = "REST_API_CALL_IDENTIFIER";
  static const String EXTRA_PARAMS = "EXTRA_PARAMS";

  Future<Response> onHandleIntent(Map<String, dynamic> params) async {
    dynamic action = params.putIfAbsent(data, () {});
    int verb = params.putIfAbsent(EXTRA_HTTP_VERB, () {
      return GET;
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
          .add(InterceptorsWrapper(onRequest: (Options options) async {
        //Set the token to headers
        options.headers["apiCallIdentifier"] = apiCallIdentifier;
        options.headers.addAll(getHeaders());
        // options.headers["token"] = "spbxfk4uvqwtft62l6ljwkvtk9qkqk5r";
        return options; //continue
      }, onError: (DioError e) async {
        print("RESTService:: onError: " + e.toString());
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
        response.headers.add("apiCallIdentifier", apiCallIdentifier.toString());
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

  static Uri _makeHttpUri(String scheme, String authority, String unencodedPath,
      Map<String, dynamic> queryParameters) {
    var userInfo = "";
    String host;
    int port;

    if (authority != null && authority.isNotEmpty) {
      var hostStart = 0;
      // Split off the user info.
      bool hasUserInfo = false;
      for (int i = 0; i < authority.length; i++) {
        const int atSign = 0x40;
        if (authority.codeUnitAt(i) == atSign) {
          hasUserInfo = true;
          userInfo = authority.substring(0, i);
          hostStart = i + 1;
          break;
        }
      }

      var hostEnd = hostStart;
      if (hostStart < authority.length &&
          authority.codeUnitAt(hostStart) == _LEFT_BRACKET) {
        // IPv6 host.
        int escapeForZoneID = -1;
        for (; hostEnd < authority.length; hostEnd++) {
          int char = authority.codeUnitAt(hostEnd);
          if (char == _PERCENT && escapeForZoneID < 0) {
            escapeForZoneID = hostEnd;
            if (authority.startsWith("25", hostEnd + 1)) {
              hostEnd += 2; // Might as well skip the already checked escape.
            }
          } else if (char == _RIGHT_BRACKET) {
            break;
          }
        }
        if (hostEnd == authority.length) {
          throw FormatException(
              "Invalid IPv6 host entry.", authority, hostStart);
        }
        Uri.parseIPv6Address(authority, hostStart + 1,
            (escapeForZoneID < 0) ? hostEnd : escapeForZoneID);
        hostEnd++; // Skip the closing bracket.
        if (hostEnd != authority.length &&
            authority.codeUnitAt(hostEnd) != _COLON) {
          throw FormatException("Invalid end of authority", authority, hostEnd);
        }
      }
      // Split host and port.
      bool hasPort = false;
      for (; hostEnd < authority.length; hostEnd++) {
        if (authority.codeUnitAt(hostEnd) == _COLON) {
          var portString = authority.substring(hostEnd + 1);
          // We allow the empty port - falling back to initial value.
          if (portString.isNotEmpty) port = int.parse(portString);
          break;
        }
      }
      host = authority.substring(hostStart, hostEnd);
    }
    return Uri(
        scheme: scheme,
        userInfo: userInfo,
        host: host,
        port: port,
        pathSegments: unencodedPath.split("/"),
        queryParameters: queryParameters);
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

  logParams(Map<String, dynamic> params) {
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

// Frequently used character codes.
const int _SPACE = 0x20;
const int _PERCENT = 0x25;
const int _AMPERSAND = 0x26;
const int _PLUS = 0x2B;
const int _DOT = 0x2E;
const int _SLASH = 0x2F;
const int _COLON = 0x3A;
const int _EQUALS = 0x3d;
const int _UPPER_CASE_A = 0x41;
const int _UPPER_CASE_Z = 0x5A;
const int _LEFT_BRACKET = 0x5B;
const int _BACKSLASH = 0x5C;
const int _RIGHT_BRACKET = 0x5D;
const int _LOWER_CASE_A = 0x61;
const int _LOWER_CASE_F = 0x66;
const int _LOWER_CASE_Z = 0x7A;

const String _hexDigits = "0123456789ABCDEF";
