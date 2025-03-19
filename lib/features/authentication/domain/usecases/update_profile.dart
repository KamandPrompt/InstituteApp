import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class UpdateProfile {
  final UserRepository repository;

  UpdateProfile(this.repository);

  Future<UserEntity?> execute(String name, String email, String password, String? image) {
    return repository.updateProfile(name, email, password, image);
  }
}
