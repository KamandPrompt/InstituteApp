import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uhl_link/config/routes/routes_consts.dart';
import '../../../../widgets/screen_width_button.dart';

class ChooseAuthPage extends StatefulWidget {
  const ChooseAuthPage({super.key});

  @override
  State<ChooseAuthPage> createState() => _ChooseAuthPageState();
}

class _ChooseAuthPageState extends State<ChooseAuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Image.asset(
                "assets/images/logo.png",
                width: MediaQuery.of(context).size.aspectRatio * 400,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Text("Vertex", style: Theme.of(context).textTheme.titleLarge!.copyWith(letterSpacing: 2.5)),
              Text("IIT Mandi", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium!.copyWith(letterSpacing: 1.5)),
              const Expanded(child: SizedBox()),
              ScreenWidthButton(
                text: "Sign Up via IIT Mandi E-Mail",
                buttonFunc: () {
                  GoRouter.of(context).pushNamed(UhlLinkRoutesNames.signup);
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              // Text("Or", style: Theme.of(context).textTheme.labelSmall),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              ScreenWidthButton(
                text: "Login via IIT Mandi E-Mail",
                buttonFunc: () {
                  GoRouter.of(context).pushNamed(UhlLinkRoutesNames.login);
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              // Text("Or", style: Theme.of(context).textTheme.labelSmall),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              ScreenWidthButton(
                text: "Continue as a Guest",
                buttonFunc: () {
                  GoRouter.of(context).goNamed(UhlLinkRoutesNames.home,
                      pathParameters: {
                        'isGuest': jsonEncode(true),
                        'user': jsonEncode(null)
                      });
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            ]),
      ),
    );
  }
}
