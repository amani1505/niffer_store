import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static late SharedPreferences _prefs;
  static late Box _secureBox;

  // Keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _secureBox = await Hive.openBox('secure_storage');
  }

  // Token management
  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _secureBox.put(_accessTokenKey, accessToken);
    await _secureBox.put(_refreshTokenKey, refreshToken);
  }

  static Future<String?> getAccessToken() async {
    return _secureBox.get(_accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    return _secureBox.get(_refreshTokenKey);
  }

  static Future<void> clearTokens() async {
    await _secureBox.delete(_accessTokenKey);
    await _secureBox.delete(_refreshTokenKey);
    await _secureBox.delete(_userIdKey);
  }

  // User data
  static Future<void> saveUserId(String userId) async {
    await _secureBox.put(_userIdKey, userId);
  }

  static Future<String?> getUserId() async {
    return _secureBox.get(_userIdKey);
  }

  // App preferences
  static Future<void> saveThemeMode(String themeMode) async {
    await _prefs.setString(_themeKey, themeMode);
  }

  static String? getThemeMode() {
    return _prefs.getString(_themeKey);
  }

  static Future<void> saveLanguage(String languageCode) async {
    await _prefs.setString(_languageKey, languageCode);
  }

  static String? getLanguage() {
    return _prefs.getString(_languageKey);
  }

  // Generic methods
  static Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  static Future<void> saveInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  static Future<void> saveDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  static Future<void> saveStringList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  static Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  static Future<void> clear() async {
    await _prefs.clear();
    await _secureBox.clear();
  }

  static bool containsKey(String key) {
    return _prefs.containsKey(key) || _secureBox.containsKey(key);
  }

  // Secure storage methods
  static Future<void> saveSecure(String key, dynamic value) async {
    await _secureBox.put(key, value);
  }

  static dynamic getSecure(String key) {
    return _secureBox.get(key);
  }

  static Future<void> removeSecure(String key) async {
    await _secureBox.delete(key);
  }

  static Future<void> clearSecure() async {
    await _secureBox.clear();
  }
}