import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final FlutterSecureStorage storage = FlutterSecureStorage();

  static Future<void> save({required String key, required String data}) async {
    await storage.write(key: key, value: data);
  }

  static Future<String?> read({required String key}) async {
    return await storage.read(key: key);
  }

  static Future<void> delete({required String key}) async {
    await storage.delete(key: key);
  }

  static Future<void> deleteAll() async {
    await storage.deleteAll();
  }
}
