import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  final bool isGuest;
  const Notifications({super.key, required this.isGuest});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text("Notifications",
              style: Theme.of(context).textTheme.bodyMedium),
          centerTitle: true,
        ),
        body: Center(
          child: Text("This page is not yet created",
              style: Theme.of(context).textTheme.labelSmall),
        ));
  }
}
