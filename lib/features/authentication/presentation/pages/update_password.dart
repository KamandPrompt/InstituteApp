import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uhl_link/features/authentication/domain/entities/user_entity.dart';

import '../../../../widgets/form_field_widget.dart';
import '../../../../widgets/screen_width_button.dart';
import '../bloc/user_bloc.dart';

class UpdatePasswordPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const UpdatePasswordPage({super.key, required this.user});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  final TextEditingController confirmPasswordTextEditingController =
      TextEditingController();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  String? errorPasswordValue;
  final GlobalKey<FormState> passwordKey = GlobalKey();

  String? errorConfirmPasswordValue;
  final GlobalKey<FormState> confirmPasswordKey = GlobalKey();

  @override
  void dispose() {
    passwordFocusNode.dispose();
    confirmPasswordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserEntity user = UserEntity.fromJson(widget.user);
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is PasswordUpdating) {
        } else if (state is PasswordUpdatedSuccessfully) {
          GoRouter.of(context).pop();
        } else if (state is PasswordUpdateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text("Update Password",
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
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        FormFieldWidget(
                          focusNode: confirmPasswordFocusNode,
                          fieldKey: confirmPasswordKey,
                          controller: confirmPasswordTextEditingController,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter password.";
                            } else if (passwordTextEditingController.text !=
                                value) {
                              return "Invalid Confirm Password.";
                            }
                            return null;
                          },
                          onChanged: (String? value) {},
                          keyboardType: TextInputType.text,
                          errorText: errorConfirmPasswordValue,
                          prefixIcon: Icons.lock_outline_rounded,
                          showSuffixIcon: true,
                          hintText: "Confirm Password",
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
                    text: "Update Password",
                    buttonFunc: () {
                      bool? isPasswordValid =
                          passwordKey.currentState?.validate();
                      bool? isConfirmPasswordValid =
                          confirmPasswordKey.currentState?.validate();

                      if (isConfirmPasswordValid! && isPasswordValid!) {
                        BlocProvider.of<AuthenticationBloc>(context).add(
                            PasswordUpdateEvent(
                                email: user.email,
                                newPassword:
                                    passwordTextEditingController.text));
                      }
                    },
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
