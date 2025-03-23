import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uhl_link/features/authentication/data/models/user_model.dart';
import 'package:uhl_link/config/routes/routes_consts.dart';
import 'package:uhl_link/features/home/domain/entities/notifications_entity.dart';
import 'package:uhl_link/features/home/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:uhl_link/features/home/presentation/bloc/notification_bloc/notification_event.dart';
import 'package:uhl_link/features/home/presentation/bloc/notification_bloc/notification_state.dart';
import 'package:uhl_link/utils/env_utils.dart';
import 'package:uhl_link/config/routes/routes_consts.dart';


class NotificationsPage extends StatefulWidget {
  final bool isGuest;
  final Map<String, dynamic>? user;

  const NotificationsPage({super.key, required this.isGuest, required this.user});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<NotificationBloc>(context).add(const GetNotificationsEvent());
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              if (state is NotificationsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is NotificationsLoaded) {
                final notifications = state.notifications;
                if (notifications.isEmpty) {
                  return Center(
                    child: Text(
                      "No Notifications",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationDetailPage(
                            notification: notification,
                          ),
                        ),
                      ),
                      child: Card(
                        color: Theme.of(context).cardColor,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification.title,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                " ${notification.by}",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
      floatingActionButton: (widget.user != null && isAdmin(widget.user!['email']))
          ? FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).pushNamed(UhlLinkRoutesNames.addNotification,   pathParameters: {
            "user": jsonEncode(widget.user ?? {}) // ✅ Ensure 'user' is passed
          },);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      )
          : null,

    );
  }
}

class NotificationDetailPage extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationDetailPage({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          notification.title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Prevent overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "By: ${notification.by}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const SizedBox(height: 10),
              ),
              if (notification.image != null && notification.image!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    notification.image!,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 50,
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              Text(
                notification.description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
