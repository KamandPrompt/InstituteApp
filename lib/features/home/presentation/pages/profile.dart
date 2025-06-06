import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:vertex/config/routes/routes_consts.dart';
import '../widgets/card.dart';

class Profile extends StatefulWidget {
  final bool isGuest;
  final Map<String, dynamic>? user;
  const Profile({super.key, required this.isGuest, this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> items = [
      // {
      //   "text": "Achievements/PORs",
      //   "icon": Icons.emoji_events_rounded,
      //   "route": UhlLinkRoutesNames.porsPage,
      //   'pathParameters': {},
      //   "guest": false
      // },
      {
        "text": "Settings",
        "icon": Icons.settings,
        "route": UhlLinkRoutesNames.settingsPage,
        'pathParameters': {"user": jsonEncode(widget.user)},
        "guest": true
      },
    ];
    final aspectRatio = MediaQuery.of(context).size.aspectRatio;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: aspectRatio * 180,
                height: aspectRatio * 180,
                child: Card(
                  color: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(aspectRatio * 90),
                    side: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(100),
                        width: 1.5,
                        strokeAlign: BorderSide.strokeAlignOutside),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(aspectRatio * 90),
                    child: (widget.isGuest || widget.user!['image'] == "")
                        ? Icon(Icons.person,
                            size: 30,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(150))
                        : CachedNetworkImage(
                            imageUrl: widget.user!['image'],
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, string, loadingProgress) {
                              return CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary);
                            },
                            errorWidget: (context, object, trace) {
                              return Icon(Icons.error_outline_outlined,
                                  size: 30,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary);
                            }),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isGuest ? "Not Logged in" : widget.user!['name'],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  widget.isGuest
                      ? SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              GoRouter.of(context)
                                  .goNamed(UhlLinkRoutesNames.chooseAuth);
                            },
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    Theme.of(context).primaryColor),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                )),
                            child: Text(
                              "Log In",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Colors.white, fontSize: 17),
                            ),
                          ),
                        )
                      : Text(
                          widget.user!['email'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  fontFamily: "Montserrat_Regular",
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor),
                        ),
                  widget.isGuest
                      ? Container()
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 8),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withAlpha(50),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          margin:  const EdgeInsets.only(
                            top: 8
                          ),
                          child: Text(
                            widget.user!['email']
                                    .toString()
                                    .contains('students')
                                ? "Student"
                                : "Faculty",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                ],
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Divider(
            thickness: 2,
            color: Theme.of(context).colorScheme.scrim,
          ),
          for (var item in items
              .where((item) => widget.isGuest ? item['guest'] == true : true))
            CardWidget(
              text: item['text'],
              icon: item['icon'],
              onTap: () {
                if (item['text'] == 'Sign Out') {
                  const storage = FlutterSecureStorage();
                  storage.delete(key: 'user');
                  storage.delete(key: 'isGuest');
                  GoRouter.of(context).goNamed(item['route'], pathParameters: {
                    for (var entry in item['pathParameters'].entries)
                      entry.key: entry.value.toString()
                  });
                } else {
                  GoRouter.of(context)
                      .pushNamed(item['route'], pathParameters: {
                    for (var entry in item['pathParameters'].entries)
                      entry.key: entry.value.toString()
                  });
                }
              },
            ),
        ],
      ),
    );
  }
}
