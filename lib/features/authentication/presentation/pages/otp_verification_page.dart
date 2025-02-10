import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:uhl_link/config/routes/routes_consts.dart';
import 'package:uhl_link/features/authentication/domain/entities/user_entity.dart';

import '../../../../widgets/screen_width_button.dart';
import '../bloc/user_bloc.dart';

class OtpVerificationPage extends StatefulWidget {
  Map<String, dynamic> user;
  int otp;
  OtpVerificationPage({super.key, required this.user, required this.otp});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  TextEditingController otpTextEditingController = TextEditingController();
  final otpKey = GlobalKey<FormState>();

  StreamController<ErrorAnimationType>? errorController;

  int secondsRemaining = 120;
  bool isResendOtpEnabled = false;
  Timer? resendOtpTimer;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    resendOtpTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          isResendOtpEnabled = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    resendOtpTimer?.cancel();
    otpTextEditingController.dispose();
    otpKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserEntity user = UserEntity.fromJson(widget.user);
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is OTPSending) {
          // Something Something
        } else if (state is OTPSent) {
          Fluttertoast.showToast(
              msg: "OTP sent successfully. Please check your email.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).colorScheme.onSurface);
        } else if (state is OTPSendingError) {
          Fluttertoast.showToast(
              msg:
                  "Something went wrong. Please try again.\nRead the instructions carefully.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).colorScheme.onSurface);
        } else if (state is UserCreating) {
          // Something Something
        } else if (state is UserCreated) {
          GoRouter.of(context).goNamed(UhlLinkRoutesNames.home,
              pathParameters: {
                'isGuest': jsonEncode(false),
                'user': jsonEncode(state.user.toMap())
              });
        } else if (state is UserCreatingError) {
          Fluttertoast.showToast(
              msg:
                  "Something went wrong. Please try again.\nRead the instructions carefully.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).colorScheme.onSurface);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text("OTP Verification",
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
                child: Stack(children: [
                  SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015),
                        Text("",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(fontFamily: 'Montserrat_Regular')),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Form(
                          key: otpKey,
                          child: PinCodeTextField(
                            controller: otpTextEditingController,
                            appContext: context,
                            length: 4,
                            animationType: AnimationType.fade,
                            autovalidateMode: AutovalidateMode.disabled,
                            validator: (v) {
                              if (v!.length != 4) {
                                return "Code is of 4 digits.";
                              } else if (v != widget.otp.toString()) {
                                return "Invalid Code.";
                              }
                              return null;
                            },
                            // errorTextSpace: 30,
                            enablePinAutofill: true,
                            enabled: true,
                            textStyle: Theme.of(context).textTheme.labelSmall,
                            pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.aspectRatio *
                                        40),
                                fieldHeight:
                                    MediaQuery.of(context).size.width * 0.15,
                                fieldWidth:
                                    MediaQuery.of(context).size.width * 0.15,
                                activeColor:
                                    Theme.of(context).colorScheme.scrim,
                                activeFillColor: Theme.of(context).cardColor,
                                selectedColor: Theme.of(context).primaryColor,
                                selectedFillColor: Theme.of(context).cardColor,
                                inactiveColor:
                                    Theme.of(context).colorScheme.scrim,
                                inactiveFillColor: Theme.of(context).cardColor,
                                errorBorderColor:
                                    Theme.of(context).colorScheme.onError),
                            cursorColor: Theme.of(context).primaryColor,
                            animationDuration:
                                const Duration(milliseconds: 300),
                            // enableActiveFill: true,
                            errorAnimationController: errorController,
                            keyboardType: TextInputType.number,
                            autoDisposeControllers: false
                            // beforeTextPaste: (value) {
                            //   return false;
                            // },
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        isResendOtpEnabled
                            ? GestureDetector(
                                onTap: () {
                                  BlocProvider.of<AuthenticationBloc>(context)
                                      .add(SendOTPEvent(
                                          name: user.name,
                                          email: user.email,
                                          password: user.password,
                                          image: user.image,
                                          otp: widget.otp));
                                },
                                child: Text("Resend Code",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                            fontFamily: 'Montserrat_Regular',
                                            color: Theme.of(context)
                                                .primaryColor)),
                              )
                            : RichText(
                                text: TextSpan(
                                    text: "Resend code in ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                            fontFamily: 'Montserrat_Regular'),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "$secondsRemaining ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                                fontFamily:
                                                    'Montserrat_Regular',
                                                color: Theme.of(context)
                                                    .primaryColor),
                                      ),
                                      TextSpan(
                                        text: "sec",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                                fontFamily:
                                                    'Montserrat_Regular'),
                                      ),
                                    ]),
                              ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    child: ScreenWidthButton(
                        text: "Verify OTP",
                        buttonFunc: () async {
                          bool otpValidator = otpKey.currentState!.validate();

                          if (otpValidator) {
                            BlocProvider.of<AuthenticationBloc>(context).add(
                                SignUpEvent(
                                    name: user.name,
                                    email: user.email,
                                    password: user.password,
                                    image: user.image ?? ""));
                          }
                        }),
                  )
                ]))),
      ),
    );
  }
}
