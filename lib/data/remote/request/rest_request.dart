import 'package:dio/dio.dart';

import '../rest_service.dart';

abstract class RESTRequest {
  final RESTService _service;

  String apiUrl;
  String _apiKey;
  String schema;
  String host;

  RESTRequest(this._service,
      {this.apiUrl = "", this.schema: "http", this.host: ""}) {
    this._apiKey = "";
  }

  Future<Response> execute(String endpoint, Map<String, dynamic> params,
      int apiCallMethod, int apiIdentifier,
      {forceRefresh: false}) async {
    return await _executeRESTCall(
        endpoint, -1, params, apiCallMethod, apiIdentifier,
        forceRefresh: forceRefresh);
  }

  Future<Response> _executeRESTCall(String endpoint, int resourceId,
      Map<String, dynamic> params, int apiCallMethod, int apiIdentifier,
      {bool forceRefresh: false}) async {
    var buffer = new StringBuffer();
    buffer.writeAll([apiUrl, "/", endpoint]);

    Map<String, dynamic> extraParams = Map();
    extraParams.putIfAbsent(RESTService.data, () {
      return apiCallMethod == RESTService.URI
          ? Uri(scheme: schema, host: host, path: endpoint)
          : buffer.toString();
    });

    extraParams.putIfAbsent(RESTService.API_URL, () {
      return apiUrl;
    });

    extraParams.putIfAbsent(RESTService.EXTRA_FORCE_REFRESH, () {
      return forceRefresh;
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
