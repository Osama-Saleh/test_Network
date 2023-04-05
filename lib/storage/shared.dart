import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static SharedPreferences? sharedPreference;
  static Future initialSharedPreference() async {
    sharedPreference = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData({required String? Key, required value}) async {
    return await sharedPreference!.setString(Key!, value);
  }

  static String? getDataSt({required String? key}) {
    return sharedPreference?.getString(key!);
  }
}
