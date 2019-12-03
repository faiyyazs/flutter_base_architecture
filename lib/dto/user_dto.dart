class UserDto {
  String name;
  num _id;

  UserDto(this._id,
      {this.name});

  UserDto.map(dynamic obj) {
    this.name = obj["name"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = name;
    return map;
  }
}
