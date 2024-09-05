import 'package:shared_preferences/shared_preferences.dart';
import 'package:united_natives/utils/exception.dart';

class Prefs {
  static const String DARKTHEME = "dark_theme";
  static const String LANGUAGE = "language";
  static const String BEARER = "bearerToken";
  static const String EMAIL = "email";
  static const String PASSWORD = "password";
  static const String USERTYPE = "userType";
  static const String LOGINTYPE = "loginType";
  static const String SOCIALID = "id";
  static const String IsAdmin = "isAdmin";
  static const String FcmToken = "fcmToken";
  static const String SecretPin = "secretPin";
  static const String normalPassword = "normalPassword";
  static const String stateFilter = "stateFilter";
  static const String cityFilter = "cityFilter";
  static const String tempMsg = "tempMsg";
  static const String isLoginFirst = "isLoginFirst";
  static const String profileImage = "profileImage";
  static const String vcStartTime = "vcStartTime";
  static const String vcEndTime = "vcEndTime";
  static const String userType = "userType";

  static SharedPreferences? _prefs;
  static final Map<String, dynamic> _memoryPrefs = <String, dynamic>{};

  static Future<SharedPreferences?> load() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs;
  }

  static Future<void> setString(String key, String value) async {
    try {
      await _prefs?.setString(key, value);
      _memoryPrefs[key] = value;
    } catch (e) {
      AppException.exceptionHandler(e);
    }
  }

  static void setInt(String key, int value) {
    _prefs?.setInt(key, value);
    _memoryPrefs[key] = value;
  }

  static void setDouble(String key, double value) {
    _prefs?.setDouble(key, value);
    _memoryPrefs[key] = value;
  }

  static void setBool(String key, bool value) {
    _prefs?.setBool(key, value);
    _memoryPrefs[key] = value;
  }

  static String? getString(String key, {String? def}) {
    String? val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    val ??= _prefs?.getString(key);
    val ??= def;
    _memoryPrefs[key] = val;
    return val;
  }

  static removeKey(String key) {
    _prefs?.remove(key);
  }

  static int? getInt(String key, {int? def}) {
    int? val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    val ??= _prefs?.getInt(key);
    val ??= def;
    _memoryPrefs[key] = val;
    return val;
  }

  static double? getDouble(String key, {double? def}) {
    double? val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    val ??= _prefs?.getDouble(key);
    val ??= def;
    _memoryPrefs[key] = val;
    return val;
  }

  static bool getBool(String key, {bool def = false}) {
    bool? val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    val ??= _prefs?.getBool(key);
    val ??= def;
    _memoryPrefs[key] = val;
    return val;
  }

  static void clear() {
    _prefs?.clear();
  }

  static void clearFilter() {
    _prefs?.remove(Prefs.stateFilter);
    _prefs?.remove(Prefs.cityFilter);
  }

  static void clearTempMsg() {
    _prefs?.remove(Prefs.tempMsg);
  }

  static bool isDark() {
    return getBool(DARKTHEME, def: false);
  }
}
