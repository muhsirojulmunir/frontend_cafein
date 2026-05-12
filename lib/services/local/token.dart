import 'package:shared_preferences/shared_preferences.dart';

class Token {
  static String keyToken = 'token';
  static String keyUserId = 'user_id';
  static String keyUserLevel = 'level';
  static String keyUsername = 'username';
  static String keyEmail = 'email';
  static String keyFullname = 'fullname';
  static String keySavedUsername = 'saved_username';

  static Future<void> saveSession({
    required String token,
    required String userId,
    required int level,
    String? username,
    String? email,
    String? fullname,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(keyToken, token);
    await sharedPreferences.setString(keyUserId, userId);
    await sharedPreferences.setInt(keyUserLevel, level);
    if (username != null) {
      await sharedPreferences.setString(keyUsername, username);
    }
    if (email != null) {
      await sharedPreferences.setString(keyEmail, email);
    }
    if (fullname != null) {
      await sharedPreferences.setString(keyFullname, fullname);
    }
  }

  static Future<String?> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(keyToken);
  }

  static Future<String?> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(keyUserId);
  }

  static Future<int?> getUserLevel() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(keyUserLevel);
  }

  static Future<String?> getUsername() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(keyUsername);
  }

  static Future<String?> getEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(keyEmail);
  }

  static Future<String?> getFullname() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(keyFullname);
  }

  static Future<void> clearSession() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(keyToken);
    await sharedPreferences.remove(keyUserId);
    await sharedPreferences.remove(keyUserLevel);
    await sharedPreferences.remove(keyUsername);
    await sharedPreferences.remove(keyEmail);
    await sharedPreferences.remove(keyFullname);
  }

  static Future<void> saveSavedUsername(String username) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(keySavedUsername, username);
  }

  static Future<String?> getSavedUsername() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(keySavedUsername);
  }

  static Future<void> removeSavedUsername() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(keySavedUsername);
  }

  // Keep old methods for compatibility if needed elsewhere
  static Future<void> saveToken({required String token}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(keyToken, token);
  }

  static Future<void> removeToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(keyToken);
  }
}
