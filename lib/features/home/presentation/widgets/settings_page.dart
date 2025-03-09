import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uhl_link/config/routes/routes_consts.dart';
import 'package:uhl_link/features/home/presentation/widgets/card.dart';

import '../../../../utils/theme.dart';

class SettingsPage extends StatefulWidget {
  final Map<String, dynamic>? user;
  const SettingsPage({super.key, this.user});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text("Settings", style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        primary: true,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 1.5,
                  )),
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                height: MediaQuery.of(context).size.aspectRatio * 132,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                    Text("Switch Dark Theme",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 16)),
                    const Expanded(child: SizedBox()),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: context.watch<ThemeBloc>().state.isDark,
                        onChanged: (value) {
                          context.read<ThemeBloc>().add(ToggleTheme());
                        },
                        activeColor: Theme.of(context).colorScheme.onPrimary,
                        activeTrackColor: Theme.of(context).primaryColor,
                        inactiveThumbColor:
                            Theme.of(context).colorScheme.onPrimary,
                        inactiveTrackColor: Theme.of(context)
                            .colorScheme
                            .scrim
                            .withValues(alpha: 0.5),
                        trackOutlineColor:
                            const WidgetStatePropertyAll(Colors.transparent),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                  ],
                ),
              ),
            ),
            if (widget.user != null || widget.user!.isNotEmpty)
              CardWidget(
                  text: "Update Profile",
                  icon: CupertinoIcons.profile_circled,
                  onTap: () {
                    GoRouter.of(context).pushNamed(
                        UhlLinkRoutesNames.updateProfile,
                        pathParameters: {"user": jsonEncode(widget.user)});
                  }),
            CardWidget(
                text: "About Vertex",
                icon: Icons.info_outline_rounded,
                onTap: () {
                  GoRouter.of(context).pushNamed(UhlLinkRoutesNames.aboutPage);
                }),
            CardWidget(
                text: "Sign Out",
                icon: Icons.logout_rounded,
                onTap: () {
                  GoRouter.of(context).pushNamed(UhlLinkRoutesNames.chooseAuth);
                }),
          ],
        ),
      ),
    );
  }
}
