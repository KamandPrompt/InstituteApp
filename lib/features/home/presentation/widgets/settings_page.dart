import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:vertex/config/routes/routes_consts.dart';
import 'package:vertex/features/authentication/domain/entities/user_entity.dart';
import 'package:vertex/features/home/presentation/widgets/card.dart';

import '../../../../utils/theme.dart';

class SettingsPage extends StatefulWidget {
  final UserEntity? user;
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(100),
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
                        inactiveTrackColor: Theme.of(context).colorScheme.scrim,
                        trackOutlineColor:
                            const WidgetStatePropertyAll(Colors.transparent),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                  ],
                ),
              ),
            ),
            if (widget.user != null)
              CardWidget(
                  text: "Update Profile",
                  icon: CupertinoIcons.profile_circled,
                  onTap: () {
                    GoRouter.of(context).pushNamed(
                        UhlLinkRoutesNames.updateProfile,
                        extra: {"user": widget.user});
                  }),
            CardWidget(
                text: "About Vertex",
                icon: Icons.info_outline_rounded,
                onTap: () {
                  GoRouter.of(context).pushNamed(UhlLinkRoutesNames.aboutPage);
                }),
            if (widget.user != null)
              CardWidget(
                  text: "Sign Out",
                  icon: Icons.logout_rounded,
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Sign Out",
                              style: Theme.of(context).textTheme.bodyMedium),
                          content: Text(
                              "Are you sure you want to sign out of Vertex?",
                              style: Theme.of(context).textTheme.labelSmall),
                          backgroundColor: Theme.of(context).cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          actionsPadding:
                              const EdgeInsets.only(right: 10, bottom: 10),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("Cancel",
                                  style:
                                      Theme.of(context).textTheme.labelSmall),
                            ),
                            TextButton(
                              onPressed: () async {
                                final storage = const FlutterSecureStorage();
                                await storage.delete(key: "user");
                                GoRouter.of(context)
                                    .goNamed(UhlLinkRoutesNames.chooseAuth);
                              },
                              child: Text("Sign Out",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onError,
                                        fontWeight: FontWeight.w700,
                                      )),
                            ),
                          ],
                        );
                      },
                    );
                  }),
          ],
        ),
      ),
    );
  }
}
