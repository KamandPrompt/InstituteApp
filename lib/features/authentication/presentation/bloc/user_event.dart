part of 'user_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class SignUpEvent extends AuthenticationEvent {
  final String name;
  final String email;
  final String? image;
  final String password;

  const SignUpEvent({required this.name, required this.email, required this.password, required this.image});
}

class SendOTPEvent extends AuthenticationEvent {
  final String name;
  final String email;
  final String? image;
  final String password;
  final int otp;

  const SendOTPEvent({required this.name, required this.email, required this.password, required this.image, required this.otp});
}

class SignInEvent extends AuthenticationEvent {
  final String email;
  final String password;

  const SignInEvent({required this.email, required this.password});
}

class PasswordUpdateEvent extends AuthenticationEvent {
  final String email;
  final String newPassword;

  const PasswordUpdateEvent({required this.email, required this.newPassword});
}

class ProfileUpdateEvent extends AuthenticationEvent {
  final String newName;
  final String email;
  final String? newImage;
  final String newPassword;

  const ProfileUpdateEvent({required this.newName, required this.email, required this.newPassword, required this.newImage});
}

class GetUserByEmailEvent extends AuthenticationEvent {
  final String email;

  const GetUserByEmailEvent({required this.email});
}
