import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uhl_link/features/home/presentation/pages/academics.dart';
import 'package:uhl_link/features/home/presentation/pages/dashboard.dart';
import 'package:uhl_link/features/home/presentation/pages/explore.dart';
import 'package:uhl_link/features/home/presentation/pages/profile.dart';
import 'package:uhl_link/features/home/presentation/pages/job_portal.dart';

import '../../../../config/routes/routes_consts.dart';

class HomePage extends StatefulWidget {
  final bool isGuest;
  final Map<String, dynamic>? user;
  const HomePage({super.key, required this.isGuest, this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentBottomBarIndex = 0;

  final homePageTitles = [
    "Dashboard",
    "Feed",
    "Academics",
    "Job Portal",
    "Profile",
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> homePages = [
      Dashboard(isGuest: widget.isGuest, user: widget.user),
      LostFoundPage(isGuest: widget.isGuest, user: widget.user),
      Academics(isGuest: widget.isGuest, user: widget.user),
      const JobPortalPage(),
      Profile(isGuest: widget.isGuest, user: widget.user),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(homePageTitles[currentBottomBarIndex],
            style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_rounded,
                color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {
              GoRouter.of(context).pushNamed(UhlLinkRoutesNames.notifications,
                  pathParameters: {'isGuest': jsonEncode(widget.isGuest)});
            },
          ),
        ],
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: homePages[currentBottomBarIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              currentBottomBarIndex = index;
            });
          },
          elevation: 10,
          currentIndex: currentBottomBarIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).cardColor,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).colorScheme.onSurface,
          // iconSize: 24,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedIconTheme:
              IconThemeData(size: 30, color: Theme.of(context).primaryColor),
          unselectedIconTheme: IconThemeData(
              size: 25, color: Theme.of(context).colorScheme.onSurface),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded), label: "Dashboard"),
            BottomNavigationBarItem(
                icon: Icon(Icons.feed_outlined), label: "Feed"),
            BottomNavigationBarItem(
                icon: Icon(Icons.school_rounded), label: "Academics"),
            BottomNavigationBarItem(
                icon: Icon(Icons.work_outline_rounded), label: "Job Portal"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded), label: "Profile"),
          ]),
    );
  }
}
