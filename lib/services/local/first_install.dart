import 'package:shared_preferences/shared_preferences.dart';

class FirstInstall {
  static String keyFirstIntall = 'firstInstall';

  static void setFirstInstall({required bool firstInstall}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(keyFirstIntall, firstInstall);
  }

  static Future<bool?> getFirstInstall() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? firstInstall = sharedPreferences.getBool(keyFirstIntall);
    return firstInstall;
  }
}
