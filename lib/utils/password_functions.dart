import 'package:bcrypt/bcrypt.dart';


void main () {
  print(hashPassword('223'));
  print(validatePassword('123', hashPassword('123')));
}

String hashPassword(String password) {
  String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
  return hashedPassword;
}

bool validatePassword(String enteredPassword, String hashedPassword) {
  return BCrypt.checkpw(enteredPassword, hashedPassword);
}
