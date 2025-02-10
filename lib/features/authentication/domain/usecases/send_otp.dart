import 'package:mailer/mailer.dart';
import '../repositories/user_repository.dart';

class SendOTP {
  final UserRepository repository;

  SendOTP(this.repository);

  Future<SendReport?> execute(String name, String email, String password, String? image, int otp) {
    return repository.sendOTP(name, email, password, image, otp);
  }
}
