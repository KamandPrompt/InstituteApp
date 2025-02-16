import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bcrypt/bcrypt.dart';

const FlutterSecureStorage _storage = FlutterSecureStorage();
const String passwordKey = "secure_user_password";

// 🔒 Hash and store password securely
Future<void> savePassword(String password) async {
  String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
  await _storage.write(key: passwordKey, value: hashedPassword);
}

// 🔍 Validate entered password against stored hash
Future<bool> validatePassword(String enteredPassword) async {
  String? storedHash = await _storage.read(key: passwordKey);
  if (storedHash == null) return false;
  return BCrypt.checkpw(enteredPassword, storedHash);
}



