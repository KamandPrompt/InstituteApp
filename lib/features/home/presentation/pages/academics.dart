import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/routes_consts.dart';
import '../widgets/card.dart';

class Academics extends StatefulWidget {
  final bool isGuest;
  final Map<String, dynamic>? user;

  const Academics({super.key, required this.isGuest, required this.user});

  @override
  State<Academics> createState() => _AcademicsState();
}

class _AcademicsState extends State<Academics> {
  List<Map<String, dynamic>> items = [
    {
      "text": "Academic Calender",
      "icon": Icons.calendar_month_rounded,
      "route": UhlLinkRoutesNames.academicCalenderPage,
      "guest": true,
      "requiresParams": false, // Added to indicate no path parameters needed
    },
    {
      "text": "Achievements",
      "icon": Icons.verified_rounded,
      "route": UhlLinkRoutesNames.achievementsPage,
      "guest": true,
      "requiresParams": true, // Added to indicate path parameters are needed
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const ClampingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var item in items
              .where((item) => widget.isGuest ? item['guest'] == true : true))
            CardWidget(
              text: item['text'],
              icon: item['icon'],
              onTap: () {
                if (item["requiresParams"] == true) {
                  GoRouter.of(context).pushNamed(
                    item['route'],
                    pathParameters: {
                      'isGuest': jsonEncode(widget.isGuest),
                      'user': jsonEncode(widget.user ?? {}),
                    },
                  );
                } else {
                  GoRouter.of(context).pushNamed(item['route']);
                }
              },
            ),
        ],
      ),
    );
  }
}
