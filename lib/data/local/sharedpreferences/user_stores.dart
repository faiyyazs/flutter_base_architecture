import 'dart:convert';

import 'package:flutter_base_architecture/constants/session_manager_const.dart';
import 'package:flutter_base_architecture/dto/user_dto.dart';
import 'package:flutter_base_architecture/utils/session_manager.dart';

class UserStore {
  UserStore._();

  static UserStore _instance;

  static UserStore getInstance() {
    if (_instance == null) {
      _instance = UserStore._();
    }
    return _instance;
  }

  Future<bool> setUser(UserDto userDto) async {
    var preference = await SessionManager.getInstance();
    return preference.setString(const_user, json.encode(userDto.toMap()));
  }

  Future<bool> userIsLoggedIn() async {
    var preference = await SessionManager.getInstance();
    return ((preference.getString(const_user) != null) ? true : false);
  }

  Future<UserDto> getLoggedInUser() async {
    var preference = await SessionManager.getInstance();
    return preference.getString(const_user) != null
        ? UserDto.map(json.decode(preference.getString(const_user)))
        : null;
  }
}
