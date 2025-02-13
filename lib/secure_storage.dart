import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypt/crypt.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Hash password before saving
  String hashPassword(String password) {
    return Crypt.sha256(password, salt: 'random_salt').toString();
  }

  // Save password securely
  Future<void> savePassword(String password) async {
    String hashedPassword = hashPassword(password);
    await _storage.write(key: 'password', value: hashedPassword);
  }

  // Retrieve password
  Future<String?> getPassword() async {
    return await _storage.read(key: 'password');
  }

  // Delete password
  Future<void> deletePassword() async {
    await _storage.delete(key: 'password');
  }
}



