import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final SharedPreferences prefs;

  SessionManager._(this.prefs);

  static SessionManager _instance;

  static Future<SessionManager> getInstance() async {
    if (_instance == null) {
      _instance = SessionManager._(await SharedPreferences.getInstance());
    }
    return _instance;
  }

  /// Reads a value from persistent storage, throwing an exception if it's not a
  /// bool.
  bool getBool(String key) => _preferenceCache('Bool', key);

  /// Reads a value from persistent storage, throwing an exception if it's not
  /// an int.
  int getInt(String key) => _preferenceCache('Int', key);

  /// Reads a value from persistent storage, throwing an exception if it's not a
  /// double.
  double getDouble(String key) => _preferenceCache('Double', key);

  /// Reads a value from persistent storage, throwing an exception if it's not a
  /// String.
  String getString(String key) => _preferenceCache('String', key);

  /// Returns true if persistent storage the contains the given [key].
  //bool containsKey(String key) => _preferenceCache.containsKey(key);
  /// Reads a set of string values from persistent storage, throwing an
  /// exception if it's not a string set.
  List<String> getStringList(String key) => _preferenceCache('StringList', key);

  _preferenceCache(String valueType, String key) {
    switch (valueType) {
      case 'Bool':
        return prefs.containsKey(key) ? prefs.getBool(key) : false;

      case 'Int':
        return prefs.containsKey(key) ? prefs.getInt(key) : -1;

      case 'Double':
        return prefs.containsKey(key) ? prefs.getDouble(key) : -1;

      case 'String':
        return prefs.containsKey(key) ? prefs.getString(key) : null;

      case 'StringList':
        return prefs.containsKey(key) ? prefs.getStringList(key) : null;

      default:
        return false;
    }
  }

  /// Saves a boolean [value] to persistent storage in the background.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setBool(String key, bool value) => _setValue('Bool', key, value);

  /// Saves an integer [value] to persistent storage in the background.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setInt(String key, int value) => _setValue('Int', key, value);

  /// Saves a double [value] to persistent storage in the background.
  ///
  /// Android doesn't support storing doubles, so it will be stored as a float.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setDouble(String key, double value) =>
      _setValue('Double', key, value);

  /// Saves a string [value] to persistent storage in the background.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setString(String key, String value) =>
      _setValue('String', key, value);

  /// Saves a list of strings [value] to persistent storage in the background.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setStringList(String key, List<String> value) =>
      _setValue('StringList', key, value);

  /// Removes an entry from persistent storage.
  Future<bool> remove(String key) => _setValue('remove', key, null);

  Future<bool> _setValue(String valueType, String key, Object value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    switch (valueType) {
      case 'Bool':
        return prefs.setBool(key, value);

      case 'Int':
        return prefs.setInt(key, value);

      case 'Double':
        return prefs.setDouble(key, value);

      case 'String':
        return prefs.setString(key, value);

      case 'StringList':
        return prefs.setStringList(key, value);

      case 'remove':
        return prefs.remove(key);

      default:
        return false;
    }
  }
}
