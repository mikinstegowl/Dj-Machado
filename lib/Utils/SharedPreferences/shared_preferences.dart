import 'package:shared_preferences/shared_preferences.dart';

typedef StringList = List<String>;

///Used for SharedPref save and get the value.
class UserPreference {
  static final UserPreference _singleton = UserPreference._internal();

  static SharedPreferences? _prefs;

  UserPreference._internal();

  factory UserPreference() {
    return _singleton;
  }

  static initSharedPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Set the value to the shared preferences.
  /// await UserPreference().setValue(key: SharedPrefKeys.counter.name, value: value + 1);
  static Future setValue({required String key, var value}) async {
    _prefs ??= await SharedPreferences.getInstance();
    switch (value.runtimeType) {
      case String:
        _prefs?.setString(key, value);
        break;
      case int:
        _prefs?.setInt(key, value);
        break;
      case bool:
        _prefs?.setBool(key, value);
        break;
      case double:
        _prefs?.setDouble(key, value);
        break;
      case StringList:
        _prefs?.setStringList(key, value);
        break;
    }
  }

  ///When the application is in use the use this for the faster communication to
  ///shared preferences.
  /// int value = await UserPreference().getValue(key: SharedPrefKeys.counter.name) ?? 0;
  static getValue({required String key}) {
    return _prefs?.get(key);
  }

  static getBool({required String key}) {
    return _prefs?.getBool(key);
  }

  static getInt({required String key}) {
    return _prefs?.getInt(key);
  }

  static getDouble({required String key}) {
    return _prefs?.getDouble(key);
  }

  static getStringList({required String key}) {
    return _prefs?.getStringList(key);
  }

  ///When the variable values are updated from the application is in the background
  ///state or application is not in the use
  ///When notification received when not a single instance of the application available then
  ///use the reloaded shared preferences otherwise the updates values from the
  ///background is not getting correct values.
  /// int value = await UserPreference().getUpdatedValue(key: SharedPrefKeys.counter.name) ?? 0;
  getUpdatedValue({required String key}) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.reload();
    return _prefs?.get(key);
  }

  ///Clear the shared preferences
  static clear() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs?.clear();
  }

  ///Remove the key value pair
  static removeKey({required String key}) async {
    _prefs ??= await SharedPreferences.getInstance();
    if (_prefs?.containsKey(key) == true) {
      _prefs?.remove(key);
    }
  }

  Future<bool> containsKey({required String key}) async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs?.containsKey(key) == true;
  }
}
