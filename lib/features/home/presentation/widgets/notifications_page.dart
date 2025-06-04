import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vertex/config/routes/routes_consts.dart';
import 'package:vertex/features/home/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:vertex/features/home/presentation/bloc/notification_bloc/notification_event.dart';
import 'package:vertex/features/home/presentation/bloc/notification_bloc/notification_state.dart';
import 'package:vertex/utils/env_utils.dart';

class NotificationsPage extends StatefulWidget {
  final bool isGuest;
  final Map<String, dynamic>? user;

  const NotificationsPage(
      {super.key, required this.isGuest, required this.user});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<NotificationBloc>(context)
        .add(const GetNotificationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          "Notifications",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              if (state is NotificationsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is NotificationsLoaded) {
                final notifications = state.notifications;
                if (notifications.isEmpty) {
                  return Center(
                    child: Text(
                      "No Notifications.\nCheck your internet connection or try again later.",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }
                return ListView.separated(
                  physics: const ClampingScrollPhysics(),
                  itemCount: notifications.length,
                  itemBuilder: (BuildContext context, int index) {
                    final notification = notifications[index];
                    return GestureDetector(
                      onTap: () {
                        GoRouter.of(context).pushNamed(
                            UhlLinkRoutesNames.notificationDetails,
                            pathParameters: {
                              "notification": jsonEncode(notification.toMap())
                            });
                      },
                      child: Card(
                        color: Theme.of(context).cardColor,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                notification.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                notification.by,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                );
              } else if (state is NotificationsError) {
                return Center(
                  child: Text(
                    "Error loading notifications: ${state.message}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              } else if (state is NotificationAdded ||
                  state is NotificationAddingError) {
                BlocProvider.of<NotificationBloc>(context)
                    .add(const GetNotificationsEvent());
                return CircularProgressIndicator();
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
      floatingActionButton: FutureBuilder(
          future: isAdmin(widget.user!['email']),
          builder: (context, snapshot) {
            if (!widget.isGuest &&
                widget.user != null &&
                snapshot.hasData &&
                snapshot.data == true) {
              return FloatingActionButton(
                onPressed: () {
                  GoRouter.of(context).pushNamed(
                    UhlLinkRoutesNames.addNotification,
                    pathParameters: {"user": jsonEncode(widget.user)},
                  );
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.add),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
    );
  }
}
