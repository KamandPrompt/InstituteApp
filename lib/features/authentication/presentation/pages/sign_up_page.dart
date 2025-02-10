import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:uhl_link/config/routes/routes_consts.dart';

import '../../../../widgets/form_field_widget.dart';
import '../../../../widgets/screen_width_button.dart';
import '../bloc/user_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  //
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  //
  final TextEditingController imageTextEditingController =
      TextEditingController();
  final FocusNode imageFocusNode = FocusNode();
  //
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final FocusNode nameFocusNode = FocusNode();

  String? errorEmailValue;
  final GlobalKey<FormState> emailKey = GlobalKey();

  String? errorPasswordValue;
  final GlobalKey<FormState> passwordKey = GlobalKey();

  String? errorImageValue;
  final GlobalKey<FormState> imageKey = GlobalKey();

  String? errorNameValue;
  final GlobalKey<FormState> nameKey = GlobalKey();

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    imageFocusNode.dispose();
    nameFocusNode.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    imageTextEditingController.dispose();
    nameTextEditingController.dispose();
    emailKey.currentState?.dispose();
    passwordKey.currentState?.dispose();
    imageKey.currentState?.dispose();
    nameKey.currentState?.dispose();
    super.dispose();
  }

  bool _isEmailValid = false;
  bool userLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is OTPSending) {
          userLoading = true;
        } else if (state is OTPSent) {
          userLoading = false;

          Fluttertoast.showToast(
              msg: "OTP sent successfully. Please check your email.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).colorScheme.onSurface);

          GoRouter.of(context).pushNamed(UhlLinkRoutesNames.otpVerify,
              pathParameters: {
                'user': jsonEncode(state.user.toMap()),
                'otp': jsonEncode(state.otp)
              });
        } else if (state is OTPSendingError) {
          Fluttertoast.showToast(
              msg:
                  "Something went wrong. Please try again.\nRead the instructions carefully.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).colorScheme.onSurface);
          userLoading = false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text("Sign Up",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                SingleChildScrollView(
                  reverse: true,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015),
                        FormFieldWidget(
                          focusNode: nameFocusNode,
                          fieldKey: nameKey,
                          controller: nameTextEditingController,
                          obscureText: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your name.";
                            }
                            return null;
                          },
                          onChanged: (String? value) {},
                          keyboardType: TextInputType.text,
                          errorText: errorNameValue,
                          prefixIcon: Icons.person_rounded,
                          showSuffixIcon: false,
                          hintText: "Name",
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        FormFieldWidget(
                          focusNode: imageFocusNode,
                          fieldKey: imageKey,
                          controller: imageTextEditingController,
                          obscureText: false,
                          validator: (value) {
                            return null;
                          },
                          // onChanged: (String? value) {},
                          keyboardType: TextInputType.text,
                          errorText: errorImageValue,
                          prefixIcon: Icons.image_rounded,
                          showSuffixIcon: false,
                          hintText: "Profile Picture Link",
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        BlocListener<AuthenticationBloc, AuthenticationState>(
                          listener: (context, state) {
                            if (state is GetUserByEmailInitial) {
                              userLoading = true;
                            } else if (state is GetUserByEmailLoaded) {
                              userLoading = false;
                              if (state.user == null) {
                                _isEmailValid = true;
                              } else {
                                _isEmailValid = false;
                              }
                            } else if (state is GetUserByEmailError) {
                              _isEmailValid = false;
                              errorEmailValue = state.message;
                              Fluttertoast.showToast(
                                  msg:
                                      "Error in processing entered email and password.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Theme.of(context).cardColor,
                                  textColor:
                                      Theme.of(context).colorScheme.onSurface);
                            }
                          },
                          child: FormFieldWidget(
                            focusNode: emailFocusNode,
                            fieldKey: emailKey,
                            controller: emailTextEditingController,
                            obscureText: false,
                            validator: (value) {
                              final bool emailPatternValid = RegExp(
                                      r"^(?:[a-zA-Z0-9]+@iitmandi\.ac\.in|[a-zA-Z0-9]+@students\.iitmandi\.ac\.in)$")
                                  .hasMatch(value!);
                              if (!emailPatternValid) {
                                return "Please enter a valid IIT Mandi email address.";
                              } else if (!_isEmailValid) {
                                return "This Email is already registered. Please login.";
                              }
                              return null;
                            },
                            onChanged: (String? value) {
                              BlocProvider.of<AuthenticationBloc>(context)
                                  .add(GetUserByEmailEvent(email: value ?? ""));
                            },
                            keyboardType: TextInputType.text,
                            errorText: errorEmailValue,
                            prefixIcon: Icons.email_rounded,
                            showSuffixIcon: false,
                            hintText: "IIT Mandi Email",
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        FormFieldWidget(
                          focusNode: passwordFocusNode,
                          fieldKey: passwordKey,
                          controller: passwordTextEditingController,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter password.";
                            }
                            return null;
                          },
                          onChanged: (String? value) {},
                          keyboardType: TextInputType.text,
                          errorText: errorPasswordValue,
                          prefixIcon: Icons.lock_outline_rounded,
                          showSuffixIcon: true,
                          hintText: "Password",
                          textInputAction: TextInputAction.done,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Text.rich(TextSpan(children: [
                          TextSpan(
                              text: '* ',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                      color: Theme.of(context).primaryColor)),
                          TextSpan(
                              text:
                                  "This will be your new password and updating the password can be done via some logged in device only.",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(fontFamily: 'Montserrat_Regular'))
                        ])),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1),
                      ]),
                ),
                Positioned(
                  bottom: 20,
                  child: ScreenWidthButton(
                    text: "Sign Up",
                    buttonFunc: () async {
                      bool nameValidator = nameKey.currentState!.validate();
                      bool emailValidator = emailKey.currentState!.validate();
                      bool passwordValidator =
                          passwordKey.currentState!.validate();
                      bool imageValidator = imageKey.currentState!.validate();

                      if (nameValidator &&
                          emailValidator &&
                          passwordValidator &&
                          imageValidator) {
                        int otp = 1000 + Random().nextInt(9000);

                        BlocProvider.of<AuthenticationBloc>(context).add(
                            SendOTPEvent(
                                name: nameTextEditingController.text,
                                email: emailTextEditingController.text,
                                password: passwordTextEditingController.text,
                                image: imageTextEditingController.text,
                                otp: otp));
                      }
                    },
                    isLoading: userLoading,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
