
import 'package:hive_flutter/hive_flutter.dart';
import 'package:niffer_store/data/models/user_model.dart';

class AuthLocalDataSource {
  static const String _userBoxKey = 'user_data';
  static const String _currentUserKey = 'current_user';

  Future<void> cacheUser(UserModel user) async {
    final box = await Hive.openBox(_userBoxKey);
    await box.put(_currentUserKey, user.toJson());
  }

  Future<UserModel?> getCachedUser() async {
    final box = await Hive.openBox(_userBoxKey);
    final userData = box.get(_currentUserKey);
    if (userData != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(userData));
    }
    return null;
  }

  Future<void> clearCache() async {
    final box = await Hive.openBox(_userBoxKey);
    await box.clear();
  }
}