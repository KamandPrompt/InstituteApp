import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:uhl_link/config/routes/routes_consts.dart';
import 'package:uhl_link/features/authentication/domain/entities/user_entity.dart';
import 'package:uhl_link/utils/password_functions.dart';

import '../../../../widgets/form_field_widget.dart';
import '../../../../widgets/screen_width_button.dart';
import '../bloc/user_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();

  String? errorEmailValue;
  final GlobalKey<FormState> emailKey = GlobalKey();

  String? errorPasswordValue;
  final GlobalKey<FormState> passwordKey = GlobalKey();

  bool _isPasswordValid = false;
  bool _isEmailValid = false;

  bool userLoading = false;
  UserEntity? currentUser;

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is UserLoading) {
          userLoading = true;
        } else if (state is UserLoaded) {
          userLoading = false;
          GoRouter.of(context).goNamed(UhlLinkRoutesNames.home,
              pathParameters: {
                'isGuest': jsonEncode(false),
                'user': jsonEncode(state.user.toMap())
              });
        } else if (state is UserError) {
          Fluttertoast.showToast(
              msg: state.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).colorScheme.onSurface);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text("Log In",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: true,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
    alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                reverse: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // SizedBox(
                      //     height: MediaQuery.of(context).size.height * 0.1),
                      // Image.asset(
                      //   "assets/images/logo.png",
                      //   width: MediaQuery.of(context).size.aspectRatio * 400,
                      // ),
                      // SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                      // Text("Vertex\nIIT Mandi",
                      //     style: Theme.of(context).textTheme.titleLarge),
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * 0.12,
                      // ),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width - 40,
                      //   child: Text("Login to your Account",
                      //       maxLines: 2,
                      //       style: Theme.of(context).textTheme.titleMedium),
                      // ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015),
                      BlocListener<AuthenticationBloc, AuthenticationState>(
                        listener: (context, state) {
                          if (state is GetUserByEmailInitial) {
                            userLoading = true;
                          } else if (state is GetUserByEmailLoaded) {
                            userLoading = false;
                            if (state.user != null) {
                              _isEmailValid = true;
                              currentUser = state.user;
                            } else {
                              _isEmailValid = false;
                              currentUser = null;
                            }
                          } else if (state is GetUserByEmailError) {
                            errorEmailValue = state.message;
                            Fluttertoast.showToast(
                                msg:
                                    "Error in loading your email and password.",
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
                              return "Invalid IIT Mandi email address.";
                            }
                            return null;
                          },
                          onChanged: (String? value) async {
                            BlocProvider.of<AuthenticationBloc>(context)
                                .add(GetUserByEmailEvent(email: value ?? ""));
                          },
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          errorText: errorEmailValue,
                          prefixIcon: Icons.mail_rounded,
                          showSuffixIcon: false,
                          hintText: "Email",
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      FormFieldWidget(
                        focusNode: passwordFocusNode,
                        maxLines: 1,
                        fieldKey: passwordKey,
                        controller: passwordTextEditingController,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter password.";
                          } else if (!_isPasswordValid) {
                            return "Password or Email is incorrect.";
                          }
                          return null;
                        },
                        onChanged: (String? value) async {
                          if (currentUser != null) {
                            if (validatePassword(
                                value ?? "", currentUser!.password)) {
                              _isPasswordValid = true;
                            } else {
                              _isPasswordValid = false;
                            }
                          } else {
                            _isPasswordValid = false;
                          }
                          setState(() {
                            _isPasswordValid;
                          });
                          // log(_isPasswordValid.toString());
                        },
                        keyboardType: TextInputType.text,
                        errorText: errorPasswordValue,
                        prefixIcon: Icons.lock_outline_rounded,
                        showSuffixIcon: true,
                        hintText: "Password",
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                    ]),
              ),
              Positioned(
                bottom: 20,
                child: ScreenWidthButton(
                  text: "Sign in",
                  buttonFunc: () {
                    final bool isValidEmail = emailKey.currentState!.validate();
                    final bool isValidPassword =
                        passwordKey.currentState!.validate();

                    if (isValidEmail && isValidPassword) {
                      BlocProvider.of<AuthenticationBloc>(context).add(
                          SignInEvent(
                              email: emailTextEditingController.text,
                              password: passwordTextEditingController.text));
                    }
                  },
                  isLoading: userLoading,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
