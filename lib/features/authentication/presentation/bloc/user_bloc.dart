import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mailer/mailer.dart';
import 'package:vertex/features/authentication/domain/entities/user_entity.dart';
import 'package:vertex/features/authentication/domain/usecases/send_otp.dart';
import 'package:vertex/features/authentication/domain/usecases/signin_user.dart';
import 'package:vertex/features/authentication/domain/usecases/update_password.dart';
import 'package:vertex/features/authentication/domain/usecases/update_profile.dart';

import '../../domain/usecases/get_user_by_email.dart';
import '../../domain/usecases/signup_user.dart';

part 'user_event.dart';
part 'user_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SignInUser loginUser;
  final SignUpUser signUpUser;
  final SendOTP sendOTP;
  final UpdatePassword updatePassword;
  final GetUserByEmail getUserByEmail;
  final UpdateProfile updateProfile;

  AuthenticationBloc(
      {required this.getUserByEmail,
      required this.loginUser,
      required this.signUpUser,
      required this.sendOTP,
      required this.updatePassword,
      required this.updateProfile})
      : super(AuthenticationInitial()) {
    on<SignInEvent>(onSignInEvent);
    on<SignUpEvent>(onSignUpEvent);
    on<SendOTPEvent>(onSendOTPEvent);
    on<PasswordUpdateEvent>(onPasswordUpdateEvent);
    on<GetUserByEmailEvent>(onGetUserByEmailEvent);
    on<ProfileUpdateEvent>(onProfileUpdateEvent);
  }

  void onSignUpEvent(
      SignUpEvent event, Emitter<AuthenticationState> emit) async {
    emit(UserCreating());
    try {
      final user = await signUpUser.execute(
          event.name, event.email, event.password, event.image);
      if (user != null) {
        const flutterSecureStorage = FlutterSecureStorage();
        flutterSecureStorage.write(
            key: 'user', value: jsonEncode(user.toMap()));
        emit(UserCreated(user: user));
      } else {
        emit(const UserCreatingError(message: "Login Failed"));
      }
    } catch (e) {
      emit(UserCreatingError(message: "Error during login : $e"));
    }
  }

  void onSendOTPEvent(
      SendOTPEvent event, Emitter<AuthenticationState> emit) async {
    emit(OTPSending());
    try {
      SendReport? otp = await sendOTP.execute(
          event.name, event.email, event.password, event.image, event.otp);
      if (otp != null) {
        final user = {
          'name': event.name,
          'email': event.email,
          'password': event.password,
          'image': event.image ?? ''
        };
        emit(OTPSent(user: UserEntity.fromJson(user), otp: event.otp));
      } else {
        emit(const OTPSendingError(message: "Error during otp sending."));
      }
    } on MailerException catch (e) {
      emit(OTPSendingError(message: "Error during sending otp : $e"));
    }
  }

  void onSignInEvent(
      SignInEvent event, Emitter<AuthenticationState> emit) async {
    emit(UserLoading());
    try {
      final user = await loginUser.execute(event.email, event.password);
      if (user != null) {
        const flutterSecureStorage = FlutterSecureStorage();
        flutterSecureStorage.write(
            key: 'user', value: jsonEncode(user.toMap()));
        emit(UserLoaded(user: user));
      } else {
        emit(const UserError(message: "Login Failed"));
      }
    } catch (e) {
      emit(UserError(message: "Error during login : $e"));
    }
  }

  Future<bool> _updatePassword(String id, String newPassword) async {
    bool? isSuccess = await updatePassword.execute(id, newPassword);
    if (isSuccess == true) {
      return true;
    } else {
      return false;
    }
  }

  void onPasswordUpdateEvent(
      PasswordUpdateEvent event, Emitter<AuthenticationState> emit) async {
    emit(PasswordUpdating());
    try {
      bool isPasswordUpdated =
          await _updatePassword(event.email, event.newPassword);
      if (isPasswordUpdated) {
        const flutterSecureStorage = FlutterSecureStorage();
        var currentUser = await flutterSecureStorage.read(key: 'user');
        Map<String, dynamic> currentUserMap = jsonDecode(currentUser!);
        currentUserMap['password'] = event.newPassword;
        flutterSecureStorage.write(
            key: 'user', value: jsonEncode(currentUserMap));
        emit(PasswordUpdatedSuccessfully(
            user: UserEntity.fromJson(currentUserMap)));
      } else {
        emit(const PasswordUpdateError(
            message: "Password is not updated. Please try again."));
      }
    } catch (e) {
      emit(PasswordUpdateError(message: "Error during password update : $e"));
    }
  }

  void onGetUserByEmailEvent(
      GetUserByEmailEvent event, Emitter<AuthenticationState> emit) async {
    emit(GetUserByEmailInitial());
    try {
      final user = await getUserByEmail.execute(event.email);
      emit(GetUserByEmailLoaded(user: user));
    } catch (e) {
      emit(GetUserByEmailError(message: "Error during fetching email : $e"));
    }
  }

  void onProfileUpdateEvent(
      ProfileUpdateEvent event, Emitter<AuthenticationState> emit) async {
    emit(ProfileUpdating());
    try {
      final user = await updateProfile.execute(
          event.newName, event.email, event.newPassword, event.newImage);
      if (user != null) {
        const flutterSecureStorage = FlutterSecureStorage();
        flutterSecureStorage.write(
            key: 'user', value: jsonEncode(user.toMap()));
        emit(ProfileUpdatedSuccessfully(user: user));
      } else {
        emit(const ProfileUpdateError(message: "Login Failed"));
      }
    } catch (e) {
      emit(ProfileUpdateError(message: "Error during login : $e"));
    }
  }
}
