class ResponseDto {
  String _status;
  String _message = "";
  int _code;
  List<dynamic> _data;

  List<dynamic> _errors;

  List<dynamic> get errors => _errors;

  String get status => _status;

  String get message => _message;

  int get code => _code;

  List<dynamic> get data => _data;

  ResponseDto(this._status, this._message, this._code, this._data);

  ResponseDto.map(dynamic obj, int statusCode) {
    this._status = obj["status"];
    this._message = obj["message"];
    this._code = statusCode;
    this._data = obj["data"];
    this._errors = obj["errors"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["status"] = _status;
    map["message"] = _message;
    map["code"] = _code;
    map["data"] = _data;
    map["errors"] = _errors;
    return map;
  }
}
