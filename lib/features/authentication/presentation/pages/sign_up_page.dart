import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:vertex/config/routes/routes_consts.dart';

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
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final FocusNode nameFocusNode = FocusNode();

  String? errorEmailValue;
  final GlobalKey<FormState> emailKey = GlobalKey();

  String? errorPasswordValue;
  final GlobalKey<FormState> passwordKey = GlobalKey();

  String? errorNameValue;
  final GlobalKey<FormState> nameKey = GlobalKey();

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    nameFocusNode.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    nameTextEditingController.dispose();
    emailKey.currentState?.dispose();
    passwordKey.currentState?.dispose();
    nameKey.currentState?.dispose();
    super.dispose();
  }

  bool _isEmailValid = false;
  bool sendingMail = false;

  //
  FilePickerResult? picker;

  Future<void> pickImage() async {
    try {
      FilePickerResult? files = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ["jpg", "jpeg", "png", "gif"]);
      setState(() {
        picker = files;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error uploading images.",
              style: Theme.of(context).textTheme.labelSmall),
          backgroundColor: Theme.of(context).cardColor));
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    final aspectRatio = MediaQuery.of(context).size.aspectRatio;
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is OTPSending) {
          setState(() {
            sendingMail = true;
          });
        } else if (state is OTPSent) {
          setState(() {
            sendingMail = false;
          });

          Fluttertoast.showToast(
              msg: "OTP sent successfully. Please check your email.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).colorScheme.onSurface);

          GoRouter.of(context).pushNamed(UhlLinkRoutesNames.otpVerify,
              extra: {
                'user': state.user,
                'otp': state.otp
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
          setState(() {
            sendingMail = false;
          });
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
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await pickImage();
                        },
                        child: Container(
                          width: height * 0.2,
                          height: height * 0.2,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(height * 0.1),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.scrim,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.all(Radius.circular(height * 0.1)),
                                child: (picker == null || picker!.files.isEmpty)
                                    ? Icon(
                                  Icons.image_rounded,
                                  color: Theme.of(context).colorScheme.scrim,
                                  size: aspectRatio * 100,
                                )
                                    : SizedBox(
                                    width: height * 0.2,
                                    height: height * 0.2,
                                    child: Image.file(
                                      File(picker!.files.first.path!),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    )),
                              )),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
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
                        maxLines: 1,
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
                      BlocListener<AuthenticationBloc, AuthenticationState>(
                        listener: (context, state) {
                          if (state is GetUserByEmailInitial) {
                            sendingMail = true;
                          } else if (state is GetUserByEmailLoaded) {
                            sendingMail = false;
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
                                    r"^(?:[a-zA-Z0-9_]+@iitmandi\.ac\.in|[a-zA-Z0-9_]+@students\.iitmandi\.ac\.in)$")
                                .hasMatch(value!);
                            if (!emailPatternValid) {
                              return "Please enter a valid IIT Mandi email address.";
                            } else if (!_isEmailValid) {
                              return "This Email is already registered. Please login.";
                            }
                            return null;
                          },
                          maxLines: 1,
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
                        maxLines: 1,
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
                    // bool imageValidator = imageKey.currentState!.validate();

                    if (nameValidator &&
                        emailValidator &&
                        passwordValidator) {
                      int otp = 1000 + Random().nextInt(9000);

                      BlocProvider.of<AuthenticationBloc>(context).add(
                          SendOTPEvent(
                              name: nameTextEditingController.text,
                              email: emailTextEditingController.text,
                              password: passwordTextEditingController.text,
                              image: picker?.files.first.path,
                              otp: otp));
                    }
                  },
                  // isLoading: sendingMail,
                ),
              ),
              if (sendingMail)
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).cardColor.withAlpha(200),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
            ],
          ),
        ),
      ),
    );
  }
}
