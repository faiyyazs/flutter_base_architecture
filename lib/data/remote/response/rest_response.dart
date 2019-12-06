import 'dart:collection';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:flutter_base_architecture/data/remote/model/response_dto.dart';
import 'package:flutter_base_architecture/exception/base_error.dart';

abstract class RESTResponse<T> {
  static const String API_STATUS_SUCCESS = "success";
  static const String API_STATUS_FAILURE = "failure";

  bool _status = false;

  bool get isSuccess => _status;

  List<BaseError> _errors = List<BaseError>();
  List<T> _data = new List<T>();
  HashMap<String, dynamic> _dataFields = HashMap<String, dynamic>();
  int _apiIdenfier = -1;
  final Response response;

  RESTResponse(this.response) {
    try {
      if (!this.response.extra.containsKey("exception") &&
          this.response.data != null) {
        print(this.response.data);
        _apiIdenfier =
            int.parse(this.response.headers.value("apiCallIdentifier"));
        print("RESTResponse:: Encrypted " + this.response.data);
        parseEncryptedResponse(this.response.data);
      } else {
        print("Exception");
        throw this.response.extra["exception"]
            as BaseError; //Exception(this.response.statusMessage);
      }
    } catch (error) {
      print("Response error>>>>>>>>>>" + error.toString());
      //getErrors().add("Something went wrong. PLease try again");
      getErrors().add(error);
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

      if (_responseDto.code != 200) {
        getErrors().add(BaseError(
            message: _responseDto.errors?.first?.toString(),
            type: BaseErrorType.DEFAULT));
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
