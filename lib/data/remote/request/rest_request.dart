import 'package:dio/dio.dart';

import '../rest_service.dart';

abstract class RESTRequest {
  final RESTService _service;

  String apiUrl;
  String _apiKey;

  RESTRequest(this._service, {this.apiUrl = "http://google.com"}) {
    this._apiKey = "";
  }

  Future<Response> execute(String endpoint, Map<String, dynamic> params,
      int apiCallMethod, int apiIdentifier) async {
    return await _executeRESTCall(
        endpoint, -1, params, apiCallMethod, apiIdentifier);
  }

  Future<Response> _executeRESTCall(String endpoint, int resourceId,
      Map<String, dynamic> params, int apiCallMethod, int apiIdentifier) async {
    var buffer = new StringBuffer();
    buffer.writeAll([apiUrl, "/", endpoint]);

    Map<String, dynamic> extraParams = Map();
    extraParams.putIfAbsent(RESTService.data, () {
      return buffer.toString();
    });
    extraParams.putIfAbsent(RESTService.EXTRA_HTTP_VERB, () {
      return apiCallMethod;
    });
    extraParams.putIfAbsent(RESTService.REST_API_CALL_IDENTIFIER, () {
      return apiIdentifier;
    });
    extraParams.putIfAbsent(RESTService.EXTRA_PARAMS, () {
      return params;
    });

    return await _service.onHandleIntent(extraParams);
    // Give it to RESTService.
  }
}
