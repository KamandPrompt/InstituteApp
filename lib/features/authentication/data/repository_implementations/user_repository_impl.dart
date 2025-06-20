import 'dart:developer';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:vertex/utils/functions.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../data_sources/user_data_sources.dart';

class UserRepositoryImpl implements UserRepository {
  final UhlUsersDB authDatabase;
  UserRepositoryImpl(this.authDatabase);

  @override
  Future<UserEntity?> signInUser(String email, String password) async {
    final user = await authDatabase.getUserByEmailAndPassword(email, password);
    if (user != null) {
      return UserEntity(
          // id: user.id,
          name: user.name,
          email: user.email,
          password: user.password,
          image: user.image);
    } else {
      return null;
    }
  }

  @override
  Future<SendReport?> sendOTP(String name, String email, String password,
      String? image, int otp) async {
    try {
      final config = await loadEncryptedConfig();
      String maintainerEmail = config['LEAD_EMAIL']!;
      String maintainerPassword = config['LEAD_PASSWORD']!;

      final smtpServer = gmail(maintainerEmail, maintainerPassword);

      final message = Message()
        ..from = Address(maintainerEmail, "Vertex Team")
        ..recipients.add(email)
        ..subject = 'OTP for Sign Up on Vertex: IIT Mandi'
        ..text =
            'Dear $name,\nYour OTP for Sign Up on Vertex is $otp.\n\nBest Regards,\nVertex Team\nIIT Mandi, Kamand 175005';

      final sendReport = await send(message, smtpServer);
      return sendReport;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  @override
  Future<UserEntity?> signUpUser(
      String name, String email, String password, String? image) async {
    final user = await authDatabase.createUser(name, email, password, image);
    if (user != null) {
      return UserEntity(
          // id: user.id,
          name: user.name,
          email: user.email,
          password: user.password,
          image: user.image);
    } else {
      return null;
    }
  }

  @override
  Future<bool?> updatePassword(String email, String password) async {
    return await authDatabase.updatePassword(email, password);
  }

  @override
  Future<UserEntity?> getUserByEmail(String email) async {
    final user = await authDatabase.getUserByEmail(email);
    if (user.isNotEmpty) {
      return UserEntity(
          // id: user.first.id,
          name: user.first.name,
          email: user.first.email,
          password: user.first.password,
          image: user.first.image);
    } else {
      return null;
    }
  }

  @override
  Future<UserEntity?> updateProfile(
      String name, String email, String password, String? image) async {
    UserEntity? user =
        await authDatabase.updateProfile(name, email, password, image);
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }
}
