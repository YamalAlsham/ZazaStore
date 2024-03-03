import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CacheHelper
{
  static SharedPreferences? sharedPreferences;

  static init() async
  {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putBoolean({
    required String key,
    required bool value,
  }) async
  {
    return await sharedPreferences!.setBool(key, value);
  }

  static dynamic getData({
    required String key,
  }) {
    return sharedPreferences!.get(key);
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);
    if (value is bool) return await sharedPreferences!.setBool(key, value);

    return await sharedPreferences!.setDouble(key, value);
  }

  static Future<bool> signOut({
    required String key,
  })async
  {
    return await sharedPreferences!.remove(key);
  }

  static Future<bool> clearShared()async
  {
    return await sharedPreferences!.clear();
  }
}

////////////////////////////////////////////////////////////////////////////////

class SecureStorage {

  static FlutterSecureStorage? storage;

  static initStorage()
  {
    storage = const FlutterSecureStorage();
  }

  static Future<void>writeSecureData({required String key, required dynamic value}) async {
    await storage!.write(key: key, value: value.toString());
  }

  static dynamic readSecureData({required String key}) async {
    String value = await storage!.read(key: key) ?? 'No data found!';
    print('Data read from secure storage: $value');
    return value;
  }

  static Future<void>deleteSecureData({required String key}) async {
    await storage!.delete(key: key);
  }

  static Future<void>deleteAllSecureData() async {
    await storage!.deleteAll();
  }
}