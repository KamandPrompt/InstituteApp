import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class SignUpUser {
  final UserRepository repository;

  SignUpUser(this.repository);

  Future<UserEntity?> execute(String name, String email, String password, String? image) {
    return repository.signUpUser(name, email, password, image);
  }
}
