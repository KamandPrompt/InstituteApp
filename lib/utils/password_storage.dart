import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bcrypt/bcrypt.dart';

class PasswordService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String passwordKey = "secure_user_password"; // Storage key

  // 🔒 Hash and store password securely
  Future<void> savePassword(String password) async {
    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt()); // Hash password
    await _storage.write(key: passwordKey, value: hashedPassword); // Store in secure storage
  }

  // 🔍 Validate entered password against stored hash
  Future<bool> validatePassword(String enteredPassword) async {
    String? storedHash = await _storage.read(key: passwordKey); // Get stored hash
    if (storedHash == null) return false; // If no password is stored, deny access
    return BCrypt.checkpw(enteredPassword, storedHash); // Compare passwords
  }
}
