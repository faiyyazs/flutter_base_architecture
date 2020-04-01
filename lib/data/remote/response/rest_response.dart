import 'dart:collection';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:flutter_base_architecture/data/remote/model/response_dto.dart';
import 'package:flutter_base_architecture/exception/base_error.dart';

abstract class RESTResponse<T> {
  static const String API_STATUS_SUCCESS = "success";
  static const String API_STATUS_FAILURE = "failure";

  bool _status = false;
  String _message = "";

  String get message => _message;

  bool get isSuccess => _status;

  List<BaseError> _errors = List<BaseError>();
  List<T> _data = new List<T>();
  HashMap<String, dynamic> _dataFields = HashMap<String, dynamic>();
  int _apiIdenfier = -1;

  int get apiIdenfier => _apiIdenfier;

  set apiIdenfier(int value) {
    _apiIdenfier = value;
  }

  final Response response;

  RESTResponse(this.response) {
    try {
      if (this.response?.data != null) {
        print(this.response.data.toString());
        _apiIdenfier = response?.extra["apiCallIdentifier"];
        print("_apiIdenfier" + _apiIdenfier?.toString());
        print("cached: " + response?.extra["cached"]?.toString());
        print("RESTResponse:: Encrypted " + this.response.data.toString());
        parseEncryptedResponse(this.response.data);
      } else if (this.response.extra.containsKey("exception")) {
        print("Exception");
        throw this.response.extra["exception"]
            as BaseError; //Exception(this.response.statusMessage);
      }
    } catch (error) {
      print("Response error>>>>>>>>>>" + error.toString());
      getErrors().add(BaseError(
          error: error,
          message: error.toString(),
          type: BaseErrorType.UNEXPECTED));
    }
  }

  int getStatus() {
    return response.statusCode;
  }

  List<BaseError> getErrors() {
    return _errors;
  }

  bool hasErrors() {
    return _errors.length != 0;
  }

  setErrors(List<BaseError> errors) {
    this._errors = errors;
  }

  List<T> getData() {
    return _data;
  }

  HashMap<String, dynamic> getDataFields() {
    return _dataFields;
  }

  String getErrorString() {
    return _errors?.first?.toString();
  }

  parseResponse(Map<String, dynamic> response) {
    Map<String, dynamic> responseObject = response;
    print("RESTResponse:: Decrypted: " + response.toString());
    try {
      ResponseDto _responseDto =
          ResponseDto.map(responseObject, this.response.statusCode);

      _status = _responseDto.status.toLowerCase() == API_STATUS_SUCCESS
          ? true
          : false;

      _message = _responseDto.message.toString();

      if (_responseDto.code != 200) {
        getErrors().add(BaseError(
            message: _responseDto.errors?.first.toString(),
            type: BaseErrorType.SERVER_MESSAGE));
        return;
      }
      print("RESTResponse: " + _responseDto.data.toString());
      parseResponseData(_responseDto.data, this._apiIdenfier);
    } catch (error) {
      getErrors().add(error);
      print("RESTResponse:: Error" + error.toString());
    }
  }

  parseEncryptedResponse(dynamic encryptedResponse) {
    parseResponse(encryptedResponse);
  }

  parseResponseData(List<dynamic> dataArray, int apiIdentifier);
}
