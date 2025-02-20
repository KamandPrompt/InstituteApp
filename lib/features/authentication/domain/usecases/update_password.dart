import '../repositories/user_repository.dart';

class UpdatePassword {
  final UserRepository repository;

  UpdatePassword(this.repository);

  Future<bool?> execute(String email, String password) {
    return repository.updatePassword(email, password);
  }
}
