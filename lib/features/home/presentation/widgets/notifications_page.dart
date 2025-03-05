import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:uhl_link/features/authentication/domain/entities/user_entity.dart';
import 'package:uhl_link/features/home/domain/entities/notifications_entity.dart';
import 'package:uhl_link/features/home/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:uhl_link/features/home/presentation/bloc/notification_bloc/notification_event.dart';
import 'package:uhl_link/features/home/presentation/bloc/notification_bloc/notification_state.dart';
import 'package:uhl_link/config/routes/routes_consts.dart';

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

  List<NotificationEntity> notifications = [];

  @override
  Widget build(BuildContext context) {
    String porsString = dotenv.env["POR_EMAILS"] ?? "";
    List<String> pors = porsString.split(',');
    UserEntity user = UserEntity.fromJson(widget.user!);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text("Notifications",
            style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              if (state is NotificationsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is NotificationsLoaded) {
                notifications = state.notifications;
                if (notifications.isEmpty) {
                  return Center(
                    child: Text(
                      "No Notifications",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }
                return ListView.separated(
                  physics: const ClampingScrollPhysics(),
                  itemCount: notifications.length,
                  itemBuilder: (BuildContext context, int index) {
                    final notification = notifications[index];
                    return Card(
                      color: Theme.of(context).cardColor,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.scrim),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.015,
                          horizontal:
                              MediaQuery.of(context).size.height * 0.015,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              notification.title,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "By: ${notification.by}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              notification.description,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            if (notification.image != null &&
                                notification.image!.isNotEmpty)
                              Container(
                                width: MediaQuery.of(context).size.width - 40,
                                // height:
                                //     MediaQuery.of(context).size.height * 0.25,
                                margin: const EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .cardColor
                                          .withValues(alpha: 0.2),
                                      width: 1.5,
                                    )),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    notification.image ?? "",
                                    errorBuilder: (context, object, stacktrace) {
                                      return Icon(Icons.error_outline_rounded,
                                          size: 40,
                                          color: Theme.of(context).primaryColor);
                                    },
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
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
      floatingActionButton: pors.contains(user.email)
          ? FloatingActionButton(
              onPressed: () {
                GoRouter.of(context).pushNamed(
                  UhlLinkRoutesNames.addNotification,
                  pathParameters: {"user": jsonEncode(widget.user)},
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
